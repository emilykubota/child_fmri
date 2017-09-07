function initRoutine(sub_num,date)
data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sub_num,'/',date,'/fmri'); 
script_dir = '/home/ekubota/git/child_fmri';
child_initialize_vista(sub_num,data_dir)
child_fmri_glm(data_dir) %Fits GLM to grouped runs and computes contrast maps(VWFA, FFA)
clx
