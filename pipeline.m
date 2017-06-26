%% This script will be a general pipeline for processing fMRI data 
function pipeline(sub_num)

data_dir = strcat('/home/ekubota/Desktop/',sub_num); 
script_dir = '/home/ekubota/git/child_fmri';

%% Step 1: Convert parrec files to Nifti 

cd(data_dir)
system('parrec2nii -c -b *.PAR');
%% Step 2: ACPC align T1W 
cd(data_dir)

% Get T1W filename 
t1w = dir('*VBM*.nii.gz');
t1w_name = t1w.name; 

% Set T1path 
T1path = strcat(data_dir, '/', t1w_name);

% Call acpc align script. This will require user to set AC and PC, and will
% output file named 't1_acpc.nii.gz'
cd(script_dir)
acpc_align(T1path, sub_num)

%% Step 3: Flip scans into RAS orientation 

cd(data_dir)
% Convert T1W
system('mri_convert --out_orientation RAS t1_acpc.nii.gz T1w.nii.gz'); 

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

%% Step 4: Motion correct functionals using mcFlirt 

cd(data_dir)
system('mcflirt -in ./run01.nii.gz -plots -report');
system('mcflirt -in ./run02.nii.gz -plots -report');

%% Step 4: Create fake inplane 
cd(script_dir)
fake_inplane(data_dir) 

%% Step 5: Initialize vistasoft session 
cd(script_dir)
initialize_vista(sub_num)
child_fmri_glm(data_dir)