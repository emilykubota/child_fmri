% Get subject numbers for everyone in LMB_Analysis folder 
root_folder = '/mnt/diskArray/projects/LMB_Analysis';
sub_list = HCP_autoDir(root_folder);

% For each subject (si = subject index)
for si = 1:length(sub_list)
    % Get the visit dates 
    visit_dates = HCP_autoDir(strcat(root_folder, sub_list(si)));
    % For each visit (vi = visit index)
    for vi = 1:length(visit_dates)
        % Check to see if the subject completed fMRI expreriment in raw
        % folder
        cd (strcat(root_folder,sub_list(si),visit_dates(vi),'raw'));
        EPI_names = dir('*EPI_70_VOL*');
        nFunctionals = size(EPI_names);
        nFunctionals = nFunctionals(1);
        if ~isempty(EPI_names)
            cd .. 
            mkdir('fmri') %Make fmri folder 
            % Copy functionals over 
            for fi = 1:nFunctionals
            copyfile(strcat(root_folder,'/',sub_list(si),'/',...
                visit_dates(vi),'/raw/', EPI_names(fi).name), ... 
                strcat(root_folder,'/',sub_list(si),'/', visit_dates(vi),...
                '/', 'fmri'));
            end
            
            % Check to see if we have anatomy folder, and if not make one
            cd(strcat(root_folder, sub_list(si)))
            if ~exist('mrVista_Anat','dir')
                mkdir('mrVista_Anat')
            end 
        end
    end 
 % ADD CODE TO COPY OVER ANATOMY STUFF HERE 
 if exist('mrVista_Anat', 'dir')
 end
end 
            