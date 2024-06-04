function new_ska(st,no,sp,rn)
    %% Arguments
    %{
        - super_path
        - run_name
    %}
    %% Get paths
        paths = list_FW_dirs(sp,rn);
    %% Get eta field from structure
        eta_field = st.eta;
    %% Apply ska function
        ska = array_ska(eta_field,1);
    %% Get structures
        skew_struct.skew = ska.skew;
        asy_struct.asy = ska.asy;

    %% Save 2 files
        skew_name = fullfile(paths.outputs_proc,['skew_',sprintf('%05d',no),'.mat']);
        asy_name = fullfile(paths.outputs_proc,['asy_',sprintf('%05d',no),'.mat']);
        save(skew_name,'-struct', 'skew_struct', '-v7.3');
        save(asy_name,'-struct', 'asy_struct', '-v7.3');
    end
    