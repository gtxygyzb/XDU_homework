clc, clear
x = [200, 220, 250, 270, 280];
y = [4, 4.5, 4.7, 4.8, 5.2];
xi = 240;
yi = interp1(x, y, xi, 'spline');  % 使用三次样条插值

xt = 200:280;
yt = interp1(x, y, xt, 'spline');
plot(xt, yt)
disp(['估计值为：', num2str(yi)]);