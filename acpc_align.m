function acpc_align(sub_num,date)
% Takes in a path to a T1W image, requires user to set AC and PC and
% outputs an ACPC aligned image

T1path = strcat('/mnt/diskArray/projects/LMB_Analysis/', sub_num,'/', date, '/raw/', sub_num, '_1_WIP_MEMP_VBM_SENSE_14_1.nii.gz')
%T1path = mri_rms(T1path); % Root mean squared image
im = niftiRead(T1path); % Read root mean squared image
voxres = [.8 .8 .8];%diag(im.qto_xyz)'; % Get the voxel resolution of the image (mm)
mrAnatAverageAcpcNifti({T1path}, strcat('/mnt/diskArray/projects/anatomy/', sub_num, '/t1_acpc.nii.gz'), [], voxres(1:3))