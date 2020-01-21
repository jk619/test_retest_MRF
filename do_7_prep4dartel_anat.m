function do_7_prep4dartel_anat(subjects)

usedsubjects = subjects;
dartel_dir = './DARTEL/ANAT_DARTEL'
mkdir(dartel_dir)

%%
anat_dir = '/data/struct3T';
subj        = dir(sprintf('./%s/',anat_dir));
subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));



%%
ct = 1
for s = usedsubjects% : length(subj)
    
    subj_name   = subj(s).name;
    
    T1w = dir(sprintf('.%s/%s/T1w/frT1w_acpc.nii',anat_dir,subj_name));
    T1w_dartel = sprintf('%s_frT1w_acpc_dartel.nii',subj_name)
    
    copyfile([T1w.folder filesep T1w.name],[dartel_dir filesep T1w_dartel])
    anatfiles{ct} = [dartel_dir filesep T1w_dartel]; ct = ct +1;

end

clear matlabbatch

matlabbatch{1}.spm.util.reorient.srcfiles = anatfiles';
matlabbatch{1}.spm.util.reorient.transform.transF = {'./reorient/reorient_dartel.mat'};
% matlabbatch{1}.spm.util.reorient.prefix = '';
spm_jobman('run',matlabbatch);

end