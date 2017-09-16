function denoiseConcatSubs 

sublist = {'NLR_GB310','NLR_197_BK','NLR_GB355','NLR_GB387','NLR_JB420'};

for ii = 1:length(sublist)
    concatPipeline(sublist{ii})
end 