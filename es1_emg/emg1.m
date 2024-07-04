% Load EMG and accelerometer data
data_emg = load('ES1_emg.mat'); % Load the EMG data
fs = 2000; % Sample frequency
t = (0:length(data_emg.Es1_emg.matrix(:,1)) - 1) / fs; % Define the time vector

nyquist = fs / 2;

% Bandpass filter design
low = 30 / nyquist; % Define the lower frequency of the bandpass filter
high = 450 / nyquist; % Define the higher frequency of the bandpass filter
filterOrder = 100; % Order of the filter, adjust as needed

% Design the bandpass filter using fir1
b = fir1(filterOrder, [low, high], 'bandpass'); % Design the bandpass filter
filtered_emg = filtfilt(b, 1, data_emg.Es1_emg.matrix(:,1)); % Apply the bandpass filter

%Plot
subplot(3, 1, 1);
plot(t,data_emg.Es1_emg.matrix(:,1));
title('Raw - Filtered EMG Signal');
xlabel('Time (s)');
ylabel('Amplitude');
hold("on");
% Plot the filtered EMG signal
plot(t, filtered_emg);

legend('Raw EMG signal', 'Filtered EMG signal')

% Rectify the EMG signal
rectified_emg = abs(filtered_emg); % Rectify the filtered signal

% Plot the rectified EMG signal
subplot(3, 1, 2);
plot(t, rectified_emg);
title('Rectified - Envelope EMG Signal');
xlabel('Time (s)');
ylabel('Amplitude');
hold("on");
% Design a lowpass filter for envelope computation
low_cutoff = 5 / nyquist; % Define the low-pass filter cutoff frequency
b_lp = fir1(filterOrder, low_cutoff, 'low'); % Design the low-pass filter
envelope_emg = filtfilt(b_lp, 1, rectified_emg); % Apply the low-pass filter to compute the envelope

% Plot the envelope of the EMG signal
plot(t, envelope_emg);

legend('Rectified EMG signal', 'Envelope EMG signal')

% Downsample the envelope signal
target_fs = 100;  % Desired down-sampled sampling rate
downsample_factor = fs / target_fs;  % Compute downsample factor
downsampled_emg = downsample(envelope_emg, downsample_factor);

% Create a time vector for the downsampled signal
t_downsampled = (0:(length(downsampled_emg) - 1)) / target_fs;

% Movement signal
accelerometer_data = data_emg.Es1_emg.matrix(:,2:4);
accelerometer_data_sqrd= (accelerometer_data(:,1).^2)+(accelerometer_data(:,2).^2)+(accelerometer_data(:,3).^2);
accelerometer_data_sqrt = sqrt(accelerometer_data_sqrd);

% Normalized envlope signal 
envelope_norm =envelope_emg/max(envelope_emg);

% Plot the movement with envelope
subplot(3, 1, 3);
plot(t,accelerometer_data_sqrt-1.08);
title('Movement Signal - Envelope EMG');
xlabel('Time (s)');
ylabel('Amplitude');
hold("on");
% Plot the envelope of the EMG signal
plot(t, envelope_norm);

legend('Movement Signal', 'Normed Enevelope EMG signal')

% QUESTION A:
% The down sampling is performed after the envelope of the signal for 
% two main reasons:
% first of all the envelope signal is less noisy than the original one,
% therefore the downsampling can be done without losing any information. 
% This implies that the downsampled signal has the same behaviour of the 
% envelope one. 
% Then the envelope provides a smoother representation of the signal, 
% which simplifies the analysis that will be done in a later moment.

% QUESTION B:
% The last graph makes clear when the muscle activation commences in
% relation to the movement: 
% the muscle activation movement, in fact, charachterized by descending
% behaviour starts right AFTER the ascending of the envelope signal. 
% This justifies even the logical answer to the question: first the brain
% gives the signal then the muscles contract.