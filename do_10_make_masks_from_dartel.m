function do_10_make_masks_from_dartel(value4thr)


filename = 'Template_6.nii'
anat_dir = './DARTEL/ANAT_DARTEL';
copyfile(sprintf('%s/%s',anat_dir,filename))

directory = './masks/'


s = load_nii(sprintf('%sTemplate_6.nii',directory))
val = value4thr
s.img(:,:,:,1) = s.img(:,:,:,1) > val
s.img(:,:,:,2) = s.img(:,:,:,2) > val
s.img(:,:,:,3) = s.img(:,:,:,3) > val
save_nii(s,sprintf('%smasks.nii',directory))