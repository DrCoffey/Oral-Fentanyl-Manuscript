%% LHb Photometry Pilot - Quick & Dirty
data = TDTbin2mat('\\128.95.12.244\kcoffey\Neumaier Lab\Fentanyl SA - LHb Photometry\LHb Photometry Pilot\Data\S05-200824-153501');
%% Import, normalize, trim, and synchronize CFC recording,




[dFFtime dFF]=computeDFF(data.streams.A465,data.streams.A405,3,903);















%% PETH Generation
shockOn=find(data.epocs.Ep1_.data==1);
shockOn=shockOn(1:10:length(shockOn),1);
shockOn=data.epocs.Ep1_.onset(shockOn);

for i=1:length(shockOn)
    if i==1    
    time=(-9.999:.001:10)';
    deltaFF=dFF(find(time_470>shockOn(i),1,'first')-9999:find(time_470>shockOn(i),1,'first')+10000);
    shockNum=repmat(i,[20000 1]);
    else
    time=[time;(-9.999:.001:10)'];
    deltaFF=[deltaFF; dFF(find(time_470>shockOn(i),1,'first')-9999:find(time_470>shockOn(i),1,'first')+10000)];
    shockNum=[shockNum; repmat(i,[20000 1])];
    end
end
% PETH Setup
pethTable=table(time,deltaFF,shockNum);
U = unstack(pethTable,'deltaFF','shockNum');

%% Figure Stuff
f1=figure('Color','w','Position',[100 100 400 600]);
sp1=subplot(2,1,1);
% Heatmap
s = pcolor(U.time,unique(pethTable.shockNum),(U{:,2:end})');
s.EdgeColor='none'
%s.FaceColor = 'interp';
colormap('plasma');
ylabel('Shock Number');
set(gca,'xticklabel',{[]})
set(gca,'fontsize', 14)

cRGB=plasma(10);
sp2=subplot(2,1,2);
options.color_area=cRGB(3,:);
options.color_line=cRGB(8,:);
options.alpha=0;
options.line_width=2;
options.error='sem';
options.x_axis=U.time(1:10:end);
options.handle=f1;
plot_areaerrorbar((U{1:10:end,2:end})',options)
ylabel('\DeltaF/F');
xlabel('Time From Shock Onset (s)');
% eb=shadedErrorBar(U.time(1:10:end),(U{1:10:end,2:end})',{@mean,@std});
% eb.mainLine.Color=cRGB(9,:);
% eb.mainLine.LineWidth=2.5;
% eb.mainLine.Clipping='off';
% eb.patch.FaceColor=cRGB(4,:);
% eb.patch.FaceAlpha=.75;
% eb.patch.EdgeAlpha=0;
% eb.edge(1).LineStyle='none'
% eb.edge(2).LineStyle='none'
set(gca,'fontsize', 14)
hold on
yl = ylim;
p=patch([0 1 1 0],[yl(1) yl(1) yl(2) yl(2)],'k');
p.EdgeColor='none';
p.FaceAlpha=.35;
options.alpha=.75;
plot_areaerrorbar((U{1:10:end,2:end})',options)
%set(gca,'children',flipud(get(gca,'children')))
export_fig('S03.png','-m3')

% % Plotting PETH with GRAMM
% g=gramm('x',pethTable.time,'y',pethTable.deltaFF);
% g.axe_property('tickdir','out','LineWidth',1.5,'FontSize',12);
% g.stat_summary('geom','area','type','sem');
% g.set_names('x','Peri-Shock Time (s)','y','Delta F/F');
% g.set_color_options('map','lch','hue_range',[0 350]);
% % g.axe_property('YLim',[-0.02 0.02],'XLim',[-10 10]);
% g.draw();
% g.export('file_name','S06_LHb-DRN','file_type','png')

% % 3D Line Graph
% Y1 = reshape(pethTable.shockNum(:), sum(pethTable.shockNum(:)==1), []);
% X1 = reshape(pethTable.time(:), sum(pethTable.shockNum(:)==1), []);
% Z1 = reshape(smooth(pethTable.deltaFF(:)), sum(pethTable.shockNum(:)==1), []);
% figure('Color','w');
% p=plot3(X1,Y1,Z1,'LineWidth',2);
% %s=mesh(U.time,unique(pethTable.shockNum),(U{:,2:end})',(U{:,2:end})','FaceAlpha',0.5);
% colormap('plasma');