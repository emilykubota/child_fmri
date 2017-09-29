function [results, denoiseddata] = ek_glmDenoise(sub_num,date)


sessDir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sub_num,'/',date,'/fmri');
%sessDir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sub_num,'/concatVistaAligned/',sess);
cd(sessDir)
 
% Open hidden inplane in order to define global variables
vw = initHiddenInplane;
vw = viewSet(vw, 'cur dt', 'Original');

%% Define design matrix
%parfile = matchfiles(fullfile(sessDir,'Stimuli', 'parfiles', '*.par'));
parDir = strcat(sessDir,'/Stimuli/parfiles');
cd(parDir)
parfiles = dir('*.par');
nParfiles = size(parfiles);
nParfiles = nParfiles(1);
parNames = {};

for ii = 1:nParfiles 
    parNames = [parNames parfiles(ii).name];
end 

design = {};
tr = 2;
for ii = 1:nParfiles
    design = [design makeDesignMatrixFromParfile(sessDir, parNames{ii}, tr)];
end 
 
cd(sessDir)
%% Load in preprocessed data
%Get EPI file names
dataDir = fullfile(sessDir);
epis = matchfiles(fullfile(dataDir, 'run*.nii'));

nScans = 2;
%Read in the data
data = cell(1, nScans);
for ii = 1:nScans
    tmp = niftiRead(epis{ii});
    data{ii} = tmp.data;
end

%% Define HRF
stimdur = 4; %seconds. Length of block
hrf = getcanonicalhrf(stimdur, tr);
 
% plot HRF
figure('Name', 'canonical hrf', 'Color', [1 1 1]);
plot(hrf);
 
title('canonical hrf (spm diff of gammas)');
xlabel('Time from condition onset (s)');
ylabel('Response (arbitrary units)');

%% run it 
[results, denoiseddata] = GLMdenoisedata(design, data, stimdur, tr, [],[],[],'GLMdenoisefigures');

save results.mat results 
save denoiseddata.mat denoiseddata

%% save denoised files as nifti
saveDenoisedasNifti(sessDir);