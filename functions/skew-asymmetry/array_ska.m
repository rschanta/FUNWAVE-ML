%{
array_ska
    - calculates the skew and asymmetry for every point in a 1D FUNWAVE
      simulation
%}


function ska = array_ska(eta_field,start_i)
%% Arguments
%{
    - eta_field: array of [t x Mglob] dimensions corresponding to eta field
      of FUNWAVE run in 1D where rows are step steps and columns are
      different points in space
%}

%%% Convert to cell array where each cell is a time series
    eta_i = num2cell(eta_field,1);

%%% Apply skasy function to each cell in cell array
    [skew, asy] = cellfun(@(eta_i) calc_skew_asym(eta_i,start_i), eta_i,'UniformOutput',false);

%%% Output as a matrix again
    ska.skew = cell2mat(skew);
    ska.asy = cell2mat(asy);
    end