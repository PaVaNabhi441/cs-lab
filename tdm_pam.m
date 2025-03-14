%% TDM PAM Simulation with Updated Mode 3 (Channel 1 = Pure DC)
clear; clc; close all;

%% 1. Simulation Parameters
fs = 1e4;             % Base sampling frequency for each message channel [Hz]
T = 0.1;              % Total time [sec] (shorter time for quick plotting)
t = 0:1/fs:T-1/fs;    % Time vector for individual channels

% Generate four message channels (example: sine waves at different frequencies)
% For mode 3, channel 1 will be replaced with pure DC.
msg1_orig = sin(2*pi*1*t);  % Original waveform for channel 1 (for modes 1 & 2)
msg2 = sin(2*pi*2*t);       % Channel 2
msg3 = sin(2*pi*3*t);       % Channel 3
msg4 = sin(2*pi*4*t);       % Channel 4

% Choose TDM mode: 1, 2, or 3
mode = 3;  % Change this value to 1, 2, or 3 to simulate different modes

% Frame parameters: one sample per channel per frame
samplesPerFrame = 4;
N = length(t);   % Number of samples in each channel

%% 2. Generate Additional Signals Based on Mode
switch mode
    case 1
        % Mode 1: Transmit separate clock and sync with messages.
        clkFreq = 100;          % Clock frequency [Hz]
        clk = square(2*pi*clkFreq*t);  % Square wave clock
        
        % Generate a sync pulse: one high sample per frame
        sync = zeros(size(t));
        for i = 1:samplesPerFrame:length(t)
            sync(i) = 1;
        end
        
        % Use original channel data for msg1
        msg1 = msg1_orig;
        
    case 2
        % Mode 2: Transmit only sync and messages.
        % Generate sync: one pulse per frame.
        sync = zeros(size(t));
        for i = 1:samplesPerFrame:length(t)
            sync(i) = 1;
        end
        
        % Use original channel data for msg1
        msg1 = msg1_orig;
        
    case 3
        % Mode 3: Only message signals are sent.
        % Set channel 1 to be a pure DC signal to act as the sync marker.
        DC_value = 2;  % Choose a DC level high enough to distinguish from other channels
        msg1 = ones(size(t)) * DC_value;
        % No separate clk or sync signals in this mode.
end

%% 3. Multiplex the Signals into One TDM Stream
% The TDM stream is formed by sequentially placing one sample from each channel.
tdmStream = zeros(1, N * samplesPerFrame);
for i = 1:N
    idx = (i-1)*samplesPerFrame + 1;
    tdmStream(idx:idx+samplesPerFrame-1) = [msg1(i), msg2(i), msg3(i), msg4(i)];
end
% The effective sampling rate for the TDM stream is 4*fs.
tdm_time = (0:length(tdmStream)-1) / (4*fs);

%% 4. Assemble the Transmitted Signal Structure
switch mode
    case 1
        txSignal.sync = sync;
        txSignal.clk  = clk;
        txSignal.msg  = tdmStream;
    case 2
        txSignal.sync = sync;
        txSignal.msg  = tdmStream;
    case 3
        txSignal.msg  = tdmStream;
end

%% 5. Receiver: Demultiplexing Process
% Assume perfect synchronization (using the sync marker or, in mode 3, the DC level).
numFrames = length(tdmStream) / samplesPerFrame;
ch1 = zeros(1, numFrames);
ch2 = zeros(1, numFrames);
ch3 = zeros(1, numFrames);
ch4 = zeros(1, numFrames);

for frame = 1:numFrames
    idx_start = (frame-1)*samplesPerFrame + 1;
    ch1(frame) = tdmStream(idx_start);
    ch2(frame) = tdmStream(idx_start+1);
    ch3(frame) = tdmStream(idx_start+2);
    ch4(frame) = tdmStream(idx_start+3);
end

%% 6. Low-Pass Filtering (LPF) for Smoothing
% Design a low-pass FIR filter using the Kaiser window method.
lpf = designfilt('lowpassfir', 'PassbandFrequency', 0.2, ...
                 'StopbandFrequency', 0.3, 'PassbandRipple', 1, ...
                 'StopbandAttenuation', 60, 'DesignMethod', 'kaiserwin');
             
% Apply the filter to each recovered channel
ch1_smooth = filter(lpf, ch1);
ch2_smooth = filter(lpf, ch2);
ch3_smooth = filter(lpf, ch3);
ch4_smooth = filter(lpf, ch4);

%% 7. Plotting the Signals

% Plot the TDM signal along with clk and sync (if applicable)
figure;
if mode == 1
    % Mode 1: Plot TDM, clock, and sync signals.
    subplot(3,1,1);
    plot(tdm_time, tdmStream, 'b'); 
    title('TDM Signal');
    xlabel('Time (sec)'); ylabel('Amplitude');
    
    subplot(3,1,2);
    plot(t, clk, 'r');
    title('Clock Signal');
    xlabel('Time (sec)'); ylabel('Amplitude');
    
    subplot(3,1,3);
    plot(t, sync, 'm');
    title('Sync Signal');
    xlabel('Time (sec)'); ylabel('Amplitude');
    
elseif mode == 2
    % Mode 2: Plot TDM and sync signals.
    subplot(2,1,1);
    plot(t, sync, 'm');
    title('Sync Signal');
    xlabel('Time (sec)'); ylabel('Amplitude');
    
    subplot(2,1,2);
    plot(tdm_time, tdmStream, 'b');
    title('TDM Signal');
    xlabel('Time (sec)'); ylabel('Amplitude');
    
elseif mode == 3
    % Mode 3: Only the TDM signal is available.
    plot(tdm_time, tdmStream, 'b');
    title('TDM Signal (Mode 3: Pure DC in Channel 1)');
    xlabel('Time (sec)'); ylabel('Amplitude');
end

% Plot the recovered and smoothed message channels
figure;
subplot(4,1,1);
plot(ch1_smooth, 'LineWidth',1.5);
title('Recovered Channel 1 (Smoothed - Pure DC in Mode 3)');
xlabel('Frame Number'); ylabel('Amplitude');

subplot(4,1,2);
plot(ch2_smooth, 'LineWidth',1.5);
title('Recovered Channel 2 (Smoothed)');
xlabel('Frame Number'); ylabel('Amplitude');

subplot(4,1,3);
plot(ch3_smooth, 'LineWidth',1.5);
title('Recovered Channel 3 (Smoothed)');
xlabel('Frame Number'); ylabel('Amplitude');

subplot(4,1,4);
plot(ch4_smooth, 'LineWidth',1.5);
title('Recovered Channel 4 (Smoothed)');
xlabel('Frame Number'); ylabel('Amplitude');
