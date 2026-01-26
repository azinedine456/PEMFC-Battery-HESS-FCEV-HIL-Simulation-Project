% clear;
% clc;

%% Boost Converter Design
Inom_boost = 6;        % Nominal inductor current [A]
VDC_boost = 100;        % Nominal output DC bus voltage [V]
E_boost = 45;           % Input voltage [V]
fdec_boost = 9e3;      % Switching frequency [Hz]

DeltaI_boost = 0.1 * Inom_boost;   % Inductor current ripple [A]
DeltaV_boost = 0.1 * VDC_boost;   % Output voltage ripple [V]

if Inom_boost < (DeltaI_boost / 2)
    disp("WARNING: DCM ");
end

alphaMR_boost = 1;  % Duty ratio at max ripple condition

L_boost = alphaMR_boost * E_boost / (DeltaI_boost * fdec_boost);      % Inductance [H]
C_boost = Inom_boost * alphaMR_boost / (fdec_boost * DeltaV_boost);   % Capacitance [F]

%% PI Controller Design
Rl_boost = 0.1;                  % Inductor series resistance [Ohm]
t5_boost = 1e-3;                % Desired settling time [s]

if Rl_boost ~= 0
    K_boost  = VDC_boost / Rl_boost;           % Plant gain
    tau_boost = L_boost / Rl_boost;             % Plant time constant [s]
    Ki_boost = 3 / (t5_boost * K_boost);        % Integral gain
    Kp_boost = tau_boost * Ki_boost;            % Proportional gain
else
    K_boost = VDC_boost / L_boost;
    Kp_boost = 3 / (t5_boost * K_boost);
    Ki_boost = 0;
    tau_boost = nan;
end

%% Results Display
disp('*------------ Finished -----------------*');
fprintf('T5_boost   = %.6f  s\n', t5_boost);
fprintf('E_boost    = %.6f  V\n', E_boost);
fprintf('VDC_boost = %.6f  V\n', VDC_boost);
fprintf('L_boost    = %.6f  H\n', L_boost);
fprintf('Rl_boost   = %.6f  Ohm\n', Rl_boost);
fprintf('C_boost    = %.6e  F\n', C_boost);
fprintf('fdec_boost = %.0f  Hz\n', fdec_boost);
fprintf('Kp_boost   = %.6f\n', Kp_boost);
fprintf('Ki_boost   = %.6f\n', Ki_boost);
disp('*----------------------------------------*');


% %% Run Simulation
% mdl_boost = "FuelCellBoostModified.slx";
% open(mdl_boost);
% out_boost = sim(mdl_boost);

