%% Code for Figure 1A of Kubota, Joo, Huber, & Yeatman 2018 (word selectivity)

% takes in measure, and ROI names, and outputs reading scores for who has
% a right lateralized ROI, left lateralized ROI, and no ROI

[leftVWFA rightVWFA noVWFA] = lateralizationIndex(1,'std', {'LH_WVO_p3.mat','RH_WVO_p3.mat'},0);

%% make bar graph

% take mean of those who have VWFA, and those who do not.
m(1,1) = mean([leftVWFA rightVWFA]);
m(2,1) = mean(noVWFA);

% calculate SE.
se(1,1) = std([leftVWFA rightVWFA])/sqrt(length([leftVWFA rightVWFA])); 
se(2,1) = std(noVWFA)/sqrt(length(noVWFA));

% set the position of the middle of the first bar and second bar (will use
% for scattering individual data)
lhpos_1(1:length(leftVWFA),:) = 1.015;
otherpos_1(1:length(noVWFA),:) = 2.015;

% Graph
figure(1); clf; hold on;
bar(1,m(1),'FaceColor',[1 1 1]);
bar(2,m(2),'FaceColor',[0.6 0.6 0.6]);

% label x axis,
set(gca,'XTick',1:2,'XTickLabel',{'VWFA','no VWFA'},'XLim',[0 3],'TickDir','out')

% and y axis, 
ylabel('TOWRE Index');

% get the stats 
[h,p1] = ttest2([leftVWFA rightVWFA],noVWFA);

hold(gca,'all')

% Make points for each subject transluscent. 
alphaValue = .4;

% scatter individual points over bars
a = scatter(lhpos_1,leftVWFA,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',...
    'none','MarkerFaceAlpha',alphaValue);

c = scatter(otherpos_1,noVWFA,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',...
    'none','MarkerFaceAlpha',alphaValue);
d = 0.01;

% Make error bars rectangles like KNK
rectangle('Position',[1-d m(1)-se(1) 2*d 2*se(1)],'FaceColor',[1 1 1],'EdgeColor',[0 0 0])
rectangle('Position',[2-d m(2)-se(2) 2*d 2*se(2)],'FaceColor',[1 1 1],'EdgeColor',[0 0 0])

origDir = pwd;
cd('/home/ekubota/Desktop/final_figures')

% print out figure in different formats in high res. 
% print('-dpdf','readingScorebyROI.pdf','-r300')
% print('-deps','readingScorebyROI.eps','-r300')
% print('-dpng','readingScorebyROI.png','-r300')