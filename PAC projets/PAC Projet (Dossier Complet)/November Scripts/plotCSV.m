
 
figure;

ax1=subplot(2,1,1);
hold on;
plot(TEK00016.Model(12:end),TEK00016.TBS2074B(12:end));
plot(TEK00015.Model(12:end),TEK00015.TBS2074B(12:end));
legend('Current','Reference');
grid on;
hold off;

ax2=subplot(2,1,2);
hold on;
plot(TEK00014.Model(12:end),TEK00014.TBS2074B(12:end));
plot(TEK00013.Model(12:end),TEK00013.TBS2074B(12:end));
legend('Voltage','Reference');
grid on;
hold off;
linkaxes([ax1 ax2],'x');
% plot(TRC02.s,TRC02.CH1V)