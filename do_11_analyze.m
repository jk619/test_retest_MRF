function [allres mymeanval_sites] = do11_analyze

sites       = dir('./data/*_*');
sites       = sites([sites(:).isdir]==1);

subj        = dir(sprintf('./data/%s/',sites(1).name));
subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));

regfolder = './DARTEL/WARP_DARTEL/';
masksfile = './masks/masks.nii';

tissues = {'grey';'white';'csf';'allbrain'}
maps = {'T1';'T2';'PD'};
mask = load_nii(masksfile);
% mask.img(:,:,:,end+1) = sum(mask.img,4);
mask.img(:,:,:,end+1) = (mask.img(:,:,:,1) | mask.img(:,:,:,2) | mask.img(:,:,:,3));

mkdir(regfolder);
allres = [];
for s = 1:length(subj)
    
    subj_name   = subj(s).name;
    
    for site = 1:length(sites)
        
        mysite = sites(site).name;
        
        
        myfile_test = dir(sprintf('%sw*%s*%s*_test*',regfolder,mysite,subj_name));
        myfile_retest = dir(sprintf('%sw*%s*%s*_retest*',regfolder,mysite,subj_name));
        
        if exist(sprintf('./data/%s/%s',mysite,subj_name),'dir')
            
            test = load_nii([myfile_test.folder filesep myfile_test.name]);
            retest = load_nii([myfile_retest.folder filesep myfile_retest.name]);
        else
            
            disp(sprintf('Subject %s is not in session %s',subj_name,mysite))
            
        end
        
        for f = 1 : size(test.img,4)
            
            for t = 1 : size(mask.img,4)
                
                if exist(sprintf('./data/%s/%s',mysite,subj_name),'dir')
                    
                    test_mask = test.img(:,:,:,f) .* mask.img(:,:,:,t);
                    retest_mask = retest.img(:,:,:,f) .* mask.img(:,:,:,t);
                    
                    test_mask(test_mask==0)=NaN;
                    retest_mask(retest_mask==0)=NaN;
                    
                    
                    mean_test = nanmean(test_mask(:));
                    mean_retest = nanmean(retest_mask(:));
                    
                    
                    
                    allres.(mysite).(subj_name).(maps{f}).(tissues{t}) = std([mean_test mean_retest])/mean([mean_test mean_retest]);
                    
                else
                    
                    allres.(mysite).(subj_name).(maps{f}).(tissues{t}) = NaN;
                end
            end
        end
    end
end


%%

for s = 1:length(subj)
    
    subj_name   = subj(s).name;
    
    for site = 1:length(sites)
        
        mysite = sites(site).name;
        
        for t = 1 : length(tissues)
            
            mytissue = tissues{t}
            
            for m = 1 : length(maps)
                
                mymap = maps{m};
                mymeanval_allsubjects.(mysite).(mymap).(mytissue)(s) = allres.(mysite).(subj_name).(mymap).(mytissue)
                
            end
            
        end
    end
end

%%
for site = 1:length(sites)
    
    mysite = sites(site).name;
    
    for t = 1 : length(tissues)
        
        mytissue = tissues{t};
        
        for m = 1 : length(maps)
            
            mymap = maps{m};
            mymeanval_sites.(mysite).(mymap).(mytissue) = mean(mymeanval_allsubjects.(mysite).(mymap).(mytissue))
            
        end
    end
end

return