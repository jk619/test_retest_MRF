function do_2_estimate_test_retest(subjects,sites)
    % clc
    % clear
    usedsubjects = subjects;
    usedsites = sites;

    sites       = dir('./data/*_*');
    sites       = sites([sites(:).isdir]==1);

    spm('defaults','FMRI');

    which_map = 1; % 1 for T1, 2 for T2, 3 for PD;
    maps = {'T1','T2','PD'};


    subj        = dir('./data/struct3T/');
    subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));

    for s = usedsubjects% : length(subj)

        subj_name =subj(s).name;

        for site = usedsites


            mysite  = sites(site).name;

            clear matlabbatch

            if ~exist(sprintf('./data/%s/%s/',mysite,subj_name));
                disp(sprintf('Subject %s not in the %s session',subj_name,sites(site).name));

            else

                disp(sprintf('Registering MRF test-retest session %s subject %s using %s',mysite,subj_name,maps{which_map}));

                matlabbatch{1}.spm.spatial.coreg.estimate.ref = {sprintf('./data/%s/%s/rs_%s_test.nii,%i',mysite,subj_name,subj_name,which_map)};
                matlabbatch{1}.spm.spatial.coreg.estimate.source = {sprintf('./data/%s/%s/rs_%s_retest.nii,%i',mysite,subj_name,subj_name,which_map)};
                matlabbatch{1}.spm.spatial.coreg.estimate.other = {
                    sprintf('./data/%s/%s/rs_%s_retest.nii,%i',mysite,subj_name,subj_name,1)
                    sprintf('./data/%s/%s/rs_%s_retest.nii,%i',mysite,subj_name,subj_name,2)
                    sprintf('./data/%s/%s/rs_%s_retest.nii,%i',mysite,subj_name,subj_name,3)
                    };
                matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'ncc';
                matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
                matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
                matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

                spm_jobman('run',matlabbatch);

            end
        end
    end
end