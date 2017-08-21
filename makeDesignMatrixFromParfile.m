function X = makeDesignMatrixFromParfile(sessDir, parfile, TR)
 
home = pwd;
parPath = strcat(sessDir, '/Stimuli', '/parfiles');
cd(parPath)
[onsets, conds, labels] = readParFile(parfile);
 
%create matrix of zeros with dimensions #TRs x nConditions
% first check to see if its the old experiment (70 vol) or new eperiment EK
cd(sessDir) 
trCheck = dir('*70*');
if isempty(trCheck)
    nTRs = 106;
    nConds = 9;
else
    nTRs = 70;
    nConds = 7;
end

X = zeros(nTRs, nConds);
 
%fill in design matrix with 1's indicating event onset and type (e.g. event
%at tr = 6 that was condition 4 would be indicated by a 1 in row 6, col 4)
for i = 1:length(onsets)
    cur_tr = (onsets(i)/TR) + 1;
    cur_cond = conds(i) + 1;
    X(cur_tr, cur_cond) = 1;
end
 
%check;
figure; imagesc(X);
colormap(gray); colorbar;
xlabel('Conditions');
ylabel('Time points');

cd(home)