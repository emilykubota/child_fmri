sub_list = HCP_autoDir('/home/ekubota/Desktop/test')
for ii = 2:length(sub_list)
    sub_num = sub_list{ii}
    data_dir = strcat('/home/ekubota/Desktop/test/',sub_num); 
    child_initialize_vista(sub_num,data_dir)
    child_fmri_glm(data_dir)
    clearvars -except sub_list
end 
