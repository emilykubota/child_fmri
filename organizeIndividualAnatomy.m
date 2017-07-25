function organizeIndividualAnatomy(sub_num)

T1w = strcat('/mnt/diskArray/projects/anatomy/',sub_num,'/t1_acpc_avg.nii.gz');
ribbon = strcat('/mnt/diskArray/projects/avg_fsurfer/',sub_num,'/mri/ribbon.mgz');
anat_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/', sub_num,'/mrVista_Anat');
copyfile (T1w,anat_dir)
copyfile(ribbon, anat_dir)