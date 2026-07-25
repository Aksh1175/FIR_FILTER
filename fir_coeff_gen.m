%% =====================================================================
%  fir_coeff_gen.m
%  Generates a 16-tap low-pass FIR filter (Hamming window), quantizes
%  the coefficients to Q1.15 fixed point, and exports everything needed
%  to simulate the Verilog design in Vivado:
%     - fir_coeffs.vh   -> Verilog localparam header (used by fir_filter.v)
%     - fir_coeffs.mem  -> hex coefficients (optional, for $readmemh use)
%     - fir_input.mem   -> hex test stimulus (1 kHz tone) for the testbench
% =====================================================================
clc; clear; close all;

%% ---------------- Filter specification ----------------
num_taps = 16;          % number of taps
Fs       = 48000;       % sampling frequency (Hz)
Fc       = 4000;        % cutoff frequency (Hz)

%% ---------------- Design filter ----------------
b = fir1(num_taps-1, Fc/(Fs/2), 'low', hamming(num_taps));

figure;
freqz(b, 1, 1024, Fs);
title('16-tap FIR Low-Pass Filter - Frequency Response');

%% ---------------- Quantize to Q1.15 (16-bit signed) ----------------
coeff_bits = 16;
scale = 2^(coeff_bits-1) - 1;              % 32767
b_quant = round(b * scale);
b_quant = max(min(b_quant, scale), -scale-1);

disp('Floating point coefficients:'); disp(b);
disp('Quantized Q1.15 coefficients:'); disp(b_quant);

%% ---------------- Write Verilog coefficient header ----------------
fid = fopen('fir_coeffs.vh', 'w');
fprintf(fid, '// Auto-generated FIR coefficients (Q1.15, 16-bit signed)\n');
fprintf(fid, '// 16-tap Hamming-window low-pass FIR, Fc=%dHz, Fs=%dHz\n', Fc, Fs);
for i = 1:length(b_quant)
    v = b_quant(i);
    if v < 0
        fprintf(fid, 'localparam signed [15:0] COEFF_%d = -16''sd%d;\n', i-1, abs(v));
    else
        fprintf(fid, 'localparam signed [15:0] COEFF_%d = 16''sd%d;\n', i-1, v);
    end
end
fclose(fid);

%% ---------------- Write hex coefficient file (optional) ----------------
fid2 = fopen('fir_coeffs.mem', 'w');
for i = 1:length(b_quant)
    v = b_quant(i);
    if v < 0
        v = v + 2^coeff_bits;   % two's complement
    end
    fprintf(fid2, '%04X\n', v);
end
fclose(fid2);

%% ---------------- Generate 1 kHz test tone stimulus ----------------
t = 0:1/Fs:1e-3;
sine_in = 0.5 * sin(2*pi*1000*t);
sine_q  = round(sine_in * scale);
sine_q  = max(min(sine_q, scale), -scale-1);

fid3 = fopen('fir_input.mem', 'w');
for i = 1:length(sine_q)
    v = sine_q(i);
    if v < 0
        v = v + 2^coeff_bits;
    end
    fprintf(fid3, '%04X\n', v);
end
fclose(fid3);

fprintf('Generated %d samples of test stimulus.\n', length(sine_q));
fprintf('Files written: fir_coeffs.vh, fir_coeffs.mem, fir_input.mem\n');
fprintf('NOTE: set NUM_SAMPLES = %d in fir_tb.v to match this stimulus.\n', length(sine_q));
