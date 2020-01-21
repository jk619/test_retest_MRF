function do_5_brain_mask_and_check(subjects)


usedsubjects = subjects;
% clc
% clear

sites       = dir('./data/*_*');
sites       = sites([sites(:).isdir]==1);

subj        = dir(sprintf('./data/%s/',sites(1).name));
subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));

anat_dir = 'struct3T';
check_dir = 'check_reg';
sourcesite = 1;

mkdir(check_dir)


for s = usedsubjects
    
    subj_name   = subj(s).name;
    mask = load_nii(sprintf('./data/%s/%s/T1w/frT1w_acpc_brain_mask.nii',anat_dir,subj_name));
    anat = load_nii(sprintf('./data/%s/%s/T1w/frT1w_acpc.nii',anat_dir,subj_name));
    anat.img = double(anat.img);
    
    anat.img = anat.img - min(anat.img(:)) ;
    anat.img = anat.img / max(anat.img(:)) ;
    anat.img = anat.img .* 3;
    
    
    for site = [2 4 1 3]
        
        mysite = sites(site).name;
        
        if exist(sprintf('./data/%s/%s',mysite,subj_name),'dir')
            
            files = dir(sprintf('./data/%s/%s/anat_*.nii',mysite,subj_name));
            
            for f = 1 : length(files)
                
                mrf = load_nii([files(f).folder filesep files(f).name]);
                mrf.img = mrf.img .* mask.img;
                save_nii(mrf,[files(f).folder filesep 'ss_' files(f).name]);
                
                
                anat.img = cat(4,anat.img,mrf.img(:,:,:,1));
            end
        end
        
    end
    
    allfiles = make_nii(anat.img);
    
    save_nii(allfiles,sprintf('./%s/%s.nii',check_dir,subj_name));
end

end