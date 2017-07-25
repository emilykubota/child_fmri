ek_glm 

sessDir = '/Volumes/server/Projects/Gamma_BOLD/wl_subj004';
cd(sessDir)
 
% Open hidden inplane in order to define global variables
vw = initHiddenInplane;
vw = viewSet(vw, 'cur dt', 'Original');