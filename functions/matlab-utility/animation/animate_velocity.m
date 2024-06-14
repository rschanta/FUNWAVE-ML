%{
plot_domain_and_spectra
    - plots and saves an AVI file of a FUNWAVE run. 
      assumes a bathy is in `files` to plot bathymetry too
%}
function animate_velocity(super_path,run_name,tri_no)
    disp('Started animation for velocities...');
    %%% Make directories needed
        p = list_FW_dirs(super_path,run_name);
        ptr = list_FW_tri_dirs(tri_no,p);
    %%% Load data
        % Input structure
            tr_s = append_no('tri_',tri_no);
            input = load(p.Is,tr_s);
            input = input.(tr_s);
        % Output
            output = load(ptr.out_file);
        % Run name
            RN = p.RN_str
            trial_name = ptr.input_name
            file_name = ptr.aniU;
        figure(1)
        set(gcf,'Visible','off')
    %%% Set up video writer
        VO = VideoWriter(file_name, 'Motion JPEG AVI');
        VO.FrameRate = 12;
        open(VO);
    %%% Pull out fields
        bathy_X = input.files.bathy.array(:,1);
        bathy_Z = input.files.bathy.array(:,2);
        u = output.u;
        v = output.v;
    %%% Timing
        dt = input.PLOT_INTV;
        step = round(1/dt);
        time = output.time_dt(:,1);
    %%% Pull out wavemaker and sponge
        % Wavemaker
        if strcmp(input.WAVEMAKER,'COUPLING')
            Xc_WK = 0;
            wkL = 'WK as Left BC';
        else
            Xc_WK = input.Xc_WK;
            wkL = ['WK at x = ', num2str(Xc_WK)];
        end
        % Sponge
        if strcmp(input.DIRECT_SPONGE,'T')
            SWW = input.Sponge_west_width;
            spL = ['Sponge to x = ', num2str(SWW)];
        else
            SWW = 0;
            spL = 'No Sponge';
        end
    %%% Plot initial fields and set limits
    plot_title = sgtitle(['Velocities ', RN, ': ', trial_name],'Interpreter','none');
        subplot(1,2,1)
            u_plot = plot(bathy_X,u(1,:),'LineWidth',2);
            ylim([min(min(u)), max(max(u))+0.01]);
            xline(Xc_WK,'LineWidth',2,'LineStyle','--','Color','r');
            xline(SWW,'LineWidth',2,'LineStyle','--','Color','g');
            legend('',wkL,spL,'Location','southoutside');
            grid on;
            xlabel('Cross-shore position (x)');
            ylabel('u velocity (m/s)');
            title('u velocity');
            u_subtitle = subtitle(['Timestep = ', num2str(0)],'Interpreter','none');
        subplot(1,2,2)
            v_plot = plot(bathy_X,v(1,:),'LineWidth',2);
            ylim([min(min(v)), max(max(v))+0.01]);
            xline(Xc_WK,'LineWidth',2,'LineStyle','--','Color','r');
            xline(SWW,'LineWidth',2,'LineStyle','--','Color','g');
            title('v velocity');
            grid on;
            legend('',wkL,spL,'Location','southoutside');
            xlabel('Cross-shore position (x)');
            ylabel('v velocity (m/s)')
            v_subtitle = subtitle(['Time = ', num2str(0)],'Interpreter','none');
        
    %%% Loop through
        for k = 1:step:size(time,1)
            % Update eta
                set(u_plot,'YData',u(k,:));
                set(v_plot,'YData',v(k,:));
            % Update timestep
                set(u_subtitle,'String',['Timestep = ',  num2str(time(k)), ' s'])
                set(v_subtitle,'String',['Timestep = ',  num2str(time(k)), ' s'])
            % Save animation
                drawnow
                writeVideo(VO, getframe(gcf)); 
        end
    close(VO);
    disp('Animation for Velocities Successful!');
end