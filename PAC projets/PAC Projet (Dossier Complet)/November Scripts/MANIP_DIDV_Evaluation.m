D = 0.5;  % Duty ratio at max ripple condition
II=2.7;
DII = D * E_boost / (L_boost * fdec_boost)      % Inductance [H]
DVV = II * D / (fdec_boost * C_boost)   % Capacitance [F]
clear("DVV")
clear("DII")
clear("II")
clear("D")