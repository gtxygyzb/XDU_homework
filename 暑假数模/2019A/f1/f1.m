clc, clear
a1 = xlsread('f1.xlsx');
theta = a1(:,1);
r = a1(:,2);
n = length(r);
fun = @(x)x(1) * cos(x(2)*theta) + x(3) - r;
x0 = [2, 1, 3];
x = lsqnonlin(fun, x0);

polarplot(theta(1:5:n), r(1:5:n), '.', 'MarkerSize', 7)

y_pred = fun(x) + r;
hold on
polarplot(theta, y_pred, 'r-', 'LineWidth', 0.7)

my = mean(r);
r_sqr = sum((y_pred - my).^2) / sum((r - my).^2);
disp(['r^2:  ', num2str(r_sqr)])
disp(['系数:  ', num2str(x)])
hold off

