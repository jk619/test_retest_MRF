function do_0_mask(subjects,sites)
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
use_mask = 1;
for s = usedsubjects
    
    subj_name   = subj(s).name;
    
    for site = usedsites
        
        mysite = sites(site).name;
        
        if exist(sprintf('./data/%s/%s',mysite,subj_name),'dir')
            
            files = dir(sprintf('./data/%s/%s/%s*.nii',mysite,subj_name,subj_name));
            
            for f = 1 : length(files)
                
                tmp = load_nii(sprintf('%s/%s',files(f).folder,files(f).name));
                %                 t1_MP = 2.3
                %                 MP2RAGE =((1-2*exp(-ti_MP./t(:,:,:,1))));
                if use_mask
                    
                    
                    pd = tmp.img(:,:,:,3)*10^8;
                    referenceslice = pd(:,:,100);
                    maxmin = [min(referenceslice(:)) max(referenceslice(:))];
                    lo = double(maxmin(1));
                    hi = double(maxmin(2));
                    norm_im = (double(referenceslice)-lo)/(hi-lo);
                    norm_level = graythresh(norm_im); %GRAYTHRESH assumes DOUBLE range [0,1]
                    my_level = norm_level*(hi-lo)+lo;
                    pd_mask = pd>my_level;
                    pd_mask_mf = medfilt3(pd_mask,[5 5 5]);
                    
                    tmp.img = tmp.img.*pd_mask_mf;
                    
                    %                     val = thresh_tool(pd(:,:,100));
                    
                end
                
                
                save_nii(tmp,sprintf('./data/%s/%s/s_%s',mysite,subj_name,files(f).name));
                
            end
            
        end
        
    end
    
end
end
