% clear;
% clc;

%% Buck Converter Design
Inom_buck = 6;      % Nominal inductor current [A]
Vnom_buck = 45;     % Nominal output voltage [V]
E_buck = 70;        % Input voltage [V]
fdec_buck = 10e3;    % Switching frequency [Hz]




DeltaI_buck_spec = 0.1 * Inom_buck;   % Inductor current ripple [A]
DeltaV_buck_spec = 0.03 * Vnom_buck;   % Output voltage ripple [V]

if Inom_buck < (DeltaI_buck_spec/2)
    disp("WARNING: DCM ");
end

alphaMR_buck = 0.5;  % Duty ratio at max ripple condition

L_buck = 3e-3;
C_buck =  10e-6;         % Capacitance [F]

DeltaI_buck = (1 - alphaMR_buck) * alphaMR_buck * E_buck / (L_buck * fdec_buck);    % Inductor current ripple [A]
DeltaV_buck = DeltaI_buck_spec / (8 * fdec_buck * C_buck);            % Output voltage ripple [V]


%% PI Voltage Controller Design
Rs_buck = Vnom_buck/2;                   %  Output Resistance (for Stabilizing system dynamics) [Ohm]
Rl_buck=0;
t5_buck = 1e-3;                   % Desired settling time reference

K_buck  = E_buck *(Rs_buck/(Rl_buck+Rs_buck));                    % Plant gain
tau_buck = L_buck / (Rs_buck+Rl_buck);                   % Plant time constant [s]
Ki_buck = 3 / (t5_buck * K_buck);              % Integral gain
Kp_buck = tau_buck * Ki_buck;                  % Proportional gain



%% Results Display
disp('*------------ Finished -----------------*');
fprintf('T5_buck   = %.6f  s\n', t5_buck);
fprintf('E_buck     = %.6f  V\n', E_buck);
fprintf('Vnom_buck     = %.6f  V\n', Vnom_buck);
fprintf('L_buck     = %.6f  H\n', L_buck);
fprintf('Rs_buck    = %.6f  Ohm\n', Rs_buck);
fprintf('C_buck     = %.6e  F\n', C_buck);
fprintf('fdec_buck  = %.0f  Hz\n', fdec_buck);
fprintf('Kp_buck    = %.6f\n', Kp_buck);
fprintf('Ki_buck    = %.6f\n', Ki_buck);
disp('*----------------------------------------*');

%% Run Simulation
% mdl_buck = "FuelCellBuck.slx";
% open(mdl_buck);
% out_buck = sim(mdl_buck);


