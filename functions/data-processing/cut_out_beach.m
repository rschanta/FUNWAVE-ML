%{
cut_out_beach
    - Takes a dep array from a 1D DEPTH_FLAT FUNWAVE trial and cuts out
      just the portion that is on the sloping area.
%}
function [cut_params, beach_start_i] = cut_out_beach(params, depth_flat)
    
    %%% Find where the beach starts and cut out
        beach_start_i = find(params.dep == depth_flat, 1, 'last');
        cut_params.dep = params.dep(beach_start_i:end);
    %%% Also cut out asymmetry and skew (if there)
        try
            cut_params.skew = params.skew(beach_start_i:end);
            cut_params.asy = params.asy(beach_start_i:end);
        catch
            disp('No skew/asymmetry in params')
        end

end