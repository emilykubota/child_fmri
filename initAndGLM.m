function initAndGLM(subnum,datadir)

% initializes vistasoft session and runs GLM
child_initialize_vista(subnum,datadir)
child_fmri_glm(datadir)
clx
