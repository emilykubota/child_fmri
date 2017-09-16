% save data as niftis
% based on /Projects/Saccade_Mislocalization/RK20130317_SaccadeMislocalization/Code/s_runGLM.m


function saveDenoisedasNifti(sessDir)
cd(sessDir)
dataDir = fullfile(sessDir);
epis = matchfiles(fullfile(dataDir, 'run*.nii'));
epiNames = dir('run*.nii');
mkdir('GLMdenoise')
denoiseDir = strcat(sessDir,'/GLMdenoise');
origDir = sessDir;


%cd(denoiseDir);

load results.mat;
load denoiseddata.mat;

cd(denoiseDir);

%loads up original, preprocessed data for each run. Rewrite each nifti's
%file name and data field with denoised data. Resave nifti under new name.
%keeps original nifti params

for ii = 1:length(denoiseddata)    
    filename = fullfile(epis{ii});
    ni = niftiRead(filename);
    
    tempfilename = strcat('denoisedGLM',epiNames(ii).name);
    newfilename = fullfile(denoiseDir, tempfilename);
    ni.fname = newfilename;
    ni.data  = denoiseddata{ii};
    niftiWrite(ni)
    
    
end
