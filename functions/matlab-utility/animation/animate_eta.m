%{
plot_domain_and_spectra
    - plots and saves an AVI file of a FUNWAVE run. 
      assumes a bathy is in `files` to plot bathymetry too
%}
function animate_results(super_path,run_name,tri_no)
    disp('Started animation for eta...');
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
            RN = p.RN_str;
            trial_name = ptr.input_name;
            file_name = ptr.aniE;
        figure(1)
        set(gcf,'Visible','off');
    %%% Set up video writer
        VO = VideoWriter(file_name, 'Motion JPEG AVI');
        VO.FrameRate = 12;
        open(VO);
    %%% Pull out fields
        bathy_X = input.files.bathy.array(:,1);
        bathy_Z = input.files.bathy.array(:,2);
        eta = output.eta;
    %%% EDIT JUNE 22: ADD MASK FEATURE
        mask = output.mask;
        eta(mask == 0) = NaN;
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
        hold on
        bathy_plot = plot(bathy_X,-bathy_Z,'LineWidth',2);
        eta_plot = plot(bathy_X,eta(1,:),'LineWidth',2);
        ylim([min(min(-bathy_Z)), max(max(eta))+0.01]);
    %%% Plot wavemaker and sponge
        xline(Xc_WK,'LineWidth',2,'LineStyle','--','Color','r');
        xline(SWW,'LineWidth',2,'LineStyle','--','Color','g');
        legend('','',wkL,spL,'Location','southoutside');
    %%% Set title,subtitle, axes, and grid
        plot_title = title([RN, ': ', trial_name],'Interpreter','none');
        plot_subtitle = subtitle(['Time = ', num2str(0)],'Interpreter','none');
        grid on;
        xlabel('Cross-shore position (x)');
        ylabel('Elevation (m)')
    %%% Loop through
        for k = 1:step:size(time,1)
            % Update eta
                set(eta_plot,'YData',eta(k,:));
            % Update timestep
                set(plot_subtitle,'String',['Timestep = ', num2str(time(k)), ' s'])
            % Save animation
                drawnow
                writeVideo(VO, getframe(gcf)); 
        end
    close(VO);
    disp('Animation for Eta Successful!');
end