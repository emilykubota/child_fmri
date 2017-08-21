function denoiseRoutine(sub_num, date)

%% glm denoise
ek_glmDenoise(sub_num,date)

%% initialize vista 
denoisedInitialize_vista(sub_num,date)

%% fit glm
denoiseDir = strcat('/mnt/diskArray/projects/LMB_Analysis/', sub_num, '/', date, '/fmri/GLMdenoise');
child_fmri_glm(denoiseDir)
clx