%% Stats for Photometry Funcition
function [sigInt] = ERT_Boot(X)
alpha = [5, 1]; % prescribed Type 1 error rate (% e.g. [5, 1])
sig = alpha(1)/100;
minInt = 3;
rate = 10;
sigInt=[];
X=X(~isnan(X(:,1)),:);
bootCI = boot_CI(X,1000,sig);
try
[sigInt] = sigERT(bootCI,minInt,rate);
end
if isempty(sigInt)
sigInt=[0 0];
end
end