clc, clear

y = @(p)0.776*exp(0.152*atan(0.00441*p + 0.234));
x = 0:200;
lou = y(x);

b0 = [0, 0, 0];
[beta2, r2] = nlinfit(x, lou, @f3fun2, b0);
y_pred = f3fun2(beta2, x);
beta2
plot(x, lou, x, y_pred)