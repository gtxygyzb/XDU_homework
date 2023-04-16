clc, clear, close all

a3 = xlsread('f3.xlsx');
n = length(a3);
x = a3(:, 1);
y = a3(:, 2);
hold on
plot(x(1:5:n), y(1:5:n), '.', 'MarkerSize', 7) % 取五个点画一幅图

b0 = [0, 0, 0, 0];
[beta1, r1] = nlinfit(x, y, @f3fun1, b0);
y_pred = f3fun1(beta1, x);
p1 = plot(a3(:,1), y_pred, 'r');

my = mean(y);
r_sqr = sum((y_pred - my).^2) / sum((y - my).^2);
disp(['r^2:  ', num2str(r_sqr)])
disp(['三次系数:  ', num2str(beta1)])

b0 = [0, 0, 0];
[beta2, r2] = nlinfit(x, y, @f3fun2, b0);
y_pred = f3fun2(beta2, x);

my = mean(y);
r_sqr = sum((y_pred - my).^2) / sum((y - my).^2);
disp(['r^2:  ', num2str(r_sqr)])
disp(['二次系数:  ', num2str(beta2)])
xlabel('压力(MPa)')
ylabel('弹性模量(MPa)')

%%
clc
b = beta2;
syms p
lou = 1/(b(1) * p^2 + b(2)*p + b(3));
flou = int(lou);
flou = exp(flou);

f = matlabFunction(flou);
C = 0.85 / f(100);
flou = C * flou;
vpa(flou, 3)
f = matlabFunction(flou);
x = 0:1:200;
plot(x, f(x))
xlabel('压力(MPa)')
ylabel('密度(mg/mm^3)')
save('loup.mat', 'f')