 %{
    comp_D3_FW_mov
        - July 7th 2024
        - creates an animation to compare the Dune 3
          dataset to the FUNWAVE output
    
%}

function comp_D3_FW_mov(no,sp,rn)
    %%% Naming and Directories
        % Get paths
            p = list_FW_dirs(sp,rn)
        % Create directory for comparisons if DNE
            aniComp = fullfile(p.ani,'comp-animations');
            make_dir(aniComp);
        % Create name of file
            file_name = fullfile(aniComp,[append_no('comp_',no),'.avi']);

    %%% Load in the needed data and merge
        %%% Load in Input structure to get bathymetry data
            % Name of trial
                tr_dir = [append_no('tri_',no),'.mat'];
                tr_name = [append_no('tri_',no+4)];
            % Load in structure and get bathy array
                Inputs = load(p.Is,tr_name); 
                Inputs = Inputs.(tr_name);
                bathy_array = Inputs.files.bathy.array;
            
        %%% Load in FUNWAVE output data and process
            % Load in and apply mask
                FW_Data = load([append_no(p.O_,no),'.mat']);     
                FW_Data.eta(FW_Data.mask == 0) = NaN;            
            % Get time and eta values into a structure
                df_FW.t = FW_Data.time_dt(:,1);
                df_FW.val = FW_Data.eta;

        %%% Load in the Dune 3 Data (NOTE OFFSET OF INDICES- the + 4 added on)
            % Load in
                D3_Data = load("/work/thsu/rschanta/RTS/data/D3a.mat",['Trial',sprintf('%02d',no+4)]);
                D3_Data = D3_Data.(['Trial',sprintf('%02d',no+4)]);
            % Get the wave gauge locations
                WG_x = D3_Data.raw_data.WG_loc_x;
            % Get time and eta values
                df_D3.t = D3_Data.raw_data.t;
                df_D3.val = D3_Data.raw_data.eta;

        %%% Merge series using align_TS
            dfc = align_TS(df_FW,df_D3);
    
    %%% Plot the series as a movie
        % Open plot
            figure('Visible','off');
            hold on
        % Open Video Writer
            VO = VideoWriter(file_name, 'Motion JPEG AVI');
            VO.FrameRate = 30;
            open(VO);
        % Initialize plot elements
            plot_bathy = plot(bathy_array(:,1),-bathy_array(:,2),'LineWidth',2,'Color','k');
            plot_FW = plot(bathy_array(:,1),dfc.val1(1,:),'LineWidth',2,'Color','b')
            plot_D3 = scatter(WG_x, dfc.val2(1,:),'red','filled');
        % Set minima and maxima
            min_val = min([min(df_FW.val(:)), min(df_D3.val(:)),min(-bathy_array(:,2))]);
            max_val =  max([max(df_FW.val(:)), max(df_D3.val(:))]);
            ylim([min_val, max_val]);
        % Set title, subtitle, axis labels,and legend
            plot_title = title(['FUNWAVE Simulation vs. Dune 3 Data: Trial ', num2str(no+4)]);
            plot_subtitle = subtitle('Time = 0 s');
            xlabel('Cross-shore position (x)'); 
            ylabel('\eta');
            grid on;
            plot_legend = legend('','FUNWAVE data','Dune3 Wave Gages','Location','southeast');

        %%% Loop through all time steps
            % Loop variables
                count = 1;
                t = dfc.t;
                FW_eta = dfc.val1;
                D3_eta = dfc.val2;
            % Loop
            for k = count:50:length(t)
                % Update values of FUNWAVE and Dune 3
                    set(plot_FW,'YData',dfc.val1(k,:))
                    set(plot_D3,'YData',dfc.val2(k,:))
                % Update time every tenth step
                    if mod(count,10) == 0
                        set(plot_subtitle,'String',['Time = ', num2str(t(k),5), ' s'])
                    end
                % Print progress every 100th step
                    if mod(count,100) == 0
                        disp(['Animated up to time step: ', num2str(t(k),100), ' s'])
                    end
                % Update figure, write to outputs, and progress forward
                    drawnow
                    frame = getframe(gcf); 
                    writeVideo(VO, frame); 
                    count = count + 1;
            end

    % Close video writer and echo success
        close(VO)
        disp('Successfully animated Comparison!')
end
