function singleSessionConcatGLM(data_dir)

% Open session
cd(data_dir)
vw = initHiddenInplane();

vw = viewSet(vw, 'current dt', 'Original');

scanIndex = [1 3 5 7];
%% Prepare scans for GLM
for ii = scanIndex(2:4)
    %numScans = viewGet(vw, 'numScans');
    whichScans = ii:(ii+1);
    home = pwd;
    cd Stimuli/parfiles
    parfs = dir('run*.par');
    whichParfs = {parfs(ii).name...
        parfs(ii+1).name};
    cd(home)
    vw = er_assignParfilesToScans(vw, whichScans, whichParfs); % Assign parfiles to scans
    dt = 'Original';
    w = er_groupScans(vw, whichScans, [], dt); % Group scans together
    % Check assigned parfiles and groups
    er_displayParfiles(vw);
    
    %% run the glm
    dt = 'Original';
    newDtName = 'GLMs';
    
    % GLM parameters
    params = er_defaultParams;
    params.detrend = 2;
    params.framePeriod = 2; %ek -changes detrend to quadratic
    % params.onsetDelta =  0;     % we deleted 4 frames = 6 seconds in pre-processing
    % params.glmHRF     =  3;     % spm difference of two gamma functions
    % params.eventsPerBlock = 8;  % 8 frames (12 seconds) per block
    % params.framePeriod = 1.5;
    
    %apply GLM for grouped scans
    vw = applyGlm(vw, dt, whichScans, params, newDtName);
    updateGlobal(vw);
    
%     %compute VWFA contrast map
%     stim     = er_concatParfiles(vw);
%     active   = [1 2 3 4]; % words
%     control  = [5 6 7 8]; % everything else
%     saveName = [];
%     vw       = computeContrastMap2(vw, active, control, saveName);
%     updateGlobal(vw);
%     
%     %compute FFA contrast map
% 
%     stim     = er_concatParfiles(vw);
%     active   = [5 6]; % faces
%     control  = [1 2 3 4 7 8]; % everything else
%     saveName = [];
%     vw       = computeContrastMap2(vw, active, control, saveName);
%     
%     updateGlobal(vw);
end 

