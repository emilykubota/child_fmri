function initVistaSingleSub(sub_num)
root_dir = '/mnt/diskArray/projects/LMB_Analysis/';
sub_dir = strcat(root_dir,sub_num);
%get dates of folder 
visit_dates = HCP_autoDir(sub_dir);

for ii = 4:length(visit_dates)
        % Check to see if the vist date folder is actually a date
        a = visit_dates{ii};
        sizeA = size(a);
        sizeA = sizeA(2);
        if sizeA == 8
            visit_dir = strcat(sub_dir,'/',visit_dates{ii});
            fmriCheck = strcat(visit_dir,'/fmri/Stimuli/parfiles');
            if exist(fmriCheck,'dir')
                cd(fmriCheck)
                fLocCheck = dir('*fLoc*.par'); % check for parfile indicating fLoc
                if ~isempty(fLocCheck)
                    initRoutine(sub_num,visit_dates{ii});
                end
            end 
        end 
end 