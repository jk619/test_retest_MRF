  This is the processing pipeline for the test-retest 3DMRF, main script is PipelineV1.m
  JK 05/10/2019

  Prerequisites :
  1. SPM12
  2. Tools for NIfTI and ANALYZE image
  3. fslswapdim (do_1_reorient)

  Anatomies were processes with HCP Pipielines
  https://github.com/Washington-University/HCPpipelines

##
  NOTES:
  
  1) Files used in the realignment are never resliced. The output is only
  a set of matrices that give the information of the realignemnt to the
  header

  2) After alignment, matricies are copied together with the raw files to the ./data/REG 
  folder. To check the alignment a nifti with T1 anatomy and all T1 MRF
  maps is created in the check_reg folder so you can open it in mango and
  explore the 4D structure (i.e MRF3D001.nii). 

  3) After segmentation and creation of dartel template a new directory is
  created 'DARTEL', inside there is ANAT_DARTEL - with segmentations and
  warped anatomies (mean anatomy is is saved in check_reg as the last
  volume ANAT.NII) MRF_DARTEL which is raw data with registration matrices and
  WARP_DARTEL which is warped MRF data to DARTEL SPACE

  4) Inside the check_reg folder there is a file DARTEL.nii that consists
  of all T1 maps in a 4d Nifti in DARTEL SPACE (Alignment puproses)

  5) reorient folder has 3 matrices that rotate and flip the brains to common
  arrengement. To align the centers of MRF and Anatomy we first have to
  flip the anatomy (reorient_anat) adjust the MRF (reorient_mrf) and bring
  everything to the original space before dartel (reorient_dartel)

  6) To check if all software is in the path
   check_prerequisites
  

  Select subjects and sessions for analysis

 >subjects   = MRF3D001 MRF3D002 MRF3D003 MRF3D004 MRF3D005 
              MRF3D006 MRF3D007 MRF3D008 MRF3D009 MRF3D010
              
 >sites      = AOUP_3_0 CNR_1_5 CNR_3_0 FSM_1_5


Data (test and retest quantitative T1, T2 and PD maps) can be obtained from zenodo (https://zenodo.org/record/3989799#.Yt8vky-B1cQ)
##
For example on how to run seperate scripts see _PipelineV1.m_

