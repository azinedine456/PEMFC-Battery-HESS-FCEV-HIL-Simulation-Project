%% Frequency-domain analysis: Bode plots & margins
s = tf('s');

% Plants
l=10;
epsfirst_buck=1/sqrt(1-((l-1)/(l+1))^2) ; %damping after which our system behaves like a 1st order (heavily damped system eps>>>>1)
Rs_buck=(1/(2*epsfirst_buck))*sqrt(L_buck/C_buck);
% Rs_buck=Vnom_buck/2;
sys_buck  = (E_buck/(L_buck*C_buck))  / (s^2+(1/(Rs_buck*C_buck))*s+1/(L_buck*C_buck));
eps_buck=(1/(2*Rs_buck))*sqrt(L_buck/C_buck);
wn_buck=1/sqrt(L_buck*C_buck);
P_buck = pole(sys_buck);

disp('*------------ Finished -----------------*');
fprintf('eps_buck     = %.6f\n', eps_buck);
fprintf('epsfirst_buck     = %.6f\n', epsfirst_buck);
fprintf('wn_buck      = %.2f  rad/s\n', wn_buck);


% Cor_buck  = (Kp_buck*s + Ki_buck) / s;      % PI for buck
Ppicalc_buck = -max(real(P_buck));
% Ppicalc_buck = Ki_buck/Kp_buck;
Kpcalc_buck=0.1;
Cor_buck = Kpcalc_buck*(s+Ppicalc_buck)/s; % Kp_calc was chosen to ensure adequate PM >45°
Kicalc_buck = Ppicalc_buck*Kpcalc_buck; %Ki_calc
T5calc_buck = 3/(Ppicalc_buck);

% Print each pole individually (works for real and complex)
for k = 1:length(P_buck)
    fprintf('P%d_buck = %.6f%+.6fi\n', k, real(P_buck(k)), imag(P_buck(k)));
end
fprintf('PPi_buck     = %.6f\n', Ppicalc_buck);
fprintf('T5calc_buck     = %.6f s\n', T5calc_buck);
fprintf('Rs_buck      = %.6f  Ohm\n', Rs_buck);
disp('*----------------------------------------*');

% Open-loop transfer functions
OL_buck  = Cor_buck  * sys_buck;

% --- Gain and phase margins ---
[GM_buck, PM_buck, Wcg_buck, Wcp_buck] = margin(OL_buck);


fprintf('\n=== Buck Converter Margins ===\n');
fprintf('Gain Margin  = %.2f dB @ %.2f rad/s\n', 20*log10(GM_buck), Wcg_buck);
fprintf('Phase Margin = %.2f deg @ %.2f rad/s\n', PM_buck, Wcp_buck);


%% ---------- Figure 1: Open-Loop Bode Diagrams with Gain & Phase Margins ----------
f = figure(111);
set(f,'Name','Open-Loop Bode Diagrams with Margins','NumberTitle','on');

% ----- Buck open-loop -----

margin(OL_buck);             % Shows gain and phase margins directly on Bode plot
grid on;
% title('Buck Converter Open-Loop (Controller × Plant)');
legend('Buck Open Loop','Location','best');



%% ---------- Figure 2: Plants and Controllers (with Gain & Phase Margins) ----------
g = figure(222);
set(g,'Name','Plant & Controller Bode Diagrams with Margins','NumberTitle','off');


% ----- Buck system -----

margin(sys_buck);             % Automatically plots gain/phase margins for the plant
hold on;
bode(Cor_buck,'r--');           % Overlay controller in red dashed
grid on;
legend('Buck Plant (with margins)','Buck Controller','Location','best');
% title('Buck Converter: Plant & Controller with Gain/Phase Margins');
hold off;


