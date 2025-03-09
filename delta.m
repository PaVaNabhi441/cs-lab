clc;
clear;
close all;

%% Transmitter: Differential Delta Modulation
% Define time vector and message signal
t = 0:2*pi/100:2*pi;            % Time vector over one period
x = 5 * sin(2*pi*t/5);          % Message signal (5V peak, 5Hz frequency)

% Parameters
del = 0.4;                     % Step size
N = length(x);                 % Number of samples
xr = zeros(1, N);              % Staircase approximation (transmitter)
y = zeros(1, N);               % Differential bit stream (0/1)
xr(1) = 0;                     % Initial condition

% Differential Delta Modulation: Compare current message sample with previous reconstruction
for i = 1:N-1
    if x(i) >= xr(i)
        d = 1;             % Output bit 1
        xr(i+1) = xr(i) + del;
    else
        d = 0;             % Output bit 0
        xr(i+1) = xr(i) - del;
    end
    y(i+1) = d;
end

%% Receiver: Differential Delta Demodulation
% Reconstruct the signal from the bit stream (using same step size)
xr_demod = zeros(1, N);  
xr_demod(1) = 0;
for i = 1:N-1
    if y(i+1) == 1
        xr_demod(i+1) = xr_demod(i) + del;
    else
        xr_demod(i+1) = xr_demod(i) - del;
    end
end

%% Low-Pass Filtering: Smooth the Demodulated Staircase
Fs = 1/(t(2)-t(1));              % Sampling frequency
Fc = 0.5;                        % Cutoff frequency (Hz), adjust as needed
[b, a] = butter(4, Fc/(Fs/2), 'low');  
xr_demod_filt = filtfilt(b, a, xr_demod);  % Zero-phase filtering

%  1: Input Signal (Original Message)
figure;
plot(t, x, 'b', 'LineWidth', 1.5);
title('Input Signal');
xlabel('Time (s)'); ylabel('Amplitude');
grid on;

%  2: Transmitter Staircase Signal (Delta Modulated)
figure;
stairs(t, xr, 'r', 'LineWidth', 1.5);
title('Transmitter Staircase Signal');
xlabel('Time (s)'); ylabel('Amplitude');
grid on;

%  3: Differential Signal (Bit Stream)
figure;
stairs(t, y, 'k', 'LineWidth', 1.5);
title('Differential Signal (Bit Stream)');
xlabel('Time (s)'); ylabel('Bit Value');
ylim([-0.2 1.2]);
grid on;

%  4: Receiver Staircase Signal (Demodulated)
figure;
stairs(t, xr_demod, 'm', 'LineWidth', 1.5);
title('Receiver Staircase Signal');
xlabel('Time (s)'); ylabel('Amplitude');
grid on;

%  5: Final Output (After LPF)
figure;
plot(t, xr_demod_filt, 'g', 'LineWidth', 1.5);
title('Final Output (Low-Pass Filtered)');
xlabel('Time (s)'); ylabel('Amplitude');
grid on;
