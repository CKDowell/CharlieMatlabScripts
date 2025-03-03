function FalsePositive  = get_convFN(gmb)
%Function aims to get false negative convergences 
gmb.dBound = 0.002;
convergences = inferConv(gmb, 'conv_model.mat');
% under this protocol convergences are detected with a lower threshold
FPdex = ismember(convergences,gmb.convergences,'rows');
FalsePositive = convergences(~FPdex,:);
close
end