function do_9_warp2dartel(subjects)

usedsubjects = subjects;
spm_dir = '/Users/jankurzawski/Dropbox/software/spm12';
subj_dir = '/data/struct3T';
anat_dir = './DARTEL/ANAT_DARTEL';
mrf_dir = './DARTEL/MRF_DARTEL';
dartel_warp = './DARTEL/WARP_DARTEL/';
mkdir(dartel_warp);

subj        = dir(sprintf('./%s/',subj_dir));
subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));

ct = 1;
allwarp = [];
allanat = [];
for s = usedsubjects
    clear allmrf
    clear mrffiles
    clear warpfile
    subj_name   = subj(s).name;
    
    warpfile = sprintf('%s/u_rc1%s_frT1w_acpc_dartel_Template.nii',anat_dir,subj_name); ct = ct +1;
    
    allmrf=dir(sprintf('%s/*%s*.nii',mrf_dir,subj_name))
    anat=dir(sprintf('%s/%s*.nii',anat_dir,subj_name))
    
    for f = 1 : size(allmrf,1)
        
        mrffiles{f} = [allmrf(f).folder filesep  allmrf(f).name]
        
    end
    
        mrffiles{end+1} = [anat.folder filesep  anat.name]

    clear matlabbatch
    
    warpfieldbatch = {warpfile};
    warpfieldbatch_all = repmat(warpfieldbatch,[1 size(mrffiles,2)]);
    mrffilesbatch_all  = {mrffiles'}
    
    matlabbatch{1}.spm.tools.dartel.crt_warped.flowfields = warpfieldbatch_all';
    matlabbatch{1}.spm.tools.dartel.crt_warped.images = mrffilesbatch_all'
    matlabbatch{1}.spm.tools.dartel.crt_warped.jactransf = 0;
    matlabbatch{1}.spm.tools.dartel.crt_warped.K = 6;
    matlabbatch{1}.spm.tools.dartel.crt_warped.interp = 1;
    
    spm_jobman('run',matlabbatch);
    
    allmrf_w=dir(sprintf('%s/w*%s*.nii',anat_dir,subj_name));
    
    for w = 1 : length(allmrf_w)-1
        tmp = load_nii([allmrf_w(w).folder filesep allmrf_w(w).name])
        allwarp = cat(4,allwarp,tmp.img(:,:,:,1));
        movefile([allmrf_w(w).folder filesep allmrf_w(w).name],[dartel_warp allmrf_w(w).name])
    end
    

    anat_tmp = load_nii([anat.folder filesep 'w' anat.name])
    allanat = cat(4,allanat,anat_tmp.img);
    
    
    
    
end


    allfiles = make_nii(allwarp,[tmp.hdr.dime.pixdim(2:4)])
    save_nii(allfiles,'./check_reg/DARTEL.nii')
    
    allanat(:,:,:,end+1) = mean(allanat,4);
    allanatfiles = make_nii(allanat,[tmp.hdr.dime.pixdim(2:4)])
    save_nii(allanatfiles,'./check_reg/AllANAT.nii')

    

end