
sessPath = '/mnt/diskArray/projects/LMB_Analysis/NLR_GB310/concatVista';
cd(sessPath)
%mrVista

roiName = {'LH_FFA_p2'};
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
figure
bar(b)