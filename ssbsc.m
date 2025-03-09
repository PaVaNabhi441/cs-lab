function amplitude = ssbsc

fm = input('Enter the value of message signal frequency: ');
fc = input('Enter the value of carrier signal frequency: ');
Am = input('Enter the value of message signal amplitude: ');
Ac = input('Enter the value of carrier signal amplitude: ');

Tm = 1/fm;
Tc = 1/fc;

t1 = 0:Tm/999:6*Tm;

% Message Signal
message_signal = Am*sin(2*pi*fm*t1);
subplot(4,1,1);
plot(t1, message_signal, 'r');
grid();
title('Message Signal');

% Carrier Signal
carrier_signal = Ac*sin(2*pi*fc*t1);
subplot(4,1,2);
plot(t1, carrier_signal, 'b');
grid();
title('Carrier Signal');

% Generate Hilbert Transform of Message Signal
hilbert_signal = imag(hilbert(message_signal));

% Upper Sideband (SSB-SC) Modulation
ssb_modulated = message_signal .* cos(2*pi*fc*t1) - hilbert_signal .* sin(2*pi*fc*t1);
subplot(4,1,3);
plot(t1, ssb_modulated, 'g');
grid();
title('SSB-SC Modulated Signal');

% Demodulation Process (Coherent Detection)
received_signal = ssb_modulated .* cos(2*pi*fc*t1);

% Apply Low-Pass Filter
[b, a] = butter(5, (fm*2)/(fc*10)); % 5th order Butterworth filter
recovered_signal = filtfilt(b, a, received_signal);

subplot(4,1,4);
plot(t1, recovered_signal, 'm');
grid();
title('Demodulated Signal');

end
