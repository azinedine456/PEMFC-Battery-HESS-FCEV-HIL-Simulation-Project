%% Clearing
clear;
clc;
%% Setup
Ilim=235;
N=1000; %steps
Tsim=1e-4;
Tend=10;
t_sweep= 0:(Tsim):Tend;
I_sweep= linspace(0,Ilim,length(t_sweep));

I_input= [t_sweep',I_sweep'];
SAVE=0; % 0-don't save IV , 1-save

%% Run Simulation
mdlIV = "IV_PAC.slx";
open(mdlIV);
set_param('IV_PAC', ...
    'SolverType', 'Fixed-step', ...
    'Solver', 'ode4', ...           % optional: choose fixed-step solver
    'FixedStep', num2str(Tsim), ...
    'StopTime', num2str(Tend));

outIV = sim(mdlIV);



vartosave=struct('Current',I_sweep,'Voltage',outIV.Vfc);
resultsFolder = fullfile(pwd,'IV_Curves');
if ~exist(resultsFolder, 'dir')
    mkdir(resultsFolder);
end
timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
paramFileName = sprintf('IV_PAC_%s.mat', timestamp);
paramFilePath = fullfile(resultsFolder, paramFileName);


%% Plot & Save
figure(777);
plot(I_sweep,outIV.Vfc.Data);
grid on;
xlabel('Current (A)');
ylabel('Voltage (V)');
title('IV Curve');


if SAVE ==1
    % Save structure to .mat file
    save(paramFilePath, 'vartosave');
    fprintf('💾 Parameters saved successfully: %s\n', paramFilePath);
end




