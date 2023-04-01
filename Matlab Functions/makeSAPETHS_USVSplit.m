function [pethT] = makeSAPETHS_USVSplit(filtS,filtC,dFFtime,eventCode,eventTime,Sess,Key,i,fFold,ylimi)
    
    pethLength=10;
    pethT=table;
    
    rlp=eventTime(eventCode==3);
    cue=eventTime(eventCode==13);
    rhe=eventTime(eventCode==98);
    uhe=eventTime(eventCode==99);

    if isempty(rlp)
       rlp=eventTime(eventCode==97);
       cue=eventTime(eventCode==97);
    end

%     [DL DLTime]=pharmacokineticsOralFent('infusions',[cue*1000 (cue+6.89)*1000],'duration',180,'type',4,'weight',325,'mg_mL',0.07,'mL_S',.006);
%     DL=DL';
%     DLTime=(.1:.1:180)';
%     DL=imresize(DL, [length(DLTime),1]);
%     [pks,locs] = findpeaks(DL);
    B=1:1:height(cue);
    if height(cue)>2
    idxcue=knee_pt(cue,B);
    else
    idxcue=height(cue);   
    end

    C=1:1:height(rhe);
    if height(rhe)>2
    idxrhe=knee_pt(rhe,C);
    else
    idxrhe=height(rhe);   
    end 

    rlpEarly=rlp(rlp<=cue(idxcue));
    rlpLate=rlp(rlp>cue(idxcue));

    cueEarly=cue(cue<=cue(idxcue));
    cueLate=cue(cue>cue(idxcue));

    rheEarly=rhe(rhe<=cue(idxcue));
    rheLate=rhe(rhe>cue(idxcue));

    uheEarly=uhe(uhe<=cue(idxcue));
    uheLate=uhe(uhe>cue(idxcue));

    while height(rlpLate)<4 & height(rlpEarly)>4
          rlpLate(end+1)=rlpEarly(end);
          rlpEarly=rlpEarly(1:end-1);
    end
    
    while height(cueLate)<4 & height(cueEarly)>4
          cueLate(end+1)=cueEarly(end);
          cueEarly=cueEarly(1:end-1);
    end

    while height(rheLate)<4 & height(rheEarly)>4
          rheLate(end+1)=rheEarly(end);
          rheEarly=rheEarly(1:end-1);
    end

    while height(uheLate)<4 & height(uheEarly)>4
          uheLate(end+1)=uheEarly(end);
          uheEarly=uheEarly(1:end-1);
    end

    disp(['Early Cues: ' num2str(height(cueEarly))]);
    disp(['Late Cues: ' num2str(height(cueLate))]);

    % Rewarded Lever Press
    try
    [f1 pethDFF]=epochPETH2(filtS,filtC,dFFtime,rlpEarly,pethLength,ylimi);
    xlabel('RP E (s)');
    exportgraphics(f1,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Rewarded Press Early.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'RewardedPress'}),[length(interpTime),1]);
    Group=repmat(categorical({'Early'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event,Group)];
    end
    end
    
    try
    [f1 pethDFF]=epochPETH2(filtS,filtC,dFFtime,rlpLate,pethLength,ylimi);
    xlabel('RP L (s)');
    exportgraphics(f1,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Rewarded Press Late.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'RewardedPress'}),[length(interpTime),1]);
    Group=repmat(categorical({'Late'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event,Group)];
    end
    end

     % Cue
    try
    [f1 pethDFF]=epochPETH2(filtS,filtC,dFFtime,cueEarly,pethLength,ylimi);
    xlabel('Cue E (s)');
    exportgraphics(f1,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Cue Early.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'Cue'}),[length(interpTime),1]);
    Group=repmat(categorical({'Early'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event,Group)];
    end
    end
    
    try
    [f1 pethDFF]=epochPETH2(filtS,filtC,dFFtime,cueLate,pethLength,ylimi);
    xlabel('Cue L (s)');
    exportgraphics(f1,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Cue Late.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'Cue'}),[length(interpTime),1]);
    Group=repmat(categorical({'Late'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event,Group)];
    end
    end

    % Rewarded Head Entry
    try
    [f4 pethDFF]=epochPETH2(filtS,filtC,dFFtime,rheEarly,pethLength,ylimi);
    xlabel('Rewarded Head Entries E (s)');
    exportgraphics(f4,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Rewarded Head Entries Early.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'RewardedHE'}),[length(interpTime),1]);
    Group=repmat(categorical({'Early'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event,Group)];
    end
    end

    try
    [f4 pethDFF]=epochPETH2(filtS,filtC,dFFtime,rheLate,pethLength,ylimi);
    xlabel('Rewarded Head Entries L (s)');
    exportgraphics(f4,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Rewarded Head Entries Late.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'RewardedHE'}),[length(interpTime),1]);
    Group=repmat(categorical({'Late'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event,Group)];
    end
    end

    % Unrewarded Rewarded Head Entry
    try
    [f5 pethDFF]=epochPETH2(filtS,filtC,dFFtime,uheEarly,pethLength,ylimi);
    xlabel('Unrewarded Head Entries (s) E');
    exportgraphics(f5,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Unrewarded Head Entries Early.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'UnrewardedHE'}),[length(interpTime),1]);
    Group=repmat(categorical({'Early'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event,Group)];
    end
    end

    % Unrewarded Rewarded Head Entry
    try
    [f5 pethDFF]=epochPETH2(filtS,filtC,dFFtime,uheLate,pethLength,ylimi);
    xlabel('Unrewarded Head Entries (s) L');
    exportgraphics(f5,fullfile(fFold,strcat(string(Key.ID(i)),'-',Sess,'-Unrewarded Head Entries Late.png')),'Resolution',300);
    mPETH=mean(pethDFF{:,2:end}')';
    Time=(-pethLength+.001:.001:pethLength)';
    interpTime=(-pethLength+.1:.1:pethLength)';
    smallPETH=imresize(mPETH, [length(interpTime),1]);
    ID=repmat(Key.ID(i),[length(interpTime),1]);
    Session=repmat(categorical({Sess}),[length(interpTime),1]);
    Event=repmat(categorical({'UnrewardedHE'}),[length(interpTime),1]);
    Group=repmat(categorical({'Late'}),[length(interpTime),1]);
    if height(pethDFF)>3
    pethT=[pethT; table(ID,interpTime,smallPETH,Session,Event,Group)];
    end
    end

end