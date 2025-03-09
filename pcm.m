function [y, Bitrate, MSE, Stepsize, QNoise] = pcm


    A = input('Enter amplitude: ');
    fm = input('Enter cosine frequency (Hz): ');
    fs = input('Enter sampling frequency (Hz): ');
    n = input('Enter number of bits per sample: ');


% High-resolution time vector for original signal plotting
t = 0:1/(100*fm):1;
x = A * cos(2*pi*fm*t);

% Sampling
ts = 0:1/fs:1;
xs = A * cos(2*pi*fm*ts);

% Quantization
x1 = (xs + A) / (2*A); % Normalize to [0,1]
L = 2^n - 1;         % Number of quantization levels
x1 = L * x1;
xq = round(x1);
r = (xq / L) * 2*A - A;  % Denormalize to [-A, A]

% Encoding: Convert each quantized sample to its binary representation.
y = [];
for i = 1:length(xq)
    d = dec2bin(xq(i), n);
    y = [y, double(d) - 48];
end

% Calculations
MSE = sum((xs - r).^2) / length(xs);
Bitrate = n * fs;
Stepsize = 2*A / L;
QNoise = (Stepsize^2) / 12;

% Plotting the signals
figure;
plot(t, x, 'linewidth', 2)
xlabel('Time (sec)')
ylabel('Amplitude')
title('Original Signal and Sampled Signal')
hold on
stem(ts, xs, 'r', 'linewidth', 2)
hold off
legend('Original Signal','Sampled Signal');
grid on

figure;
stem(ts, x1, 'linewidth', 2)
hold on
stem(ts, xq, 'r', 'linewidth', 2)
plot(ts, xq, '--r')
plot(t, (x + A)*L/(2*A), '--b')
grid on
hold off
title('Quantization')
ylabel('Levels')
legend('Normalized Sampled Signal','Quantized Signal');

figure;
stairs([y, y(end)], 'linewidth', 2)
title('Encoding')
xlabel('Bit index')
ylabel('Binary Value')
axis([0 length(y) -1 2])
grid on

end
