%{
print_1D_spectra
    - prints a FUNWAVE 1D spectra file
%}
function print_1D_spectra(data,path)
    %% Arguments
    %{
        - data: (structure): structure containing 3 elements,
        2 arrays f and S for frequency bins and amplitude spectra,
        and a double maxT for the maximum period.
        
        - path: (string) path to print to, including file name
    %}
    fname=path;
    fid=fopen(fname,'w');
        fprintf(fid,'%5i %5i   - NumFreq NumDir \n',length(data.f),1);
        fprintf(fid,'%10.3f   - PeakPeriod  \n',data.maxT);
        fprintf(fid,'%10.3f   - Freq \n',data.f');
        fprintf(fid,'%10.3f   - Dire \n',0.0');
        S_col = reshape(data.S,[numel(data.S),1]);
        dlmwrite(fname,S_col,'delimiter','\t','-append','precision',5);
    fclose(fid);
end