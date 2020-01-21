function do_1_reorient(subjects,sites)
% clc
% clear
usedsubjects = subjects;
usedsites = sites;
%%
anat_dir = '/data/struct3T';
subj        = dir(sprintf('./%s/',anat_dir));
subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));
sites       = dir('./data/*_*');
sites       = sites([sites(:).isdir]==1);

%%


ct = 1;
ct2 = 1;
ct3 = 1;
anat = 0;

if anat
    
    for s = usedsubjects% : length(subj)
        
        subj_name   = subj(s).name;
        
        anatfiles{ct} = sprintf('.%s/%s/T1w/T1w_acpc.nii',anat_dir,subj_name); ct = ct +1;
        anatfiles{ct} = sprintf('.%s/%s/T1w/T1w_acpc_brain.nii',anat_dir,subj_name); ct = ct +1;
        anatfiles{ct} = sprintf('.%s/%s/T1w/T1w_acpc_brain_mask.nii',anat_dir,subj_name); ct = ct +1;
        
        reor_anatfiles{ct2} = sprintf('.%s/%s/T1w/rT1w_acpc.nii',anat_dir,subj_name); ct2 = ct2 +1;
        reor_anatfiles{ct2} = sprintf('.%s/%s/T1w/rT1w_acpc_brain.nii',anat_dir,subj_name); ct2 = ct2 +1;
        reor_anatfiles{ct2} = sprintf('.%s/%s/T1w/rT1w_acpc_brain_mask.nii',anat_dir,subj_name); ct2 = ct2 +1;
        
        flip_anatfiles{ct3} = sprintf('.%s/%s/T1w/frT1w_acpc.nii',anat_dir,subj_name); ct3 = ct3 +1;
        flip_anatfiles{ct3} = sprintf('.%s/%s/T1w/frT1w_acpc_brain.nii',anat_dir,subj_name); ct3 = ct3 +1;
        flip_anatfiles{ct3} = sprintf('.%s/%s/T1w/frT1w_acpc_brain_mask.nii',anat_dir,subj_name); ct3 = ct3 +1;
        
    end
end
%%

ct = 1;

for s = usedsubjects% : length(subj)
    
    subj_name   = subj(s).name;
    
    for site = usedsites
        
        mysite = sites(site).name;
        
        if exist(sprintf('./data/%s/%s',mysite,subj_name),'dir');
            
            files = dir(sprintf('./data/%s/%s/s_*.nii',mysite,subj_name));
            
            for f = 1 : length(files)
                
                mrffiles{ct} = sprintf('%s/%s,1',files(f).folder,files(f).name); ct = ct + 1;
                mrffiles{ct} = sprintf('%s/%s,2',files(f).folder,files(f).name); ct = ct + 1;
                mrffiles{ct} = sprintf('%s/%s,3',files(f).folder,files(f).name); ct = ct + 1;
            end
            
            
            
        end
        
    end
    
end


%%
if anat
    matlabbatch{1}.spm.util.reorient.srcfiles = anatfiles';
    matlabbatch{1}.spm.util.reorient.transform.transF = {'./reorient/reorient_anat.mat'};
    matlabbatch{1}.spm.util.reorient.prefix = 'r';
    spm_jobman('run',matlabbatch);
    %%
    
    for a = 1 : length(reor_anatfiles)
        system(sprintf('fslswapdim %s -x y z %s', reor_anatfiles{a},flip_anatfiles{a}));
        system(sprintf('gunzip -f %s',[flip_anatfiles{a} '.gz']));
    end
end
%%
clear matlabbatch

matlabbatch{1}.spm.util.reorient.srcfiles = mrffiles';
matlabbatch{1}.spm.util.reorient.transform.transF = {'./reorient/reorient_mrf.mat'};
matlabbatch{1}.spm.util.reorient.prefix = 'r';
spm_jobman('run',matlabbatch);


end
