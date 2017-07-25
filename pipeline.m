%% This script will be a general pipeline for processing fMRI data 
function pipeline(sub_num,date)

data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sub_num,'/',date,'/fmri'); 
script_dir = '/home/ekubota/git/child_fmri';

%% Step 1: Preprocess fMRI data using Winawer lab pipeline 

eck_preprocessfmri(data_dir)

%% Step 2: Convert functionals to RAS
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


%Convert functionals, and set TR to 2.
convert_command = 'mri_convert --out_orientation RAS';

for ii = 1:nFunctionals
    % Convert to RAS
    convert = [convert_command ' ' EPI_names{ii} ' ' EPI_names{ii}];
    system(convert);
    
    %Set TR to 2 
    h = readFileNifti(EPI_names{ii}); 
    h.pixdim(4) = 2;
    h.data = uint16(h.data);
    writeFileNifti(h); 
end 


%% Step 3: Use mean functional as inplane & initialize mrVista session
cd(script_dir)
child_initialize_vista(sub_num,data_dir)

%% Step 4: Align functionals and volume using rxAlign and knk tools (using steps from Winawer lab wiki)
%child_fmri_align(data_dir)
%% At this point, run child_fmri_align 
%% Step 6: Fit the GLM
cd(script_dir)
child_fmri_glm(data_dir) %Fits GLM to grouped runs and computes contrast maps(VWFA, FFA)
clx