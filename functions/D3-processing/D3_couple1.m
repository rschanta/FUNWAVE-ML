function D3_Bathy_Couple = D3_couple1(D3a,DX)
    %%%
        % NOTE: specify DX explicitly for stability
    %%% Access helper functions
        addpath(genpath('/work/thsu/rschanta/RTS/functions/'));
    %%% Initialize processed structure
        D3_Bathy_Couple = struct();

    %%% Loop through all trials
    for k = 5:24
        disp(['Processing Trial Number: ', num2str(k)])
        % Get trial data and initialize new template
        df = D3a.(['Trial',sprintf('%02d',k)]);
        dfr = df.raw_data;
        
        %% Get gauge positions, ADV positions, and bathymetry
            % Wave Gauge Locations [Position, MWL]
                WG = [dfr.WG_loc_x;dfr.MWL]';
            % ADV Locations [X,Z]
                ADV = [dfr.ADV_loc_xyz(1,:);dfr.ADV_loc_xyz(3,:)]';
            % Find where WG goes to NaN (ie- on the beach at this point
                [dry_WG_i, ~] = find(isnan(WG), 1, 'first');
                dry_WG_x = WG(dry_WG_i,1);
            % Bathymetry (before)
                bathy = [dfr.bed_before(:,1),dfr.bed_before(:,2)];
            % Cut bathymetry to be between leftmost wave gauge and dry beach
                bathy_cut = cut(bathy,[WG(1,1),dry_WG_x],1,2);
        
        %% Process Coupling Data
            %%% Times of Interest (start and end time)
                t0 = df.raw_data.t0; 
                t_end = df.raw_data.t_end;
                couple = [dfr.t, dfr.u(:,2),dfr.v(:,2),dfr.eta(:,1)];
                couple_cut = cut(couple,[t0,t_end],1,4);
            %%% Put into structure
                Coupling = struct();
                Coupling.t = couple_cut(:,1) - t0;
                Coupling.u = couple_cut(:,2);
                Coupling.v = couple_cut(:,3);
                Coupling.eta = couple_cut(:,4);
                D3_Bathy_Couple.(['Trial',sprintf('%02d',k)]).Coupling = Coupling;
        %% Process Bathymetry Data
            DX = DX;
            %%% Transform coordinates
                % Get MWL mean from mean of MWL's given
                    MWL = nanmean(WG(:,2));
                % Shift X coordinates over all the way to the left
                    depX_raw = bathy_cut(:,1) - min(bathy_cut(:,1));
                % Convert heights to depths
                    depZ_raw = MWL - bathy_cut(:,2);
                % Remove any duplicates of X coordinates
                    dep = [depX_raw, depZ_raw];
                    dep = unique_bathy(dep);
            %%% Interpolate to Grid
                depX = 0:DX:max(dep(:,1));
                depZ = interp1(dep(:,1),dep(:,2),depX,"linear");
            %%% Save into structure, edit Mglob accordingly
                Bathy = [depZ; depZ; depZ];
                D3_Bathy_Couple.(['Trial',sprintf('%02d',k)]).Bathy = Bathy;
    end

end
