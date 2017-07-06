function fake_inplane(datadir)
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
im.fname = fullfile(datadir,'Inplane.nii.gz');
writeFileNifti(im)


%% Align t1 to first functional
f = im; % Mean functional
t1 = readFileNifti('t1_acpc.nii.gz');
% t1FileName = t1w.name;
% t1 = readFileNifti(t1FileName);
% t1.data = datam;
% t1.pixdim = t1.pixdim(1:3);
% t1.dim = t1.dim(1:3);
% t1.ndim = 3;
% t1.descrip = 'T1w';
% t1.fname = fullfile(datadir,'T1w.nii.gz');
% writeFileNifti(t1)
seed = inv(f.qto_xyz)*t1.qto_xyz;  % EPI image space to T1 image space

% get into KK format
T1 = matrixtotransformation(seed,1,t1.pixdim(1:3),f.dim(1:3),f.dim(1:3).*f.pixdim(1:3));

% call the alignment
alignvolumedata(double(t1.data),t1.pixdim(1:3),double(f.data),f.pixdim(1:3),T1);
% Define ellipse
[~,mn,sd] = defineellipse3d(double(f.data));

%% Automatic alignment (coarse)
useMI = true;  % you need MI if the two volumes have different tissue contrast.
               % it's much faster to not use MI.
alignvolumedata_auto(mn,sd,1,[4 4 4],[],[],[],useMI);  % rigid body, coarse, mutual information metric

%% Automatic alignment (fine)
alignvolumedata_auto( mn, sd,1,[1 1 1],[],[],[],useMI);  % rigid body, fine, mutual information metric


%% Export the final transformation
tr = alignvolumedata_exporttransformation;

% make the transformation into a 4x4 matrix
T = transformationtomatrix(tr,1,t1.pixdim(1:3));

%% (5) Save as alignment for your vista session
vw = initHiddenInplane; mrGlobals;


mrSESSION.alignment = eye(4);
saveSession;


%% Optional: Save images showing the alignment

t1match = extractslices(double(t1.data),t1.pixdim(1:3),double(f.data),f.pixdim(1:3),tr);

f.data = t1match;
f.fname = 'Inplane.nii.gz';
writeFileNifti(f);

