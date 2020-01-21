function do_17_runGLM(directory4glm)

matlabbatch{1}.spm.stats.fmri_est.spmmat = {sprintf('%s/SPM.mat',directory4glm)};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
spm_jobman('run',matlabbatch)

end