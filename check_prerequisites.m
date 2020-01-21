[~,var ] =system('which fslswapdim');

if isempty(var)
    
    error('FSL not in the PATH try setenv(''PATH'',''$FSLDIR'')')
else
    
    disp('FSL in the path')
    
end

[var] = which('spm');

if isempty(var)
    
    error('Add SPM to the path')
else
    
    disp('SPM in the path')
    
end


[var] = which('load_nii');

if isempty(var)
    
    error('Add NIFTI toolbox to the path')
else
    
    disp('NIFTI in the path')
    
end