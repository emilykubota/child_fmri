% Find session path 
sessionPath = '/mnt/diskArray/projects/LMB_Analysis/NLR_HB275/20170515/fmri';
cd(sessionPath)

rxAlign; 
% Once you are done with the alignment, pull out the necessary info
rxVista = rxRefresh;
rxClose;
rx = rxVista; clear rxVista;
close all;%% (3) get into knk format 
% (why doesn't he just take the 4x4?)
% the reason is that the coordinate-space conventions are different.
rxAlignment = rx.xform;
rxAlignment([1 2],:) = rxAlignment([2 1],:);
rxAlignment(:,[1 2]) = rxAlignment(:,[2 1]);
knk.TORIG = rxAlignment;
knk.trORIG = matrixtotransformation(knk.TORIG,0,rx.volVoxelSize,size(rx.ref),size(rx.ref) .* rx.refVoxelSize);

volpre = preconditionvolume(rx.vol,[],[],[99 1/3]);
refpre = preconditionvolume(rx.ref);


alignvolumedata(volpre,rx.volVoxelSize,refpre,rx.refVoxelSize,knk.trORIG);
%% Define ellipse
[~,mn,sd] = defineellipse3d(refpre);
%% 4c Automatic alignment (coarse)
useMI = true;  % you need MI if the two volumes have different tissue contrast.
               % it's much faster to not use MI.
alignvolumedata_auto([],[],0,[4 4 2],[],[],[],useMI);  % rigid body, coarse, mutual information metric

%% 4d Automatic alignment (fine)
alignvolumedata_auto(mn,sd,0,[1 1 1],[],[],[],useMI);  % rigid body, fine, mutual information metric

%% 4e Export the final transformation
tr = alignvolumedata_exporttransformation;

% make the transformation into a 4x4 matrix
T = transformationtomatrix(tr,0,rx.volVoxelSize);

%% (5) Save as alignment for your vista session 
vw = initHiddenInplane; mrGlobals; 
mrSESSION.alignment = T;
saveSession;

close all


%% (3) get into knk format 
% (why doesn't he just take the 4x4?)
% the reason is that the coordinate-space conventions are different.
rxAlignment = rx.xform;
rxAlignment([1 2],:) = rxAlignment([2 1],:);
rxAlignment(:,[1 2]) = rxAlignment(:,[2 1]);
knk.TORIG = rxAlignment;
knk.trORIG = matrixtotransformation(knk.TORIG,0,rx.volVoxelSize,size(rx.ref),size(rx.ref) .* rx.refVoxelSize);

volpre = preconditionvolume(rx.vol,[],[],[99 1/3]);
refpre = preconditionvolume(rx.ref);


alignvolumedata(volpre,rx.volVoxelSize,refpre,rx.refVoxelSize,knk.trORIG);
%% Define ellipse
[~,mn,sd] = defineellipse3d(refpre);
%% 4c Automatic alignment (coarse)
useMI = true;  % you need MI if the two volumes have different tissue contrast.
               % it's much faster to not use MI.
alignvolumedata_auto([],[],0,[4 4 2],[],[],[],useMI);  % rigid body, coarse, mutual information metric

%% 4d Automatic alignment (fine)
alignvolumedata_auto(mn,sd,0,[1 1 1],[],[],[],useMI);  % rigid body, fine, mutual information metric

%% 4e Export the final transformation
tr = alignvolumedata_exporttransformation;

% make the transformation into a 4x4 matrix
T = transformationtomatrix(tr,0,rx.volVoxelSize);

%% (5) Save as alignment for your vista session 
vw = initHiddenInplane; mrGlobals; 
mrSESSION.alignment = T;
saveSession;

close all