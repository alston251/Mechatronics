%Example
t=0:0.01:10
y=sin(t)
plot(t,y)
%-------------------------
dy=diff(y)./diff(t)
k=220; % point number 220
tang=(t-t(k))*dy(k)+y(k)
hold on
plot(t,tang)
scatter(t(k),y(k))
hold off
% 
% Gs1 = tf([1],[1 5 10 10 5 1],'InputDelay',3);
% [y,t] = step(Gs1);
% h = mean(diff(t));
% dy = gradient(y, h);                                            % Numerical Derivative
% [~,idx] = max(dy);                                              % Index Of Maximum
% b = [t([idx-1,idx+1]) ones(2,1)] \ y([idx-1,idx+1]);            % Regression Line Around Maximum Derivative
% tv = [-b(2)/b(1); (1-b(2))/b(1)];                               % Independent Variable Range For Tangent Line Plot
% f = [tv ones(2,1)] * b;                                         % Calculate Tangent Line
% figure
% plot(t, y)
% hold on
% plot(tv, f, '-r')                                               % Tangent Line
% plot(t(idx), y(idx), '.r')                                      % Maximum Vertical
% hold off
% grid
