tc = get(gcf, 'UserData');
temp = tc.glm.betas;
face = [temp(4) temp(5)];
meanFace = mean(face)