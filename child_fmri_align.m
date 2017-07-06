%% Alignment using knk tools abd steps winawer lab wiki 
function child_fmri_align

% Open rxAlign and get crude alignment 
rx = rxAlign;

% Get into KNK format
rxAlignment = rx.xform;
rxAlignment([1 2],:) = rxAlignment([2 1],:);
rxAlignment(:,[1 2]) = rxAlignment(:,[2 1]);
knk.TORIG = rxAlignment;
knk.trORIG = matrixtotransformation(knk.TORIG,0,rx.volVoxelSize,size(rx.ref),size(rx.ref) .* rx.refVoxelSize);

% Precondition the volumes 

volpre = preconditionvolume(rx.vol,[],[],[99 1/3]);
refpre = preconditionvolume(rx.ref);
%close all

% open knk alignment GUI
alignvolumedata(volpre,rx.volVoxelSize,refpre,rx.refVoxelSize,knk.trORIG);

%% 4b Define ellipse
[~,mn,sd] = defineellipse3d(refpre);

useMI = true; %takes longer, but necessary for different tissue contrasts
alignvolumedata_auto(mn,sd,0,[4 4 2],[],[],[],useMI);  % rigid body, coarse, mutual information metric

alignvolumedata_auto(mn,sd,0,[1 1 1],[],[],[],useMI);

alignvolumedata_auto(mn,sd,[0 0 0 0 0 0 1 1 1 1 1 1],[2 2 1],[],[],[],useMI,1e-3);
alignvolumedata_auto(mn,sd,0,[2 2 1],[],[],[],useMI,1e-3);
alignvolumedata_auto(mn,sd,[0 0 0 0 0 0 1 1 1 1 1 1],[2 2 1],[],[],[],useMI,1e-3);
alignvolumedata_auto(mn,sd,0,[2 2 1],[],[],[],useMI,1e-3);
alignvolumedata_auto(mn,sd,[0 0 0 0 0 0 1 1 1 1 1 1],[1 1 1],[],[],[],useMI,1e-3);
alignvolumedata_auto(mn,sd,0,[1 1 1],[],[],[],useMI,1e-3);
alignvolumedata_auto(mn,sd,[0 0 0 0 0 0 1 1 1 1 1 1],[1 1 1],[],[],[],useMI,1e-3);
alignvolumedata_auto(mn,sd,0,[1 1 1],[],[],[],useMI,1e-3);
alignvolumedata_auto(mn,sd,[0 0 0 0 0 0 1 1 1 1 1 1],[1 1 1],[],[],[],useMI,1e-3);
alignvolumedata_auto(mn,sd,0,[1 1 1],[],[],[],useMI,1e-3);
alignvolumedata_auto(mn,sd,[0 0 0 0 0 0 1 1 1 1 1 1],[1 1 1],[],[],[],useMI,1e-3);

% Export the final transformation
tr = alignvolumedata_exporttransformation;
 
% make the transformation into a 4x4 matrix (mrVista format)
T = transformationtomatrix(tr,0,rx.volVoxelSize);
 
% Save as alignment for your vista session
vw = initHiddenInplane; mrGlobals;
mrSESSION.alignment = T;
saveSession;


t1match = extractslices(volpre,rx.volVoxelSize,refpre,rx.refVoxelSize,tr);
 
% inspect the results
if ~exist('Images', 'dir'), mkdir('Images'); end
imwrite(uint8(255*makeimagestack(refpre,1)),'Images/inplane.png');
imwrite(uint8(255*makeimagestack(t1match,1)),'Images/reslicedT1.png');