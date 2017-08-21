function denoisedInitialize_vista(sub_num, date)
% This script was taken from Winawer lab wiki, and is being modified to use
% with child fMRI data.

% Set session and anatomy paths
%  Modify: sess_path, subj_id

fmri_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/', sub_num, '/', date, '/fmri');
data_dir = strcat(fmri_dir, '/GLMdenoise');


%% copy parfiles over from main fmri directory 
cd(data_dir)
mkdir('Stimuli')
copyfile(fullfile(fmri_dir,'Stimuli'),fullfile(data_dir,'Stimuli'))

%% Step 4: Build t1_class file to build a 3d surface (mesh)
anat_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sub_num, '/vistaAnat');
cd(anat_dir)
ribbonfile = strcat('/mnt/diskArray/projects/LMB_Analysis/', sub_num, '/vistaAnat/ribbon.mgz');
outfile = strcat('/mnt/diskArray/projects/LMB_Analysis/',sub_num, '/vistaAnat/t1_class.nii.gz');
alignTo = strcat('/mnt/diskArray/projects/LMB_Analysis/',sub_num, '/vistaAnat/t1_acpc_avg.nii.gz');
fillWithCSF = true; 
fs_ribbon2itk(ribbonfile, outfile, fillWithCSF, alignTo)


%% Since we don't have an inplane, we will use the mean functional as an inplane
cd(data_dir)
data=[];
% parentdir = '/home/ekubota/Desktop/raw';
% datadir = '/home/ekubota/Desktop/raw/'; 
%functionals = dir('run01.nii.gz');

% for ii = 1:length(functionals)
%     im = readFileNifti(fullfile(data_dir,sprintf(functionals(ii).name,ii)));
%     data = cat(4,data,im.data);
%     movefile(fullfile(datadir,sprintf('run%02d.nii',ii)),fullfile(datadir,'RAW',sprintf('run%02d.nii',ii)));
% end

im = readFileNifti(fullfile(data_dir,'denoisedGLMrun01.nii'));
data = cat(4,data,im.data);

datam = nanmean(data,4); %data(:,:,:,1);
im.data = datam;
im.pixdim = im.pixdim(1:3);
im.dim = im.dim(1:3);
im.ndim = 3;
im.descrip = 'firstfMRI';
im.fname = fullfile(data_dir,'Inplane.nii');
writeFileNifti(im)

%% To initialize the vista session

% Set session path
cd(data_dir)
 
% Created path to anatomy to identify T1W file (not the most elegant, but
% functional for how the data is arranged)


% Set paths to scan files


%Specify functionals
epi_file{1} = fullfile('denoisedGLMrun01.nii');
assert(exist(epi_file{1},'file')>0)

epi_file{2} = fullfile('denoisedGLMrun02.nii');
assert(exist(epi_file{2},'file')>0)

% Specify INPLANE file
inplane_file = fullfile('Inplane.nii'); 
assert(exist(inplane_file, 'file')>0)
 
% Specify 3DAnatomy file -EK need to change path
%cd(anat_path)
anat_file = fullfile(anat_dir,'t1_acpc_avg.nii.gz');
assert(exist(anat_file, 'file')>0)

%cd(sess_path)

% Create params structure
% Generate the expected generic params structure
params = mrInitDefaultParams;
 
% And insert the required parameters: 
params.inplane      = inplane_file; 
params.functionals  = epi_file; 
params.sessionDir   = data_dir;

% Set optional parameters (specific to experiment)
% Modify: params.subject, params.annotations (e.g. 'FacesHouses' 'Words' 'Bars' 'Bars' 'OnOff'), params.coParams.nCycles (for each scan, can be determined from par files)
params.subject = sub_num;
params.annotations = {'denoisedrun01', 'denoisedrun02'};

% Specify some optional parameters
params.vAnatomy     = anat_file;

% Go!
ok = mrInit(params);
