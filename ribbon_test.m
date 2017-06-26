%% To build a 3d surface (mesh)
anat_dir = strcat('/home/ekubota/Desktop/test/');
cd(anat_dir)
ribbonfile = strcat('/home/ekubota/Desktop/test/ribbon.mgz');
outfile = strcat('/home/ekubota/Desktop/test/t1_class.nii.gz');
alignTo = strcat('/home/ekubota/Desktop/test/T1w.nii.gz');
fillWithCSF = true; 
fs_ribbon2itk(ribbonfile, outfile, fillWithCSF, alignTo)
