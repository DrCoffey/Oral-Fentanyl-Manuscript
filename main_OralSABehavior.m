% Title: main_OralSABehavior_20220714
% Author: Kevin Coffey, Ph.D.
% Affiliation: University of Washington, Psychiatry
% email address: mrcoffey@uw.edu  
% February 2022; Last revision: 14-Feb 2023

% ------------- Description --------------
% This is the main analysis script for Oral Fentanyl SA Behavior.
% ----------------------------------------

%% ------------- BEGIN CODE --------------
% Import Master Key
clear all;
addpath('Matlab Functions')  
opts = detectImportOptions('K99 Aim2 Master Key.xlsx');
opts = setvartype(opts,{'TagColor','ID','Cage','Sex','LHbTarget',...
                   'Treatment','Stream'},'categorical');
opts = setvartype(opts,{'IncludePhotometry','IncludeBehavior'},'logical');
mKey=readtable('K99 Aim2 Master Key.xlsx',opts);

% %% Import Round 1 Data
% Files=dir("2022.02.28 LHb Oral Fentanyl\2022.03.07 Oral SA Round 1\Oral SA Behavior");
% Files=Files(1:height(Files)-2);
% 
% for i=1:length(Files)
%     tmp=ImportDataFiles(fullfile(Files(i).folder, Files(i).name));
%     t=BehavioralDataScript(tmp);
%     if i==1
%         T1=t;
%     else
%         T1=[T1; t];
%     end
% end
% [~,~,sessionNum] = unique(T1.Date);
% T1=[T1 table(sessionNum)];
% Files = struct2table(Files);
% folder = Files.folder;
% name = Files.name;
% T1=[T1 table(folder) table(name)];
% 
% %% Import Round 2 Data
% Files=dir("2022.02.28 LHb Oral Fentanyl\2022.05.17 Oral SA Round 2\Oral SA Behavior");
% Files=Files(1:height(Files)-2);
% 
% for i=1:length(Files)
%     tmp=ImportDataFiles(fullfile(Files(i).folder, Files(i).name));
%     t=BehavioralDataScript(tmp);
%     if i==1
%         T2=t;
%     else
%         T2=[T2; t];
%     end
% end
% [~,~,sessionNum] = unique(T2.Date);
% T2=[T2 table(sessionNum)];
% Files = struct2table(Files);
% folder = Files.folder;
% name = Files.name;
% T2=[T2 table(folder) table(name)];
% 
% %% Import Round 3 Data
% Files=dir("2022.02.28 LHb Oral Fentanyl\2022.08.08 Oral SA Round 3\Oral SA Behavior");
% Files=Files(1:height(Files)-2);
% 
% for i=1:length(Files)
%     tmp=ImportDataFiles(fullfile(Files(i).folder, Files(i).name));
%     t=BehavioralDataScript(tmp);
%     if i==1
%         T3=t;
%     else
%         T3=[T3; t];
%     end
% end
% [~,~,sessionNum] = unique(T3.Date);
% T3=[T3 table(sessionNum)];
% Files = struct2table(Files);
% folder = Files.folder;
% name = Files.name;
% T3=[T3 table(folder) table(name)];
% 
% %% Clean Behavior Data
% mT=[T1;T2;T3];
% 
% % Fix Weight for R30 Day 5 & Session Num (24) for R23-26
% % Remove Consumption for Reinstatement
% % Remove Broken Head Entry Detector
% % Calculate Intake
% mT.Weight(mT.Weight==25)=250;
% mT.sessionNum(mT.sessionNum==24)=23;
% mT.Infusions((mT.sessionNum==23))=0;
% % R28 has broken head entry detector (fluttering) fill in data with mean to
% % complete analysis
% idx=find(mT.Subject=='R28')';
% for i=idx
% mT{i,4}=floor(nanmean(mT{mT.sessionNum==mT{i,9},4}));
% end
% Intake=(mT.Infusions*2.81)./(mT.Weight/1000);
% 
% sessionType=categorical();
% for i=1:height(mT);
%     if mT.sessionNum(i)<16
%         sessionType(i,1)=categorical({'Training'});
%     elseif mT.sessionNum(i)>15 & mT.sessionNum(i)<23
%         sessionType(i,1)=categorical({'Extinction'});
%     elseif mT.sessionNum(i)==23    
%         sessionType(i,1)=categorical({'Reinstatement'});
%     end
% end
% mT=[mT table(Intake) table(sessionType)];
% mT.Properties.VariableNames{'Subject'} = 'ID';
% mT=innerjoin(mT,mKey,'Keys',{'ID'},'RightVariables',{'Sex','Treatment','Stream','IncludeBehavior'});
% mT=mT(mT.IncludeBehavior,:);
% % Slide Days for looks 
% 
% % Slide Days for looks 
% mT.sessionNum(mT.sessionNum(:)>15)=mT.sessionNum(mT.sessionNum(:)>15)+1;
% mT.sessionNum(mT.sessionNum(:)==24)=25;
% 
% mTname=fullfile('Processed Data','Master Behavior Table.mat');
% save(mTname,'mT');
 
load("Processed Data\Master Behavior Table.mat");
%% Generate Figures
g=gramm('x',mT.sessionNum,'y',mT.Intake,'lightness',mT.sessionType,'color',mT.Sex);
f=figure('Position',[1 1 350 300]);
g.set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g.stat_summary('geom',{'errorbar','point'},'type','sem','dodge',2.5,'setylim',1);
g.set_point_options('markers',{'o','s'},'base_size',5);
g.set_text_options('font','Helvetica','base_size',16,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[0 26],'YLim',[0 650],'TickDir','out');
g.set_order_options('lightness',{'Extinction','Training','Reinstatement'});
g.set_names('x','Session','y','Fentanyl Intake (μg/Kg)','color','Session Type','lightness','Sex');
g.no_legend();
g.draw();
set(g.facet_axes_handles,'XTick',[0 5 10 15 20 25],'XTickLabels',{'0' '5' '10' '15' 'Ext' 'R'});
set(g.facet_axes_handles,'YTick',[0  325 650]);
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Fentanyl Consumption.pdf'),'ContentType','vector');

g=gramm('x',mT.sessionNum,'y',mT.Infusions,'lightness',mT.sessionType,'color',mT.Sex);
f=figure('Position',[1 1 350 300]);
g.set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g.stat_summary('geom',{'errorbar','point'},'type','sem','dodge',2.5,'setylim',1);
g.set_point_options('markers',{'o','s'},'base_size',5);
g.set_text_options('font','Helvetica','base_size',16,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[0 26],'YLim',[0 100],'TickDir','out');
g.set_order_options('lightness',{'Extinction','Training','Reinstatement'});
g.set_names('x','Session','y','Infusions','color','Session Type','lightness','Sex');
g.no_legend();
g.draw();
set(g.facet_axes_handles,'XTick',[0 5 10 15 20 25],'XTickLabels',{'0' '5' '10' '15' 'Ext' 'R'});
set(g.facet_axes_handles,'YTick',[0 50 100]);
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Infusions.pdf'),'ContentType','vector');

g=gramm('x',mT.sessionNum,'y',mT.HeadEntries,'lightness',mT.sessionType,'color',mT.Sex);
f=figure('Position',[1 1 350 300]);
g.set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g.stat_summary('geom',{'errorbar','point'},'type','sem','dodge',2.5,'setylim',1);
g.set_point_options('markers',{'o','s'},'base_size',5);
g.set_text_options('font','Helvetica','base_size',16,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[0 26],'YLim',[0 180],'TickDir','out');
g.set_order_options('lightness',{'Extinction','Training','Reinstatement'});
g.set_names('x','Session','y','Head Entries','color','Session Type','lightness','Sex');
g.no_legend();
g.draw();
set(g.facet_axes_handles,'XTick',[0 5 10 15 20 25],'XTickLabels',{'0' '5' '10' '15' 'Ext' 'R'});
set(g.facet_axes_handles,'YTick',[0 90 180]);
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Head Entries.pdf'),'ContentType','vector');

g=gramm('x',mT.sessionNum,'y',mT.Latency,'lightness',mT.sessionType,'color',mT.Sex);
f=figure('Position',[1 1 350 300]);
g.set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g.stat_summary('geom',{'errorbar','point'},'type','sem','dodge',2.5,'setylim',1);
g.set_point_options('markers',{'o','s'},'base_size',5);
g.set_text_options('font','Helvetica','base_size',16,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[0 26],'YLim',[0 400],'TickDir','out');
g.set_order_options('lightness',{'Extinction','Training','Reinstatement'});
g.set_names('x','Session','y','Head Entry Latency (s)','color','Session Type','lightness','Sex');
g.no_legend();
g.draw();
set(g.facet_axes_handles,'XTick',[0 5 10 15 20 25],'XTickLabels',{'0' '5' '10' '15' 'Ext' 'R'});
set(g.facet_axes_handles,'YTick',[0 200 400]);
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Latency.pdf'),'ContentType','vector');

g=gramm('x',mT.sessionNum,'y',mT.ActiveLever,'lightness',mT.sessionType,'color',mT.Sex)
f=figure('Position',[1 1 350 300]);
g.set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g.stat_summary('geom',{'errorbar','point'},'type','sem','dodge',2.5,'setylim',1);
g.set_point_options('markers',{'o','s'},'base_size',5);
g.set_text_options('font','Helvetica','base_size',16,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[0 26],'YLim',[0 150],'TickDir','out');
g.set_order_options('lightness',{'Extinction','Training','Reinstatement'});
g.set_names('x','Session','y','Active Lever Presses');
g.no_legend();
g.draw();
set(g.facet_axes_handles,'XTick',[0 5 10 15 20 25],'XTickLabels',{'0' '5' '10' '15' 'Ext' 'Rei'});
set(g.facet_axes_handles,'YTick',[0 75 150]);
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Active Lever.pdf'),'ContentType','vector');

g=gramm('x',mT.sessionNum,'y',mT.InactiveLever,'lightness',mT.sessionType,'color',mT.Sex,'subset',mT.ID~='R17'); % Extreme Outlier (Fixed)
f=figure('Position',[1 1 350 300]);
g.set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g.stat_summary('geom',{'errorbar','point'},'type','sem','dodge',2.5,'setylim',1);
g.set_point_options('markers',{'o','s'},'base_size',5);
g.set_text_options('font','Helvetica','base_size',16,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[0 26],'YLim',[0 150],'TickDir','out');
g.set_order_options('lightness',{'Extinction','Training','Reinstatement'});
g.set_names('x','Session','y','Inactive Lever Presses');
g.no_legend();
g.draw();
set(g.facet_axes_handles,'XTick',[0 5 10 15 20 25],'XTickLabels',{'0' '5' '10' '15' 'Ext' 'R'});
set(g.facet_axes_handles,'YTick',[0 75 150]);
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Inactive Lever.pdf'),'ContentType','vector');

%% Statistic Linear Mixed Effects Models
% Training
IntakeTrainLME = fitlme(mT(mT.sessionType=='Training',:),'Intake ~ Sex*sessionNum + (1|ID)');
InfusionsTrainLME = fitlme(mT(mT.sessionType=='Training',:),'Infusions ~ Sex*sessionNum + (1|ID)');
HeadTrainLME = fitlme(mT(mT.sessionType=='Training',:),'HeadEntries ~ Sex*sessionNum + (1|ID)');
LatencyTrainLME = fitlme(mT(mT.sessionType=='Training',:),'Latency ~ Sex*sessionNum + (1|ID)');
ActiveTrainLME = fitlme(mT(mT.sessionType=='Training',:),'ActiveLever ~ Sex*sessionNum + (1|ID)');
InactiveTrainLME = fitlme(mT(mT.sessionType=='Training',:),'InactiveLever ~ Sex*sessionNum + (1|ID)');

IntakeTrainF = anova(IntakeTrainLME,'DFMethod','satterthwaite');
InfusionsTrainF = anova(InfusionsTrainLME,'DFMethod','satterthwaite');
HeadTrainF = anova(HeadTrainLME,'DFMethod','satterthwaite');
LatencyTrainF = anova(LatencyTrainLME,'DFMethod','satterthwaite');
ActiveTrainF = anova(ActiveTrainLME,'DFMethod','satterthwaite');
InactiveTrainF = anova(InactiveTrainLME,'DFMethod','satterthwaite');

% Extinction
HeadExtLME = fitlme(mT(mT.sessionType=='Extinction',:),'HeadEntries ~ Sex*sessionNum + (1|ID)');
LatencyExtLME = fitlme(mT(mT.sessionType=='Extinction',:),'Latency ~ Sex*sessionNum + (1|ID)');
ActiveExtLME = fitlme(mT(mT.sessionType=='Extinction',:),'ActiveLever ~ Sex*sessionNum + (1|ID)');
InactiveExtLME = fitlme(mT(mT.sessionType=='Extinction',:),'InactiveLever ~ Sex*sessionNum + (1|ID)');

HeadExtF = anova(HeadExtLME,'DFMethod','satterthwaite');
LatencyExtF = anova(LatencyExtLME,'DFMethod','satterthwaite');
ActiveExtF = anova(ActiveExtLME,'DFMethod','satterthwaite');
InactiveExtF = anova(InactiveExtLME,'DFMethod','satterthwaite');

% Reinstatement
HeadReinLME = fitlme(mT(mT.sessionNum>22,:),'HeadEntries ~ Sex*sessionNum + (1|ID)');
LatencyReinLME = fitlme(mT(mT.sessionNum>22,:),'Latency ~ Sex*sessionNum + (1|ID)');
ActiveReinLME = fitlme(mT(mT.sessionNum>22,:),'ActiveLever ~ Sex*sessionNum + (1|ID)');
InactiveReinLME = fitlme(mT(mT.sessionNum>22,:),'InactiveLever ~ Sex*sessionNum + (1|ID)');

HeadReinF = anova(HeadReinLME,'DFMethod','satterthwaite');
LatencyReinF = anova(LatencyReinLME,'DFMethod','satterthwaite');
ActiveReinF = anova(ActiveReinLME,'DFMethod','satterthwaite');
InactiveReinF = anova(InactiveReinLME,'DFMethod','satterthwaite');

statsname=fullfile('Statistics','Oral SA Group Stats.mat');
save(statsname,'IntakeTrainF','InfusionsTrainF','HeadTrainF','LatencyTrainF','ActiveTrainF','InactiveTrainF',...
    'HeadExtF','LatencyExtF','ActiveExtF','InactiveExtF',...
    'HeadReinF','LatencyReinF','ActiveReinF','InactiveReinF');


%% Individual Variability Suseptibility Modeling
% INDIVIDUAL VARIABLES
% Intake = total fentanyl consumption (ug/kg)
% Seeking = total head entries in SA
% Cue Association = HE Latency in SA (Invert?)
% Escalation = Slope of intake
% Extinction = total presses during extinction
% Persistance = slope of extinction presses
% Flexability = total inactive lever presses during extinction (Invert?)
% Relapse = total presses during reinstatement
% Cue Recall = HE Latency in reinstatement (invert?)tmpT

% corrMat=corr([ivT.Intake,ivT.S% Slope Calculation & IV Extraction
ID=unique(mT.ID);

Intake=[];
for i=1:length(ID)
Dummy(i,1)=1;   
ID(i,1)=ID(i);    
Intake(i,1)= mean(mT.Intake(mT.ID==ID(i) & mT.sessionNum>5 & mT.sessionType=='Training'));
Seeking(i,1)= mean(mT.HeadEntries(mT.ID==ID(i) & mT.sessionNum>5 & mT.sessionType=='Training'));
Association(i,1)= mean(mT.Latency(mT.ID==ID(i) & mT.sessionNum>5 & mT.sessionType=='Training'));
e = polyfit([1:1:10],mT.Infusions(mT.ID==ID(i) & mT.sessionNum>5 & mT.sessionType=='Training'),1);
Escalation(i,1)=e(1);
Extinction(i,1)=mean(mT.ActiveLever(mT.ID==ID(i) & mT.sessionType=='Extinction'));
Flexability(i,1)=mean(mT.InactiveLever(mT.ID==ID(i) & mT.sessionType=='Extinction'));
Relapse(i,1)=mT.ActiveLever(mT.ID==ID(i) & mT.sessionType=='Reinstatement');
Recall(i,1)=mT.Latency(mT.ID==ID(i) & mT.sessionType=='Reinstatement');
s=mT.Sex(mT.ID==ID(i) & mT.sessionType=='Training');
Sex(i,1)=s(1);
end

Association=log(Association);
Recall=log(Recall);

% Tests of Normality vs Bimodal
[hIn pIn]=kstest(zscore(Intake));
[hIn pIn]=kstest(zscore(Seeking));
[hIn pIn]=kstest(zscore(Association));
[hIn pIn]=kstest(zscore(Escalation));
[hIn pIn]=kstest(zscore(Extinction));
[hIn pIn]=kstest(zscore(Relapse));

% Individual Variable Table
ivT=table(ID,Sex,Intake,Seeking,Association,Escalation,Extinction,Relapse);

% Z-Score & Severity Score
ivZT=ivT;
ivZT.Intake=zscore(ivZT.Intake);
ivZT.Seeking=zscore(ivZT.Seeking);
ivZT.Association=zscore(max(ivZT.Association)-ivZT.Association);
ivZT.Escalation=zscore(ivZT.Escalation);
ivZT.Extinction=zscore(ivZT.Extinction);
ivZT.Relapse=zscore(ivZT.Relapse);

% Correlations
varnames = ivZT.Properties.VariableNames;
prednames = varnames(varnames ~= "ID" & varnames ~= "Sex");
f=figure('Position',[1 1 400 300]);
ct=corr(ivZT{:,prednames},Type='Pearson');
imagesc(ct,[0 1]); % Display correlation matrix as an image
colormap('magma');
a = colorbar();
a.Label.String = 'Rho';
a.Label.FontSize = 12;
a.FontSize = 12;
set(gca, 'XTickLabel', prednames, 'XTickLabelRotation',45, 'FontSize', 12); % set x-axis labels
set(gca, 'YTickLabel', prednames, 'YTickLabelRotation',45, 'FontSize', 12); % set x-axis labels
box off
set(gca,'LineWidth',1.5,'TickDir','out')
[corrs,~,h2]=corrplotKC(ivZT,DataVariables=prednames,Type="Spearman",TestR="on")
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/Individual Differences','Correlations.pdf'),'ContentType','vector');

Severity=sum(ivZT{:,prednames}')';
Class=cell([height(Severity) 1]);
Class(Severity>1.5)={'High'};
Class(Severity>-1.5 & Severity<1.5)={'Mid'};
Class(Severity<-1.5)={'Low'};
Class=categorical(Class);
ivT=[ivT table(Severity,Class)];

[hIn pIn]=kstest(zscore(Severity));

% save("Processed Data\Master Behavior Table.mat","mT",'ivT','ivZT');

clear g
g(1,1)=gramm('x',ones([1,22]),'y',ivT.Intake,'color',ivT.Sex);
g(1,1).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,1).stat_violin('extra_y',0,'half',1,'normalization','width','fill','transparent');
g(1,1).geom_jitter('width',.05,'dodge',-.5,'alpha',.75);
g(1,1).axe_property('LineWidth',1.5,'FontSize',14,'Font','Helvetica','XLim',[.5 1.5],'YLim',[0 1200],'TickDir','out');
g(1,1).set_names('x',[],'y',' Fentanyl Intake (mg/kg)','color','');
g(1,1).set_point_options('base_size',6);
g(1,1).no_legend();
g(1,1).set_title(' ');

g(1,2)=gramm('x',ones([1,22]),'y',ivT.Seeking,'color',ivT.Sex);
g(1,2).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,2).stat_violin('extra_y',0,'half',1,'normalization','width','fill','transparent');
g(1,2).geom_jitter('width',.05,'dodge',-.5,'alpha',.75);
g(1,2).axe_property('LineWidth',1.5,'FontSize',14,'Font','Helvetica','XLim',[.5 1.5],'YLim',[0 200],'TickDir','out');
g(1,2).set_names('x',[],'y','Head Entries (Training)','color','');
g(1,2).set_point_options('base_size',6);
g(1,2).no_legend();
g(1,2).set_title(' ');

g(1,3)=gramm('x',ones([1,22]),'y',ivT.Association,'color',ivT.Sex);
g(1,3).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,3).stat_violin('extra_y',0,'half',1,'normalization','width','fill','transparent');
g(1,3).geom_jitter('width',.05,'dodge',-.5,'alpha',.75);
g(1,3).axe_property('LineWidth',1.5,'FontSize',14,'Font','Helvetica','XLim',[.5 1.5],'YLim',[0 6],'TickDir','out');
g(1,3).set_names('x',[],'y','Head Entry Latency-Log(s)','color','');
g(1,3).set_point_options('base_size',6);
g(1,3).no_legend();
g(1,3).set_title(' ');

g(1,4)=gramm('x',ones([1,22]),'y',ivT.Escalation,'color',ivT.Sex);
g(1,4).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,4).stat_violin('extra_y',0,'half',1,'normalization','width','fill','transparent');
g(1,4).geom_jitter('width',.05,'dodge',-.5,'alpha',.75);
g(1,4).axe_property('LineWidth',1.5,'FontSize',14,'Font','Helvetica','XLim',[.5 1.5],'YLim',[-1 10],'TickDir','out');
g(1,4).set_point_options('base_size',6);
g(1,4).set_names('x',[],'y','Slope of Intake Across Days','color','');
g(1,4).no_legend();
g(1,4).set_title(' ');

g(1,5)=gramm('x',ones([1,22]),'y',ivT.Extinction./7,'color',ivT.Sex);
g(1,5).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,5).stat_violin('extra_y',0,'half',1,'normalization','width','fill','transparent');
g(1,5).geom_jitter('width',.05,'dodge',-.5,'alpha',.75);
g(1,5).axe_property('LineWidth',1.5,'FontSize',14,'Font','Helvetica','XLim',[.5 1.5],'YLim',[0 16],'TickDir','out');
g(1,5).set_point_options('base_size',6);
g(1,5).set_names('x',[],'y','Presses During Extinction','color','');
g(1,5).no_legend();
g(1,5).set_title(' ');

g(1,6)=gramm('x',ones([1,22]),'y',ivT.Relapse,'color',ivT.Sex);
g(1,6).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,6).stat_violin('extra_y',0,'half',1,'normalization','width','fill','transparent');
g(1,6).geom_jitter('width',.05,'dodge',-.5,'alpha',.75);
g(1,6).axe_property('LineWidth',1.5,'FontSize',14,'Font','Helvetica','XLim',[.5 1.5],'YLim',[0 120],'TickDir','out');
g(1,6).set_point_options('base_size',6);
g(1,6).set_names('x',[],'y','Lever Presses Reinstatement','color','');
g(1,6).no_legend();
g(1,6).set_title(' ');

g(1,7)=gramm('x',ones([1,22]),'y',ivT.Severity,'color',ivT.Sex);
g(1,7).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,7).stat_violin('extra_y',0,'half',1,'normalization','width','fill','transparent');
g(1,7).geom_jitter('width',.05,'dodge',-.5,'alpha',.75);
g(1,7).axe_property('LineWidth',1.5,'FontSize',14,'Font','Helvetica','XLim',[.5 1.5],'YLim',[-12 12],'TickDir','out');
g(1,7).set_point_options('base_size',6);
g(1,7).set_names('x',[],'y','Sum of Severity Z-Scores','color','');
g(1,7).no_legend();
g(1,7).set_title(' ');

f=figure('Position',[100 100 1350 350],'Color',[1 1 1]);
g.draw;
for i=1:width(g)
   g(1,i).results.geom_jitter_handle(1).MarkerEdgeColor = [0 0 0] 
   g(1,i).results.geom_jitter_handle(2).MarkerEdgeColor = [0 0 0] 
end

set(g(1,1).facet_axes_handles,'XTick',1,'XTickLabels',{'Intake'});
set(g(1,1).facet_axes_handles,'YTick',[0 600 1200]);

set(g(1,2).facet_axes_handles,'XTick',1,'XTickLabels',{'Seeking'});
set(g(1,2).facet_axes_handles,'YTick',[0 100 200]);
set(g(1,5).facet_axes_handles,'XTick',1,'XTickLabels',{'Extinction'});

set(g(1,3).facet_axes_handles,'XTick',1,'XTickLabels',{'Association'});
set(g(1,3).facet_axes_handles,'YTick',[0 3 6]);

set(g(1,4).facet_axes_handles,'XTick',1,'XTickLabels',{'Escalation'});
set(g(1,4).facet_axes_handles,'YTick',[0 5 10]);

set(g(1,5).facet_axes_handles,'YTick',[0 8 16]);

% set(g(1,6).facet_axes_handles,'XTick',1,'XTickLabels',{'Persistence'});
% set(g(1,6).facet_axes_handles,'YTick',[0 3 6]);

set(g(1,6).facet_axes_handles,'XTick',1,'XTickLabels',{'Relapse'});
set(g(1,6).facet_axes_handles,'YTick',[0 60 120]);

set(g(1,7).facet_axes_handles,'XTick',1,'XTickLabels',{'Severity'});
set(g(1,7).facet_axes_handles,'YTick',[-12 0 12]);


exportgraphics(f,fullfile('Combined Oral Fentanyl Output\Individual Differences','Individual Differences.pdf'),'ContentType','vector');

%PCA
varnames = ivZT.Properties.VariableNames;
prednames = varnames(varnames ~= "ID" & varnames ~= "Sex" & varnames ~= "Class");
% Y = tsne(ivZT{:,prednames},'Algorithm','exact','Distance','cosine','Perplexity',15);
[coeff,score,latent] = pca(ivZT{:,prednames});
PC1=score(:,1);
PC2=score(:,2);

f1=figure('color','w','position',[100 100 400 325]);
h1 = biplot(coeff(:,1:3),'Scores',score(:,1:3),...
    'Color','b','Marker','o','VarLabels',prednames);
for i=1:6
h1(i).Color=[.5 .5 .5];    
h1(i).LineWidth=1.5;
h1(i).LineStyle=':';
h1(i).Marker='o'
h1(i).MarkerSize=4;
h1(i).MarkerFaceColor=[.5 .5 .5]
h1(i).MarkerEdgeColor=[0 .0 0]
end
for i=7:12
h1(i).Marker='none'
end
R = rescale(Severity,4,18)
for i=19:40
    if Sex(i-18)=='Male'
        h1(i).MarkerFaceColor=[.46 .51 1]
        h1(i).MarkerEdgeColor=[0 .0 0]
        h1(i).MarkerSize=R(i-18)
    else
        h1(i).MarkerFaceColor=[.95 .39 .13]
        h1(i).MarkerEdgeColor=[0 .0 0]
        h1(i).MarkerSize=R(i-18)
    end
end
for i=13:18
h1(i).FontSize=11
h1(i).FontWeight='bold'
end
h1(13).Position=[.535 .185];
h1(14).Position=[.435 .625];
h1(15).Position=[.4 -.265];
h1(16).Position=[.485 .285];
h1(17).Position=[.435 -.41];
h1(18).Position=[.435 -.515];
set(gca,'LineWidth',1.5,'TickDir','in','FontSize',14);
grid off
xlabel('');
ylabel('');
zlabel('');
exportgraphics(f1,fullfile('Combined Oral Fentanyl Output\Individual Differences','PCA Vectors.pdf'),'ContentType','vector');

% Set up recording parameters (optional), and record
% OptionX.FrameRate=30;OptionX.Duration=20;OptionX.Periodic=true;
% CaptureFigVid([-180,0;0,90], 'Combined Oral Fentanyl Output\Individual Differences\PCA',OptionX)
close all
%% Within Session Behavioral Analysis
% Event Codes
% 3 = Rewarded Press
% 97 = ITI Press
% 23 = Inactive Press
% 98 = Rewarded Head Entry
% 99 = Unrewarded Head Entry

% mT=mT(mT.sessionType=='Training',:);
% for i=1:height(mT)
% disp(num2str(height(mT)-i));    
% raw=importOralSA(fullfile(mT.folder{i}, mT.name{i}));
% [eventCode,eventTime] = EventExtractor(raw);
% [eventCodeFilt,eventTimeFilt] = eventFilter(eventCode,eventTime);
% 
% % Analyze Rewarded Lever Pressing Across the Session
% rewLP=eventTime(eventCode==3);
% rewHE=eventTimeFilt(eventCodeFilt==98);
% doseHE=[];
% 
% for j=1:height(rewHE)
%     if j==1
%         doseHE(j,1)=sum(rewLP<rewHE(j,1));
%     else
%         doseHE(j,1)=sum(rewLP<rewHE(j,1))-sum(doseHE(1:j-1,1));
%     end
% end
% 
% ID=repmat([mT.ID(i)],length(rewLP),1);
% sessionNum=repmat([mT.sessionNum(i)],length(rewLP),1);
% 
% if i==1
% mPressT=table(ID,sessionNum,rewLP);
% else
% mPressT=[mPressT; table(ID,sessionNum,rewLP)];
% end
% 
% [DL DLTime]=pharmacokineticsOralFent('infusions',[rewHE*1000 (rewHE+(7*doseHE))*1000],'duration',180,'type',4,'weight',mT.Weight(i),'mg_mL',0.07,'mL_S',.006);
% DL=DL';
% DLTime=(.1:.1:180)';
% DL=imresize(DL, [length(DLTime),1]);
% 
% ID=repmat([mT.ID(i)],length(DL),1);
% sessionNum=repmat([mT.sessionNum(i)],length(DL),1);
% 
% if i==1
% mDrugLT= table(ID, sessionNum, DL, DLTime);
% else
% mDrugLT=[mDrugLT; table(ID, sessionNum, DL, DLTime)];
% end
% 
% end
% 
% mDrugLT=innerjoin(mDrugLT,mT,'Keys',{'ID','sessionNum'},'RightVariables',{'sessionType','Sex'});
% mPressT=innerjoin(mPressT,mT,'Keys',{'ID','sessionNum'},'RightVariables',{'sessionType','Sex'});
% 
% idTname=fullfile('Processed Data','ID Behavior Table.mat');
% save(idTname,'mDrugLT','mPressT');

load('Processed Data\ID Behavior Table.mat');

f=figure('Position',[100 100 1200 800]);
g=gramm('x',mPressT.rewLP/60,'subset',mPressT.sessionType=='Training','color',mPressT.Sex);
g.set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g.facet_wrap(mPressT.sessionNum,'scale','independent','ncols',5,'force_ticks',1,'column_labels',0);
g.stat_bin('normalization','cumcount','geom','stairs','edges',0:1:180);
g.axe_property('LineWidth',1.5,'FontSize',14,'XLim',[0 180],'tickdir','out');
g.set_names('x',' Time (m)','y','Cumulative Rewards');
g.draw;
for i=1:15
    g.facet_axes_handles(i).Title.String=['Day ' num2str(i)];
    g.facet_axes_handles(i).Title.FontSize=12;
    g.facet_axes_handles(i).YLim=[0 800];
end
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Cumulative Infusions All.pdf'),'ContentType','vector');

f=figure('Position',[100 100 1200 800]);
g=gramm('x',mDrugLT.DLTime,'y',mDrugLT.DL*1000,'subset',mDrugLT.sessionType=='Training','color',mDrugLT.Sex);
g.set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g.facet_wrap(mDrugLT.sessionNum,'scale','independent','ncols',5,'force_ticks',1,'column_labels',0);
g.stat_summary('geom','area','setylim',1);
g.axe_property('LineWidth',1.5,'FontSize',10,'XLim',[0 180],'tickdir','out');
g.set_names('x',' Time (m)','y','Estimated Brain Fentanyl (pMOL)');
g.draw;
for i=1:15
    g.facet_axes_handles(i).Title.String=['Day ' num2str(i)];
    g.facet_axes_handles(i).Title.FontSize=12;
    %g.facet_axes_handles(i).YLim=[0 40];
end
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Drug Level All.pdf'),'ContentType','vector');

IDs=unique(mPressT.ID);
for j=1:length(IDs)
g=gramm('x',mPressT.rewLP/60,'subset',mPressT.sessionType=='Training' & mPressT.ID==IDs(j));
g.set_color_options('hue_range',[-65 265],'chroma',80,'lightness',70,'n_color',2);
g.facet_wrap(mPressT.sessionNum,'scale','independent','ncols',5,'force_ticks',1,'column_labels',0);
g.stat_bin('normalization','cumcount','geom','stairs','edges',0:1:180);
g.axe_property('LineWidth',1.5,'FontSize',12,'XLim',[0 180],'tickdir','out');
g.set_names('x',' Time (m)','y','Infusions');
g.set_title(['ID: ' char(IDs(j))]);
f=figure('Position',[100 100 1200 800]);
g.draw;
for i=1:length(g.facet_axes_handles)
    g.facet_axes_handles(i).Title.String=['Day ' num2str(i)];
    g.facet_axes_handles(i).Title.FontSize=12;
    %set(g.facet_axes_handles(i),'XTick',[0 90 180],'YTick',[0 40 80]);
end
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/Raw Behavior',[char(IDs(j)) ' Cumulative Infusions.pdf']),'ContentType','vector');
end

for j=1:length(IDs)
g=gramm('x',mDrugLT.DLTime,'y',mDrugLT.DL*1000,'subset',mDrugLT.sessionType=='Training' & mDrugLT.ID==IDs(j));
g.set_color_options('hue_range',[-65 265],'chroma',80,'lightness',70,'n_color',1);
g.facet_wrap(mDrugLT.sessionNum,'scale','independent','ncols',5,'force_ticks',1,'column_labels',0);
g.geom_line();
g.axe_property('LineWidth',1.5,'FontSize',12,'XLim',[0 180],'tickdir','out');
g.set_names('x',' Time (m)','y','Brain DL (pMOL)');
g.set_title(['ID: ' char(IDs(j))]);
f=figure('Position',[100 100 1200 800]);
g.draw;
for i=1:length(g.facet_axes_handles)
    g.facet_axes_handles(i).Title.String=['Day ' num2str(i)];
    g.facet_axes_handles(i).Title.FontSize=12;
    set(g.facet_axes_handles(i),'XTick',[0 90 180],'YTick',[0 15 30]);
end
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/Raw Behavior',[char(IDs(j)) ' Drug Level.pdf']),'ContentType','vector');
end

g=gramm('x',mDrugLT.DLTime,'y',mDrugLT.DL*1000,'color',mDrugLT.Sex,'subset',mDrugLT.sessionType=='Training');
g.set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g.facet_wrap(mDrugLT.sessionNum,'scale','independent','ncols',5,'force_ticks',1,'column_labels',0);
g.stat_summary('geom','area','setylim',1);
g.axe_property('LineWidth',1.5,'FontSize',13,'XLim',[0 200],'tickdir','out');
g.set_names('x',' Time (m)','y','Brain DL (pMOL)');
g.set_title(['Average Drug Level']);
f=figure('Position',[100 100 1200 800]);
g.draw;
for i=1:length(g.facet_axes_handles)
    g.facet_axes_handles(i).Title.String=['Day ' num2str(i)];
    g.facet_axes_handles(i).Title.FontSize=12;
    g.facet_axes_handles(i).YLim=[0 50];
end
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Average Drug Level.pdf'),'ContentType','vector');

g=gramm('x',mDrugLT.DLTime,'y',mDrugLT.DL*1000,'color',mDrugLT.Sex,'lightness',mDrugLT.sessionNum,'subset',(mDrugLT.sessionNum==5 | mDrugLT.sessionNum==10 | mDrugLT.sessionNum==15));
%g=gramm('x',mDrugLT.DLTime,'y',mDrugLT.DL*1000);
g.set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g.stat_summary('geom','line','setylim',1);
g.set_text_options('font','Helvetica','base_size',12,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[0 180],'YLim',[0 31],'tickdir','out');
g.set_names('x',' Time (m)','y','Estimated Brain Fentanyl');
%g.set_title(['Average Drug Level']);
g.no_legend();
f=figure('Position',[100 100 270 250]);
g.draw;
set(g.facet_axes_handles,'YTick',[0 15 30],'XTick',[0 90 180]);
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Average Drug Level-51015.pdf'),'ContentType','vector');

g=gramm('x',mPressT.rewLP/60,'color',mPressT.Sex,'lightness',mPressT.sessionNum,'subset',(mPressT.sessionNum==5 | mPressT.sessionNum==10 | mPressT.sessionNum==15));
g.set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g.stat_bin('normalization','cumcount','geom','stairs','edges',0:1:180);
g.set_text_options('font','Helvetica','base_size',12,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[0 180],'YLim',[0 800],'tickdir','out');
g.set_names('x',' Time (m)','y','Cumulative Responses');
%g.set_title(['Average Drug Level']);
g.no_legend();
f=figure('Position',[100 100 270 250]);
g.draw;
set(g.facet_axes_handles,'YTick',[0 400 800],'XTick',[0 90 180]);
exportgraphics(f,fullfile('Combined Oral Fentanyl Output','Average Cumulative-51015.pdf'),'ContentType','vector');
close all;
%% BE Battery & Hot Plate

% Hot Plate
% clear all;
opts = detectImportOptions('Processed Data\HP Master Sheet.xlsx');
opts = setvartype(opts,{'ID','Sex'},'categorical');
hpT=readtable('Processed Data\HP Master Sheet.xlsx'),opts;
hpT.ID = categorical(hpT.ID);
hpT.Sex = categorical(hpT.Sex);
hpT.Session = categorical(hpT.Session);

clear g
g(1,1)=gramm('x',hpT.Session,'y',hpT.Latency,'color',hpT.Sex);
g(1,1).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,1).stat_violin('normalization','width','half',0,'fill','transparent','dodge',.75)
g(1,1).geom_jitter('width',.1,'dodge',.75,'alpha',.5);
g(1,1).stat_summary('geom',{'black_errorbar'},'type','sem','dodge',.75);
g(1,1).axe_property('LineWidth',1.5,'FontSize',16,'Font','Helvetica','YLim',[20 80],'XLim',[.5 2.5],'TickDir','out');
g(1,1).set_order_options('x',{'Pre' 'Post'});
g(1,1).set_names('x',[],'y','Paw Lick Latency (s)','color','Sex');
f=figure('Position',[100 100 350 300],'Color',[1 1 1]);
g(1,1).no_legend();
g.draw;
exportgraphics(f,fullfile('Combined Oral Fentanyl Output\BE HP Figs','Hot Plate.pdf'),'ContentType','vector');

HP_LME = fitlme(hpT,'Latency ~ Sex*Session + (1|ID)');
HP_F = anova(HP_LME,'DFMethod','satterthwaite');
statsna=fullfile('Statistics','Oral SA Hoteplate Stats.mat');
save(statsna,'HP_F');

% Behavioral Economics (Dose Response)
% Hot Plate
% clear all;
opts = detectImportOptions('Processed Data\Oral Fentanyl Behavioral Economics Data.xlsx');
opts = setvartype(opts,{'ID','Sex'},'categorical');
beT=readtable('Processed Data\Oral Fentanyl Behavioral Economics Data.xlsx'),opts;
beT.Sex = categorical(beT.Sex);
beT.ID = categorical(beT.ID);
responses=ceil((beT.mLTaken./.05));
unitPrice=(1000./beT.Dose__g_ml_);
beT=[beT table(responses,unitPrice)];

%Curve Fit Each Animals Intake over Dose
IDs = unique(beT.ID);
Sex=[];
for i=1:height(IDs)
    tmp=beT(beT.ID==IDs(i),2);
    Sex(i,1)=tmp{1,1};
    in=beT{beT.ID==IDs(i),10};
    in=in(1:5);
    price=beT{beT.ID==IDs(i),12};
    price=price(1:5);
    price=price-price(1)+1;

    myfittype = fittype('log(b)*(exp(1)^(-1*a*x))',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a','b'})

    f=fit(price,log(in),myfittype,'StartPoint', [.003, 200],'lower',[.0003 100],'upper',[.03 1500]);
    [res_x, idx_x]=knee_pt(log(1:50),f(1:50));

%     figure;
%     plot(log(1:50),f(1:50));
%     hold on;
%     scatter(log(price),log(in),10);
%     plot([log(idx_x) log(idx_x)],[min(f(1:50)) max(f(1:50))],'--k')
%     xlim([-1 5]);
%     title(IDs(i))
    
    Alpha(i,1)=f.a;
    Elastic(i,1)=idx_x;
end
aT=table(IDs,Sex,Alpha,Elastic);

clear g
g(1,1)=gramm('x',aT.Sex,'y',aT.Alpha,'color',aT.Sex);
g(1,1).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,1).stat_violin('normalization','width','half',0,'fill','transparent','dodge',.75)
g(1,1).geom_jitter('width',.1,'dodge',.75,'alpha',.5);
g(1,1).stat_summary('geom',{'black_errorbar'},'type','sem','dodge',.75);
g(1,1).axe_property('LineWidth',1.5,'FontSize',16,'Font','Helvetica','TickDir','out');
g(1,1).set_order_options('x',{'Female' 'Male'});
g(1,1).set_names('x','Sex','y','Demand Elasticity','color','Sex');
f=figure('Position',[100 100 350 300],'Color',[1 1 1]);
g(1,1).no_legend();
g.draw;
exportgraphics(f,fullfile('Combined Oral Fentanyl Output\BE HP Figs','Alpha.pdf'),'ContentType','vector');

clear g
g(1,1)=gramm('x',aT.Sex,'y',aT.Elastic,'color',aT.Sex);
g(1,1).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,1).stat_violin('normalization','width','half',0,'fill','transparent','dodge',.75)
g(1,1).geom_jitter('width',.1,'dodge',.75,'alpha',.5);
g(1,1).stat_summary('geom',{'black_errorbar'},'type','sem','dodge',.75);
g(1,1).axe_property('LineWidth',1.5,'FontSize',16,'Font','Helvetica','TickDir','out');
g(1,1).set_order_options('x',{'Female' 'Male'});
g(1,1).set_names('x','Sex','y','Demand Elasticity','color','Sex');
f=figure('Position',[100 100 350 300],'Color',[1 1 1]);
g(1,1).no_legend();
g.draw;
exportgraphics(f,fullfile('Combined Oral Fentanyl Output\BE HP Figs','Elastic.pdf'),'ContentType','vector');

clear g
g(1,1)=gramm('x',beT.Dose__g_ml_,'y',beT.Intake__g_kg_,'color',beT.Sex);
g(1,1).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,1).stat_summary('geom',{'area','point'},'type','sem','setylim',1);
g.set_text_options('font','Helvetica','base_size',16,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[0 250],'YLim',[0 800],'tickdir','out');
g(1,1).set_names('x','Unit Dose (μg)','y','Fentanyl Intake (μg/kg)','color','Sex');
f=figure('Position',[100 100 350 300],'Color',[1 1 1]);
g(1,1).no_legend();
g.draw;
exportgraphics(f,fullfile('Combined Oral Fentanyl Output\BE HP Figs','Intake.pdf'),'ContentType','vector');

clear g
g(1,1)=gramm('x',beT.Dose__g_ml_,'y',responses,'color',beT.Sex);
g(1,1).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g.stat_summary('geom',{'errorbar','point','line'},'type','sem','dodge',.75,'setylim',1);
g.set_point_options('markers',{'o','s'},'base_size',5);
g.set_text_options('font','Helvetica','base_size',16,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[-15 250],'tickdir','out');
g(1,1).set_names('x','Dose (μg/mL)','y','Responses','color','Sex');
f=figure('Position',[100 100 350 300],'Color',[1 1 1]);
g(1,1).no_legend();
g.draw;
exportgraphics(f,fullfile('Combined Oral Fentanyl Output\BE HP Figs','Responses.pdf'),'ContentType','vector');

clear g
g(1,1)=gramm('x',beT.unitPrice,'y',beT.Intake__g_kg_,'color',beT.Sex,'subset',beT.Dose__g_ml_~=0);
g(1,1).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,1).stat_summary('geom',{'area','point'},'type','sem','setylim',1);
%g(1,1).stat_smooth('geom',{'area_only'});
g.set_text_options('font','Helvetica','base_size',16,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'tickdir','out');
g(1,1).set_names('x','Unit Price (responses/mg)','y','Fentanyl Intake (μg/kg)','color','Sex');
f=figure('Position',[100 100 350 300],'Color',[1 1 1]);
g(1,1).no_legend();
g.draw;
set(g.facet_axes_handles,'YScale','log','XScale','log')
set(g.facet_axes_handles,'XTick',[1 10 20 40])
exportgraphics(f,fullfile('Combined Oral Fentanyl Output\BE HP Figs','Unit Price Intake.pdf'),'ContentType','vector');

BE_LME = fitlme(beT,'responses ~ Sex*Dose__g_ml_ + (1|ID)');
BE_F = anova(BE_LME,'DFMethod','satterthwaite');
statsna=fullfile('Statistics','Oral SA BE Stats.mat');
save(statsna,'BE_F');


% Group BE Demand Curve
myfittype = fittype('log(b)*(exp(1)^(-1*a*x))',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a','b'})

x=g.results.stat_summary.x;
[y z]=g.results.stat_summary.y;
x=x-x(1)+exp(1);

ff=fit(x,log(y),myfittype,'StartPoint', [.003, 200],'lower',[.0003 100],'upper',[.03 1500]);
fm=fit(x,log(z),myfittype,'StartPoint', [.003, 200],'lower',[.0003 100],'upper',[.03 1500]);

f=figure('Position',[100 100 350 300],'Color',[1 1 1]);
hold on;
plot(log(1:50),ff(1:50),'LineWidth',1.5,'Color',[.95 .39 .13]);
plot(log(1:50),fm(1:50),'LineWidth',1.5,'Color',[.46 .51 1]);
scatter(log(x),log(y),36,[.95 .39 .13],'filled');
scatter(log(x),log(z),36,[.46 .51 1],'filled');
xlim([-.25 4.25]);
set(gca,'LineWidth',1.5,'tickdir','out','FontSize',16,'box',0);
xt=log([2.71 5 10 25 50]);
set(gca,'XTick',[0 xt],'XTickLabels',{'0' '1' '5' '10' '25' '50'});
xlabel('Cost (Response/Unit Dose)');
set(gca,'YTick',[5 5.85843 6.28229],'YTickLabels',{'148' '350' '535'});
ylabel('Fentanyl Intake (μg/kg)');

fAlpha=ff.a;
fQ0=exp(ff(1));
mAlpha=fm.a;
mQ0=exp(fm(1));
exportgraphics(f,fullfile('Combined Oral Fentanyl Output\BE HP Figs','True BE Figure.pdf'),'ContentType','vector');
save('Statistics\BE_Stats.m','fAlpha','mAlpha','fQ0','mQ0');

clear g
g(1,1)=gramm('x',beT.unitPrice,'y',beT.responses,'color',beT.Sex);
g(1,1).set_color_options('hue_range',[50 542.5],'chroma',80,'lightness',60,'n_color',2);
g(1,1).stat_summary('geom',{'area','point'},'type','sem','setylim',1);
g.set_text_options('font','Helvetica','base_size',16,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'tickdir','out');
g(1,1).set_names('x','Unit Price (responses/mg)','y','Responses','color','Sex');
f=figure('Position',[100 100 350 300],'Color',[1 1 1]);
g(1,1).no_legend();
g.draw;
set(g.facet_axes_handles,'XScale','log')
set(g.facet_axes_handles,'XTick',[1 10 20 40])
exportgraphics(f,fullfile('Combined Oral Fentanyl Output\BE HP Figs','Unit Price Response.pdf'),'ContentType','vector');

close all;

%% Behavior x Photometry Correlations
% clear all
% load('Processed Data\masterPETH_KneeSplitCue.mat');
% load('Processed Data\Master Behavior Table.mat');
% 
% w1T=masterPETH(masterPETH.Session=='W1' & masterPETH.Group=='Late',:);
% 
% for i=1:height(ivT)
% 
% cueT=w1T{w1T.ID==ivT.ID(i) & w1T.Event=='Cue',3};
% if isempty(cueT)
% cueMax(i,1)=NaN;
% cueSum(i,1)=NaN;
% else
% cueMax(i,1)=max(cueT);
% cueSum(i,1)=sum(cueT(101:150));
% end
% 
% rheT=w1T{w1T.ID==ivT.ID(i) & w1T.Event=='RewardedHE',3};
% if isempty(rheT)
% rheMin(i,1)=NaN;
% rheSum(i,1)=NaN;
% else
% rheMin(i,1)=min(rheT);
% rheSum(i,1)=sum(rheT(101:150));
% end
% 
% uheT=w1T{w1T.ID==ivT.ID(i) & w1T.Event=='UnrewardedHE',3};
% if isempty(uheT)
% uheMax(i,1)=NaN;
% uheSum(i,1)=NaN;
% else
% uheMax(i,1)=max(uheT);
% uheSum(i,1)=sum(uheT(101:200));
% end
% 
% end
% 
% % Cross Correlation Matrix
% ivT=[ivT table(cueMax,cueSum,rheMin,rheSum,uheMax,uheSum)];
% corrT=ivT(:,{'Intake','Seeking','Escalation','Extinction','Relapse','cueSum','rheSum','uheSum','cueMax','rheMin','uheMax'})
% f=figure('Position',[100 100 950 900],'Color',[1 1 1]);
% corrplot(corrT,Type="Spearman",TestR="on")