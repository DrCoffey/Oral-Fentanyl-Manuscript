function [signalTime,signalDFF,filtSig,filtCont] = computeDFF3(signalStream,controlStream,varargin)
%COMPUTEDFF Smooth and process signal and control channel photometry

%Inputs:
% signalStream - Tucker Davis data stream structure containing GCamp Channel
% controlStream - Tucker Davis data stream structure containing isosbestic control channel
% 3 - Start time in seconds
% 4 - End time in seconds

%Outputs:
% signalTime - Array containing time indicies for signalDFF (seconds)
% signalDFF - Change in fluorecence normalized to control stream (%)

%create time vectors for each data stream by dividing by the sampling frequency
time_Sig = (1:length(signalStream.data))/signalStream.fs; 
time_Cont = (1:length(controlStream.data))/controlStream.fs; 

if length(varargin)==1
    t = varargin{1}; % time threshold before which we will discard
    ind = find(time_Sig>t,1); % find first index of when time crosses threshold
    time_Sig = time_Sig(ind:end); % reformat vector to only include allowed time
    time_Cont = time_Cont(ind:end); % reformat vector to only include allowed time
    signalStream.data = signalStream.data(ind:end);
    controlStream.data = controlStream.data(ind:end);
elseif length(varargin)==2
    t = varargin{1}; % time threshold before which we will discard
    t2 = varargin{2}; % time threshold after which we will discard
    ind = find(time_Sig>t,1); % find first index of when time crosses threshold
    ind2 = find(time_Sig<t2,1,'last'); % find first index of when time crosses threshold
    time_Sig = time_Sig(ind:ind2); % reformat vector to only include allowed time
    time_Cont = time_Cont(ind:ind2); % reformat vector to only include allowed time
    signalStream.data = signalStream.data(ind:ind2);
    controlStream.data = controlStream.data(ind:ind2);
end

% Smooth signal slightly
SmoothSig=fastsmooth(signalStream.data,250000,1,1);
SmoothCont=fastsmooth(controlStream.data,250000,1,1);

filtSig=signalStream.data-SmoothSig;
filtCont=controlStream.data-SmoothCont;

% Fit control stream to signal stream 
bls=polyfit(controlStream.data,signalStream.data,1);
Y_Fit=bls(1).*controlStream.data+bls(2);

% Subtract fit control signal from a
signalDFF = ((signalStream.data-Y_Fit)./Y_Fit)*100;
signalTime = time_Sig;

% plot(filtSig)
% hold on
% plot(filtCont)
% plot(signalDFF);

end

