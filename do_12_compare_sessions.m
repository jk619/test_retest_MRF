function [allres sitescomp] = do_12_compare_sessions(firstsession,secondsession)



sites       = dir('./data/*_*');
sites       = sites([sites(:).isdir]==1);

subj        = dir(sprintf('./data/%s/',sites(1).name));
subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));

regfolder = './DARTEL/WARP_DARTEL/';
masksfile = './masks/masks.nii';

tissues = {'grey';'white';'csf';'allbrain'}
maps = {'T1';'T2';'PD'};
mask = load_nii(masksfile)
% mask.img(:,:,:,end+1) = sum(mask.img,4);
mask.img(:,:,:,end+1) = (mask.img(:,:,:,1) | mask.img(:,:,:,2) | mask.img(:,:,:,3));

mkdir(regfolder);
ct = 1;
allres = [];
for s = 1:length(subj)
    
    subj_name   = subj(s).name;
    
    
    mysite_1 = sites(firstsession).name;
    mysite_2 = sites(secondsession).name;
    
    myfile_test = dir(sprintf('%sw*%s*%s*_test*',regfolder,mysite_1,subj_name));
    myfile_retest = dir(sprintf('%sw*%s*%s*_retest*',regfolder,mysite_2,subj_name));
    
    if exist(sprintf('./data/%s/%s',mysite_1,subj_name),'dir') && exist(sprintf('./data/%s/%s',mysite_2,subj_name),'dir')
        
        test = load_nii([myfile_test.folder filesep myfile_test.name]);
        retest = load_nii([myfile_retest.folder filesep myfile_retest.name]);
        
        for f = 1 : size(test.img,4)
            
            for t = 1 : size(mask.img,4)
                
                
                
                test_mask = test.img(:,:,:,f) .* mask.img(:,:,:,t);
                retest_mask = retest.img(:,:,:,f) .* mask.img(:,:,:,t);
                
                test_mask(test_mask==0)=NaN;
                retest_mask(retest_mask==0)=NaN;
                
                
                mean_test = nanmean(test_mask(:));
                mean_retest = nanmean(retest_mask(:));
                
                mysite = strcat(mysite_1,'and',mysite_2);
                
                allres.(mysite).(subj_name).(maps{f}).(tissues{t}) = std([mean_test mean_retest])/mean([mean_test mean_retest]);
                
            end
        end
        
    else
        disp(sprintf(' %s is not present in both selected %s %s sessions',subj_name,mysite_1,mysite_2))
    end
    
    
end

subjects = fieldnames(allres.(mysite))
maps = fieldnames(allres.(mysite).(subjects{1}))
tissues = fieldnames(allres.(mysite).(subjects{1}).(maps{1}))


for s = 1  : length(subjects)
    
    subj_name = subjects{s}
    
    for m = 1 : length(maps)
        
        for t = 1 : length(tissues)
            
            sitescomp.(maps{m}).(tissues{t})(s) =  allres.(mysite).(subj_name).(maps{m}).(tissues{t})
            
        end
        
    end
    
end

end
