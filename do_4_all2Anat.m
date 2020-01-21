function do_4_all2Anat(subjects,sites)


usedsubjects = subjects;
usedsites = sites;

sites       = dir('./data/*_*');
sites       = sites([sites(:).isdir]==1);

subj        = dir(sprintf('./data/%s/',sites(1).name));
subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));

anat_dir = 'struct3T';

sourcesite = 1;
spm('defaults','FMRI');

%%
for s = usedsubjects
    ct = 1;
    
    clear subject_files
    subj_name   = subj(s).name;
    
    for site = usedsites
        
        
        mysite = sites(site).name;
        
        if exist(sprintf('./data/%s/%s',mysite,subj_name),'dir');
            
            files = dir(sprintf('./data/%s/%s/rs*.nii',mysite,subj_name));
            
            for f = 1 : length(files)
                
                subject_files{ct} = sprintf('%s/%s,1',files(f).folder,files(f).name); ct = ct + 1;
                subject_files{ct} = sprintf('%s/%s,2',files(f).folder,files(f).name); ct = ct + 1;
                subject_files{ct} = sprintf('%s/%s,3',files(f).folder,files(f).name); ct = ct + 1;
                
                
            end
            
        end
        
    end
    
    clear matlabbatch
    
    source = sprintf('./data/%s/%s/rs_%s_test.nii,1',sites(sourcesite).name,subj_name,subj_name);
    ref = sprintf('./data/%s/%s/T1w/frT1w_acpc.nii',anat_dir,subj_name);
    sprintf('Registering %s to anatomy',subj_name)
    
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = {ref};
    matlabbatch{1}.spm.spatial.coreg.estimate.source = {source};
    matlabbatch{1}.spm.spatial.coreg.estimate.other = subject_files';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    
    spm_jobman('run',matlabbatch);
    
    clear matlabbatch
    
    matlabbatch{1}.spm.spatial.coreg.write.ref = {ref}
    matlabbatch{1}.spm.spatial.coreg.write.source = subject_files'
    matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'anat_';
    
    spm_jobman('run',matlabbatch);
    
    
    
end

end
