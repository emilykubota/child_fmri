sub_list = HCP_autoDir('/home/ekubota/Desktop/test');
for ii = 1:length(sub_list)
    pipeline(sub_list{ii})
%    clearvars -except sub_list
end 