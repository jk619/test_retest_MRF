function do_3_estimate_to_refscan(subjects,sites)

    % clc
    % clear
    usedsubjects = subjects;
    usedsites = sites;
    sites       = dir('./data/*_*');
    sites       = sites([sites(:).isdir]==1);
    myrefsite      = sites(1).name;
    subj        = dir(sprintf('./data/%s/',myrefsite));
    subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));


    %%
    for s = usedsubjects


        subj_name   = subj(s).name;
        ref = sprintf('./data/%s/%s/rs_%s_test.nii,1',myrefsite,subj_name,subj_name);

        for site = usedsites


            clear matlabbatch

            mysite      = sites(site).name;

            if exist(sprintf('./data/%s/%s',mysite,subj_name),'dir');


                source = sprintf('./data/%s/%s/rs_%s_test.nii,1',mysite,subj_name,subj_name);


                disp(sprintf('Registering MRF session %s subject %s to the ref session %s subject %s',mysite,subj_name,myrefsite,subj_name));

                matlabbatch{1}.spm.spatial.coreg.estimate.ref = {ref};
                matlabbatch{1}.spm.spatial.coreg.estimate.source = {source};
                matlabbatch{1}.spm.spatial.coreg.estimate.other = {
                    sprintf('./data/%s/%s/rs_%s_test.nii,1',mysite,subj_name,subj_name)
                    sprintf('./data/%s/%s/rs_%s_test.nii,2',mysite,subj_name,subj_name)
                    sprintf('./data/%s/%s/rs_%s_test.nii,3',mysite,subj_name,subj_name)
                    sprintf('./data/%s/%s/rs_%s_retest.nii,1',mysite,subj_name,subj_name)
                    sprintf('./data/%s/%s/rs_%s_retest.nii,2',mysite,subj_name,subj_name)
                    sprintf('./data/%s/%s/rs_%s_retest.nii,3',mysite,subj_name,subj_name)
                    };
                matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'ncc';
                matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
                matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
                matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

                spm_jobman('run',matlabbatch)

            else
                disp(sprintf('Subject %s not in the %s session',subj_name,sites(site).name));
            end
        end
    end


    disp(sprintf('Data across subjects is aligned to the reference scan \n %s where subjMRF###_test and subjrMRF###_retest are ',myrefsite));

end