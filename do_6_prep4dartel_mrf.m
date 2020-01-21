function do_6_prep4dartel_mrf(subjects,sites)


usedsubjects = subjects;
usedsites = sites;

sites       = dir('./data/*_*');
sites       = sites([sites(:).isdir]==1);

subj        = dir(sprintf('./data/%s/',sites(1).name));
subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));

regfolder = './DARTEL_NEW/MRF_DARTEL';
mkdir(regfolder);
ct = 1;
for s = usedsubjects
    
    subj_name   = subj(s).name;
    
    for site = usedsites
        
        mysite = sites(site).name;
        
        if exist(sprintf('./data/%s/%s',mysite,subj_name),'dir')
            
            files = dir(sprintf('./data/%s/%s/%s_*.nii',mysite,subj_name,subj_name));
            
            for f = 1 : length(files)
                
                copyfile([files(f).folder filesep files(f).name], [regfolder filesep sprintf('%s_%s',mysite,files(f).name)])
                mrffiles{ct} = [regfolder filesep sprintf('%s_%s,1',mysite,files(f).name)];ct = ct + 1;
                mrffiles{ct} = [regfolder filesep sprintf('%s_%s,2',mysite,files(f).name)];ct = ct + 1;
                mrffiles{ct} = [regfolder filesep sprintf('%s_%s,3',mysite,files(f).name)];ct = ct + 1;

            end
            
            regmat = dir(sprintf('./data/%s/%s/rs*.mat',mysite,subj_name));
            
            for fm = 1 : length(regmat)
                
                copyfile([regmat(fm).folder filesep regmat(fm).name], [regfolder filesep sprintf('%s_%s.mat',mysite,files(fm).name(1:end-4))])
                
            end
        end
    end
end


% allmrf=spm_select('ExtFPList',regfolder,'.*',[1 2 3]);
% 
% 
% for f = 1 : size(allmrf,1)
%     
%     mrffiles{f} = allmrf(f,:);
%     
% end

clear matlabbatch
matlabbatch{1}.spm.util.reorient.srcfiles = mrffiles';
matlabbatch{1}.spm.util.reorient.transform.transF = {'./reorient/reorient_dartel.mat'};
spm_jobman('run',matlabbatch);

end




