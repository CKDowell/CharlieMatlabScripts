function [COEFF,SCORE,LATENT,MU,V,S] = NaNpca(X)
pseudotime = 1:size(X,1);
for i = 1:size(X,1)
    X(i,:) = interpolate_NaNsFast(X(i,:));
end
[COEFF,SCORE,LATENT,MU,V,S] = pca(X);
end