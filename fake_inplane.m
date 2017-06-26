function fake_inplane(datadir, sub_num)
% Make a fake inplane
cd(datadir)
data=[];
% parentdir = '/home/ekubota/Desktop/raw';
% datadir = '/home/ekubota/Desktop/raw/'; 
functionals = dir('run01_mcf.nii.gz');

for ii = 1:length(functionals)
    im = readFileNifti(fullfile(datadir,sprintf(functionals(ii).name,ii)));
    data = cat(4,data,im.data);
%     movefile(fullfile(datadir,sprintf('run%02d.nii',ii)),fullfile(datadir,'RAW',sprintf('run%02d.nii',ii)));
end
datam = nanmean(data,4); %data(:,:,:,1);
im.data = datam;
im.pixdim = im.pixdim(1:3);
im.dim = im.dim(1:3);
im.ndim = 3;
im.descrip = 'firstfMRI';
im.fname = fullfile(datadir,'FirstFunctional.nii.gz');
writeFileNifti(im)


%% Align t1 to first functional
f = im; % Mean functional
t1 = readFileNifti('T1w.nii.gz');
% t1FileName = t1w.name;
% t1 = readFileNifti(t1FileName);
% t1.data = datam;
% t1.pixdim = t1.pixdim(1:3);
% t1.dim = t1.dim(1:3);
% t1.ndim = 3;
% t1.descrip = 'T1w';
% t1.fname = fullfile(datadir,'T1w.nii.gz');
% writeFileNifti(t1)
seed = inv(t1.qto_xyz)*f.qto_xyz;  % EPI image space to T1 image space

% get into KK format
T = matrixtotransformation(seed,0,t1.pixdim(1:3),f.dim(1:3),f.dim(1:3).*f.pixdim(1:3));

% call the alignment
alignvolumedata(double(t1.data),t1.pixdim(1:3),double(f.data),f.pixdim(1:3),T);
% Define ellipse
[~,mn,sd] = defineellipse3d(double(f.data));

%% Automatic alignment (coarse)
useMI = true;  % you need MI if the two volumes have different tissue contrast.
               % it's much faster to not use MI.
alignvolumedata_auto(mn,sd,0,[4 4 4],[],[],[],useMI);  % rigid body, coarse, mutual information metric

%% Automatic alignment (fine)
alignvolumedata_auto( mn, sd,0,[1 1 1],[],[],[],useMI);  % rigid body, fine, mutual information metric


%% Export the final transformation
tr = alignvolumedata_exporttransformation;

% make the transformation into a 4x4 matrix
T = transformationtomatrix(tr,0,t1.pixdim(1:3));

% %% (5) Save as alignment for your vista session 
% vw = initHiddenInplane; mrGlobals; 
% mrSESSION.alignment = T;
% saveSession;


%% Optional: Save images showing the alignment

t1match = extractslices(double(t1.data),t1.pixdim(1:3),double(f.data),f.pixdim(1:3),tr);

f.data = t1match;
f.fname = 'Inplane.nii.gz';
writeFileNifti(f);

%% To initialize the vista session

cd(datadir)
 
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
params.sessionDir   = datadir; %sess_path;

% Set optional parameters (specific to experiment)
% Modify: params.subject, params.annotations (e.g. 'FacesHouses' 'Words' 'Bars' 'Bars' 'OnOff'), params.coParams.nCycles (for each scan, can be determined from par files)
params.subject = sub_num;
params.annotations = {'run01', 'run02'};

% Specify some optional parameters
params.vAnatomy     = anat_file;

% Go!
ok = mrInit(params);

% Save alignment from making fake inplane for your vista session 
vw = initHiddenInplane; mrGlobals; 
mrSESSION.alignment = T;
saveSession;


