function [pethT] = makeSAPETHS(filtS,filtC,dFFtime,eventCode,eventTime,Sess,Key,i,fFold,ylimi)
    
    pethLength=10;
    pethT=table;
    % Rewarded Lever Press
    try
    [f1 pethDFF]=epochPETH2(filtS,filtC,dFFtime,eventTime(eventCode==17),pethLength,ylimi);
    xlabel('Cued/Rewarded Lever Press (s)');
    exportgraphics(f1,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Cued-Rewarded Lever Press.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'CuedLeverPress'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event)];
    end
    end

    % Unrewarded Lever Press
    try
    [f2 pethDFF]=epochPETH2(filtS,filtC,dFFtime,eventTime(eventCode==97),pethLength,ylimi);
    xlabel('Uncued Lever Press (s)');
    exportgraphics(f2,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Uncued-unrewarded Lever Press.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'UncuedLeverPress'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event)];
    end
    end

    % Inactive Press
    try
    [f3 pethDFF]=epochPETH2(filtS,filtC,dFFtime,eventTime(eventCode==23),pethLength,ylimi);
    xlabel('Inactive Lever Press (s)');
    exportgraphics(f3,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Inactive Lever Press.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'InactiveLeverPress'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event)];
    end
    end

    % Rewarded Head Entry
    try
    [f4 pethDFF]=epochPETH2(filtS,filtC,dFFtime,eventTime(eventCode==98),pethLength,ylimi);
    xlabel('Rewarded Head Entries (s)');
    exportgraphics(f4,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Rewarded Head Entries Press.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'RewardedHE'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event)];
    end
    end

    % Unrewarded Rewarded Head Entry
    try
    [f5 pethDFF]=epochPETH2(filtS,filtC,dFFtime,eventTime(eventCode==99),pethLength,ylimi);
    xlabel('Unrewarded Head Entries (s)');
    exportgraphics(f5,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Unrewarded Head Entries Press.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'UnrewardedHE'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event)];
    end
    end

end