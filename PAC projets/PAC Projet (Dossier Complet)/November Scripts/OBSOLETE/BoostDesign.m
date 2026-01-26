clear;
clc;

%% Boost Converter Design
Inom = 10;      % Nominal inductor current [A]
Vnom = 60;      % Nominal output DC bus voltage [V]
E = 45;          % Input voltage [V]
fdec = 10e3;     % Switching frequency [Hz]

DeltaI = 0.1 * Inom;   % Inductor current ripple [A]
DeltaV = 0.1 * Vnom;   % Output voltage ripple [V]

if Inom < (DeltaI/2)
    disp("WARNING: DCM ");
end

alphaMR = 1;  % Duty ratio at max ripple condition

L = alphaMR * E / (DeltaI * fdec);   % Inductance [H]
C = Inom * alphaMR / (fdec * DeltaV); % Capacitance [F]

%% PI Controller Design
Rl = 0.1;                     % Inductor series resistance [Ohm]
t5 = 10e-3;                 % Desired settling time [s]

if Rl ~= 0
    K  = Vnom / Rl;         % Plant gain
    tau = L / Rl;           % Plant time constant [s]
    Ki = 3 / (t5 * K);      % Integral gain
    Kp = tau * Ki;          % Proportional gain
else
    K = Vnom / L;
    Kp = 3 / (t5 * K);
    Ki = 0;
    tau = nan;
end

%% Results Display
disp('*------------ Finished -----------------*');
fprintf('T5s   = %.2f  s\n', t5);
fprintf('E     = %.6f  V\n', E);
fprintf('Vnom     = %.6f  V\n', Vnom);
fprintf('L     = %.6f  H\n', L);
fprintf('Rl    = %.6f  Ohm\n', Rl);
fprintf('C     = %.6e  F\n', C);
fprintf('fdec  = %.0f  Hz\n', fdec);
fprintf('Kp    = %.6f\n', Kp);
fprintf('Ki    = %.6f\n', Ki);
disp('*----------------------------------------*');

%% Run Simulation
mdl = "FuelCellBoostModified.slx";
open(mdl);
out = sim(mdl);

%% Plot and Save Results
% Ensure output variables exist
if exist('CC', 'var') && exist('Duty', 'var')
    figure('Name','Boost Converter Simulation','NumberTitle','off');

    subplot(2,1,1);
    hold on;
    plot(CC.Time, CC.Data(:,1), 'LineWidth', 1.2);
    plot(CC.Time, CC.Data(:,2), 'LineWidth', 1.2);
    plot(CC.Time, CC.Data(:,3), 'LineWidth', 1.2);
    legend('Consigne (A)', 'Mesure (A)', 'Erreur (A)');
    title('Courant Inducteur');
    xlabel('Temps [s]');
    ylabel('Courant [A]');
    grid on;
    hold off;

    subplot(2,1,2);
    hold on;
    plot(Duty.Time, Duty.Data(:,1), 'LineWidth', 1.2);
    plot(Duty.Time, Duty.Data(:,2), 'LineWidth', 1.2);
    legend('Rapport Cyclique', 'Consigne Normalisée');
    title('Rapport Cyclique');
    xlabel('Temps [s]');
    ylabel('Duty Ratio');
    grid on;
    hold off;

    % ---- Folder and timestamped saving ----
    resultsFolder = fullfile(pwd, 'simulation results BOOST');
    if ~exist(resultsFolder, 'dir')
        mkdir(resultsFolder);
    end

    timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    figName = sprintf('BoostSim_%s.fig', timestamp);
    saveas(gcf, fullfile(resultsFolder, figName));

    fprintf('✅ Figure saved successfully: %s\n', fullfile(resultsFolder, figName));
else
    warning('Simulation variables "CC" or "Duty" not found. Check your Simulink model outputs.');
end
