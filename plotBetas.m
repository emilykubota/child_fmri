function [sess1 sess2 sess3 sess4] = plotBetas(roiName,grouped,simplify)

subs = {'NLR_HB275', 'NLR_GB310', 'NLR_KB218', 'NLR_197_BK','NLR_JB420',...
    'NLR_GB355', 'NLR_JB423','NLR_GB267','NLR_IB357'};%,'NLR_GB387'};

% indicates whether we have denoised data for each session 1-4. Each row
% corresponds to index of subject number above. These must match.

sess = [1 1 1 1;...
    1 1 1 1;...
    1 1 1 1;...
    1 1 0 1;...
    1 1 0 1;
    0 1 1 1;...
    0 1 0 1;...
    0 1 1 1;...
    0 1 0 1];%;...
%     1 1 1 0];
%  
% Sets datatype to original, GLM will be run within this script.
 dt = [1]; 
 
 % create empty arrays to collect betas for each session
 sess1 = [];
 sess2 = [];
 sess3 = [];
 sess4 = [];

 
 for ii = 1:length(subs)
     size1 = size(sess1); %Checks how many subjects have data for that session
     size1 = size1(1);    % This will tell us which index to insert data for  
     size2 = size(sess2); % the current subject we are indexing, there is probably
     size2 = size2(1);    % a more elegant way to do this.
     size3 = size(sess3);
     size3 = size3(1);
     size4 = size(sess4);
     size4 = size4(1);
     concatDir = strcat('/mnt/diskArray/projects/LMB_Analysis/',subs{ii},'/concatVistaAligned/concatVista');
     cd(concatDir)
     if sum(sess(ii,:)) == 4 % Add up sess row to see how many sessions we have 
         scan = [1 2 3 4 5 6 7 8]; %if there are 4, we have 8 scans to work with
         vw = initHiddenInplane(dt,scan,roiName); %initialize hidden inplane 
         if vw.selectedROI == 1
             % % enforce consistent preprocessing / event-related parameters
             params = er_defaultParams;
             params.detrend = 2; % Quadtratic 
             params.framePeriod = 2; % TRs
             params.glmHRF     =  3; % SPM difference of gamas
             params.ampType = 'betas';
             er_setParams(vw, params,scan,dt);
         
             %% Apply glm separately for each session
             mv(1) = mv_init(vw,1,[1 2]);
             mv(2) = mv_init(vw,1,[3 4]);
             mv(3) = mv_init(vw,1,[5 6]);
             mv(4) = mv_init(vw,1,[7 8]);
             
             %get betas
             for mi = 1:length(mv)
                 tempmv(mi) = mv_applyGlm(mv(mi));
                 % average the betas across voxels
                 b(mi,:) = mean(tempmv(mi).glm.betas,3);
             end
             
             sess1((size1+1),:) = b(1,:); %based on previous size of the data matrix,
             sess2((size2+1),:) = b(2,:); % insert data at one below.
             sess3((size3+1),:) = b(3,:);
             sess4((size4+1),:) = b(4,:);
         end 
    elseif sum(sess(ii,:)) == 3
         scan = [1 2 3 4 5 6];
         vw = initHiddenInplane(dt,scan,roiName);
         if vw.selectedROI == 1
             % % enforce consistent preprocessing / event-related parameters
             params = er_defaultParams;
             params.detrend = 2;
             params.framePeriod = 2; %ek -changes detrend to quadratic
             params.glmHRF     =  3;
             params.ampType = 'betas';
             er_setParams(vw, params,scan,dt);
             
             %% Apply glm separately for each session
             mv(1) = mv_init(vw,1,[1 2]);
             mv(2) = mv_init(vw,1,[3 4]);
             mv(3) = mv_init(vw,1,[5 6]);
             
             for mi = 1:length(mv)
                 tempmv(mi) = mv_applyGlm(mv(mi));
                 % average the betas across voxels
                 b(mi,:) = mean(tempmv(mi).glm.betas,3);
             end
             
             %based on which scan is missing, figure out which session data
             %belongs with 
             
             if sess(ii,1) == 0 
                 sess2((size2+1),:) = b(1,:);
                 sess3((size3+1),:) = b(2,:);
                 sess4((size4+1),:) = b(3,:);
             elseif sess(ii,2) == 0
                 sess1((size1+1),:) = b(1,:);
                 sess3((size3+1),:) = b(2,:);
                 sess4((size4+1),:) = b(3,:);
             elseif sess(ii,3) == 0
                 sess1((size1+1),:) = b(1,:);
                 sess2((size2+1),:) = b(2,:);
                 sess4((size4+1),:) = b(3,:);
             elseif sess(ii,4) == 0
                 sess1((size1+1),:) = b(1,:);
                 sess2((size2+1),:) = b(2,:);
                 sess3((size3+1),:) = b(3,:);
             end 
         end 
         
     elseif sum(sess(ii,:)) == 2
         scan = [1 2 3 4];
         vw = initHiddenInplane(dt,scan,roiName);
         if vw.selectedROI == 1 
             % % enforce consistent preprocessing / event-related parameters
             params = er_defaultParams;
             params.detrend = 2;
             params.framePeriod = 2; %ek -changes detrend to quadratic
             params.glmHRF     =  3;
             params.ampType = 'betas';
             er_setParams(vw, params,scan,dt);
             
             %% Apply glm separately for each session
             mv(1) = mv_init(vw,1,[1 2]);
             mv(2) = mv_init(vw,1,[3 4]);
             
             for mi = 1:length(mv)
                 tempmv(mi) = mv_applyGlm(mv(mi));
                 % average the betas across voxels
                 b(mi,:) = mean(tempmv(mi).glm.betas,3);
             end
             
             if sess(ii,1) == 0 && sess(ii,2) == 0
                 sess3((size3+1),:) = b(1,:);
                 sess4((size4+1),:) = b(2,:);
             elseif sess(ii,1) == 0 && sess(ii,3) == 0
                 sess2((size2+1),:) = b(1,:);
                 sess4((size4+1),:) = b(2,:);
             elseif sess(ii,1) == 0 && sess(ii,4) == 0 
                sess2((size2+1),:) = b(1,:);
                sess3((size3+1),:) = b(2,:);
            elseif sess(ii,2) == 0 && sess(ii,3) == 0 
                sess1((size1+1),:) = b(1,:);
                sess4((size4+1),:) = b(2,:); 
            elseif sess(ii,2) == 0 && sess(ii,4) == 0 
                sess1((size1+1),:) = b(1,:);
                sess3((size3+1),:) = b(2,:);
            elseif sess(ii,3) == 0 && sess(ii,4) == 0 
                sess1((size1+1),:) = b(1,:);
                sess2((size2+1),:) = b(2,:);
             end 
         end 
         
    elseif sum(sess(ii,:)) == 2
        scan = [1 2];
        vw = initHiddenInplane(dt,scan,roiName);
        if vw.selectedROI == 1
            % % enforce consistent preprocessing / event-related parameters
            params = er_defaultParams;
            params.detrend = 2;
            params.framePeriod = 2; %ek -changes detrend to quadratic
            params.glmHRF     =  3;
            params.ampType = 'betas';
            er_setParams(vw, params,scan,dt);
         
            %% Apply glm separately for each session
            mv(1) = mv_init(vw,1,[1 2]);
        
            for mi = 1:length(mv)
                tempmv(mi) = mv_applyGlm(mv(mi));
                % average the betas across voxels
                b(mi,:) = mean(tempmv(mi).glm.betas,3);
            end 
         
            if sess(ii,1) == 0 && sess(ii,2) == 0 && sess(ii,3) == 0 
                sess4((size4+1),:) = b(1,:);
            elseif sess(ii,1) == 0 && sess(ii,2) == 0 && sess(ii,4) == 0
                sess3((size3+1),:) = b(1,:);
            elseif sess(ii,1) == 0 && sess(ii,3) == 0 && sess(ii,4) == 0
                sess2((size2+1),:) = b(1,:);
            elseif sess(ii,2) == 0 && sess(ii,3) == 0 && sess(ii,4) == 0
                sess1((size1+1),:) = b(1,:);
            end 
        end 
     end 
     
 end

 if grouped == 0 
     f(1,1:8) = mean(sess1(:,1:8));
     f(2,1:8) = mean(sess2(:,1:8));
     f(3,1:8) = mean(sess3(:,1:8)); 
     f(4,1:8) = mean(sess4(:,1:8));
     
     err(1,1:8) = RepMeasErr(sess1(:,1:8));
     err(2,1:8) = RepMeasErr(sess2(:,1:8));
     err(3,1:8) = RepMeasErr(sess3(:,1:8));
     err(4,1:8) = RepMeasErr(sess4(:,1:8));
     
     figure
     hold on
     
     colors = {[.3,.8,.5],[.5,0,.5],[0,.7,.7],[1,.8,.2]};
     
     for j = 1:4
         k = 1:8;
         x = -0.5 + j + 1/9 * k;
         bar(x,f(j,k),'FaceColor',colors{j}); 
         errorbar(x,f(j,k),err(j,k),'.','Color','k')
     end 
 
 elseif grouped == 1 
     size1 = size(sess1);
     size1 = size1(1);
     size2 = size(sess2);
     size2 = size2(1);
     size3 = size(sess3);
     size3 = size3(1);
     size4 = size(sess4);
     size4 = size4(1);
     
     for a = 1:size1
         temp1(a,1) = mean(sess1(a,1:4));
         temp1(a,2) = mean(sess1(a,5:6));
         temp1(a,3) = mean(sess1(a,7:8));
     end
     
     for b = 1:size2
         temp2(b,1) = mean(sess2(b,1:4));
         temp2(b,2) = mean(sess2(b,5:6));
         temp2(b,3) = mean(sess2(b,7:8));
     end
     
     for c = 1:size3
         temp3(c,1) = mean(sess3(c,1:4));
         temp3(c,2) = mean(sess3(c,5:6));
         temp3(c,3) = mean(sess3(c,7:8));
     end
     
     for d = 1:size4
         temp4(d,1) = mean(sess4(d,1:4));
         temp4(d,2) = mean(sess4(d,5:6));
         temp4(d,3) = mean(sess4(d,7:8));
     end
     
     f(1,1:3) = mean(temp1);
     f(2,1:3) = mean(temp2);
     f(3,1:3) = mean(temp3);
     f(4,1:3) = mean(temp4);
     
     err(1,1:3) = RepMeasErr(temp1);
     err(2,1:3) = RepMeasErr(temp2);
     err(3,1:3) = RepMeasErr(temp3);
     err(4,1:3) = RepMeasErr(temp4);
     
     
     s(1,1:3) = mean(temp2);
     s(2,1:3) = mean(temp4);
     
     errs(1,1:3) = RepMeasErr(temp2);
     errs(2,1:3) = RepMeasErr(temp4);
     
     figure
     hold on
     
     colors = {[.3,.8,.5],[.5,0,.5],[0,.7,.7],[1,.8,.2]};
     
if simplify == 0 
    ticklocations = [];
     for j = 1:4
         k = 1:3;
         x = -0.5 + j + 1/4 * k;
         ticklocations = [ticklocations x];
         bar(x,f(j,k),'FaceColor',colors{j}); 
         errorbar(x,f(j,k),err(j,k),'.','Color','k')
     end
     
     set(gca,'xtick',ticklocations,'xticklabels',{'W','F','O','W','F','O',...
     'W','F','O','W','F','O'});
     ylabel('Betas')
     xlabel('Session')
     title(roiName)
     
     

     
elseif simplify == 1
     ticklocations = [];
     for j = 1:2
         k = 1:3;
         x = -0.5 + j + 1/4 * k;
         ticklocations = [ticklocations x];
         bar(x,s(j,k),'FaceColor',colors{j}); 
         errorbar(x,s(j,k),errs(j,k),'.','Color','k')
     end
     
     set(gca,'xtick',ticklocations,'xticklabels',{'W','F','O','W','F','O'});
     ylabel('Betas')
     xlabel('Session')
     title(roiName)
end 
 end 
 