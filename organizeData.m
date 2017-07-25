% Get subject numbers for everyone in LMB_Analysis folder 
root_dir = '/mnt/diskArray/projects/LMB_Analysis';
sub_list = HCP_autoDir(root_dir);

% For each subject (si = subject index)
for si = 1:length(sub_list)
    % Get the visit dates 
    visit_dir = strcat(root_dir,'/',sub_list{si});
    visit_dates = HCP_autoDir(visit_dir);
    % For each visit (vi = visit index)
    for vi = 1:length(visit_dates)
        % Check to see if the vist date folder is actually a date
        a = visit_dates{vi};
        sizeA = size(a);
        sizeA = sizeA(2);
        if sizeA == 8
            raw_dir = strcat(root_dir, '/', sub_list{si}, '/',visit_dates{vi},'/raw');
            cd(raw_dir);
            EPI_names = dir('*EPI_106VOL*.PAR'); % check the raw directory for 70V functionals 
            nFunctionals = size(EPI_names);
            nFunctionals = nFunctionals(1);
            if ~isempty(EPI_names) %If there are functionals, make fmri directory and convert parrec files
                cd .. 
                mkdir('fmri') %Make fmri folder
                cd fmri 
                mkdir('Stimuli/parfiles')
                funDir = strcat(root_dir,'/',sub_list{si},'/', visit_dates{vi},...
                '/', 'fmri');
                cd(raw_dir)
            % Convert to nifti and sace into functional directory
                for fi = 1:nFunctionals
                    parrecCommand = strcat('parrec2nii -o', {' '},funDir,{' '},'-c -b',{' '},EPI_names(fi).name);
                    parrecCommand = parrecCommand{1};
                    system(parrecCommand)           
                end
            
            % Check to see if we have anatomy folder, and if not make one
                sub_folder = strcat(root_dir, '/',sub_list{si});
                %sub_folder = sub_folder{1};
                cd(sub_folder)
                if ~exist('mrVista_Anat','dir')
                    mkdir('mrVista_Anat')
                end 
            end
        end 
    end 
end
            