function amplitude = dsbsc

fm = input('Enter the value of message signal frequency: ');
fc = input('Enter the value of carrier signal frequency: ');
Am = input('Enter the value of message signal amplitude: ');
Ac = input('Enter the value of carrier signal amplitude: ');

Tm = 1/fm;
Tc = 1/fc;

t1 = 0:Tm/999:6*Tm;

% Message Signal
message_signal = Am*sin(2*pi*fm*t1);
subplot(5,1,1);
plot(t1, message_signal, 'r');
grid();
title('Message Signal');

% Carrier Signal
carrier_signal = Ac*sin(2*pi*fc*t1);
subplot(5,1,2);
plot(t1, carrier_signal, 'b');
grid();
title('Carrier Signal');

% Modulated DSB-SC Signal
modulated_signal = message_signal .* carrier_signal;
subplot(5,1,3);
plot(t1, modulated_signal, 'g');
grid();
title('DSB-SC Modulated Signal');

% Demodulation Process
received_signal = modulated_signal .* carrier_signal; % Coherent Detection

% Apply Low-Pass Filter
[b, a] = butter(5, (fm*2)/(fc*10)); % 5th order Butterworth filter
recovered_signal = filtfilt(b, a, received_signal);

subplot(5,1,4);
plot(t1, recovered_signal, 'm');
grid();
title('Demodulated Signal');

% Compute Modulation Index
modulation_index = Am / Ac;

% Display Modulation Index
subplot(5,1,5);
text(0.5, 0.5, ['Modulation Index: ', num2str(modulation_index)], 'FontSize', 12, 'HorizontalAlignment', 'center');
axis off;
title('Modulation Index');

end
