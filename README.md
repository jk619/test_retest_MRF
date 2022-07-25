  This is the processing pipeline for the test-retest 3DMRF, main script is PipelineV1.m
  JK 05/10/2019

  Prerequisites :
  1. SPM12
  2. Tools for NIfTI and ANALYZE image
  3. fslswapdim (do_1_reorient)

  Anatomies were processes with HCP Pipielines
  https://github.com/Washington-University/HCPpipelines


  NOTES
  
  Files used in the realignment are never resliced. The output is only
  a set of matrices that give the information of the realignemnt to the
  header

  After alignment, matricies are copied together with the raw files to the ./data/REG 
  folder. To check the alignment a nifti with T1 anatomy and all T1 MRF
  maps is created in the check_reg folder so you can open it in mango and
  explore the 4D structure (i.e MRF3D001.nii). 

  After segmentation and creation of dartel template a new directory is
  created 'DARTEL', inside there is ANAT_DARTEL - with segmentations and
  warped anatomies (mean anatomy is is saved in check_reg as the last
  volume ANAT.NII) MRF_DARTEL which is raw data with registration matrices and
  WARP_DARTEL which is warped MRF data to DARTEL SPACE

  Inside the check_reg folder there is a file DARTEL.nii that consists
  of all T1 maps in a 4d Nifti in DARTEL SPACE (Alignment puproses)

  reorient folder has 3 matrices that rotate and flip the brains to common
  arrengement. To align the centers of MRF and Anatomy we first have to
  flip the anatomy (reorient_anat) adjust the MRF (reorient_mrf) and bring
  everything to the original space before dartel (reorient_dartel)

   To check if all software is in the path
addpath('/soft/NIfTI_20140122/NIfTI_20140122')
addpath('/soft/spm12/spm12/')

check_prerequisites
  

  Select subjects and sessions for analysis

 subjects   = MRF3D001 MRF3D002 MRF3D003 MRF3D004 MRF3D005 
              MRF3D006 MRF3D007 MRF3D008 MRF3D009 MRF3D010

 sites      = AOUP_3_0 CNR_1_5 CNR_3_0 FSM_1_5

subjects = 1:10;
sites = 1:4;

   Mask the MRF data with PD for better alignment
tic;do_0_mask(subjects,sites);toc
   Align the center of T1 and MRF - instead of setting the origin manually
  This is done by setting the origin of all files to middle point with
  SPM. MRF matrix size is (200,200,200) now the origin is (100,100,100)
  same is done for anatomy 
tic;do_1_reorient(subjects,sites);toc

   Align the subjects within the same session test-retest
tic;do_2_estimate_test_retest(subjects,sites);toc

   Align all files to the reference scan - AUOP in our case
   after this all files per subject should be in the same place
sites_no_ref = 2:4;   [2:4] because 1 is the ref session
tic;do_3_estimate_to_refscan(subjects,sites_no_ref);toc

   Align to anatomy our reference scan and apply it to all files
tic;do_4_all2Anat(subjects,sites);toc

   Create the check_reg files
tic;do_5_brain_mask_and_check(subjects);toc


  
 -----------------DARTEL-----------------
  Copy raw data with the corresponding matrix to the ./DARTEL folder
  and rotate back to the original space that DARTEL likes

tic;do_6_prep4dartel_mrf(subjects,sites);toc

  Copy processed anatomies to ./DARTEL and flip back so SPM likes it
do_7_prep4dartel_anat(subjects)
  Run dartel
do_8_run_dartel(subjects)
  Use estimated deformations to warp the MRF data
do_9_warp2dartel(subjects)
 -----------------DARTEL-----------------

   Create masks for the quantitative analysis 
vall4thr = 0.7   binary thr for probabilistic maps (higher more conservative)
do_10_make_masks_from_dartel(vall4thr)
   Extract CVs for all subjects (cvs) and averaged across subjects on site cvs_sites
[cvs_allsites,cvs_mean_allsites] = do_11_analyze;
   Compate between two selected sessions
  'AOUP_3_0'  = 1;
  'CNR_1_5'   = 2;
  'CNR_3_0'   = 3;
  'FSM_1_5'   = 4;
firstsession = 1;
secondsession = 2;
[cvs_between_sites,cvs_mean_between_sites] = do_12_compare_sessions(firstsession,secondsession);

   Plot the values of test-retest against eachother
subjects = 1:10;
sites = 1:4;
skip = 100;  a lot of data, choose how many to skip in the plot
do_13_plot_vals(subjects,sites,skip)
   Prepare covariates for GLM
[vec_subj,vec_sites,vec_test] = do_13_prepare_covariates;
   Prepare GLM   use the covariate to setup the 
spm   laod spm to see the design
directory4glm = './GLM'
  Setup the contast T1 = 1, T2 = 2, PD = 3
contrast = 1;
do_14_prepare_GLM(vec_subj,vec_sites,vec_test,vec_fields,directory4glm,contrast)
   RUN GLM
do_15_runGLM(directory4glm)
   Plot btas
do_16_plot_betas(directory4glm)
