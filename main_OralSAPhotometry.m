% Title: main_OralSAPhotometry
% Author: Kevin Coffey, Ph.D.
% Affiliation: University of Washington, Psychiatry
% email address: mrcoffey@uw.edu  
% February 2022; Last revision: 1-April-2023

% ------------- Description --------------
% This is the main analysis script for LHb photometry data generated
% during Oral Fentanyl SA. gCamp7 recordings from LHb are compared at
% various behavioral events throughout SA, Extinction, and Reinstatement.
% ----------------------------------------

%% ------------- BEGIN CODE --------------
% Sort out path for replicability on other computers
% Determine where your m-file's folder is.
folder = fileparts(which('main_OralSAPhotometry.m')); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));

% Import Master Key
clear all;
opts = detectImportOptions("K99 Aim2 Master Key.xlsx");
opts = setvartype(opts,{'ID','Cage','Sex','Treatment','LHbTarget','Stream'},'categorical');
opts = setvartype(opts,{'IncludePhotometry','IncludeBehavior'},'logical');
mKey=readtable("K99 Aim2 Master Key.xlsx",opts);
fFold='Combined Oral Fentanyl Output\Raw Photometry';
%% Compare Spontaeuos gCamp Peaks Between Saline Conditioning and Naloxone Conditioning
Key=mKey(mKey.LHbTarget=='NA' & mKey.IncludePhotometry,:);
dT=table;
dT.ID=Key.ID;
dT.Sex=Key.Sex;
dT.Treatment=Key.Treatment;

% %% Extract TDT Data and Calculate AUC for
% c=0;
% masterPETH=table;
% h = waitbar(0,'Initializing');
% 
% for i=1:height(Key)
%     
%     waitbar(i/height(Key),h, sprintf('Analyzing File %u through %u of %u', ((i-1)*5)+1, i*5, height(Key)*5));
% 
%     %% Week 1 Analysis Block
%     % TDT Data Import Week 1 Photometry
%     Session='W1';
%     if categorical(Key.Week1Photometry(i))~='NA'
%     dataSC = TDTbin2mat(Key.Week1Photometry{i});
%     % Import, normalize, trim, and synchronize CFC recording,
%     if Key.Stream(i)=='A'
%     [dFFtime, dFFS, filtS, filtC]=computeDFF2(dataSC.streams.A465,dataSC.streams.A405,10,18000);
%     elseif Key.Stream(i)=='B'
%     [dFFtime, dFFS, filtS, filtC]=computeDFF2(dataSC.streams.B465,dataSC.streams.B405,10,18000);    
%     end
%     end
% 
%     %signalFig(dFFtime,filtS,filtC,Key,i,Session,fFold)
% 
%     if categorical(Key.Week1Photometry(i))~='NA'
%     raw=importOralSA(Key.Week1Behavior{i});
%     [eventCode,eventTime] = EventExtractor(raw);
%     % Align Event Times with Photometry Data
%     eventTime=eventTime+dataSC.epocs.PC0_.onset(1);
%     [eventCode,eventTime] = eventFilter(eventCode,eventTime);
%     %[pethT] = makeSAPETHS(dFFS,filtC,dFFtime,eventCode,eventTime,Session,Key,i,fFold,[-5,10]);
%     [pethT] = makeSAPETHS_USVSplit(dFFS,filtC,dFFtime,eventCode,eventTime,Session,Key,i,fFold,[-5,10]);
%     masterPETH=[masterPETH; pethT];
%     end
% 
%     close all;
%     %% Week 2 Analysis Block
%     % TDT Data Import Week 1 Photometry
%     Session='W2';
%     if categorical(Key.Week2Photometry(i))~='NA'
%     dataSC = TDTbin2mat(Key.Week2Photometry{i});
%     % Import, normalize, trim, and synchronize CFC recording,
%     if Key.Stream(i)=='A'
%     [dFFtime, dFFS, filtS, filtC]=computeDFF2(dataSC.streams.A465,dataSC.streams.A405,10,18000);
%     elseif Key.Stream(i)=='B'
%     [dFFtime, dFFS, filtS, filtC]=computeDFF2(dataSC.streams.B465,dataSC.streams.B405,10,18000);
%     end
%     end
% 
%     %signalFig(dFFtime,filtS,filtC,Key,i,Session,fFold)
% 
%     if categorical(Key.Week2Photometry(i))~='NA'
%     raw=importOralSA(Key.Week2Behavior{i});
%     [eventCode,eventTime] = EventExtractor(raw);
%     % Align Event Times with Photometry Data
%     eventTime=eventTime+dataSC.epocs.PC0_.onset(1);
%     [eventCode,eventTime] = eventFilter(eventCode,eventTime);
%     %[pethT] = makeSAPETHS(dFFS,filtC,dFFtime,eventCode,eventTime,Session,Key,i,fFold,[-5,10]);
%     [pethT] = makeSAPETHS_USVSplit(dFFS,filtC,dFFtime,eventCode,eventTime,Session,Key,i,fFold,[-5,10]);
%     masterPETH=[masterPETH; pethT];
%     end
% 
%     close all;
% 
%     %% Week 3 Analysis Block
%     % TDT Data Import Week 1 Photometry
%     Session='W3';
%     if categorical(Key.Week3Photometry(i))~='NA'
%     dataSC = TDTbin2mat(Key.Week3Photometry{i});
%     % Import, normalize, trim, and synchronize CFC recording,
%     if Key.Stream(i)=='A'
%     [dFFtime, dFFS, filtS, filtC]=computeDFF2(dataSC.streams.A465,dataSC.streams.A405,10,18000);
%     elseif Key.Stream(i)=='B'
%     [dFFtime, dFFS, filtS, filtC]=computeDFF2(dataSC.streams.B465,dataSC.streams.B405,10,18000);    
%     end
%     end
% 
%     %signalFig(dFFtime,filtS,filtC,Key,i,Session,fFold)
% 
%     if categorical(Key.Week3Photometry(i))~='NA'
%     raw=importOralSA(Key.Week3Behavior{i});
%     [eventCode,eventTime] = EventExtractor(raw);
%     % Align Event Times with Photometry DatacomputeDFF2
%     eventTime=eventTime+dataSC.epocs.PC0_.onset(1);
%     [eventCode,eventTime] = eventFilter(eventCode,eventTime);
%     %[pethT] = makeSAPETHS(dFFS,filtC,dFFtime,eventCode,eventTime,Session,Key,i,fFold,[-5,10]);
%     [pethT] = makeSAPETHS_USVSplit(dFFS,filtC,dFFtime,eventCode,eventTime,Session,Key,i,fFold,[-5,10]);
%     masterPETH=[masterPETH; pethT];
%     end
% 
%     close all;
% 
%     %% Extinction Analysis Block
% %     % TDT Data Import Week 1 Photometry
% %     Session='Extinction';
% %     if categorical(Key.ExtinctionPhotometry(i))~='NA'
% %     dataSC = TDTbin2mat(Key.ExtinctionPhotometry{i});
% %     % Import, normalize, trim, and synchronize CFC recording,
% %     if Key.Stream(i)=='A'
% %     [dFFtime, dFFS, filtS, filtC]=computeDFF2(dataSC.streams.A465,dataSC.streams.A405,10,18000);
% %     elseif Key.Stream(i)=='B'
% %     [dFFtime, dFFS, filtS, filtC]=computeDFF2(dataSC.streams.B465,dataSC.streams.B405,10,18000);    
% %     end
% %     end
% % 
% %     %signalFig(dFFtime,filtS,filtC,Key,i,Session,fFold)
% % 
% %     if categorical(Key.ExtinctionPhotometry(i))~='NA'
% %     raw=importOralSA(Key.ExtinctionBehavior{i});
% %     [eventCode,eventTime] = EventExtractor(raw);
% %     % Align Event Times with Photometry Data
% %     eventTime=eventTime+dataSC.epocs.PC0_.onset(1);
% %     [eventCode,eventTime] = eventFilter(eventCode,eventTime);
% %     %[pethT] = makeSAPETHS(dFFS,filtC,dFFtime,eventCode,eventTime,Session,Key,i,fFold,[-5,10]);
% %     [pethT] = makeSAPETHS_USVSplit(dFFS,filtC,dFFtime,eventCode,eventTime,Session,Key,i,fFold,[-5,10]);
% %     masterPETH=[masterPETH; pethT];
% %     end
% 
% 
%     close all;
% 
%     %% Reinstatement Analysis Block
%     % TDT Data Import Week 1 Photometry
%     Session='Reinstatement';
%     if categorical(Key.ReinstatementPhotometry(i))~='NA'
%     dataSC = TDTbin2mat(Key.ReinstatementPhotometry{i});
%     % Import, normalize, trim, and synchronize CFC recording,
%     if Key.Stream(i)=='A'
%     [dFFtime, dFFS, filtS, filtC]=computeDFF2(dataSC.streams.A465,dataSC.streams.A405,10,18000);
%     elseif Key.Stream(i)=='B'
%     [dFFtime, dFFS, filtS, filtC]=computeDFF2(dataSC.streams.B465,dataSC.streams.B405,10,18000);    
%     end
%     end
% 
%     %signalFig(dFFtime,filtS,filtC,Key,i,Session,fFold)
% 
%     if categorical(Key.ReinstatementPhotometry(i))~='NA'
%     raw=importOralSA(Key.ReinstatementBehavior{i});
%     [eventCode,eventTime] = EventExtractor(raw);
%     % Align Event Times with Photometry Data
%     eventTime=eventTime+dataSC.epocs.PC0_.onset(1);
%     [eventCode,eventTime] = eventFilter(eventCode,eventTime);
%     % Adjust Event Codes for Reinstatement
%     eventCode(eventCode==98)=99;
%     %[pethT] = makeSAPETHS(dFFS,filtC,dFFtime,eventCode,eventTime,Session,Key,i,fFold,[-5,10]);
%     [pethT] = makeSAPETHS_USVSplit(dFFS,filtC,dFFtime,eventCode,eventTime,Session,Key,i,fFold,[-5,10]);
%     masterPETH=[masterPETH; pethT];
%     end
% 
% 
%     
%     close all;
% end
% close(h);
% save('Processed Data/masterPETH_USVSplit.mat','masterPETH');
% %% Group Data
load('masterPETH_USVSplit.mat')
mpT=masterPETH;

%% Cued Lever Press
% Heatmap Stuff
mpTCLP=mpT(mpT.Event=='Cue',:);
U = unstack(mpTCLP,'smallPETH','ID');
Sess={'W1' 'W2' 'W3' 'Reinstatement'};

f1=figure('Color','w','Position',[100 100 710 100]);
ha=tight_subplot(2,4);
for i=1:width(Sess)
% Heatmap
axes(ha(i));
tmp=U(U.Session==Sess{i} & U.Group=='Early',:);
[~,idx]=sort(sum(tmp{100:end,5:end}),'ascend');
idx=idx+4;
s = pcolor(tmp.interpTime,unique(double(removecats(mpTCLP.ID))),(tmp{:,idx})');
s.EdgeColor='none'
ylabel('Rat #');
set(gca,'xticklabel',{[]})
set(gca,'fontsize', 14)
set(gca,'Visible','off');
colormap(gca,'blues_div');
c= colorbar();
clim([-4 8]);
%c.Label.String = '%\Delta FF';
c.TickLabels = [{''};{''};{'0'};{''};{''};{'6'};{' '}];
box off
if i==1
   CueW1E = ERT_Boot(tmp{:,idx}');
elseif i==2
   CueW2E = ERT_Boot(tmp{:,idx}');
elseif i==3
   CueW3E = ERT_Boot(tmp{:,idx}');
else
   CueReE = ERT_Boot(tmp{:,idx}'); 
end


axes(ha(i+4));
tmp=U(U.Session==Sess{i} & U.Group=='Late',:);
[~,idx]=sort(sum(tmp{100:end,5:end}),'ascend');
idx=idx+4;
s = pcolor(tmp.interpTime,unique(double(removecats(mpTCLP.ID))),(tmp{:,idx})');
s.EdgeColor='none'
ylabel('Rat #');
set(gca,'xticklabel',{[]})
set(gca,'fontsize', 14)
set(gca,'Visible','off');
colormap(gca,'reds_div');
c= colorbar();
clim([-4 8]);
%c.Label.String = '%\Delta FF';
c.TickLabels = [{''};{''};{'0'};{''};{''};{'6'};{' '}];
box off
if i==1
   CueW1L = ERT_Boot(tmp{:,idx}');
elseif i==2
   CueW2L = ERT_Boot(tmp{:,idx}');
elseif i==3
   CueW3L = ERT_Boot(tmp{:,idx}');
else
   CueReL = ERT_Boot(tmp{:,idx}'); 
end

end
exportgraphics(f1,fullfile('Combined Oral Fentanyl Output','Cued Lever Press Average Heat USV Split.pdf'),'ContentType','vector');

f=figure('Color','w','Position',[10 10 750 300]);
clear g
g(1,1)=gramm('x',mpT.interpTime,'y',mpT.smallPETH,'color',mpT.Group,'subset',mpT.Event=='Cue');
g(1,1).facet_wrap(mpT.Session,'ncols',4,'column_labels',0,'force_ticks',1);
g(1,1).stat_summary('geom',{'line','area'},'type','sem','dodge',.75);
g(1,1).axe_property('LineWidth',1.5,'FontSize',14,'YLim',[-2 6]);
g(1,1).set_order_options('Column',{'W1' 'W2' 'W3'  'Reinstatement'},'color',{'Late','Early'});
g(1,1).set_layout_options('redraw_gap', 0.115);
g(1,1).set_names('x','Time (s)','y','% dFF','color',{'Session'});
g(1,1).geom_vline('xintercept',0,'style','k--');
g(1,1).set_title('Cued Lever Press');
g.no_legend();
g.draw;
hold on
axes(g.facet_axes_handles(1));
plot(CueW1L-10,[6 6],'LineWidth',3,'Color',[ 1 .5 .5])
plot(CueW1E-10,[5.5 5.5],'LineWidth',3,'Color',[ .25 .8 .9])
axes(g.facet_axes_handles(2));
plot(CueW2L-10,[6 6],'LineWidth',3,'Color',[ 1 .5 .5])
plot(CueW2E'-10,repmat([5.5 5.5],[height(CueW2E),1])','LineWidth',3,'Color',[ .25 .8 .9])
axes(g.facet_axes_handles(3));
plot(CueW3L-10,[6 6],'LineWidth',3,'Color',[ 1 .5 .5])
plot(CueW3E-10,[5.5 5.5],'LineWidth',3,'Color',[ .25 .8 .9])
axes(g.facet_axes_handles(4));
plot(CueReL-10,[6 6],'LineWidth',3,'Color',[ 1 .5 .5])
plot(CueReE-10,[5.5 5.5],'LineWidth',3,'Color',[ .25 .8 .9])
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Cued Lever Press Average USV Split.pdf'),'ContentType','vector');

%% Rewarded Head Entry
% Heatmap Stuff
mpTCLP=mpT(mpT.Event=='RewardedHE',:);
U = unstack(mpTCLP,'smallPETH','ID');
Sess={'W1' 'W2' 'W3'};

f1=figure('Color','w','Position',[100 100 535 100]);
ha=tight_subplot(2,3);
for i=1:width(Sess)
% Heatmap
axes(ha(i));
tmp=U(U.Session==Sess{i} & U.Group=='Early',:);
[~,idx]=sort(sum(tmp{100:end,5:end}),'ascend');
idx=idx+4;
s = pcolor(tmp.interpTime,unique(double(removecats(mpTCLP.ID))),(tmp{:,idx})');
s.EdgeColor='none'
ylabel('Rat #');
set(gca,'xticklabel',{[]})
set(gca,'fontsize', 14)
set(gca,'Visible','off');
colormap(gca,'blues_div');
c= colorbar();
clim([-6 6]);
%c.Label.String = '%\Delta FF';
c.TickLabels = [{''};{'0'};{'5'}];
box off
if i==1
   RewHeW1E= ERT_Boot(tmp{:,idx}');
elseif i==2
   RewHeW2E= ERT_Boot(tmp{:,idx}');
elseif i==3
   RewHeW3E= ERT_Boot(tmp{:,idx}');
end

axes(ha(i+3));
tmp=U(U.Session==Sess{i} & U.Group=='Late',:);
[~,idx]=sort(sum(tmp{100:end,5:end}),'ascend');
idx=idx+4;
s = pcolor(tmp.interpTime,unique(double(removecats(mpTCLP.ID))),(tmp{:,idx})');
s.EdgeColor='none'
ylabel('Rat #');
set(gca,'xticklabel',{[]})
set(gca,'fontsize', 14)
set(gca,'Visible','off');
colormap(gca,'reds_div');
c= colorbar();
clim([-6 6]);
%c.Label.String = '%\Delta FF';
c.TickLabels = [{''};{'0'};{'5'}];
box off
if i==1
   RewHeW1L= ERT_Boot(tmp{:,idx}');
elseif i==2
   RewHeW2L= ERT_Boot(tmp{:,idx}');
elseif i==3
   RewHeW3L= ERT_Boot(tmp{:,idx}');
end

end
exportgraphics(f1,fullfile('Combined Oral Fentanyl Output','Rewarded Head Entry Average Heat USV Split.pdf'),'ContentType','vector');

f=figure('Color','w','Position',[10 10 585 300]);
clear g
g(1,1)=gramm('x',mpT.interpTime,'y',mpT.smallPETH,'color',mpT.Group,'subset',mpT.Event=='RewardedHE');
g(1,1).facet_wrap(mpT.Session,'ncols',4,'column_labels',0,'force_ticks',1);
g(1,1).stat_summary('geom',{'line','area'},'type','sem','dodge',.75);
g(1,1).axe_property('LineWidth',1.5,'FontSize',14,'YLim',[-4 4]);
g(1,1).set_order_options('Column',{'W1' 'W2' 'W3'  'Reinstatement'},'color',{'Late','Early'});
g(1,1).set_layout_options('redraw_gap', 0.115);
g(1,1).set_names('x','Time (s)','y','% dFF','color',{'Session'});
g(1,1).geom_vline('xintercept',0,'style','k--');
g(1,1).set_title('Rewarded Head Entry');
g.no_legend();
g.draw;
hold on
axes(g.facet_axes_handles(1));
plot(RewHeW1L-10,[4 4],'LineWidth',3,'Color',[ 1 .5 .5])
plot(RewHeW1E-10,[3.65 3.65],'LineWidth',3,'Color',[ .25 .8 .9])
axes(g.facet_axes_handles(2));
plot(RewHeW2L'-10,repmat([4 4],[height(RewHeW2L),1])','LineWidth',3,'Color',[ 1 .5 .5])
plot(RewHeW2E'-10,repmat([3.6 3.6],[height(RewHeW2E),1])','LineWidth',3,'Color',[ .25 .8 .9])
axes(g.facet_axes_handles(3));
plot(RewHeW3L-10,[4 4],'LineWidth',3,'Color',[ 1 .5 .5])
plot(RewHeW3E-10,[3.65 3.65],'LineWidth',3,'Color',[ .25 .8 .9])
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Rewarded Head Entry Average USV Split.pdf'),'ContentType','vector');

%% Unrewarded Head Entry
% Heatmap Stuff
mpTCLP=mpT(mpT.Event=='UnrewardedHE',:);
U = unstack(mpTCLP,'smallPETH','ID');
Sess={'W1' 'W2' 'W3' 'Reinstatement'};

f1=figure('Color','w','Position',[100 100 710 100]);
ha=tight_subplot(2,4);
for i=1:width(Sess)
% Heatmap
axes(ha(i));
tmp=U(U.Session==Sess{i} & U.Group=='Early',:);
[~,idx]=sort(sum(tmp{100:end,5:end}),'ascend');
idx=idx+4;
s = pcolor(tmp.interpTime,unique(double(removecats(mpTCLP.ID))),(tmp{:,idx})');
s.EdgeColor='none'
ylabel('Rat #');
set(gca,'xticklabel',{[]})
set(gca,'fontsize', 14)
set(gca,'Visible','off');
colormap(gca,'blues_div');
c= colorbar();
clim([-4 6]);
%c.Label.String = '%\Delta FF';
c.TickLabels = [{''};{''};{'0'};{''};{'4'};{' '}];
box off
if i==1
   UrHeW1E= ERT_Boot(tmp{:,idx}');
elseif i==2
   UrHeW2E= ERT_Boot(tmp{:,idx}');
elseif i==3
   UrHeW3E= ERT_Boot(tmp{:,idx}');
else
   UrHeReE= ERT_Boot(tmp{:,idx}');
end

axes(ha(i+4));
tmp=U(U.Session==Sess{i} & U.Group=='Late',:);
[~,idx]=sort(sum(tmp{100:end,5:end}),'ascend');
idx=idx+4;
s = pcolor(tmp.interpTime,unique(double(removecats(mpTCLP.ID))),(tmp{:,idx})');
s.EdgeColor='none'
ylabel('Rat #');
set(gca,'xticklabel',{[]})
set(gca,'fontsize', 14)
set(gca,'Visible','off');
colormap(gca,'reds_div');
c= colorbar();
clim([-4 6]);
%c.Label.String = '%\Delta FF';
c.TickLabels = [{''};{''};{'0'};{''};{'4'};{' '}];
box off

if i==1
   UrHeW1L= ERT_Boot(tmp{:,idx}');
elseif i==2
   UrHeW2L= ERT_Boot(tmp{:,idx}');
elseif i==3
   UrHeW3L= ERT_Boot(tmp{:,idx}');
else
   UrHeReL= ERT_Boot(tmp{:,idx}');
end

end
exportgraphics(f1,fullfile('Combined Oral Fentanyl Output','Unrewarded Head Entry Average Heat USV Split.pdf'),'ContentType','vector');


f=figure('Color','w','Position',[10 10 750 300]);
clear g
g(1,1)=gramm('x',mpT.interpTime,'y',mpT.smallPETH,'color',mpT.Group,'subset',mpT.Event=='UnrewardedHE');
g(1,1).facet_wrap(mpT.Session,'ncols',4,'column_labels',0,'force_ticks',1);
g(1,1).stat_summary('geom',{'line','area'},'type','sem','dodge',.75);
g(1,1).axe_property('LineWidth',1.5,'FontSize',14,'YLim',[-2 4]);
g(1,1).set_order_options('Column',{'W1' 'W2' 'W3'  'Reinstatement'},'color',{'Late','Early'});
g(1,1).set_layout_options('redraw_gap', 0.115);
g(1,1).set_names('x','Time (s)','y','% dFF','color',{'Session'});
g(1,1).geom_vline('xintercept',0,'style','k--');
g(1,1).set_title('UnrewardedHE');
g.no_legend();
g.draw;
hold on
axes(g.facet_axes_handles(1));
plot(UrHeW1L'-10,repmat([4 4],[height(UrHeW1E),1])','LineWidth',3,'Color',[ 1 .5 .5])
plot(UrHeW1E-10,[3.6 3.6],'LineWidth',3,'Color',[ .25 .8 .9])
axes(g.facet_axes_handles(2));
plot(UrHeW2L-10,[4 4],'LineWidth',3,'Color',[ 1 .5 .5])
plot(UrHeW2E-10,[3.6 3.6],'LineWidth',3,'Color',[.25 .8 .9])
axes(g.facet_axes_handles(3));
plot(UrHeW3L-10,[4 4],'LineWidth',3,'Color',[ 1 .5 .5])
plot(UrHeW3E'-10,repmat([3.6 3.6],[height(UrHeW3L),1])','LineWidth',3,'Color',[ .25 .8 .9])
axes(g.facet_axes_handles(4));
plot(UrHeReL-10,[4 4],'LineWidth',3,'Color',[ 1 .5 .5])
plot(UrHeReE-10,[3.6 3.6],'LineWidth',3,'Color',[ .25 .8 .9])
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Unrewarded Head Entry Average USV Split.pdf'),'ContentType','vector');

%% Save Stats
save('Statistics/OralFent_PhotoStats.m','CueW1E','CueW1L','CueW2E','CueW2L','CueW3E','CueW3L','CueReE','CueReL',...
    'RewHeW1E','RewHeW1L','RewHeW2E','RewHeW2L','RewHeW3E','RewHeW3L',...
    'UrHeW1E','UrHeW1L','UrHeW2E','UrHeW2L','UrHeW3E','UrHeW3L','UrHeReE','UrHeReL');


%% Dependent Functions
function signalFig(dFFtime,filtS,filtC,Key,i,Session,fFold)
    try
    % Plot the data using area function
    f=figure('Color','w','Position',[10 10 1280 960])
    plot(dFFtime,filtS,'Color',[0 0.81 0.1],'LineWidth',1);
    hold on
    plot(dFFtime,filtC,'Color',[0.65 0.02 1],'LineWidth',1);
    box off
    set(gca,'LineWidth',1.5,'TickDir','out','FontSize',14);
    xlim([min(dFFtime) max(dFFtime)]);
    % ylim([-30 30]);
    ylabel('Filtered Fluorecence Signal','FontSize',14);
    xlabel('Session Time (s)','FontSize',14);
    title(strcat(string(Key.ID(i)),'-',Session,'-Filtered Signal'));
    exportgraphics(f,fullfile(fFold,strcat(string(Key.ID(i)),'-',Session,'-Filtered Signal.png')),'Resolution',300);
    end
end

function makePETHS(filtS,filtC,dFFtime,eventCode,eventTime,Session,Key,i,fFold)
    % Rewarded Press Week 1
    try
    [f1 pethDFF]=rawepochPETH(filtS,filtC,dFFtime,eventTime(eventCode==3),20);
    xlabel('Rewarded Lever Press (s)');
    exportgraphics(f1,fullfile(fFold,strcat(string(Key.ID(i)),'-',Session,'-Rewarded Lever Press.png')),'Resolution',300);
    end

    % Infusions Week 1
    try
    [f1 pethDFF]=rawepochPETH(filtS,filtC,dFFtime,eventTime(eventCode==17),20);
    xlabel('Infusions (s)');
    exportgraphics(f1,fullfile(fFold,strcat(string(Key.ID(i)),'-',Session,'-Infusions.png')),'Resolution',300);
    end

    % Unrewarded Press Week 1
    try
    [f1 pethDFF]=rawepochPETH(filtS,filtC,dFFtime,eventTime(eventCode==20),20);
    xlabel('Unrewarded Lever Press (s)');
    exportgraphics(f1,fullfile(fFold,strcat(string(Key.ID(i)),'-',Session,'-Unrewarded Lever Press.png')),'Resolution',300);
    end

    % Inactive Press Week 1
    try
    [f1 pethDFF]=rawepochPETH(filtS,filtC,dFFtime,eventTime(eventCode==23),20);
    xlabel('Inactive Lever Press (s)');
    exportgraphics(f1,fullfile(fFold,strcat(string(Key.ID(i)),'-',Session,'-Inactive Lever Press.png')),'Resolution',300);
    end

    % Inactive Press Week 1
    try
    [f1 pethDFF]=rawepochPETH(filtS,filtC,dFFtime,eventTime(eventCode==6),20);
    xlabel('Head Entries (s)');
    exportgraphics(f1,fullfile(fFold,strcat(string(Key.ID(i)),'-',Session,'-Head Entries Press.png')),'Resolution',300);
    end
end
%------------- END OF CODE --------------