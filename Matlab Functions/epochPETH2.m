function [f1, U] = epochPETH2(dFF,cont,dFFTime,epochTime,pethLength,ylimit)
%FUNCTION_NAME - One line description of what the function or script performs (H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    input1 - Description
%    input2 - Description
%    input3 - Description
%
% Outputs:
%    output1 - Description
%    output2 - Description
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2
% Author: Denis Gilbert, Ph.D., physical oceanography
% Maurice Lamontagne Institute, Dept. of Fisheries and Oceans Canada
% email address: gilbertd@dfo-mpo.gc.ca  
% Website: http://www.qc.dfo-mpo.gc.ca/iml/
% December 1999; Last revision: 12-May-2004
%------------- BEGIN CODE --------------

idx=epochTime>dFFTime(1)+pethLength & epochTime<dFFTime(end)-pethLength;
epochTime=epochTime(idx);

if height(epochTime)<4
   f1=[];
   U=[];
   return
end

for i=1:length(epochTime)
    if i==1    
    time=(-pethLength+.001:.001:pethLength)';
    minu=-(-pethLength+.001)*1000;
    plu=pethLength*1000;
    deltaFF=dFF(find(dFFTime>epochTime(i),1,'first')-minu:find(dFFTime>epochTime(i),1,'first')+plu)';
    controlFF=cont(find(dFFTime>epochTime(i),1,'first')-minu:find(dFFTime>epochTime(i),1,'first')+plu)';
    epochNum=repmat(i,[length(-pethLength+.001:.001:pethLength) 1]);
    else
    time=[time; (-pethLength+.001:.001:pethLength)'];
    deltaFF=[deltaFF; dFF(find(dFFTime>epochTime(i),1,'first')-minu:find(dFFTime>epochTime(i),1,'first')+plu)'];
    controlFF=[controlFF; cont(find(dFFTime>epochTime(i),1,'first')-minu:find(dFFTime>epochTime(i),1,'first')+plu)'];
    epochNum=[epochNum; repmat(i,[length(-pethLength+.001:.001:pethLength) 1])];
    end
end

% PETH Setup
pethTable=table(time,deltaFF,epochNum);
U = unstack(pethTable,'deltaFF','epochNum');

% Normalize Each Trial to first Quarter of Sigal
for i=2:width(U)
samps=floor(height(U)/4);
base=U(1:samps,i);
basemean=mean(base{:,1});
U{:,i}=U{:,i}-basemean;
end


contTable=table(time,controlFF,epochNum);
cU = unstack(contTable,'controlFF','epochNum');

%% Figure Stuff
f1=figure('Color','w','Position',[100 100 400 600]);
sp1=subplot(2,1,1);
% Heatmap
s = pcolor(U.time,unique(pethTable.epochNum),(U{:,2:end})');
s.EdgeColor='none'
%s.FaceColor = 'interp';
colormap('inferno');
ylabel('Trial #');
set(gca,'xticklabel',{[]})
set(gca,'fontsize', 14)

cRGB=inferno(10);
sp2=subplot(2,1,2);
options.color_area=cRGB(1,:);
options.color_line=cRGB(1,:);
options.alpha=.25;
options.line_width=1;
options.error='sem';
options.x_axis=U.time(1:10:end);
options.handle=f1;
% plot_areaerrorbar((cU{1:10:end,2:end})',options)
hold on
options.color_area=cRGB(5,:);
options.color_line=cRGB(5,:);
options.alpha=.25;
options.line_width=2;
plot_areaerrorbar((U{1:10:end,2:end})',options)
ylabel('% \DeltaF');
xlabel('Time Epoch (s)');
set(gca,'fontsize', 14)
%set(gca,"YLim",ylimit);
hold on
yl = ylim;
p=patch([0 .1 .1 0],[yl(1) yl(1) yl(2) yl(2)],'k');
p.EdgeColor='none';
p.FaceAlpha=.35;



%------------- END OF CODE --------------
