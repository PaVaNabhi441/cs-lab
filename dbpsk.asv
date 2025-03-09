clc;
clear;
close all;

%% Data Generation and Line Coding
data = randi([0 1], 1, 10);  % Random binary sequence of length 10
S = 100;                    % Samples per bit (assumed even)
T = 1;                      % Bit duration (arbitrary units)
total_samples = length(data) * S;
total_time = linspace(0, length(data)*T, total_samples);

% Preallocate waveforms
RZ = [];      % Return-to-Zero
NRZL = [];    % NRZ-L (Non Return-to-Zero Level)
NRZM = [];    % NRZ-M (Non Return-to-Zero Mark - differential)
Manchester = [];
Mark = [];    % Unipolar Mark Code
RB = [];      % Return-to-Blank
AMI = [];     % Alternate Mark Inversion

% Variables for differential encoding
level_nrzm = 1;
last_ami = 1;

for k = 1:length(data)
    bit = data(k);
    t_bit = linspace(0, T, S);
    
    %% RZ (Return-to-Zero)
    % Bit 1: first half +1, second half 0; Bit 0: first half -1, second half 0
    if bit == 1
        rz_bit = [ones(1, S/2) zeros(1, S/2)];
    else
        rz_bit = [-ones(1, S/2) zeros(1, S/2)];
    end
    RZ = [RZ, rz_bit];
    
    %% NRZ-L (Non Return-to-Zero Level)
    % Bit 1: constant +1; Bit 0: constant -1
    if bit == 1
        nrzl_bit = ones(1, S);
    else
        nrzl_bit = -ones(1, S);
    end
    NRZL = [NRZL, nrzl_bit];
    
    %% NRZ-M (Non Return-to-Zero Mark)
    % Differential: if bit==1, toggle level; if bit==0, maintain previous level.
    if bit == 1
        level_nrzm = -level_nrzm;
    end
    nrzm_bit = level_nrzm * ones(1, S);
    NRZM = [NRZM, nrzm_bit];
    
    %% Manchester (IEEE Convention)
    % Bit 0: first half +1 then -1; Bit 1: first half -1 then +1
    if bit == 0
        manch_bit = [ones(1, S/2) -ones(1, S/2)];
    else
        manch_bit = [-ones(1, S/2) ones(1, S/2)];
    end
    Manchester = [Manchester, manch_bit];
    
    %% Mark Code (Unipolar Mark)
    % Bit 1: constant +1; Bit 0: constant 0
    if bit == 1
        mark_bit = ones(1, S);
    else
        mark_bit = zeros(1, S);
    end
    Mark = [Mark, mark_bit];
    
    %% Return-to-Blank (RB)
    % Bit 1: pulse in first half then 0; Bit 0: all 0.
    if bit == 1
        rb_bit = [ones(1, S/2) zeros(1, S/2)];
    else
        rb_bit = zeros(1, S);
    end
    RB = [RB, rb_bit];
    
    %% AMI (Alternate Mark Inversion)
    % Bit 1: alternate between +1 and -1; Bit 0: 0.
    if bit == 1
        ami_bit = last_ami * ones(1, S);
        last_ami = -last_ami;
    else
        ami_bit = zeros(1, S);
    end
    AMI = [AMI, ami_bit];
end

%% Figure 1: Compare NRZ-L with RZ, NRZ-M, and Manchester
figure;

% Subplot 1: NRZ-L reference (dashed blue)
subplot(4,1,1);
plot(total_time, NRZL, 'b--', 'LineWidth', 1.5);
title('NRZ-L Reference');
xlabel('Time'); ylabel('Amplitude');
grid on;

% Subplot 2: NRZ-L (blue dashed) vs RZ (red solid)
subplot(4,1,2);
plot(total_time, NRZL, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, RZ, 'r', 'LineWidth', 1.5);
title('RZ vs NRZ-L');
xlabel('Time'); ylabel('Amplitude');
legend('NRZ-L', 'RZ');
grid on;

% Subplot 3: NRZ-L vs NRZ-M
subplot(4,1,3);
plot(total_time, NRZL, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, NRZM, 'r', 'LineWidth', 1.5);
title('NRZ-M vs NRZ-L');
xlabel('Time'); ylabel('Amplitude');
legend('NRZ-L', 'NRZ-M');
grid on;

% Subplot 4: NRZ-L vs Manchester
subplot(4,1,4);
plot(total_time, NRZL, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, Manchester, 'r', 'LineWidth', 1.5);
title('Manchester vs NRZ-L');
xlabel('Time'); ylabel('Amplitude');
legend('NRZ-L', 'Manchester');
grid on;

%% Figure 2: Compare NRZ-L with Mark, RB, and AMI
figure;

% Subplot 1: NRZ-L reference (dashed blue)
subplot(4,1,1);
plot(total_time, NRZL, 'b--', 'LineWidth', 1.5);
title('NRZ-L Reference');
xlabel('Time'); ylabel('Amplitude');
grid on;

% Subplot 2: NRZ-L vs Mark Code
subplot(4,1,2);
plot(total_time, NRZL, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, Mark, 'r', 'LineWidth', 1.5);
title('Mark Code vs NRZ-L');
xlabel('Time'); ylabel('Amplitude');
legend('NRZ-L', 'Mark');
grid on;

% Subplot 3: NRZ-L vs Return-to-Blank (RB)
subplot(4,1,3);
plot(total_time, NRZL, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, RB, 'r', 'LineWidth', 1.5);
title('Return-to-Blank vs NRZ-L');
xlabel('Time'); ylabel('Amplitude');
legend('NRZ-L', 'RB');
grid on;

% Subplot 4: NRZ-L vs AMI
subplot(4,1,4);
plot(total_time, NRZL, 'b--', 'LineWidth', 1.5); hold on;
plot(total_time, AMI, 'r', 'LineWidth', 1.5);
title('AMI vs NRZ-L');
xlabel('Time'); ylabel('Amplitude');
legend('NRZ-L', 'AMI');
grid on;
