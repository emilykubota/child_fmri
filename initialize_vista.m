function initialize_vista(sub_num, alignment)
% This script was taken from Winawer lab wiki, and is being modified to use
% with child fMRI data.

% Set session and anatomy paths
%  Modify: sess_path, subj_id

% %% To build a 3d surface (mesh) - will worry about this later EK
% anat_dir = strcat('/mnt/scratch/', folder,'/',sub_num,'/MNINonLinear');
% cd(anat_dir)
% ribbonfile = strcat('/mnt/scratch/', folder, '/',sub_num,'/MNINonLinear/ribbon.nii.gz');
% outfile = strcat('/mnt/scratch/', folder, '/',sub_num,'/MNINonLinear/t1_class.nii.gz');
% alignTo = strcat('/mnt/scratch/', folder, '/',sub_num,'/MNINonLinear/T1w.nii.gz');
% fillWithCSF = true; 
% fs_ribbon2itk(ribbonfile, outfile, fillWithCSF, alignTo)

%% To initialize the vista session

% Set session path
sess_path = strcat('/home/ekubota/Desktop/',sub_num);
cd(sess_path)
 
% Created path to anatomy to identify T1W file (not the most elegant, but
% functional for how the data is arranged)

%anat_path = strcat('/home/ekubota/Desktop/', sub_num);

% Set paths to scan files


%Specify functionals
epi_file{1} = fullfile('run01.nii.gz');
assert(exist(epi_file{1},'file')>0)

epi_file{2} = fullfile('run02.nii.gz');
assert(exist(epi_file{2},'file')>0)

% Specify INPLANE file
inplane_file = fullfile('Inplane.nii.gz'); 
assert(exist(inplane_file, 'file')>0)
 
% Specify 3DAnatomy file -EK need to change path
%cd(anat_path)
anat_file = fullfile('T1w.nii.gz');
assert(exist(anat_file, 'file')>0)

%cd(sess_path)

% Create params structure
% Generate the expected generic params structure
params = mrInitDefaultParams;
 
% And insert the required parameters: 
params.inplane      = inplane_file; 
params.functionals  = epi_file; 
params.sessionDir   = sess_path;

% Set optional parameters (specific to experiment)
% Modify: params.subject, params.annotations (e.g. 'FacesHouses' 'Words' 'Bars' 'Bars' 'OnOff'), params.coParams.nCycles (for each scan, can be determined from par files)
params.subject = sub_num;
params.annotations = {'run01', 'run01'};

% Specify some optional parameters
params.vAnatomy     = anat_file;

% Go!
ok = mrInit(params);

% Save alignment from making fake inplane for your vista session 
vw = initHiddenInplane; mrGlobals; 
mrSESSION.alignment = T;
saveSession;

