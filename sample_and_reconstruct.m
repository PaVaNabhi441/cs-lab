%% PAM using Natural Sampling
fc = 1000;
fm  = 10;
fs = 100*fc;
t = 0:1/fs:4/fm;
Msg_sgl  = cos(2*pi*fm*t);
Carr_sgl = 0.5*square(2*pi*fc*t) + 0.5;
Mod_sgl  = Msg_sgl .* Carr_sgl;

figure;
subplot(4,1,1);
plot(t, Msg_sgl);
title('Message Signal');
xlabel('Time');
ylabel('Amplitude');

subplot(4,1,2);
plot(t, Carr_sgl);
title('Carrier Signal');
xlabel('Time');
ylabel('Amplitude');

subplot(4,1,3);
plot(t, Mod_sgl);
title('PAM Modulated Signal');
xlabel('Time');
ylabel('Amplitude')


[b, a] = butter(5, (fm*2)/(fc*10)); % 5th order Butterworth filter
recovered_signal = filtfilt(b, a, Mod_sgl);

subplot(4,1,4);
plot(t, recovered_signal);
title('PAM Modulated Signal');
xlabel('Time');
ylabel('Amplitude')
