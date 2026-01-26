function cost = COSTIV(X, vartosave, out)

    % Extract lookup data
    Lookup_voltage = vartosave.Voltage.Data(:);
    Lookup_current = vartosave.Current(:);

    % Simulation data
    inp_current    = out.inp_current.Data(:);
    target_voltage = out.Vfc_FuelCellStack.Data(:);
    Time           = out.tout(:);

    % Lookup table model
    out_voltage = interp1(Lookup_current, Lookup_voltage, inp_current, 'linear');

    % First-order low-pass filter model
%     s = tf('s');
%     Dyn = 1/(X(1)*s + 1);
% 
%     % Dynamic response
%     Vfcmodel = lsim(Dyn, out_voltage, Time);


% First-order low-pass filter model
ssrep=ss([-1/X(1)],[1/X(1)],1,0);
% Dynamic response
Vfcmodel = lsim(ssrep, out_voltage, Time,target_voltage(1));
    % Cost (RMSE)
    cost = sqrt(mean((Vfcmodel - target_voltage).^2));

end
