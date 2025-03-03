function [tpr,fpr] = CDROC(data,prediction)
%% Function description gives TP rate vs false positive rate
TP = sum(sum(data+prediction,2)==2);
TN = sum(sum(data+prediction,2)==0);
FP = sum(data==0&prediction==1);
FN = sum(data==1&prediction==0);
tpr = TP./(TP+FN);
fpr = FP./(FP+TN);
end