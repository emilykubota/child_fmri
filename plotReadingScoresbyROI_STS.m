% function plotReadingScoresbyROI

[leftVWFA_e rightVWFA_e noVWFA_e] = lateralizationIndex(1,'std', {'LH_STS_p3.mat','RH_STS_p3.mat'},0);


%% make error bar graph

m(1,1) = mean([leftVWFA_e rightVWFA_e]);%[94.9167]; %90.7857];
% m(1,2) = mean([leftVWFA_f rightVWFA_f]);
m(2,1) = mean(noVWFA_e);%[66.00]; %69.667];
% m(2,2) = mean(noVWFA_f);

% Demean each subject before calculating error
se(1,1) = std([leftVWFA_e rightVWFA_e])/sqrt(length([leftVWFA_e rightVWFA_e])); %6.2575];
% se(1,2) = std([leftVWFA_f rightVWFA_f])/sqrt(length([leftVWFA_f rightVWFA_f]));
se(2,1) = std(noVWFA_e)/sqrt(length(noVWFA_e));%[3.9279]; % 8.3533];
% se(2,2) = std(noVWFA_f)/sqrt(length(noVWFA_f));

% New column names
newcnames = {'word vs. object'};%,'word vs. face'}; %, 'Word vs face'}

lhpos_1(1:length(leftVWFA_e),:) = 1.015;
otherpos_1(1:length(noVWFA_e),:) = 2.015;
% rhpos_1(1:length(rightVWFA_e),:) = .815;
% lhpos_2(1:length(leftVWFA_f),:) = 1.815;
% otherpos_2(1:length(noVWFA_f),:) = 2.215;
% rhpos_2(1:length(rightVWFA_f),:) = 1.815;

% Graph
% d = errorbargraph(m,se,[],[1 1 1; .6 .6 .6]);
figure(1); clf; hold on;
bar(1,m(1),'FaceColor',[1 1 1]);
bar(2,m(2),'FaceColor',[0.6 0.6 0.6]);
% errorbar([1 2],m(:,1),se,'.k');

set(gca,'XTick',1:2,'XTickLabel',{'STC','no STC'},'XLim',[0 3],'TickDir','out')

ylabel('TOWRE Index');


[h,p1,ci,stats] = ttest2([leftVWFA_e rightVWFA_e],noVWFA_e);

hold(gca,'all')

alphaValue = .4;
a = scatter(lhpos_1,leftVWFA_e,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor','none','MarkerFaceAlpha',alphaValue);


c = scatter(otherpos_1,noVWFA_e,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor','none','MarkerFaceAlpha',alphaValue);
d = 0.01;
rectangle('Position',[1-d m(1)-se(1) 2*d 2*se(1)],'FaceColor',[1 1 1],'EdgeColor',[0 0 0])
rectangle('Position',[2-d m(2)-se(2) 2*d 2*se(2)],'FaceColor',[1 1 1],'EdgeColor',[0 0 0])
 
origDir = pwd;
cd('/home/ekubota/Desktop/final_figures')
% print('-dpdf','readingScorebyROI.pdf','-r300')
% print('-deps','readingScorebyROI.eps','-r300')
% print('-dpng','readingScorebyROI.png','-r300')