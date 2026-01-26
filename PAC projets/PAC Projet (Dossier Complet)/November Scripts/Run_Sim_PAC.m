%% Run Simulation
if RealData % If using experimental Data
    ImportedData = load("RealData\WLTC_HESS_data.mat");

%     Tini = 1710;
    Tini = 165;
    Tfin = Tini + 20; % 10 seconds simulation time
    Tsim_fullsys = 1e-6; % Simulation step size

    indx = (ImportedData.WLTC_data_HESS.time >= Tini-0.2 & ...
            ImportedData.WLTC_data_HESS.time <= Tfin+0.2);

    Tsim_array = 0:Tsim_fullsys:(Tfin - Tini);

    IFC_Real = interp1( ImportedData.WLTC_data_HESS.time(indx), ...
        ImportedData.WLTC_data_HESS.iFC(indx), ...
        Tsim_array + Tini );
%                         ImportedData.WLTC_data_HESS.iFC(indx)./15, ...

                                        %/15 to guarentee a max current of 5A

    if PLTRealData
        hold on;
        figure(537);
    
        plot(Tsim_array,IFC_Real);
            title('IFC-REAL');
            hold off;
    end

IFC_Real_Matrix= [Tsim_array(:),IFC_Real(:)];
    mdl = "FullSystem";
    open(mdl);

    % ---- ADD THE CONFIGURATION HERE ----
    set_param(mdl, "SolverType", "Fixed-step");                 % fixed step solver
    set_param(mdl, "FixedStep", num2str(Tsim_fullsys));         % fixed step size
    set_param(mdl, "Solver", "ode4");                           % Runge–Kutta
    set_param(mdl, "StopTime", num2str(Tsim_array(end))); % <-- IMPORTANT
    % ------------------------------------

    out = sim(mdl);

else

    mdl = "FullSystem.slx";
    open(mdl);
    out = sim(mdl);

end
