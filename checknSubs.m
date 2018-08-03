%% Check number of subjects that we have 70V FMRI data for 
function fMRI_subs = checknSubs;

root_dir = '/mnt/diskArray/projects/LMB_Analysis';
sub_list = HCP_autoDir(root_dir);

fMRI_subs = [];
for ii = 1:length(sub_list)
    sub_dir = strcat(root_dir, '/',sub_list{ii});
    cd(sub_dir)
    if exist('vistaAnat', 'dir')
        fMRI_subs = [fMRI_subs {sub_list{ii}}];
    end 
end 
    
