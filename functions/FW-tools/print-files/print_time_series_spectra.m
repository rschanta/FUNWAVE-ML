%{
print_time_series_spectra
    - prints a spectra file from a time series, processed by `get_TS_spectra.m`
%}

function print_time_series_spectra(data,path,sc)
%% Arguments
%{
    - data: (structure): structure output from get_TS_spectra 
        containing the following:
            - per (double array): periods
            - cnn (double array): fourier coefficients, unscaled
            - cnn_sc (double array): fourier coefficients, scaled
            - enn (double array): phase information
            - fourier (structure): structure with all fourier coefficients
                - a0 (double): first term
                - an (double array): cosine terms
                - bn (double array): sine temrs
    - path: (string) path to print to, including file name
    - sc (double): whether or not to use scaling factor
        - sc == 0 : do not use scaling factor
        - sc == 1 : use scaling factor
%}
    fid = fopen(path, 'w');
        % Pull out data
            per = data.per;
            enn = data.enn;
            if sc == 0
                cnn = data.cnn;
            elseif sc == 1
                cnn = data.cnn_sc;
            end

        % Print to file
        for i=1:1:length(per)
            fprintf(fid,'%12.8f %12.8f %12.8f\n',per(i),cnn(i),enn(i));
        end
    fclose(fid);

end