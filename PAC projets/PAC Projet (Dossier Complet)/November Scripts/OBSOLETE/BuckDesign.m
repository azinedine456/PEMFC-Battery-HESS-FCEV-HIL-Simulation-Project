clear;
clc;

%% Buck Converter Design
Inom = 10;      % Nominal inductor current [A]
Vnom = 100;     % Nominal output voltage [V]
E = 200;        % Input voltage [V]
fdec = 10e3;    % Switching frequency [Hz]

DeltaI = 0.1 * Inom;   % Inductor current ripple [A]
DeltaV = 0.1 * Vnom;   % Output voltage ripple [V]

if Inom < (DeltaI/2)
    disp("WARNING: DCM ");
end

alphaMR = 0.5;  % Duty ratio at max ripple condition

L = (1 - alphaMR) * alphaMR * E / (DeltaI * fdec);   % Inductance [H]
C = DeltaI / (8 * fdec * DeltaV);                    % Capacitance [F]

%% PI Voltage Controller Design
Rs =Vnom/Inom;                     %  Equivalent Load Resistance [Ohm]
t5i = 10e-3;                   % Desired settling time reference

K  = E ;                    % Plant gain
tau = L / Rs;                   % Plant time constant [s]
Ki = 3 / (t5i * K);              % Integral gain
Kp = tau * Ki;                  % Proportional gain



%% Results Display
disp('*------------ Finished -----------------*');
fprintf('T5s   = %.2f  s\n', t5i);
fprintf('E     = %.6f  V\n', E);
fprintf('Vnom     = %.6f  V\n', Vnom);
fprintf('L     = %.6f  H\n', L);
fprintf('Rs    = %.6f  Ohm\n', Rs);
fprintf('C     = %.6e  F\n', C);
fprintf('fdec  = %.0f  Hz\n', fdec);
fprintf('Kp    = %.6f\n', Kp);
fprintf('Ki    = %.6f\n', Ki);
disp('*----------------------------------------*');

%% Run Simulation
mdl = "FuelCellBuck.slx";
open(mdl);
out = sim(mdl);

%% Plot and Save Results
% Ensure output variables exist
VC = out.VC;
Duty = out.Duty;
if exist('VC', 'var') && exist('Duty', 'var')
    figure('Name','Buck Converter Simulation','NumberTitle','off');

    subplot(2,1,1);
    hold on;
    plot(VC.Time, VC.Data(:,1), 'LineWidth', 1.2);
    plot(VC.Time, VC.Data(:,2), 'LineWidth', 1.2);
    plot(VC.Time, VC.Data(:,3), 'LineWidth', 1.2);
    legend('Consigne (V)', 'Mesure (V)', 'Erreur (V)');
    title('Tension de sortie');
    xlabel('Temps [s]');
    ylabel('Tension [V]');
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
    resultsFolder = fullfile(pwd, 'simulation results Buck');
    if ~exist(resultsFolder, 'dir')
        mkdir(resultsFolder);
    end

    timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    figName = sprintf('BuckSim_%s.fig', timestamp);
    saveas(gcf, fullfile(resultsFolder, figName));

    fprintf('✅ Figure saved successfully: %s\n', fullfile(resultsFolder, figName));
else
    warning('Simulation variables "VC" or "Duty" not found. Check your Simulink model outputs.');
end
