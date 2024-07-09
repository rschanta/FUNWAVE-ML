%{
plot_time_spectra
    - saves a diagram of the spectra for a time series spectra
%}

function plote_time_spectra(df,ptr)
disp('Started plotting spectra...');
        %% Get needed parameters
            TITLE = df.TITLE;
            files = df.files;
            run_name = ptr.RN;
            spectra = files.spectra;
            per = files.spectra.per;
            amp = files.spectra.cnn;
        %% Plot 
        close all
        figure(1)
            plot(per,amp);
            grid on
            
        %%% Formatting
            xlabel('Period (s)'); ylabel('Amplitude (m)');
            grid on; axis tight;
            title(['Time Series Spectra for ', run_name, ' ', TITLE],'Interpreter','none');
        %%% Save Out
            disp(['Saving spectra plot to... ',ptr.sp_fig])
            exportgraphics(gcf,ptr.sp_fig,'Resolution',300) 
    
disp('Spectra plotted succesfully!');
end
        