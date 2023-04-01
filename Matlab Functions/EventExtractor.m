function [eventCode,eventTime] = EventExtractor(raw)
%EventExtractor: Dirty function to pull behavioral events from Oral SA
%Behavior Files
    e_idx=find(strcmp(raw.VarName1, 'E:'), 1);
    t_idx=find(strcmp(raw.VarName1, 'T:'), 1);
    e=raw{e_idx+1:t_idx-1,3:7};
    t=raw{t_idx+1:end,3:7};
    e=reshape(e',[],1);
    t=reshape(t',[],1);
    eventCode=e(~isnan(e));
    eventTime=t(~isnan(t));
end