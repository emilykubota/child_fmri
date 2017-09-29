%  sublist = {'NLR_GB267','NLR_GB310','NLR_GB355','NLR_GB387',...
%      'NLR_HB275','NLR_KB218','NLR_IB357','NLR_JB423','NLR_197_BK','NLR_JB420'};

sublist = {'NLR_KB396','NLR_JB486'};

for ii = 1:length(sublist)
    sub_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii});
    cd(sub_dir)
    mkdir concatVistaAligned
end

%% Copy raw niftis into concatinated directory 
for si = 1:length(sublist)
    sub_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{si});
    % Get the visit dates 
    visit_dates = HCP_autoDir(sub_dir);
    % For each visit (vi = visit index)
    for vi = 1:length(visit_dates)
        % Check to see if the vist date folder is actually a date
        a = visit_dates{vi};
        sizeA = size(a);
        sizeA = sizeA(2);
        if sizeA == 8
            sessDir = strcat(sub_dir,'/',visit_dates{vi});
            cd(sessDir)
            if (exist(fullfile(sessDir,'fmri'),'dir') == 7)
                cd fmri
                temp = dir('*106VOL*');
                nruns = size(temp);
                nruns = nruns(1);
                    
                % set paths for old and new data
                dataDir = strcat(sessDir, '/fmri');
                concatDir = strcat(sub_dir,'/concatVistaAligned');
                    
                % copy data into concatinated folder 
                for ci = 1:nruns  
                    copyfile(fullfile(dataDir,(temp(ci).name)),fullfile(concatDir))
                end 
                % copy parfiles over
                 copyfile(fullfile(dataDir,'Stimuli'),fullfile(concatDir,'Stimuli'))
            end
       end
   end 
end  
 

%% Preprocess data 
for ii = 1:length(sublist)
    % preprocess data all together 
    data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii},'/concatVistaAligned');
    eck_preprocessfmri(data_dir) 
end 


%% Step 2: Convert functionals to RAS

for ii = 1:length(sublist)
    % preprocess data all together 
    data_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/',sublist{ii},'/concatVistaAligned');
    cd(data_dir)
    
    % Get functional filenames 
    EPIs = dir('run0*.nii');
    
    % Check how many functionals there are 
    nruns = size(EPIs);
    nruns = nruns(1);
    
    EPI_names = {};
    % Create array of functional names 
    for ii = 1:nruns
        EPI_names = [EPI_names EPIs(ii).name];
    end
    
    %convert functionals, and set TR to 2.
    convert_command = 'mri_convert --out_orientation RAS';
    
    for ii = 1:nruns
        % Convert to RAS
        convert = [convert_command ' ' EPI_names{ii} ' ' EPI_names{ii}];
        system(convert);
        
        %Set TR to 2 
        h = readFileNifti(EPI_names{ii}); 
        h.pixdim(4) = 2;
        h.data = uint16(h.data);
        writeFileNifti(h); 
    end 
end 


for ii = 1:length(sublist)
    % Step 2: make directory for each session
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

% copy nii over based on how many parfiles are in each session folder

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
    mkdir 'concatVista'
%     concatDir = strcat(data_dir,'/concatVista');
%     cd(concatDir)
%     mkdir 'Stimuli/parfiles'
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
    initAndGLM(sublist{ii},data_dir)
end 

