function child_initialize_vista(sub_num, data_dir)
% This script was taken from Winawer lab wiki, and is being modified to use
% with child fMRI data.

% Set session and anatomy paths
%  Modify: sess_path, subj_id

%% Step 4: Build t1_class file to build a 3d surface (mesh)
anat_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sub_num, '/mrVista_Anat');
cd(anat_dir)
ribbonfile = strcat('/mnt/diskArray/projects/LMB_Analysis/', sub_num, '/mrVista_Anat/ribbon.mgz');
outfile = strcat('/mnt/diskArray/projects/LMB_Analysis/',sub_num, '/mrVista_Anat/t1_class.nii.gz');
if exist(fullfile(anat_dir,'t1_acpc.nii.gz'),'file') == 2
    alignTo = strcat('/mnt/diskArray/projects/LMB_Analysis/',sub_num, '/mrVista_Anat/t1_acpc.nii.gz');
    avg = 0;
else 
    alignTo = strcat('/mnt/diskArray/projects/LMB_Analysis/',sub_num, '/mrVista_Anat/t1_acpc_avg.nii.gz');
    avg = 1;
end 
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
temp = dir('*.nii');
nruns = size(temp);
nruns = nruns(1);

im = readFileNifti(fullfile(data_dir,temp(1).name));
data = cat(4,data,im.data);

datam = nanmean(data,4); %data(:,:,:,1);
im.data = datam;
im.pixdim = im.pixdim; %(1:3);
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
for ii = 1:nruns
    epi_file{ii} = fullfile(temp(ii).name);
    assert(exist(epi_file{ii},'file')>0)
end 

% epi_file{2} = fullfile(temp(2).name);
% assert(exist(epi_file{2},'file')>0)

% Specify INPLANE file
inplane_file = fullfile('Inplane.nii'); 
assert(exist(inplane_file, 'file')>0)
 
% Specify 3DAnatomy file -EK need to change path
%cd(anat_path)
if avg == 1
    anat_file = fullfile(anat_dir,'t1_acpc_avg.nii.gz');
    assert(exist(anat_file, 'file')>0)
else 
    anat_file = fullfile(anat_dir,'t1_acpc.nii.gz');
    assert(exist(anat_file, 'file')>0)
end 

%cd(sess_path)

% Create params structure
% Generate the expected generic params structure
params = mrInitDefaultParams;
 
% And insert the required parameters: 
params.inplane      = inplane_file; 
params.functionals  = epi_file; 
params.sessionDir   = data_dir;

hold = {};
for n = 1:nruns 
    hold = [hold, strcat('run0',int2str(n))];
end 

% Set optional parameters (specific to experiment)
% Modify: params.subject, params.annotations (e.g. 'FacesHouses' 'Words' 'Bars' 'Bars' 'OnOff'), params.coParams.nCycles (for each scan, can be determined from par files)
params.subject = sub_num;
params.annotations = hold;

% Specify some optional parameters
params.vAnatomy     = anat_file;


% Go!
ok = mrInit(params);

