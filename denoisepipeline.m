function denoisepipeline(subnum, date)

datadir = strcat('/mnt/diskArray/projects/LMB_Analysis/',subnum,'/',date,'/fmri/GLMdenoise');
child_initialize_vista(subnum,datadir)

child_fmri_glm(datadir)
clx 