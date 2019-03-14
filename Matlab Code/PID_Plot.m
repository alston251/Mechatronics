% read in test data
% xlsread(filename,tab#,cells)
time = xlsread('PID Testing', 13, 'A2:A1352');
set_pt = xlsread('PID Testing', 13, 'B2:B1352');
speed_var = xlsread('PID Testing', 13, 'C2:C1352');

% plot time vs setpoint
figure(1)
plot(time(1:end),set_pt(1:end));
hold on
% plot time vs speed
plot(time(1:end), speed_var(1:end))

% apply moving average to data
avg_window = 100; % datapoints
movingAvgCoeff = ones(1,movingAvg_time)/movingAvg_time;
var_avg = filter(movingAvgCoeff, 1, speed_var);

% calculate filter delay
filter_delay = (length(movingAvgCoeff)-1)/2;
plot(time - filter_delay/avg_window, var_avg)
legend('Set Pt','Var','Moving Avg Var','location','best')
xlabel('Time (s)')
ylabel('Speed (m/s)')
hold off

% calculate speed tangent
figure(2)
speed_tangent = diff(var_avg)./diff(time - filter_delay);
plot(speed_tangent(1:end))

