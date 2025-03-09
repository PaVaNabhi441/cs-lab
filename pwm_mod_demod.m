clc;
clear all;
close all;

%% Parameters
fs = 30;                    % Frequency of the sawtooth (comparator) signal (Hz)
fm = 3;                     % Frequency of the message signal (Hz)
sampling_frequency = 1e4;   % Sampling frequency (10 kHz)
a = 0.5;                    % Amplitude

%% Time Vector
t = 0:(1/sampling_frequency):1;

%% Generate Comparator (Sawtooth) Wave
comp_wave = 2 * a .* sawtooth(2*pi*fs*t);

subplot(4,1,1);
plot(t, comp_wave, 'b', 'LineWidth', 1.5);
title('Comparator Wave');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% Generate Message Signal (Sine Wave)
msg = a .* sin(2*pi*fm*t);
subplot(4,1,2);
plot(t, msg, 'k', 'LineWidth', 1.5);
title('Message Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% Generate PWM Signal
pwm = zeros(1, length(t));
for i = 1:length(t)
    if msg(i) >= comp_wave(i)
        pwm(i) = 1;
    else
        pwm(i) = 0;
    end
end

subplot(4,1,3);
plot(t, pwm, 'r', 'LineWidth', 1.5);
title('PWM Signal');
xlabel('Time (s)');
ylabel('Amplitude');
axis([0 1 0 1.1]);
grid on;

%% PWM Demodulation: Reconstruct Signal via Pulse Width Measurement
demodulated_signal = zeros(size(msg));
for i = 1:length(pwm)-1
    if pwm(i) == 1
        j = i + 1;
        while (j <= length(pwm)) && (pwm(j) == 1)
            j = j + 1;
        end
        demodulated_signal(i) = mean(msg(i:j-1));
    end
end

%% Low-Pass Filter Design & Application
Fs = 1 / (t(2) - t(1));          % Sampling frequency (should equal sampling_frequency)
Fc = 5;                          % Cutoff frequency (Hz)
[b, a_filter] = butter(4, Fc/(Fs/2), 'low');  % 4th-order Butterworth filter
filtered_signal = filtfilt(b, a_filter, demodulated_signal);

subplot(4,1,4);
plot(t, filtered_signal, 'r', 'LineWidth', 1.5);
title('Demodulated Signal (Filtered)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
