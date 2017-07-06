%% This script will be a general pipeline for processing fMRI data 
function pipeline_version4(sub_num)

data_dir = strcat('/home/ekubota/Desktop/',sub_num); 
script_dir = '/home/ekubota/git/child_fmri';

%% Step 1: Preprocess fMRI data using Winawer lab pipeline 

cd(data_dir)
eck_preprocessfmri(data_dir)

%% Step 2: Convert to nii.gz and RAS
% Get functional filenames 
EPIs = dir('run0*.nii');

% Check how many functionals there are 
epiSize = size(EPIs);
nFunctionals = epiSize(1);

EPI_names = {};
% Create array of functional names 
for ii = 1:nFunctionals
    EPI_names = [EPI_names EPIs(ii).name];
end 

fun_names = {};
for ii = 1:nFunctionals 
    fun_names = [fun_names strcat(EPIs(ii).name,'.gz')];
end 

%Convert functionals, and set TR to 2.
convert_command = 'mri_convert -ot nii --out_orientation RAS';

for ii = 1:nFunctionals
    % Convert to RAS
    convert = [convert_command ' ' EPI_names{ii} ' ' fun_names{ii}];
    system(convert);
    
    %Set TR to 2 
    h = readFileNifti(fun_names{ii}); 
    h.pixdim(4) = 2; 
    writeFileNifti(h); 
end 


%% Step 3: Use mean functional as inplane & initialize mrVista session
cd(script_dir)
child_initialize_vista(sub_num,data_dir)

%% Step 4: Align functionals and volume using rxAlign and knk tools (using steps from Winawer lab wiki)
cd(data_dir)
child_fmri_align

%% Step 6: Fit the GLM
cd(script_dir)
child_fmri_glm(data_dir) %Fits GLM to grouped runs and computes contrast maps (VWFA, FFA)