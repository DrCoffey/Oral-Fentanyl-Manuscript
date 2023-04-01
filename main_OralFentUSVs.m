% Title: main_OralFentUSVs
%
% Author: Kevin Coffey, Ph.D.
% Affiliation: University of Washington, Psychiatry
% email address: mrcoffey@uw.edu  
% January 2023; Last revision: 1-April-2023

% ------------- Description --------------
% Analysis script for USV data generated during oral fentanyl training,
% extinction, and reinstatement
% ----------------------------------------

%% ------------- BEGIN CODE --------------
% Import Data and Generate Key
clear all;
opts = detectImportOptions('K99 Aim2 Master Key.xlsx');
opts = setvartype(opts,{'TagColor','ID','Cage','Sex','LHbTarget',...
                   'Treatment','Stream'},'categorical');
opts = setvartype(opts,{'IncludePhotometry','IncludeBehavior'},'logical');
mKey=readtable('K99 Aim2 Master Key.xlsx',opts);

opts = detectImportOptions("Processed Data\01_20_23-18_09_55_merged_Stats.xlsx");
opts = setvartype(opts,{'Label'},'categorical');
opts = setvartype(opts,{'Accepted'},'logical');
mT=readtable("Processed Data\01_20_23-18_09_55_merged_Stats.xlsx",opts);
mT = renamevars(mT,'ID','CallNum');

% Generate Variables from File Name
for i=1:height(mT)
    tmp=strsplit(mT.File{i},{'\','_',' '});
    ID(i,1)=tmp(23);
    if strcmp(tmp{1,24}(1),'E')
        sessionType{i,1}='Extinction';
        sessionNum(i,1)= 16+str2num(tmp{1,24}(2:end));
    elseif strcmp(tmp{1,24}(1),'T')
        sessionType{i,1}='Training';
        sessionNum(i,1)= str2num(tmp{1,24}(2:end));
    else
        sessionType{i,1}='Reinstatement';
        sessionNum(i,1)= 25;
    end
    if mT.PrincipalFrequency_kHz_(i)>30
        Affect{i,1}='Positive';
    else
        Affect{i,1}='Negative';
    end

    if sessionNum(i,1)<6
       sessionWeek(i,1)=1; 
    elseif sessionNum(i,1)>5 & sessionNum(i,1)<11
       sessionWeek(i,1)=2;
    elseif sessionNum(i,1)>10 & sessionNum(i,1)<16
       sessionWeek(i,1)=3;
    elseif sessionNum(i,1)>15 & sessionNum(i,1)<25
        sessionWeek(i,1)=4;
    else
        sessionWeek(i,1)=5;
    end
end
ID=categorical(ID);
sessionType=categorical(sessionType);
Affect=categorical(Affect);
mT=[mT table(ID, sessionNum, sessionType, sessionWeek, Affect)];
load("Processed Data\ClusteringDataUMAP_All Calls.mat")
ClusteringData=ClusteringData(:,[1 11 12]);
mT=[mT ClusteringData];

clear i sessionType sessionNum sessionWeek opts ID tmp Affect ClusteringData

%% ----------- Graphing UMAP Embeddings ----------
g=gramm('x',mT.embedX,'y',mT.embedY,'color',mT.Label);
f=figure('Position',[800 250 700 500]);
g.geom_point('alpha',.5);
g.set_text_options('font','Helvetica','base_size',16,'legend_scaling',.75,'legend_title_scaling',.50);
g.set_point_options('base_size',4);
g.axe_property('LineWidth',1.5);
g.set_names('x','UMAP Embedings X','y','UMAP Embedings Y','color','Call Type');
%g.no_legend();
g.draw();
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','UMAP for Legend.pdf'),'ContentType','vector');

% ----------- Graphing UMAP Embeddings All----------
g=gramm('x',mT.embedX,'y',mT.embedY,'color',mT.Label);
f=figure('Position',[800 250 270 250]);
g.geom_point('alpha',.5);
g.set_text_options('font','Helvetica','base_size',14,'legend_scaling',.75,'legend_title_scaling',.50);
g.set_point_options('base_size',2);
g.axe_property('LineWidth',1.5,'XLim',[0 1],'YLim',[0 1]);
g.set_names('x','UMAP Embedings X','y','UMAP Embedings Y','color','Call Type');
g.no_legend();
g.draw();
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','UMAP All Calls.pdf'),'ContentType','vector');

% ----------- Graphing UMAP Embeddings All----------
g=gramm('x',mT.embedX,'y',mT.embedY,'color',mT.Affect);
f=figure('Position',[800 250 270 250]);
g.geom_point('alpha',.5);
g.set_text_options('font','Helvetica','base_size',14,'legend_scaling',.75,'legend_title_scaling',.50);
g.set_point_options('base_size',2);
g.axe_property('LineWidth',1.5,'XLim',[0 1],'YLim',[0 1]);
g.set_names('x','UMAP Embedings X','y','UMAP Embedings Y','color','Call Type');
g.no_legend();
g.draw();
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','UMAP All Calls Affect.pdf'),'ContentType','vector');

% ----------- Graphing UMAP Embeddings Training 1 ----------
g=gramm('x',mT.embedX,'y',mT.embedY,'color',mT.Label,'subset',mT.sessionType=='Training');
f=figure('Position',[800 250 270 250]);
g.geom_point('alpha',.5);
g.set_text_options('font','Helvetica','base_size',14,'legend_scaling',.75,'legend_title_scaling',.50);
g.set_point_options('base_size',2);
g.axe_property('LineWidth',1.5,'XLim',[0 1],'YLim',[0 1]);
g.set_names('x','UMAP Embedings X','y','UMAP Embedings Y','color','Call Type');
g.no_legend();
g.draw();
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','UMAP Training.pdf'),'ContentType','vector');

% ----------- Graphing UMAP Embeddings Extinction ----------
g=gramm('x',mT.embedX,'y',mT.embedY,'color',mT.Label,'subset',mT.sessionWeek==4);
f=figure('Position',[800 250 270 250]);
g.geom_point('alpha',.5);
g.set_text_options('font','Helvetica','base_size',14,'legend_scaling',.75,'legend_title_scaling',.50);
g.set_point_options('base_size',2);
g.axe_property('LineWidth',1.5,'XLim',[0 1],'YLim',[0 1]);
g.set_names('x','UMAP Embedings X','y','UMAP Embedings Y','color','Call Type');
g.no_legend();
g.draw();
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','UMAP Extinction.pdf'),'ContentType','vector');

% ----------- Graphing UMAP Embeddings Reinstatement ----------
g=gramm('x',mT.embedX,'y',mT.embedY,'color',mT.Label,'subset',mT.sessionWeek==5);
f=figure('Position',[800 250 270 250]);
g.geom_point('alpha',.5);
g.set_text_options('font','Helvetica','base_size',14,'legend_scaling',.75,'legend_title_scaling',.50);
g.set_point_options('base_size',2);
g.axe_property('LineWidth',1.5,'XLim',[0 1],'YLim',[0 1]);
g.set_names('x','UMAP Embedings X','y','UMAP Embedings Y','color','Call Type');
g.no_legend();
g.draw();
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','UMAP Reintstatement.pdf'),'ContentType','vector');


%% ----------- Graphing USVs Over Time ------------
g=gramm('x',mT.BeginTime_s_./60,'color',mT.Label,'subset',mT.sessionType=='Training');
f=figure('Position',[800 250 270 250]);
g.stat_density('npoints',1000,'kernel','epanechnikov');
g.set_text_options('font','Helvetica','base_size',14,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[-5 60],'YLim',[0 .3]);
g.set_names('x','Session Time (m)','y','USV Density (pdf)','color','Call Type');
g.no_legend();
g.draw();
set(g.facet_axes_handles,'XTick',[0 30 60],'YTick',[0 .1 .2 .3]);
ylabel(g.facet_axes_handles,'USV Density (pdf)','FontSize',14,'Interpreter','none');
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','Session Time USVs Training.pdf'),'ContentType','vector');

% ----------- Graphing USVs Over Time ------------
g=gramm('x',mT.BeginTime_s_./60,'color',mT.Label,'subset',mT.sessionType=='Extinction');
f=figure('Position',[800 250 270 250]);
g.stat_density('npoints',1000,'kernel','epanechnikov');
g.set_text_options('font','Helvetica','base_size',14,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[-5 60],'YLim',[0 .3]);
g.set_names('x','Session Time (m)','y','USV Density (pdf)','color','Call Type');
g.no_legend();
g.draw();
set(g.facet_axes_handles,'XTick',[0 30 60],'YTick',[0 .1 .2 .3]);
ylabel(g.facet_axes_handles,'USV Density (pdf)','FontSize',14,'Interpreter','none');
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','Session Time USVs Extinction.pdf'),'ContentType','vector');

% ----------- Graphing USVs Over Time ------------
g=gramm('x',mT.BeginTime_s_./60,'color',mT.Label,'subset',mT.sessionType=='Reinstatement');
f=figure('Position',[800 250 270 250]);
g.stat_density('npoints',1000,'kernel','epanechnikov');
g.set_text_options('font','Helvetica','base_size',14,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[-5 60],'YLim',[0 .3]);
g.set_names('x','Session Time (m)','y','USV Density (pdf)','color','Call Type');
g.no_legend();
g.draw();
set(g.facet_axes_handles,'XTick',[0 30 60],'YTick',[0 .1 .2 .3]);
ylabel(g.facet_axes_handles,'USV Density (pdf)','FontSize',14,'Interpreter','none');
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','Session Time USVs Reinstatment.pdf'),'ContentType','vector');

% ----------- Graphing USVs Over Time ------------
g=gramm('x',mT.BeginTime_s_./60,'color',mT.Affect,'subset',mT.sessionType=='Training');
f=figure('Position',[800 250 270 250]);
g.stat_density('npoints',1000,'kernel','epanechnikov');
g.set_text_options('font','Helvetica','base_size',14,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[-5 120],'YLim',[0 .15]);
g.set_names('x','Session Time (m)','y','USV Density (pdf)','color','Call Type');
g.no_legend();
g.draw();
set(g.facet_axes_handles,'XTick',[0 60 120],'YTick',[0 .15]);
ylabel(g.facet_axes_handles,'USV Density (pdf)','FontSize',14,'Interpreter','none');
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','Session Time USVs Training .pdf'),'ContentType','vector');

% ----------- Graphing USVs Over Time ------------
g=gramm('x',mT.BeginTime_s_./60,'color',mT.Affect,'subset',mT.sessionType=='Extinction');
f=figure('Position',[800 250 270 250]);
g.stat_density('npoints',1000,'kernel','epanechnikov');
g.set_text_options('font','Helvetica','base_size',14,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[-5 60],'YLim',[0 .25]);
g.set_names('x','Session Time (m)','y','USV Density (pdf)','color','Call Type');
g.no_legend();
g.draw();
set(g.facet_axes_handles,'XTick',[0 30 60],'YTick',[0 .1 .2]);
ylabel(g.facet_axes_handles,'USV Density (pdf)','FontSize',14,'Interpreter','none');
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','Session Time USVs Extinction.pdf'),'ContentType','vector');

% ----------- Graphing USVs Over Time ------------
g=gramm('x',mT.BeginTime_s_./60,'color',mT.Affect,'subset',mT.sessionType=='Reinstatement');
f=figure('Position',[800 250 270 250]);
g.stat_density('npoints',1000,'kernel','epanechnikov');
g.set_text_options('font','Helvetica','base_size',14,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'XLim',[-5 60],'YLim',[0 .25]);
g.set_names('x','Session Time (m)','y','USV Density (pdf)','color','Call Type');
g.no_legend();
g.draw();
set(g.facet_axes_handles,'XTick',[0 30 60],'YTick',[0 .1 .2]);
ylabel(g.facet_axes_handles,'USV Density (pdf)','FontSize',14,'Interpreter','none');
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','Session Time USVs Reinstatment.pdf'),'ContentType','vector');

% ---------- USV Timing Stats ----------------
t4 = grpstats(mT,["ID","Affect",'sessionType'],["mean"], ...
    "DataVars","BeginTime_s_", ...
    "VarNames",["ID","Affect","sessionType","Group Count", ...
    "meanCallTime"])

g=gramm('x',t4.sessionType,'Y',t4.meanCallTime./60,'color',t4.Affect);
f=figure('Position',[800 250 570 550]);
%g(1,1).stat_violin('normalization','width','half',1,'fill','transparent','dodge',.65,'extra_y',1)
%g(1,1).geom_jitter('width',.1,'dodge',.65,'alpha',.5);
g(1,1).stat_summary('geom',{'black_errorbar'},'type','sem','dodge',-.65);
g.set_text_options('font','Helvetica','base_size',14,'legend_scaling',.75,'legend_title_scaling',.75);
g.axe_property('LineWidth',1.5,'YLim',[0 60]);
g.set_names('x','Session Type','y','Call Time','color','Call Type');
g.set_order_options('x',{'Training' 'Extinction' 'Reinstatement'});
g.no_legend();
g.draw();
exportgraphics(f,fullfile('Combined Oral Fentanyl Output/USVs','Session Time USVs Stats Animals Collapse.pdf'),'ContentType','vector');


USV_LME = fitlme(mT,'BeginTime_s_ ~ sessionType*Affect + (1|ID)');
USV_F = anova(USV_LME,'DFMethod','satterthwaite');

[USV_p,USV_Anova,USV_stats]= anovan(t4.meanCallTime,{t4.sessionType t4.Affect},'model','interaction','varnames',{'Session','Affect'})
[mult_results,~,~,mult_gnames] = multcompare(USV_stats,"Dimension",[1 2]);
save('Statistics/USV Stats.m','USV_Anova','mult_results','mult_gnames');

close all;
%------------- END OF CODE --------------

