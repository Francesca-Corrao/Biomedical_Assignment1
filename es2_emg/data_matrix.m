data_emg = load('ES2_emg.mat');
% row matrix sample number, 5 columns
matrix_emg=[data_emg.ES2_emg.time,data_emg.ES2_emg.signals];
fs=1000;
nyquist = fs / 2; 
low = 30 / nyquist; % Define the lower frequency of the bandpass filter
high = 450 / nyquist; % Define the higher frequency of the bandpass filter
filterOrder = 100;
low_cutoff = 5 / nyquist; % Define the low-pass filter cutoff frequency
b = fir1(filterOrder, [low, high], 'bandpass');
b_lp = fir1(filterOrder, low_cutoff, 'low'); % Design the low-pass filter

