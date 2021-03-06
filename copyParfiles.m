sublist = {'NLR_GB387','NLR_GB310','NLR_KB218','NLR_JB423','NLR_GB355','NLR_GB267','NLR_HB275','NLR_197_BK'};

%% Step 1: Preprocess data all together 
for ii = 1:length(sublist)
    data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii},'/concatVistaAligned');
    eck_preprocessfmri(data_dir)

for ii = 1:length(sublist)
    data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii},'/concatVistaAligned');
    fmri_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii},'/denoisedConcatVista');
    
    %% copy parfiles over from main fmri directory 
    cd(data_dir)
    mkdir('Stimuli')
    copyfile(fullfile(fmri_dir,'Stimuli'),fullfile(data_dir,'Stimuli'))
end
%% make directory for each session
for ii = 1:length(sublist)
    data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii},'/concatVistaAligned');
    cd(data_dir)
    mkdir('sess1')
    mkdir('sess2')
    mkdir('sess3')
    mkdir('sess4')
end 

%% copy parfiles for each session
sessFolders = {'sess1','sess2','sess3','sess4'};

for ii = 1:length(sublist)
    for vi = 1:length(sessFolders)
        data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii},'/concatVistaAligned');
        parf_dir = strcat(data_dir,'/Stimuli/parfiles');
        sess_dir = strcat(data_dir,'/',sessFolders{vi});
        cd(sess_dir)
        mkdir('Stimuli')
        cd Stimuli
        mkdir('parfiles')
        cd(parf_dir)
        search = strcat('run',int2str(vi),'*.par');
        temp = dir(search);
        nruns = size(temp);
        nruns = nruns(1);
        for n = 1:nruns
            copyfile(fullfile(parf_dir,temp(n).name),fullfile(sess_dir,'Stimuli','parfiles'))
        end 
    end 
end 

sessFolders = {'sess1','sess2','sess3','sess4'};
 

for ii = 1:length(sublist)
count = 1;
    for vi = 1:length(sessFolders)
        data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii},'/concatVistaAligned');
        sess_dir = strcat(data_dir,'/',sessFolders{vi});
        parf_dir = strcat(sess_dir,'/Stimuli/parfiles');
        cd(data_dir)
        temp = dir('run*.nii');
        cd(parf_dir)
        nruns = dir('*.par');
        nruns = size(nruns);
        nruns = nruns(1);
        for n = 1:nruns
            copyfile(fullfile(data_dir,temp(count).name),fullfile(sess_dir))
            count = count + 1;
        end 
    end 
end 

%% initialize vista for each session
for ii = 1:length(sublist)
    for vi = 1:length(sessFolders)
        data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii},'/concatVistaAligned');
        sess_dir = strcat(data_dir,'/',sessFolders{vi});
        cd(sess_dir)
        nruns = dir('*.nii');
        nruns = size(nruns);
        nruns = nruns(1);
        if nruns == 2
            child_initialize_vista(sublist{ii},sess_dir)
        end 
    end 
end 

%% denoise
for ii = 1:length(sublist)
    for vi = 1:length(sessFolders) 
        data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii},'/concatVistaAligned');
        sess_dir = strcat(data_dir,'/',sessFolders{vi});
        cd(sess_dir)
        if exist('mrSESSION.mat') == 2
            ek_glmDenoise(sublist{ii},sessFolders{vi})
        end 
    end 
end 

%% make concatinated directory with denoised epis
for ii = 1:length(sublist)
    data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii},'/concatVistaAligned');
    cd(data_dir)
    mkdir('concatVista')
    for vi = 1:length(sessFolders)
        denoised_dir = strcat(data_dir,'/',sessFolders{vi},'/GLMdenoise');
        if exist(denoised_dir,'dir') == 7
            cd(denoised_dir)
            temp = dir('*.nii');
            nruns = size(temp);
            nruns = nruns(1);
            for n = 1:nruns
                copyfile(fullfile(denoised_dir,temp(n).name),fullfile(data_dir,'concatVista'))
            end 
        end 
    end 
    
    cd(data_dir)
    cd concatVista
    mkdir Stimuli
    
    copyfile(fullfile(data_dir,'Stimuli'),fullfile(data_dir,'concatVista','Stimuli'))  
end 

%% intialize vista 
for ii = 1:length(sublist)
    data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii},'/concatVistaAligned/concatVista');
    child_initialize_vista(sublist{ii},data_dir)
end 

