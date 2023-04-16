clc, clear
x = 0:11;
y = [5,8,9,15,25,29,31,30,22,25,27,24];
xi = 0:0.1:11;
yi = interp1(x, y, xi, 'spline');  % 使用三次样条插值

plot(x, y, 'r*', xi, yi, 'b');
xlabel('时间(h)');
ylabel('温度℃');