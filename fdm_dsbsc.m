function fdm_dsbsc
% User inputs
fm1 = input('Enter message signal 1 frequency (Hz): ');
fm2 = input('Enter message signal 2 frequency (Hz): ');
fc1 = input('Enter carrier 1 frequency (Hz): ');
fc2 = input('Enter carrier 2 frequency (Hz): ');
Am1 = input('Enter message signal 1 amplitude: ');
Am2 = input('Enter message signal 2 amplitude: ');
Ac1 = input('Enter carrier 1 amplitude: ');
Ac2 = input('Enter carrier 2 amplitude: ');
fs  = input('Enter sampling frequency (Hz): ');

t = 0:1/fs:0.01; % Time vector

m1 = Am1 * sin(2*pi*fm1*t);
m2 = Am2 * sin(2*pi*fm2*t);
c1 = Ac1 * sin(2*pi*fc1*t);
c2 = Ac2 * sin(2*pi*fc2*t);

mod1 = m1 .* c1;
mod2 = m2 .* c2;

multiplexed = mod1 + mod2;

demod1 = multiplexed .* sin(2*pi*fc1*t);
demod2 = multiplexed .* sin(2*pi*fc2*t);

[b1,a1] = butter(5, (2*fm1)/(fs/2), 'low');
[b2,a2] = butter(5, (2*fm2)/(fs/2), 'low');
recov1 = filtfilt(b1, a1, demod1);
recov2 = filtfilt(b2, a2, demod2);

figure;
subplot(4,1,1); plot(t, m1, 'r'); title('Message Signal 1'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(4,1,2); plot(t, m2, 'b'); title('Message Signal 2'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(4,1,3); plot(t, multiplexed, 'k'); title('Multiplexed Signal'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(4,1,4); plot(t, recov1, 'r', t, recov2, 'b'); title('Demodulated Signals'); xlabel('Time (s)'); ylabel('Amplitude'); legend('Channel 1','Channel 2'); grid on;

% Frequency spectrum of FDM signal
N = length(multiplexed);
f_axis = fs * (-N/2:N/2-1)/N; % Frequency axis
X = fftshift(fft(multiplexed, N)); % FFT and shift zero frequency
figure;
plot(f_axis, abs(X));
title('Frequency Spectrum of FDM Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
end
