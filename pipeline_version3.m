%% This script will be a general pipeline for processing fMRI data 
function pipeline_version3(sub_num)

data_dir = strcat('/home/ekubota/Desktop/',sub_num); 
script_dir = '/home/ekubota/git/child_fmri';

%% Step 1: Flip functionals into RAS orientation 

cd(data_dir)

% Get functional filenames 
EPIs = dir('*EPI*.nii.gz');

% Check how many functionals there are 
epiSize = size(EPIs);
nFunctionals = epiSize(1);

EPI_names = {};
fun_names = {};

for ii = 1:nFunctionals
    EPI_names = [EPI_names EPIs(ii).name];
    fun_names = [fun_names strcat('run0',int2str(ii),'.nii.gz')];
end 

%Convert functionals, and set TR to 2.
convert_command = 'mri_convert --out_orientation RAS';

for ii = 1:nFunctionals
    % Convert to RAS
    convert = [convert_command ' ' EPI_names{ii} ' ' fun_names{ii}];
    system(convert);
    
    %Set TR to 2 
    h = readFileNifti(fun_names{ii}); 
    h.pixdim(4) = 2; 
    writeFileNifti(h); 
end 

%% Step 2: Motion correct functionals using mcFlirt 

cd(data_dir)
% first within scan
for ii = 1:length(fun_names)
    system(strcat('mcflirt -in ./',fun_names{ii},' -plots -report'));
end 

% then, between scan
system('flirt -in ./run02_mcf.nii.gz -ref ./run01_mcf.nii.gz -out run02_bw.nii.gz')


%% Step 3: Use mean functional as inplane & initialize mrVista session
cd(script_dir)
child_initialize_vista(sub_num,data_dir)

%% Step 4: Align functionals and volume using rxAlign and knk tools (using steps from Winawer lab wiki)
cd(data_dir)
child_fmri_align

% %% Step 5: Between scan motion compensation
% % Once the mrVista session has been initalized, we can do between scan
% % motion compensation (mrFlirt is within scan only). We only do this step
% % if there is more than one scan
% 
if nFunctionals == 2 
    cd(data_dir)
    vw = initHiddenInplane;
    newDtName = 'MotionComp';
    %Motion correct for both scans 1 and 2
    [vw, M, newDtName] = betweenScanMotComp(vw, newDtName, 1, [1 2]);
%     [vw, M, newDtName] = betweenScanMotComp(vw, newDtName, 1, 2);
end 

%% Step 6: Fit the GLM
cd(script_dir)
child_fmri_glm(data_dir) %Fits GLM to grouped runs and computes contrast maps (VWFA, FFA)