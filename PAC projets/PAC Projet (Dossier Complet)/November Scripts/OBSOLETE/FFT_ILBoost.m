% --- Extract signal and time vector ---
t = CC.Time;                     % Time vector
x = CC.Data(:,2);                % Signal to analyze
% x=2*sin(2*pi*50.*t)+2*sin(2*pi*500.*t);

% --- Sampling parameters ---
Ts = mean(diff(t));              % Sampling period
Fs = 1/Ts;                       % Sampling frequency
N = length(x);                   % Number of samples

% --- FFT computation ---
X = fft(x);
X_mag = abs(X)/N;                % Magnitude (normalized)
X_mag = 2*X_mag(1:floor(N/2));     % Keep only positive frequencies

% --- Frequency axis ---
f = (0:length(X_mag)-1)*(Fs/N);

% --- Plot time signal ---
figure;
plot(t, x, 'LineWidth', 1.2);
grid on;
xlabel('Time [s]');
ylabel('Current [A]');
title('Courant Bobine Boost');

% --- Plot FFT ---
figure;
plot(f, X_mag, 'LineWidth', 1.2);
grid on;
xlabel('Frequency [Hz]');
ylabel('Amplitude');
title('FFT du courant bobine Boost');
xlim([0 Fs/2]);