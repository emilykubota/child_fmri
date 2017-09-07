function err = RepMeasErr(X)

err = std(X - repmat(mean(X,2), 1, size(X,2))) ./ sqrt(size(X,1))