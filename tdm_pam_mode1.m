function tdm_pam_mode1_refined
fs = 50000;                  % Sampling frequency (Hz)
total_samples = 200;         % Total TDM samples
samples_per_channel = 50;    % 50 samples per channel

% Get message signal parameters for 4 channels
freq1 = input('Channel 1 frequency (Hz): ');
amp1  = input('Channel 1 amplitude: ');
freq2 = input('Channel 2 frequency (Hz): ');
amp2  = input('Channel 2 amplitude: ');
freq3 = input('Channel 3 frequency (Hz): ');
amp3  = input('Channel 3 amplitude: ');
freq4 = input('Channel 4 frequency (Hz): ');
amp4  = input('Channel 4 amplitude: ');

t_channel = (0:samples_per_channel-1)/fs;
ch1 = amp1 * sin(2*pi*freq1*t_channel);
ch2 = amp2 * sin(2*pi*freq2*t_channel);
ch3 = amp3 * sin(2*pi*freq3*t_channel);
ch4 = amp4 * sin(2*pi*freq4*t_channel);

% Build TDM signal by interleaving channels
tdm_signal = zeros(1,total_samples);
for i = 1:samples_per_channel
    idx = 4*(i-1);
    tdm_signal(idx+1:idx+4) = [ch1(i), ch2(i), ch3(i), ch4(i)];
end
t_tdm = (0:total_samples-1)/fs;

% Generate explicit clock (square wave) and sync (pulse at frame start)
clock_signal = square(2*pi*fs*t_tdm);
sync_signal = zeros(size(tdm_signal));
for i = 1:samples_per_channel
    sync_signal(4*(i-1)+1) = 1;
end

figure;
subplot(3,1,1); plot(t_tdm, tdm_signal, 'k'); title('TDM Signal'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(3,1,2); plot(t_tdm, clock_signal, 'b'); title('Clock Signal'); xlabel('Time (s)'); ylabel('Level'); grid on;
subplot(3,1,3); stem(t_tdm, sync_signal, 'r'); title('Sync Signal'); xlabel('Time (s)'); ylabel('Level'); grid on;

% Demultiplex and smooth using a low-pass filter
rec_ch1 = tdm_signal(1:4:end);
rec_ch2 = tdm_signal(2:4:end);
rec_ch3 = tdm_signal(3:4:end);
rec_ch4 = tdm_signal(4:4:end);
[b,a] = butter(3, 0.2);
rec_ch1_f = filtfilt(b,a,rec_ch1);
rec_ch2_f = filtfilt(b,a,rec_ch2);
rec_ch3_f = filtfilt(b,a,rec_ch3);
rec_ch4_f = filtfilt(b,a,rec_ch4);

figure;
subplot(4,1,1); plot(t_channel, rec_ch1_f, 'r'); title('Recovered Channel 1'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(4,1,2); plot(t_channel, rec_ch2_f, 'b'); title('Recovered Channel 2'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(4,1,3); plot(t_channel, rec_ch3_f, 'g'); title('Recovered Channel 3'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(4,1,4); plot(t_channel, rec_ch4_f, 'm'); title('Recovered Channel 4'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;
end
