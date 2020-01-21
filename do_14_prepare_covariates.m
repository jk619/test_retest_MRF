function [vec_subj,vec_sites,vec_test,vec_fields] = do_14_prepare_covariates

regfolder = './DARTEL/WARP_DARTEL/';


files        = dir(sprintf('./%s/',regfolder));
files        = files(~ismember({files(:).name},{'.','..','.DS_Store'}));

sites       = dir('./data/*_*');
sites       = sites([sites(:).isdir]==1);


subj        = dir(sprintf('./data/%s/',sites(1).name));
subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));






fields = {'3_0','1_5'};
test = {'_test','_retest'};


vec_subj = zeros(length(files),length(subj));

for f = 1:length(files)
    
    
    for s = 1 : length(subj)
        
        if strfind(files(f).name,subj(s).name) > 0
            
            vec_subj(f,s) = 1;
            
        end
    end
end

%%
vec_sites = zeros(length(files),length(sites));


for f = 1:length(files)
    
    
    for s = 1 : length(sites)
        
        if strfind(files(f).name,sites(s).name) > 0
            
            vec_sites(f,s) = 1;
            
        end
    end
end

%%
vec_fields = zeros(length(files),length(fields));


for f = 1:length(files)
    
    for s = 1 : length(fields)
        
        if strfind(files(f).name,fields{s}) > 0
            
            vec_fields(f,s) = 1;
            
        end
    end
end


vec_test = zeros(length(files),length(test));


for f = 1:length(files)
    
    for s = 1 : length(test)
        
        if strfind(files(f).name,test{s}) > 0
            
            vec_test(f,s) = 1;
            
        end
    end
end

vec_field = zeros(length(files),length(test));

for f = 1:length(files)
    
    for s = 1 : length(test)
        
        if strfind(files(f).name,fields{s}) > 0
            
            vec_fields(f,s) = 1;
            
        end
    end
end






