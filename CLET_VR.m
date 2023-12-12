clear; close all; clc;
%% CLET code for LED screen
% By Piyush
% Last Updated: 18th Aug' 2022

%% VR data
% User Inputs
DirPath = '25Feb2021_VR_All_All_LELENSON';
FileName = '25Feb2021_VR_WC_1_LELENSON.eeg';
nstim = 2; % Number of stimuli types
Lisi = 1; % Lower bound of interstimuli period (in s)
ThD1 = 180000; % Threshold1 for positive electrode
ThD2 = 8000; % Threshold2 

%% Load data
cd(DirPath); % Change current path
FileLoc = strcat(DirPath, '/', FileName); % File location
EEG = pop_fileio(FileLoc); % Load all information in a structure using an eeglab function 
DataAll = EEG.data; % Data across all channels
DataPhoto = DataAll(68, :); % Photodiode data

% Time vector
fs = EEG.srate; % Sampling frequency in Samples/seconds
L = length(DataPhoto); % Length of signal
T = 1/fs; % Sample time
Tt = L * T; % Total time 
t = (linspace(0, Tt, L))'; % Time vector

%% STIMLULI S1 & S2
stim_name = cell(1, nstim); % Name of stimuli
for n = 1 : nstim
    stim_name{n} = horzcat('S','  ',num2str(n)); %  
end

onsetsam = [EEG.event(:).latency]'; % Onset sample for all the events

nevents = length(onsetsam); % Total number of events
events = cell(nevents,1);
for n = 1 : nevents
    events{n} = [EEG.event(n).type];
end

indxS1 = strfind(events, stim_name{1});
indxS1 = find(not(cellfun('isempty', indxS1)));
nindxS1 = length(indxS1);

indxS2 = strfind(events, stim_name{2});
indxS2 = find(not(cellfun('isempty', indxS2)));
nindxS2 = length(indxS2);

onsetsam_S1 = onsetsam(indxS1);
tsec_S1 = t(onsetsam_S1);

onsetsam_S2 = onsetsam(indxS2);
tsec_S2 = t(onsetsam_S2);

% Plot S1 & S2 markers
amp_S1 = DataPhoto(onsetsam_S1);
amp_S2 = DataPhoto(onsetsam_S2);
plot(t, DataPhoto, 'k'); 
hold on, plot(tsec_S1,amp_S1, 'ro', 'linewidth', 2, 'MarkerSize', 5); 
plot(tsec_S2,amp_S2, 'go', 'linewidth', 2, 'MarkerSize', 5);

%% PHOTODIODE D1 & D2
% D1
indxGap = fs*Lisi; 

PosPhoto = double(DataPhoto >= ThD1); % Positions in DataPhoto >= ThD1
PosDiff = [0 double(diff(PosPhoto) == 1)]; % 
indxD1 = (find(PosDiff == 1))';
onsetsam_D1 = zeros(nindxS1,1);
onsetsam_D1(1) = indxD1(1);
for n = 2 : length(indxD1)-1
    if indxD1(n) > (indxD1(n-1) + indxGap)
        onsetsam_D1(n) = indxD1(n);
    end            
end
onsetsam_D1 = onsetsam_D1(onsetsam_D1 ~= 0);
tsec_D1 = t(onsetsam_D1); % Time (in seconds) of D1 event

% D2
[y_pks, x_pks] = findpeaks(DataPhoto);
y_pks = double(y_pks);
xVals = double(ismember(DataPhoto, y_pks));
% xVals = double(DataPhoto .* xVals);
% yVals = zeros(1, L);
% for n = 1 : L-indxGap
%     if (xVals(n) < ThD2) && (xVals(n+1) < ThD2)
% 
%         if (xVals(n) < ThD2) && (xVals(n+2) < ThD2)
%             if (xVals(n) < ThD2) && (xVals(n+3) < ThD2)
%                 if (xVals(n) < ThD2) && (xVals(n+4) < ThD2)
%                     if (xVals(n) < ThD2) && (xVals(n+5) < ThD2)
%                         if (xVals(n) < ThD2) && (xVals(n+6) < ThD2)
%                             if (xVals(n) < ThD2) && (xVals(n+7) < ThD2)
%                                 if (xVals(n) < ThD2) && (xVals(n+8) < ThD2)
%                                     if (xVals(n) < ThD2) && (xVals(n+9) < ThD2)
%                                         if (xVals(n) < ThD2) && (xVals(n+10) < ThD2)
%                                             yVals(n) = DataPhoto(n);
%                                         end
%                                     end
%                                 end
%                             end
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end
yVals(yVals ~= 0) = 1;
NegDiff = [0 double(diff(yVals))];
indxD2 = (find(NegDiff == 1))';
onsetsam_D2 = zeros(nindxS2,1);
onsetsam_D2(1) = indxD2(1);
for n = 2 : length(indxD2)-1
    if indxD2(n) > (indxD2(n-1) + indxGap)
        onsetsam_D2(n) = indxD2(n);
    end            
end
onsetsam_D2 = onsetsam_D2(onsetsam_D2 ~= 0);
onsetsam_D2 = onsetsam_D2(1:length(onsetsam_S2));
tsec_D2 = t(onsetsam_D2); % Time (in seconds) of D1 event

% Plot D1 & D2 markers
amp_D1 = DataPhoto(onsetsam_D1);
amp_D2 = DataPhoto(onsetsam_D2);
plot(tsec_D1, amp_D1, 'r*', 'linewidth', 2, 'MarkerSize', 5); 
plot(tsec_D2, amp_D2, 'g*', 'linewidth', 2, 'MarkerSize', 5);
xlabel('Time (in sec.)', 'FontSize', 20); ylabel('Amplitude (in units)', 'FontSize', 20);
title('Photodiode signal with markers of stimuli & diode in VR', 'fontweight', 'bold', 'FontSize', 24);
legend({'Photodiode signal', 'Trigger Sent S1', 'Trigger Sent S2', 'Trigger Detected D1', 'Trigger Detected D2'}, 'FontSize', 20, 'Orientation','horizontal');

%% Find latencies and create two tables
LatD1S1 = tsec_D1 - tsec_S1;
aveLatD1S1 = mean(LatD1S1);
stdLatD1S1 = std(LatD1S1);
decpla = '%.3f';
S1D1col1 = [cellstr(num2str(tsec_S1, decpla)); 'Not Applicable'];
S1D1col2 = [cellstr(num2str(tsec_D1, decpla)); 'Not Applicable'];
S1D1col3 = [cellstr(num2str(LatD1S1, decpla)); cellstr(strcat(num2str(aveLatD1S1, decpla), char(177), num2str(stdLatD1S1*100, decpla)))];
varNames = {'Onset Time for Trigger S1 (in s)', 'Onset Time for Diode D1 (in s)', 'Latency between D1 and S1 (in s)'};
T = table(S1D1col1, S1D1col2, S1D1col3, 'VariableNames', varNames);
writetable(T,'VRTableS1D1.xls','Sheet',1);

LatD2S2 = tsec_D2 - tsec_S2;
aveLatD2S2 = mean(LatD2S2);
stdLatD2S2 = std(LatD2S2);
S2D2col1 = [cellstr(num2str(tsec_S2, decpla)); 'Not Applicable'];
S2D2col2 = [cellstr(num2str(tsec_D2, decpla)); 'Not Applicable'];
S2D2col3 = [cellstr(num2str(LatD2S2, decpla)); cellstr(strcat(num2str(aveLatD2S2, decpla), char(177), num2str(stdLatD2S2*100, decpla)))];
varNames = {'Onset Time for Trigger S2 (in s)', 'Onset Time for Diode D2 (in s)', 'Latency between D2 and S2 (in s)'};
T2 = table(S2D2col1, S2D2col2, S2D2col3, 'VariableNames', varNames);
writetable(T2,'VRTableS2D2.xls','Sheet',1);
