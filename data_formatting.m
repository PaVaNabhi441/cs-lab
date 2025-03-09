clc;
clear;
close all;

%% Data Generation and Line Coding
data = randi([0 1], 1, 10);  % Random binary sequence of length 10
S = 100;                    % Samples per bit (assumed even)
T = 1;                      % Bit duration (arbitrary units)
total_samples = length(data) * S;
total_time = linspace(0, length(data)*T, total_samples);

data_wave = repelem(data, S); % Convert data to waveform format

% Preallocate waveforms
RZ = [];
NRZL = [];
NRZM = [];
Manchester = [];
Mark = [];
RB = [];
AMI = [];

% Variables for differential encoding
level_nrzm = 1;
last_ami = 1;

for k = 1:length(data)
    bit = data(k);
    
    %% RZ (Return-to-Zero)
    if bit == 1
        rz_bit = [ones(1, S/2) zeros(1, S/2)];
    else
        rz_bit = [-ones(1, S/2) zeros(1, S/2)];
    end
    RZ = [RZ, rz_bit];
    
    %% NRZ-L
    nrzl_bit = ones(1, S) * (2*bit - 1);
    NRZL = [NRZL, nrzl_bit];
    
    %% NRZ-M
    if bit == 1
        level_nrzm = -level_nrzm;
    end
    NRZM = [NRZM, level_nrzm * ones(1, S)];
    
    %% Manchester (IEEE)
    if bit == 0
        manch_bit = [ones(1, S/2) -ones(1, S/2)];
    else
        manch_bit = [-ones(1, S/2) ones(1, S/2)];
    end
    Manchester = [Manchester, manch_bit];
    
    %% Mark Code
    Mark = [Mark, bit * ones(1, S)];
    
    %% Return-to-Blank (RB)
    if bit == 1
        rb_bit = [ones(1, S/2) zeros(1, S/2)];
    else
        rb_bit = zeros(1, S);
    end
    RB = [RB, rb_bit];
    
    %% AMI
    if bit == 1
        ami_bit = last_ami * ones(1, S);
        last_ami = -last_ami;
    else
        ami_bit = zeros(1, S);
    end
    AMI = [AMI, ami_bit];
end

%% Figure 1: Compare RZ, NRZ-M, and Manchester with Data
figure;
subplot(4,1,1);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5);
title('Binary Data Reference');
xlabel('Time'); ylabel('Amplitude');
grid on;

subplot(4,1,2);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, RZ, 'r', 'LineWidth', 1.5);
title('RZ vs Data');
legend('Data', 'RZ');
grid on;

subplot(4,1,3);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, NRZM, 'r', 'LineWidth', 1.5);
title('NRZ-M vs Data');
legend('Data', 'NRZ-M');
grid on;

subplot(4,1,4);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, Manchester, 'r', 'LineWidth', 1.5);
title('Manchester vs Data');
legend('Data', 'Manchester');
grid on;

%% Figure 2: Compare Mark, RB, and AMI with Data
figure;
subplot(4,1,1);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5);
title('Binary Data Reference');
grid on;

subplot(4,1,2);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, Mark, 'r', 'LineWidth', 1.5);
title('Mark Code vs Data');
legend('Data', 'Mark');
grid on;

subplot(4,1,3);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, RB, 'r', 'LineWidth', 1.5);
title('Return-to-Blank vs Data');
legend('Data', 'RB');
grid on;

subplot(4,1,4);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, AMI, 'r', 'LineWidth', 1.5);
title('AMI vs Data');
legend('Data', 'AMI');
grid on;
