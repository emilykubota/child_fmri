function child_fmri_glm(data_dir)

% Open session
cd(data_dir)
vw = initHiddenInplane();

vw = viewSet(vw, 'current dt', 'Original');
%% Prepare scans for GLM

%numScans = viewGet(vw, 'numScans');
% whichScans = 1:2;

% If you're processing your own experiment, you'll need to produce parfiles
% More info @
% http://white.stanford.edu/newIm/index.php/GLM#Create_.par_files_for_each_scan
home = pwd;
cd Stimuli/parfiles
parfs = dir('*.par');

nruns = size(parfs);
nruns = nruns(1);
whichScans = 1:nruns;
whichParfs = [];
for nn = 1:nruns 
    whichParfs = [whichParfs {parfs(nn).name}];
end 

cd(home)
vw = er_assignParfilesToScans(vw, whichScans, whichParfs); % Assign parfiles to scans

dt = 'Original';
vw = er_groupScans(vw, whichScans, [], dt); % Group scans together


% Check assigned parfiles and groups
er_displayParfiles(vw);


%% run the glm
dt = 'Original';
newDtName = 'GLMs';

% GLM parameters
params = er_defaultParams;
params.detrend = 2; %changes detrend to quadtadic 
params.framePeriod = 2; %sets TR to 2
params.glmHRF     =  3;     % spm difference of two gamma functions


%apply GLM for grouped scans
vw = applyGlm(vw, dt, whichScans, params, newDtName);
updateGlobal(vw);

%compute VWFA contrast map

stim     = er_concatParfiles(vw);
active   = [1 2 3 4]; % words
control  = [5 6 7 8]; % everything else
saveName = [];
vw       = computeContrastMap2(vw, active, control, saveName);


updateGlobal(vw);

%compute FFA contrast map

stim     = er_concatParfiles(vw);
active   = [5 6]; % faces
control  = [1 2 3 4 7 8]; % everything else
saveName = [];
vw       = computeContrastMap2(vw, active, control, saveName);


updateGlobal(vw);

