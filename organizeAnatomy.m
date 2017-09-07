%% Check number of subjects that we have 70V FMRI data for 
root_dir = '/mnt/diskArray/projects/LMB_Analysis';
sub_list = HCP_autoDir(root_dir);

% fMRI_subs = [];
% for ii = 1:length(sub_list)
%     sub_dir = strcat(root_dir, '/',sub_list{ii});
%     cd(sub_dir)
%     if exist('mrVista_Anat', 'dir')
%         fMRI_subs = [fMRI_subs {sub_list{ii}}];
%     end 
% end 

% fMRI_subs = {'NLR_110_HH','NLR_145_AC','NLR_150_MG','NLR_160_EK','NLR_161_AK',...
%    'NLR_162_EF','NLR_163_LF','NLR_164_SF','NLR_170_GM','NLR_174_HS',...
%    'NLR_102_RS','NLR_207_AH','NLR_208_LH','NLR_210_SB','NLR_211_LB'};
fMRI_subs = {'NLR_151_RD'};

for fi = 1:length(fMRI_subs)
    organizeIndividualAnatomy(fMRI_subs{fi})
%         T1w = strcat('/mnt/diskArray/projects/anatomy/',sub_list{fi},'/t1_acpc_avg.nii.gz');
%         ribbon = strcat('/mnt/diskArray/projects/avg_fsurfer/',sub_list{fi},'/mri/ribbon.mgz');
%         anat_dir = strcat('/mnt/diskArray/projects/LMB_Analysis/', sub_list{fi},'/mrVista_Anat');
%         copyfile (T1w,anat_dir)
%         copyfile(ribbon, anat_dir)
end      
