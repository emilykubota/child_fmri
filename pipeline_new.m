%% This script will be a general pipeline for processing fMRI data 
function pipeline_new(sub_num)

data_dir = strcat('/home/ekubota/Desktop/',sub_num); 
script_dir = '/home/ekubota/git/child_fmri';

%% Step 1 
% Convert gold standard T1W into nii.gz 
cd(data_dir)
system('mri_convert -ot nii --out_orientation RAS T1.mgz T1w.nii.gz')

%% Step 2: Flip functionals into RAS orientation 

cd(data_dir)

% Get functional filenames 
EPIs = dir('*EPI*.nii.gz');
EPI_names = {EPIs(1).name, EPIs(2).name};

%Convert functionals, and set TR to 2.
fun_names = {'run01.nii.gz', 'run02.nii.gz'};
convert_command = 'mri_convert --out_orientation RAS';

for ii = 1:length(fun_names)
    % Convert to RAS
    convert = [convert_command ' ' EPI_names{ii} ' ' fun_names{ii}];
    system(convert);
    
    %Set TR to 2 
    h = readFileNifti(fun_names{ii}); 
    h.pixdim(4) = 2; 
    writeFileNifti(h); 
end 

%% Step 3: Motion correct functionals using mcFlirt 

cd(data_dir)
system('mcflirt -in ./run01.nii.gz -plots -report');
system('mcflirt -in ./run02.nii.gz -plots -report');

%% Step 4: Build t1_class file to build a 3d surface (mesh)
anat_dir = strcat('/home/ekubota/Desktop/',sub_num);
cd(anat_dir)
ribbonfile = strcat('/home/ekubota/Desktop/', sub_num, '/ribbon.mgz');
outfile = strcat('/home/ekubota/Desktop/', sub_num, '/t1_class.nii.gz');
alignTo = strcat('/home/ekubota/Desktop/', sub_num, '/T1w.nii.gz');
fillWithCSF = true; 
fs_ribbon2itk(ribbonfile, outfile, fillWithCSF, alignTo)

%% Step 4: Create fake inplane & initialize session
cd(script_dir)
fake_inplane(data_dir, sub_num) 

%% Step 5: Between scan motion compensation
% Once the mrVista session has been initalized, we can do between scan
% motion compensation (mrFlirt is within scan only)
cd(data_dir)
vw = initHiddenInplane;
newDtName = 'MotionComp'
%Motion correct for both scans 1 and 2
[vw, M, newDtName] = betweenScanMotComp(vw, newDtName, 2, 1);
[vw, M, newDtName] = betweenScanMotComp(vw, newDtName, 1, 2);

%% Step 6: Fit the GLM
cd(script_dir)
child_fmri_glm(data_dir)