function sample_and_reconstruct
% User inputs
fs = input('Enter the sampling frequency (Hz): ');
f = input('Enter the frequency of the continuous signal (Hz): ');
A = input('Enter the amplitude of the continuous signal: ');

Ts = 1/fs;                         % Sampling period
t = linspace(0, 1, fs*100);          % High-resolution time vector
signal = A * sin(2*pi*f*t);          % Continuous signal

% Generate pulse train (pulse width = 10% of Ts)
tau = Ts/10;
pulse = double(mod(t, Ts) < tau);
sampled_signal = signal .* pulse;  % Sampled signal using pulse train

% Ideal sampling instants and values
t_samples = 0:Ts:1;
sampled_values = A * sin(2*pi*f*t_samples);

% Reconstruction using sinc interpolation
reconstructed_signal = zeros(size(t));
for k = 1:length(t_samples)
    reconstructed_signal = reconstructed_signal + sampled_values(k) * sinc((t - t_samples(k)) / Ts);
end

figure;
subplot(3,1,1);
plot(t, signal, 'b'); grid on;
title('Original Continuous Signal');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,2);
stem(t_samples, sampled_values, 'r', 'filled'); grid on;
title('Sampled Signal');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,3);
plot(t, reconstructed_signal, 'm', t, signal, 'k--'); grid on;
title('Reconstructed Signal');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Reconstructed','Original');
end
