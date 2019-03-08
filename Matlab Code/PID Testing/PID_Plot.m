% read in test data
% xlsread(filename,tab#,cells)
xls_tab = 20
time = xlsread('PID Test Data',xls_tab,'A2:A2000');
setPt = xlsread('PID Test Data',xls_tab,'B2:B2000');
speed_var = xlsread('PID Test Data',xls_tab,'C2:C2000');

% offset for initial velocity and initial time
setPt_init = 0;
time_init = 0;

% plot time vs setpoint
figure(1)
plot(time - time_init,setPt - setPt_init);
hold on
% plot time vs speed
plot(time - time_init, speed_var - setPt_init)

% apply moving average to data
windowSize = 20
b = (1/windowSize)*ones(1,windowSize);
a = 1;
var_avg = filter(b,a,speed_var - setPt_init);
filter_delay = (length(b)-1)/2;

plot(time - time_init, var_avg)
legend('Set Pt','Var','Avg Var','location','best')
xlabel('Time (s)')
ylabel('Speed (m/s)')
hold off
grid

% plot slope vs time
figure(2)
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


% h = mean(diff(time));
% h = diff(time);
% dy = gradient(var_avg, h);                                      % Numerical Derivative
% [~,idx] = max(dy);                                              % Index Of Maximum
% b = [time([idx-1,idx+1]) ones(2,1) ] \ var_avg([idx-1,idx+1]);   % Regression Line Around Maximum Derivative
% tv = [-b(2)/b(1); (1-b(2))/b(1)];                               % Independent Variable Range For Tangent Line Plot
% f = [(time) ones(size(time))] * b;                              % Calculate Tangent Line

figure(3)
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