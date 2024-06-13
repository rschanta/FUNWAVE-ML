%{
plot_domain
    - saves diagrams of the domain for a DEPTH_FLAT case
%}
function plot_domain(df,ptr)
    %% Get Common Parameters
        TITLE = df.TITLE;
        Mglob = double(df.Mglob);
        Nglob = double(df.Mglob);
        DX = df.DX;
        DY = df.DY;
        files = df.files;
        run_name = ptr.RN;
    
    
    %% Get bathymetry/wavemaker/sponge
        bathy = files.bathy;
        SWW = df.Sponge_west_width;
        if strcmp(df.WAVEMAKER,'LEFT_BC_IRR')
            Xc_WK = 0;
        else
            Xc_WK = df.Xc_WK;
        end
    %% Plot 
    close all
    figure(1)
    hold on
    %%% Bathymetry
        bathy_X = bathy.array(:,1);
        bathy_Z = bathy.array(:,2);
        plot (bathy_X,-bathy_Z,'LineWidth',2)
    %%% Wavemaker
        xline(Xc_WK,'LineWidth',2,'LineStyle','--','Color','r');
        if strcmp(df.WAVEMAKER,'LEFT_BC_IRR')
            wkL = 'WK as Left BC';
        else
            wkL = ['WK at x = ', num2str(Xc_WK)];
        end
    %%% Spongelayer
        if strcmp(df.DIRECT_SPONGE,'T')
            xline(SWW,'LineWidth',2,'LineStyle','--','Color','g');
            spL = ['Sponge to x = ', num2str(SWW)];
        else
            plot(0,0);
            spL = 'No Sponge';
        end
        
    %%% Formatting
        xlabel('Crosshore Position (x)'); ylabel('Depth (z)');
        grid on; pbaspect([3 1 1]); axis tight;
        legend('Bathymetry',wkL,spL, 'Location','bestoutside');
        title(['Domain for ', run_name, ' ', TITLE],'Interpreter','none');
        subtitle(['DX = ', num2str(DX), ', Mglob = ', num2str(Mglob)])
    %%% Save Out
        disp(['Saving bathymetry plot to... ',ptr.b_fig])
        exportgraphics(gcf,ptr.b_fig,'Resolution',300) 

    end
    