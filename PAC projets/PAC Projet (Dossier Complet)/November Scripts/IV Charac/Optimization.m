% [Bestparam, cost] = fmincon(@(X) COSTIV(X, vartosave, out),0.5, [], [], [],[],0,1);
% fmincon(fun,x0,A,b,Aeq,beq,lb,ub)
[Bestparam, cost] = fminsearchbnd(@(X) COSTIV(X, vartosave, out),0.5,0,1);

% Re-run model with best tau
Lookup_voltage = vartosave.Voltage.Data(:);
Lookup_current = vartosave.Current(:);
inp_current    = out.inp_current.Data(:);
target_voltage = out.Vfc_FuelCellStack.Data(:);
Time           = out.tout(:);
out_voltage    = interp1(Lookup_current, Lookup_voltage, inp_current, 'linear');

% s = tf('s');
% Dyn = 1/(Bestparam(1)*s + 1);
% Vfcmodel = lsim(Dyn, out_voltage, Time);


ssrep=ss([-1/Bestparam(1)],[1/Bestparam(1)],1,0);
Vfcmodel = lsim(ssrep, out_voltage, Time,target_voltage(1));

% Goodness of fit (R^2)
SS_res = sum((target_voltage - Vfcmodel).^2);
SS_tot = sum((target_voltage - mean(target_voltage)).^2);
Rsq = (1 - SS_res/SS_tot)*100;

% Plot
figure(888);
plot(Time, target_voltage, 'k', 'LineWidth', 1.5); hold on;
plot(Time, Vfcmodel, 'r--', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Voltage (V)');
legend('FuelCell Stack (Powertrain)', 'Lookup+1st Order Model');
title(sprintf('Best tau = %.4f s | Cost = %.4f | R^2 = %.4f', Bestparam, cost, Rsq));
grid on;



charac =1;

if charac 
    tau=0.005:0.01:1;
    costar=zeros(1,length(tau));
    for i=1:length(tau)
        costar(i)=COSTIV(tau(i), vartosave, out);
    end
figure(999);
    plot(tau,costar);
    xlabel('tau (s)');
    ylabel('Cost');
    title('Charac');
    grid on;
end