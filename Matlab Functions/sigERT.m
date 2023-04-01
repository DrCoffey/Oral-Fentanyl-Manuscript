function [sigInt] = sigERT(bootCI,minInt,rate)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   Determines what intervals in a PETH contain significant event related
%   transients.

% % Inputs
% bootCI: Output from the boot_CI function from: Jean-Richard-dit-Bressel, P., Clifford, C. W., & McNally, G. P. (2020). Analyzing event-related transients: confidence intervals, permutation tests, and consecutive thresholds. Frontiers in Molecular Neuroscience, 13, 14.
% minInt: Minimum interval to consider (E.g. less than 2 secons is not
% biologically relevant
% rate: the sample rate in sample/second

% % Outputs
% sigInt[Start, Stop]: The begining and end of significant event related
% transients in seconds.


% this finds the index of he rows(2) that have x in between 
idx = ~(0 > bootCI(1,:) & 0 < bootCI(2,:));
CC = bwconncomp(idx);
sigInt=[];
c=0;
for i=1:width(CC.PixelIdxList)
    if height(CC.PixelIdxList{i})>=(minInt*rate)
        c=c+1;
        tmp=CC.PixelIdxList{i};
        sigInt(c,1)=tmp(1)/rate;
        sigInt(c,2)=tmp(end)/rate;
    end
end

end