

figure('Name','Full PAC System Simulation','NumberTitle','off');
%% Plot and Save BUCK Results
% Ensure output variables exist
VC = out.VC;
Duty_buck = out.Duty_buck;
if exist('VC', 'var') && exist('Duty_buck', 'var')

    ax(1)=subplot(4,1,1);
    hold on;
    plot(VC.Time, VC.Data(:,1), 'LineWidth', 1.2);
    plot(VC.Time, VC.Data(:,2), 'LineWidth', 1.2);
    plot(VC.Time, VC.Data(:,3), 'LineWidth', 1.2);
    legend('Consigne (V)', 'Mesure (V)', 'Erreur (V)');
    legend('boxoff');
    title('Tension de sortie Buck');
    xlabel('Temps [s]');
    ylabel('Tension [V]');
    grid on;
    hold off;

    ax(2)=subplot(4,1,2);
    hold on;
    plot(Duty_buck.Time, Duty_buck.Data(:,1), 'LineWidth', 1.2);
    plot(Duty_buck.Time, Duty_buck.Data(:,2), 'LineWidth', 1.2);
    legend('Rapport Cyclique Buck', 'Consigne Normalisée');
    legend('boxoff');
    title('Rapport Cyclique Buck');
    xlabel('Temps [s]');
    ylabel('Duty Ratio');
    grid on;
    hold off;
else
    warning('Simulation variables "VC" or "Duty" not found. Check your Simulink model outputs.');
    ax(1)=subplot(4,1,1);
    ax(2)=subplot(4,1,2);
end
%% Plot and Save BOOST Results
% Ensure output variables exist
% if exist('CC', 'var') && exist('Duty_boost', 'var')
CC = out.CC;
Duty_boost = out.Duty_boost;
if exist('CC', 'var') && exist('Duty_boost', 'var')


    ax(3)=subplot(4,1,3);
    hold on;
    plot(CC.Time, CC.Data(:,1), 'LineWidth', 1.2);
    plot(CC.Time, CC.Data(:,2), 'LineWidth', 1.2);
    plot(CC.Time, CC.Data(:,3), 'LineWidth', 1.2);
    legend('Consigne (A)', 'Mesure (A)', 'Erreur (A)');
    legend('boxoff');
    title('Courant Bobine Boost');
    xlabel('Temps [s]');
    ylabel('Courant [A]');
    grid on;
    hold off;

    ax(4)=subplot(4,1,4);
    hold on;
    plot(Duty_boost.Time, Duty_boost.Data(:,1), 'LineWidth', 1.2);
    plot(Duty_boost.Time, Duty_boost.Data(:,2), 'LineWidth', 1.2);
    legend('(1-Rapport Cyclique Boost)', 'Consigne Normalisée');
    legend('boxoff');
    title('Rapport Cyclique Boost');
    xlabel('Temps [s]');
    ylabel('Duty Ratio');
    grid on;
    hold off;


else
    warning('Simulation variables "VC" or "Duty" not found. Check your Simulink model outputs.');
    ax(3)=subplot(4,1,1);
    ax(4)=subplot(4,1,2);
end

linkaxes(ax,'x'); %Linking x-Axes

if SAVEALL
    % ---- Folder and timestamped saving ----
%     resultsFolder = fullfile(pwd, 'simulation results FullSystem');
    resultsFolder = fullfile(pwd, 'simulation results FullSystem');

    if ~exist(resultsFolder, 'dir')
        mkdir(resultsFolder);
    end

    timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    figName = sprintf('FullSim_%s.fig', timestamp);
    saveas(gcf, fullfile(resultsFolder, figName));
    save
    if exist('VC', 'var') && exist('Duty_buck', 'var') && exist('CC', 'var') && exist('Duty_boost', 'var')
        fprintf('✅ Figure saved successfully: %s\n', fullfile(resultsFolder, figName));
    else
        fprintf('X Warning: The figure lacks keys signals %s\n', fullfile(resultsFolder, figName));

    end
    %% ---- Save all relevant parameters in a .mat file ----
    paramFileName = sprintf('Buck_Boost_Params_%s.mat', timestamp);
    paramFilePath = fullfile(resultsFolder, paramFileName);

    % Collect relevant parameters into a structured variable
    Buck_Params = struct( ...
        't5_buck', t5_buck, ...
        'T5calc_buck', T5calc_buck, ...
        'E_buck', E_buck, ...
        'Vnom_buck', Vnom_buck, ...
        'Inom_buck',Inom_buck,...
        'L_buck', L_buck, ...
        'Rs_buck', Rs_buck, ...
        'C_buck', C_buck, ...
        'fdec_buck', fdec_buck, ...
        'Kp_buck', Kp_buck, ...
        'Ki_buck', Ki_buck, ...
        'Kpcalc_buck', Kpcalc_buck, ...
        'Kicalc_buck', Kicalc_buck);

    Boost_Params = struct( ...
        't5_boost', t5_boost, ...
        'E_boost', E_boost, ...
        'VDC_boost', VDC_boost, ...
        'Inom_boost',Inom_boost,...
        'L_boost', L_boost, ...
        'Rl_boost', Rl_boost, ...
        'C_boost', C_boost, ...
        'fdec_boost', fdec_boost, ...
        'Kp_boost', Kp_boost, ...
        'Ki_boost', Ki_boost);

    % Combine into one structure for saving
    Buck_Boost_Params = struct( ...
        'Buck', Buck_Params, ...
        'Boost', Boost_Params);

    % Save structure to .mat file
    save(paramFilePath, 'Buck_Boost_Params');
    fprintf('💾 Parameters saved successfully: %s\n', paramFilePath);
else
    fprintf('XX💾 Parameters & figures were not saved (SAVEALL=0)\n');

end
