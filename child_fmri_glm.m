function child_fmri_glm(data_dir)

% Open session
cd(data_dir)
vw = initHiddenInplane();

vw = viewSet(vw, 'current dt', 'MotionComp');
%% Prepare scans for GLM

%numScans = viewGet(vw, 'numScans');
whichScans = 1:2;

% If you're processing your own experiment, you'll need to produce parfiles
% More info @
% http://white.stanford.edu/newIm/index.php/GLM#Create_.par_files_for_each_scan
home = pwd;
cd Stimuli/parfiles
parfs = dir('*fLoc*.par');
whichParfs = {parfs(1).name...
   parfs(2).name};

cd(home)
vw = er_assignParfilesToScans(vw, whichScans, whichParfs); % Assign parfiles to scans

%vw = er_groupScans(vw, whichScans, [], dataType); % Group scans together


% Check assigned parfiles and groups
er_displayParfiles(vw);


%% run the glm
dt = 'MotionComp';
newDtName = 'GLMs';

% GLM parameters
params = er_defaultParams;
params.detrend = 2;
params.framePeriod = 2; %ek -changes detrend to quadratic
% params.onsetDelta =  0;     % we deleted 4 frames = 6 seconds in pre-processing
% params.glmHRF     =  3;     % spm difference of two gamma functions
% params.eventsPerBlock = 8;  % 8 frames (12 seconds) per block
% params.framePeriod = 1.5;


%apply GLM for run 1
vw = applyGlm(vw, dt, 1, params, newDtName);

%compute contrast map

stim     = er_concatParfiles(vw);
active   = [1 2]; % words
control  = [3 4 5 6]; % everything else
saveName = [];
vw       = computeContrastMap2(vw, active, control, saveName);


updateGlobal(vw);

%apply GLM & compute contrast map for run 2
vw = applyGlm(vw, dt, 2, params, newDtName);

stim     = er_concatParfiles(vw);
active   = [1 2]; %words
control  = [3 4 5 6]; %everything else
saveName = [];
vw       = computeContrastMap2(vw, active, control, saveName);

updateGlobal(vw);



