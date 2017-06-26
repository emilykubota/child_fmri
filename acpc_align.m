function acpc_align(T1path, sub_num)
% Takes in a path to a T1W image, requires user to set AC and PC and
% outputs an ACPC aligned image

%T1path = mri_rms(T1path); % Root mean squared image
im = niftiRead(T1path); % Read root mean squared image
voxres = diag(im.qto_xyz)'; % Get the voxel resolution of the image (mm)
mrAnatAverageAcpcNifti({T1path}, strcat('/home/ekubota/Desktop/', sub_num, '/t1_acpc.nii.gz'), [], voxres(1:3))