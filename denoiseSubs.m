% Get subject numbers for everyone in LMB_Analysis folder 
root_dir = '/mnt/diskArray/projects/LMB_Analysis';
sub_list = HCP_autoDir(root_dir);

% Get list of subjects we have fmri data for
fMRI_subs = [];
for ii = 1:length(sub_list)
    sub_dir = strcat(root_dir, '/',sub_list{ii});
    cd(sub_dir)
    if exist('vistaAnat', 'dir')
        fMRI_subs = [fMRI_subs {sub_list{ii}}];
    end 
end 
fMRI_subs={'NLR_GB267'};

% For each subject (si = subject index)
for si = 1:length(fMRI_subs)
    % Get the visit dates 
    visit_dir = strcat(root_dir,'/',fMRI_subs{si});
    visit_dates = HCP_autoDir(visit_dir);
    % For each visit (vi = visit index)
    for vi = 4:length(visit_dates)
        % Check to see if the vist date folder is actually a date
        a = visit_dates{vi};
        sizeA = size(a);
        sizeA = sizeA(2);
        if sizeA == 8
            sessDir = strcat(root_dir,'/',fMRI_subs{si},'/',visit_dates{vi});
            functionalDir = strcat(sessDir,'/raw');
            fmriDir = strcat(sessDir,'/fmri');
            cd(functionalDir)
            funCheck = dir('*106VOL*');
            if ~isempty(funCheck)
                cd(fmriDir)
                if (exist(fullfile(sessDir,'fmri','GLMdenoise'),'dir') == 0) && (exist(fullfile(sessDir,'fmri','run02.nii'),'file') == 2)
                    ek_glmDenoise(fMRI_subs{si},visit_dates{vi})
                    %denoisedInitialize_vista(fMRI_subs{si},visit_dates{vi})
                end 
            end 
        end 
    end 
end 
            