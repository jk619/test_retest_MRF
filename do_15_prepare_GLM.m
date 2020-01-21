function do_15_prepare_GLM(vec_subj,vec_sites,vec_test,vec_fields,directory4glm,t)
directory = directory4glm;
mkdir(directory)

WARP_DIR = '/Volumes/Maxtor/test_retest/DARTEL/WARP_DARTEL';
files = dir(sprintf('%s/*.nii',WARP_DIR));

mycovar = cat(2,vec_subj,vec_sites,vec_test,vec_fields);

subj_dir = '/data/struct3T';
subj        = dir(sprintf('./%s/',subj_dir));
subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));
sites       = dir('./data/*_*');
sites       = sites([sites(:).isdir]==1);

leg = cat(1,subj,sites);
leg(end+1).name = 'test';
leg(end+1).name = 'retest';
leg(end+1).name = '3_0';
leg(end+1).name = '1_5';

Contrast = t;


for f = 1 : length(files)
    
    mrffiles{f} = [files(f).folder filesep  files(f).name ',' num2str(Contrast)]
    
end


matlabbatch{1}.spm.stats.factorial_design.dir = {directory};
%%
matlabbatch{1}.spm.stats.factorial_design.des.mreg.scans = mrffiles'
%%
%%
for covar = 1 : size(mycovar,2)
    matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(covar).c = mycovar(:,covar)
    matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(covar).cname = leg(covar).name;
    matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(covar).iCC = 1;
end


matlabbatch{1}.spm.stats.factorial_design.des.mreg.incint = 1;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

spm_jobman('run',matlabbatch)

end
