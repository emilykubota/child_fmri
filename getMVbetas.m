function b = getMVbetas
sessPath = '/mnt/diskArray/projects/LMB_Analysis/NLR_HB275/concatVistaAligned/concatVista';
cd(sessPath)
%mrVista

roiName = {'RH_VWFA_WVF_p3'};
dt = [1];
scan = [1 2 3 4 5 6 7 8];
vw = initHiddenInplane(dt,scan,roiName);

% % enforce consistent preprocessing / event-related parameters
params = er_defaultParams;
params.detrend = 2;
params.framePeriod = 2; %ek -changes detrend to quadratic
params.glmHRF     =  3;
params.ampType = 'betas';

er_setParams(vw, params,scan,dt);
%% Apply glm separately for each session
mv(1) = mv_init(vw,1,[1 2]);
%mv(1) = mv_init(INPLANE{2},1,[1 2])
mv(2) = mv_init(vw,1,[3 4]);
mv(3) = mv_init(vw,1,[5 6]);
mv(4) = mv_init(vw,1,[7 8]);

for ii = 1:length(mv)
    tempmv(ii) = mv_applyGlm(mv(ii));
    % average teh betas across voxels
    b(ii,:) = mean(tempmv(ii).glm.betas,3);
end

temp(1,1) = mean(b(1,1:4));
temp(1,2) = mean(b(1,5:6));
temp(1,3) = mean(b(1,7:8));

temp(2,1) = mean(b(2,1:4));
temp(2,2) = mean(b(2,5:6));
temp(2,3) = mean(b(2,7:8));

temp(3,1) = mean(b(3,1:4));
temp(3,2) = mean(b(3,5:6));
temp(3,3) = mean(b(3,7:8));

temp(4,1) = mean(b(4,1:4));
temp(4,2) = mean(b(4,5:6));
temp(4,3) = mean(b(4,7:8));

figure
bar(temp)