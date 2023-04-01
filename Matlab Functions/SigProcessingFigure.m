%% R14 Naloxone

fig1=figure('Color','w','Position',[10 10 620 200]);
subplot(1,3,1);
plot(signalStream.data,'LineWidth',1.5);
hold on
plot(controlStream.data,'LineWidth',1.5,'Color',[.5 0 .5]);
box off
set(gca,'LineWidth',1,'FontSize',12,'YLim',[0 300],'XLim',[1650000 1750000],'TickDir','out');
ylabel('Raw Signal (mV)')
xlabel('Time (s)')
xticks([1650000 1750000]);
xticklabels({'0' '100'});
H=gca;
H.LineWidth=1.5; %change to the desired value     

subplot(1,3,2);
plot(signalStream.data,'LineWidth',1.5);
hold on
plot(controlStream.data+(f-f2),'LineWidth',1.5,'Color',[.5 0 .5]);
box off
set(gca,'LineWidth',1,'FontSize',12,'YLim',[0 300],'XLim',[1650000 1750000],'TickDir','out');
ylabel('Scaled Signal (mV)')
xlabel('Time (s)')
xticks([1650000 1750000]);
xticklabels({'0' '100'});
H=gca;
H.LineWidth=1.5; %change to the desired value     

subplot(1,3,3);
plot(signalDFF,'LineWidth',1.5);
hold on
plot(zeros(height(f),1),'--k');
box off
set(gca,'LineWidth',1,'FontSize',12,'YLim',[-10 30],'XLim',[1650000 1750000],'TickDir','out');
ylabel('Processed (% \Delta FF)')
xlabel('Time (s)')
xticks([1650000 1750000]);
xticklabels({'0' '100'});
yticks([-10 0 10 20 30]);
H=gca;
H.LineWidth=1.5; %change to the desired value     

exportgraphics(fig1,'SigProcess.pdf','ContentType','vector')