clc; clear; close all;

% Set parameters
fs = 1000; % Sampling rate in Hz
t = 0:1/fs:1; % Time vector spanning 1 second
analogSignal = (sin(2 * pi * 2 * t) + 1) / 2; % Generate a 2 Hz sine wave, scaled to [0,1]

samplesPerPulse = 100; % Define number of samples per pulse
ppmWidthFraction = 0.1; % Fraction of samplesPerPulse used for pulse width

% Perform PPM modulation
[ppmSignal, ppmPulseTrain] = ppmModulate(analogSignal, samplesPerPulse, ppmWidthFraction);

% Perform PPM demodulation
demodulatedSignal = ppmDemodulate(ppmSignal, samplesPerPulse);

% Display the demodulated signal values
disp('Demodulated Signal:');
disp(demodulatedSignal);

% Plot results
figure;

% Plot original analog signal
subplot(3, 1, 1);
plot(t, analogSignal, 'b');
title('Original 2 Hz Sine Wave');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot modulated PPM signal
subplot(3, 1, 2);
stem(ppmSignal(1:1000), 'filled');
title('Pulse Position Modulated (PPM) Signal');
xlabel('Sample Index');
ylabel('Amplitude');

% Plot demodulated signal
subplot(3, 1, 3);
samples = 1:1000;
plot(samples / 1000, demodulatedSignal(1:1000), 'r');
title('Recovered Demodulated Signal');
xlabel('Sample Index (x10^3)');
ylabel('Normalized Pulse Position');

% Function for PPM Modulation
function [ppmSignal, ppmPulseTrain] = ppmModulate(analogSignal, samplesPerPulse, ppmWidthFraction)
    pulseWidth = round(ppmWidthFraction * samplesPerPulse); % Compute pulse width
    ppmSignal = zeros(1, length(analogSignal) * samplesPerPulse); % Initialize PPM signal
    ppmPulseTrain = zeros(1, length(analogSignal) * samplesPerPulse); % Initialize pulse train

    for i = 1:length(analogSignal)
        % Calculate the pulse's starting position within the symbol period
        pulsePosition = round(analogSignal(i) * (samplesPerPulse - pulseWidth));

        % Determine the start and end indices of the pulse
        startIndex = (i - 1) * samplesPerPulse + pulsePosition + 1;
        endIndex = min(startIndex + pulseWidth - 1, i * samplesPerPulse);

        % Assign pulse in the PPM signal and pulse train
        ppmSignal(startIndex:endIndex) = 1;
        ppmPulseTrain(startIndex:endIndex) = 1;
    end
end

% Function for PPM Demodulation
function demodulatedSignal = ppmDemodulate(ppmSignal, samplesPerPulse)
    numSymbols = length(ppmSignal) / samplesPerPulse; % Determine number of symbols
    demodulatedSignal = zeros(1, numSymbols); % Initialize demodulated signal

    for i = 1:numSymbols
        startIndex = (i - 1) * samplesPerPulse + 1;
        endIndex = i * samplesPerPulse;
        segment = ppmSignal(startIndex:endIndex);
        
        % Locate the first occurrence of the pulse
        pulsePosition = find(segment == 1, 1);
        
        if ~isempty(pulsePosition)
            % Normalize the pulse position to a range of [0,1]
            demodulatedSignal(i) = (pulsePosition - 1) / samplesPerPulse;
        else
            demodulatedSignal(i) = 0; % Assign zero if no pulse is detected
        end
    end
end

