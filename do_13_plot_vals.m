function do_13_plot_vals(subjects,sites,skip)

usedsubjects = subjects;
usedsites = sites;

cmap(1,:) =  [1.0000    0.6000    0.7843]; %pink
cmap(2,:) =  [1.0000         0         0]; %red
cmap(3,:) =  [0.4000    0.8000    0.1000]; %pale green
cmap(4,:) =  [0.1647    0.3843    0.2745]; %dark green


sites       = dir('./data/*_*');
sites       = sites([sites(:).isdir]==1);

subj        = dir(sprintf('./data/%s/',sites(1).name));
subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));

regfolder = './DARTEL/WARP_DARTEL/';
masksfile = './masks/masks.nii';

tissues = {'grey';'white';'csf';'allbrain'};
maps = {'T1';'T2';'PD'};
mask = load_nii(masksfile);
% mask.img(:,:,:,end+1) = sum(mask.img,4);
mask.img(:,:,:,end+1) = (mask.img(:,:,:,1) | mask.img(:,:,:,2) | mask.img(:,:,:,3));

allres_test = [];
allres_retest = [];
for s = usedsubjects
    
    subj_name   = subj(s).name;
    
    for site = usedsites
        
        mysite = sites(site).name;
        
        
        myfile_test = dir(sprintf('%sw*%s*%s*_test*',regfolder,mysite,subj_name));
        myfile_retest = dir(sprintf('%sw*%s*%s*_retest*',regfolder,mysite,subj_name));
        
        if exist(sprintf('./data/%s/%s',mysite,subj_name),'dir')
            
            test = load_nii([myfile_test.folder filesep myfile_test.name]);
            retest = load_nii([myfile_retest.folder filesep myfile_retest.name]);
        else
            
            disp(sprintf('Subject %s is not in session %s',subj_name,mysite))
            
        end
        
        for f = 1 : length(maps)
            
            for t = 1 : length(tissues)
                
                if exist(sprintf('./data/%s/%s',mysite,subj_name),'dir')
                    
                    test_mask = test.img(:,:,:,f) .* mask.img(:,:,:,t);
                    retest_mask = retest.img(:,:,:,f) .* mask.img(:,:,:,t);
                    
                    test_mask(test_mask==0)=NaN;
                    retest_mask(retest_mask==0)=NaN;
                    
              
                    
                    
                    allres_test.(maps{f}).(tissues{t})(s,:) = test_mask(:);
                    allres_retest.(maps{f}).(tissues{t})(s,:) = retest_mask(:);
                    
                end
                
            end
        end    
    end
end
%%
ct = 1;
figure(666)
for f = 1 : length(maps)
    
    for t = 1 : length(tissues)
        
        
        siz = size(allres_test.(maps{f}).(tissues{t}));
        test = reshape(allres_test.(maps{f}).(tissues{t}),[1 siz(1)*siz(2)]);
        retest = reshape(allres_retest.(maps{f}).(tissues{t}),[1 siz(1)*siz(2)]);
        xlabel('test')
        ylabel('retest')

        subplot(3,4,ct); hold on
        ct = ct + 1;
        
        plot(test(1:skip:end),retest(1:skip:end),'.','Color',cmap(t,:)); 
        title(sprintf('%s %s',maps{f},tissues{t}))
        
    end
    
end

        
set(gcf,'Position',[560   282   902   666])
        
        
                
                