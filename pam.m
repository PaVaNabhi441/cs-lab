%% PAM using Natural Sampling
fc = 100;
fm  = 10;
fs = 100*fc;
t = 0:1/fs:4/fm;
Msg_sgl  = cos(2*pi*fm*t);
Carr_sgl = 0.5*square(2*pi*fc*t) + 0.5;
Mod_sgl  = Msg_sgl .* Carr_sgl;

tt = [];
for i = 1:length(Mod_sgl)
    if Mod_sgl(i) == 0
        tt = [tt, Mod_sgl(i)];
    else
        tt = [tt, Mod_sgl(i) + 2];
    end
end

figure;
subplot(3,1,1);
plot(t, Msg_sgl);
title('Message Signal');
xlabel('Time');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, Carr_sgl);
title('Carrier Signal');
xlabel('Time');
ylabel('Amplitude');

subplot(3,1,3);
plot(t, Mod_sgl);
title('PAM Modulated Signal');
xlabel('Time');
ylabel('Amplitude')
