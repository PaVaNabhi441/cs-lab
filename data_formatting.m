clc;
clear;
close all;

%% Parameters
data = randi([0 1], 1, 10);  % Random binary sequence of length 10
S = 100;                     % Samples per bit (assumed even)
T = 1;                       % Bit duration (arbitrary units)
total_samples = length(data) * S;
total_time = linspace(0, length(data)*T, total_samples);

data_wave = repelem(data, S); % Convert data to waveform format

% Preallocate waveforms
RB = [];
NRZL = [];
NRZM = [];
Manchester = [];
Biphase_Mark = [];  % Biphase Mark (Differential Manchester)
Mark = [];
RZ = [];
AMI = [];

% Variables for encoding
level_nrzm = 1;  % NRZ-M initial level
last_ami = 1;    % AMI alternating level
last_biphase = 1; % Biphase Mark previous state

for k = 1:length(data)
    bit = data(k);
    
    %% RB (Return-to-Bias)
    if bit == 1
        rz_bit = [ones(1, S/2) zeros(1, S/2)];
    else
        rz_bit = [-ones(1, S/2) zeros(1, S/2)];
    end
    RB = [RB, rz_bit];
    
    %% NRZ-L (Non-Return to Zero - Level)
    nrzl_bit = data;
    NRZL = [NRZL, nrzl_bit];
    
    %% NRZ-M (Non-Return to Zero - Mark)
    if bit == 1
        level_nrzm = -level_nrzm;
    end
    NRZM = [NRZM, level_nrzm * ones(1, S)];
    
    %% Manchester (IEEE Standard)
    if bit == 1
        manch_bit = [ones(1, S/2) -ones(1, S/2)];
    else
        manch_bit = [-ones(1, S/2) ones(1, S/2)];
    end
    Manchester = [Manchester, manch_bit];
    
   %% Biphase Mark (Differential Manchester) - Corrected
    if bit == 1
        % Extra transition at the start + mandatory transition in the middle
        biphase_bit = [-last_biphase * ones(1, S/2), last_biphase * ones(1, S/2)];
        last_biphase = -last_biphase;  % Toggle for next bit
    else
        % Only mandatory transition in the middle
        biphase_bit = [last_biphase * ones(1, S/2), -last_biphase * ones(1, S/2)];
    end
    Biphase_Mark = [Biphase_Mark, biphase_bit];

    %% NRZ-Mark
    Mark = [Mark, bit * ones(1, S)];
    
    %% Return-to-Zero (RZ)
    if bit == 1
        rb_bit = [ones(1, S/2) zeros(1, S/2)];
    else
        rb_bit = zeros(1, S);
    end
    RZ = [RZ, rb_bit];
    
    %% AMI (Corrected: Pulses Only in First Half of the Clock Cycle)
    if bit == 1
        ami_bit = [last_ami * ones(1, S/2), zeros(1, S/2)]; % Active only in first half
        last_ami = -last_ami;  % Toggle polarity
    else
        ami_bit = zeros(1, S); % Zero level for '0'
    end
    AMI = [AMI, ami_bit];
end

%% Plot Figure 1: Compare RB, NRZ-M, Manchester, and Biphase Mark with Data
figure;
subplot(5,1,1);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5);
title('Binary Data Reference');
xlabel('Time'); ylabel('Amplitude');
grid on;

subplot(5,1,2);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, RB, 'r', 'LineWidth', 1.5);
title('RB vs Data');
legend('Data', 'RB');
grid on;

subplot(5,1,3);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, NRZM, 'r', 'LineWidth', 1.5);
title('NRZ-M vs Data');
legend('Data', 'NRZ-M');
grid on;

subplot(5,1,4);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, Manchester, 'r', 'LineWidth', 1.5);
title('Manchester vs Data');
legend('Data', 'Manchester');
grid on;

subplot(5,1,5);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, Biphase_Mark, 'r', 'LineWidth', 1.5);
title('Biphase Mark (Differential Manchester) vs Data');
legend('Data', 'Biphase Mark');
grid on;

%% Plot Figure 2: Compare Mark, RZ, and AMI with Data
figure;
subplot(4,1,1);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5);
title('Binary Data Reference');
grid on;

subplot(4,1,2);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, Mark, 'r', 'LineWidth', 1.5);
title('NRZ(L) vs Data');
legend('Data', 'Mark');
grid on;

subplot(4,1,3);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, RZ, 'r', 'LineWidth', 1.5);
title('Return-to-Zero vs Data');
legend('Data', 'RZ');
grid on;

subplot(4,1,4);
plot(total_time, data_wave, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, AMI, 'r', 'LineWidth', 1.5);
title('AMI vs Data (Corrected for Positive Clock)');
legend('Data', 'AMI');
grid on;
