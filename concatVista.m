% Get subject numbers for everyone in LMB_Analysis folder 
root_dir = '/mnt/diskArray/projects/LMB_Analysis';
sub_list = HCP_autoDir(root_dir);

% Get list of subjects we have fmri data for
fMRI_subs = [];
for ii = 1:length(sub_list)
    sub_dir = strcat(root_dir, '/',sub_list{ii});
    cd(sub_dir)
    if exist(fullfile(root_dir,sub_list{ii},'mrVista_Anat'), 'dir')
        if ~exist(fullfile(root_dir,sub_list{ii},'concatVista'),'dir') %make folder to put all denoised data into
            mkdir 'concatVista'
        end
        if ~exist(fullfile(root_dir,sub_list{ii},'concatVista','Stimuli'),'dir') %make folder for parfiles
            cd 'concatVista'
            mkdir 'Stimuli'
        end
        fMRI_subs = [fMRI_subs {sub_list{ii}}];
    end 
end 


% For each subject (si = subject index)
for si = 1:length(fMRI_subs)
    % Get the visit dates 
    visit_dir = strcat(root_dir,'/',fMRI_subs{si});
    visit_dates = HCP_autoDir(visit_dir);
    % For each visit (vi = visit index)
    for vi = 1:length(visit_dates)
        % Check to see if the vist date folder is actually a date
        a = visit_dates{vi};
        sizeA = size(a);
        sizeA = sizeA(2);
        if sizeA == 8
            sessDir = strcat(root_dir,'/',fMRI_subs{si},'/',visit_dates{vi});
            cd(sessDir)
            if (exist(fullfile(sessDir,'fmri'),'dir') == 7)
                cd fmri
                if (exist(fullfile(sessDir,'fmri','GLMdenoise'),'dir') == 7)
                    cd GLMdenoise 
                    % Check number of runs
                    nruns = dir('denoisedGLMrun*.nii');
                    nruns = size(nruns);
                    nruns = nruns(1);
                    
                    % set paths for old and new data
                    denoiseDir = strcat(sessDir, '/fmri','/GLMdenoise');
                    concatDir = strcat(root_dir,'/',fMRI_subs{si},'/concatVista');
                    
                    % copy data into concatinated folder 
                    for ii = 1:nruns  
                        filename = fullfile(denoiseDir, sprintf('denoisedGLMrun%02.0f.nii',ii));
                        ni = niftiRead(filename);
                        
                        newfilename = fullfile(concatDir, sprintf('denoisedGLMrun%02.0f.nii',(vi*10+ii)));
                        ni.fname = newfilename;
                        niftiWrite(ni)
                    end 
                    % copy parfiles over
                    copyfile(fullfile(denoiseDir,'Stimuli'),fullfile(concatDir,'Stimuli'))
                end
            end
        end 
    end 
end 
    
    
            