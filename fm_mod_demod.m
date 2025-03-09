function fm_mod_demod
% User Inputs
Ac = input('Enter the amplitude of the carrier: ');  % Carrier Amplitude
fm = input('Enter the message signal frequency (Hz): '); % Message Frequency
fc = input('Enter the carrier frequency (Hz): ');   % Carrier Frequency
F  = input('Enter the sampling frequency (Hz): ');  % Sampling Frequency
kf = input('Enter the frequency sensitivity (Hz per unit amplitude): '); % Frequency Sensitivity
Am = input('Enter the amplitude of the message signal: ');  % Message Amplitude

% Derived Parameters
mi = (kf * Am) / fm; % Corrected Modulation Index
T  = 1 / F;          % Sampling Period
t  = 0:T:0.1;        % Time Vector

% 1. Message Signal
m = Am .* sin(2 * pi * fm * t);

% 2. FM Modulation (Corrected)
x_fm = Ac * sin(2 * pi * fc * t - mi * cos(2 * pi * fm * t)); 

% 3. FM Demodulation using Hilbert Transform
analytic_signal = hilbert(x_fm);
inst_phase = unwrap(angle(analytic_signal));

% Compute instantaneous frequency (in Hz)
inst_freq = [diff(inst_phase) * F / (2 * pi), 0];  

% Recover the baseband message:
% Instantaneous frequency = fc + kf * Am * sin(2 * pi * fm * t) 
% => Subtract fc and scale by (kf * Am) to recover m(t).
demodulated_signal = (inst_freq - fc) / kf;

% Optionally, smooth the recovered signal with a low-pass filter
[b, a] = butter(1, 0.01);
recovered_signal = filter(b, a, demodulated_signal);

% Plotting
figure;
subplot(3,1,1);
plot(t, m);
title('Message Signal');
xlabel('Time (sec)');
ylabel('Amplitude');
grid on;

subplot(3,1,2);
plot(t, x_fm);
title('FM Modulated Signal');
xlabel('Time (sec)');
ylabel('Amplitude');
grid on;

subplot(3,1,3);
plot(t, recovered_signal);
title('FM Demodulated Signal');
xlabel('Time (sec)');
ylabel('Amplitude');
grid on;

end
