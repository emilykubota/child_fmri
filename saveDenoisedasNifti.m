% save data as niftis
% based on /Projects/Saccade_Mislocalization/RK20130317_SaccadeMislocalization/Code/s_runGLM.m


function saveDenoisedasNifti(sessDir)
cd(sessDir)
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
    filename = fullfile(origDir, sprintf('run%02.0f.nii',ii));
    ni = niftiRead(filename);
    
    newfilename = fullfile(denoiseDir, sprintf('denoisedGLMrun%02.0f.nii',ii));
    ni.fname = newfilename;
    ni.data  = denoiseddata{ii};
    niftiWrite(ni)
    
    
end
