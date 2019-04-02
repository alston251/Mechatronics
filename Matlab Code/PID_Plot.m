% read in test data
% xlsread(filename,tab#,cells)
file = 'X-Axis PID Data/1-4-2019 Autotune.xlsx';

xls_tab = 3;
time = xlsread(file,xls_tab,'A2:A2000');
setPt = xlsread(file,xls_tab,'B2:B2000');
speed_var = xlsread(file,xls_tab,'C2:C2000');

Kc = xlsread(file,xls_tab,'E2');
Ti = xlsread(file,xls_tab,'F2');
Td = xlsread(file,xls_tab,'G2');

% apply moving average to data
windowSize = 20;
b = (1/windowSize)*ones(1,windowSize);
a = 1;
var_avg = filter(b,a,speed_var);
filter_delay = (length(b)-1)/2;

setPt_idx = find(setPt == 20, 1);
setPt_time = time(setPt_idx);
reach_idx = find(var_avg > 20, 1);
reach_time = time(reach_idx);
[overshoot, overshoot_idx] = max(var_avg);
overshoot_time = time(overshoot_idx);

% error of avg PV compared to SP after SP has been reached
error = abs(var_avg - setPt);
reach_error_avg = mean(error(reach_idx:end));
reach_error_std = std(error(reach_idx:end));
reach_error_span = max(time) - reach_time;

fprintf('filename: %s, tab: %d, window size = %d\n', file, xls_tab, windowSize);
fprintf('Kc = %f, Ti = %f, Td = %f\n', Kc, Ti, Td);
fprintf('SP time: %fs, reach time: %fs, overshoot: %fm/s, overshoot time: %fs\n', setPt_time, reach_time, overshoot, overshoot_time);
fprintf('error_avg: %fmm/s, error_std: %fmm/s, error_span: %fs\n', reach_error_avg, reach_error_std, reach_error_span);
fprintf('\n');

clf

figure(1)
hold on
% plot time vs setpoint
plot(time,setPt, '-b')
% plot time vs speed
plot(time, speed_var, '-r')

plot(time, var_avg, '-k')
legend('Set Pt','Var','Avg Var','location','best')
xlabel('Time (s)')
ylabel('Speed (m/s)')
hold off
grid

% plot time vs speed filtered PV and SP only
figure(2)
hold on
plot(time,setPt, '-b')
plot(time, var_avg, '-k')
legend('Set Pt','PV Avg','location','best')
xlabel('Time (s)')
ylabel('Speed (m/s)')
hold off
grid

%{
% plot slope vs time
figure(3)
slope = diff(var_avg - setPt_init)./diff(time - filter_delay - time_init);
%slope = gradient(var_avg - setPt_init, time - filter_delay);
% apply moving average to slope
slope_windowSize = 20;
slope_b = (1/slope_windowSize)*ones(1,slope_windowSize);
slope_avg = filter(slope_b,1,slope);
plot(time,setPt - setPt_init)
hold on
plot(time(2:end),slope_avg)
plot(time,var_avg)
legend('Set Point','Avg Grad','Avg Var','location','best')
xlabel('Time Steps')
ylabel('Speed (m/s)')
hold off
grid


% region of inflection point
t1 = 7.44
t2 = 7.7
idx1 = find(time == t1);
idx2 = find(time == t2);
pCoeff = polyfit(time(idx1:idx2),var_avg(idx1:idx2),1)      % grad and y-cept @ inflection point
tan_x = linspace(t1 - 1,t2 + 1,200);                 % x points around region of inflection point
tan_y = pCoeff(1) .* tan_x + pCoeff(2);                         % y points of tangent line

figure(4)
plot(time, var_avg)
hold on
plot(tan_x,tan_y, '-r')                               % Tangent Line
%plot(time(idx), var_avg(idx), '.r')                   % Maximum Vertical
plot(time,setPt - setPt_init)
legend('Avg Var','Tangent','Set Point','location','best')
xlabel('Time (s)')
ylabel('Speed (m/s)')
hold off
grid
%}