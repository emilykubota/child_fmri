function initializeVistaGLMdenoise

root_dir = '/mnt/diskArray/projects/LMB_Analysis';

fMRI_subs = {'NLR_GB310'};

for si = 1:length(fMRI_subs)
    % Get the visit dates 
    visit_dir = strcat(root_dir,'/',fMRI_subs{si});
    visit_dates = HCP_autoDir(visit_dir);
    % For each visit (vi = visit index)
    for vi = 3:length(visit_dates)
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
                    denoiseDir = strcat(sessDir,'/fmri/GLMdenoise');
                    cd(denoiseDir)
                    % Check number of runs
                    nruns = dir('denoisedGLMrun*.nii');
                    nruns = size(nruns);
                    nruns = nruns(1);
                    if nruns == 2
                        denoisepipeline(fMRI_subs{si},visit_dates{vi})
                    end 
                end 
            end
        end
    end 
end 