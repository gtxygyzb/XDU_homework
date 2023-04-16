clc, clear, close all

a3 = xlsread('f3.xlsx');
hold on
plot(a3(:,1), a3(:,2), 'r.', a3(:,1), a3(:,3), 'g.', a3(:,1), a3(:,4), 'b.', 'MarkerSize', 8)

b0 = [0, 0, 0, 0];
[beta1, r1] = nlinfit(a3(:,1), a3(:,2), @f3fun1, b0);
p1 = plot(a3(:,1), f3fun1(beta1, a3(:,1)), 'r');
[beta2, r2] = nlinfit(a3(:,1), a3(:,3), @f3fun1, b0);
p2 = plot(a3(:,1), f3fun1(beta2, a3(:,1)), 'g');
[beta3, r3] = nlinfit(a3(:,1), a3(:,4), @f3fun1, b0);
p3 = plot(a3(:,1), f3fun1(beta3, a3(:,1)), 'b');

beta1, beta2, beta3
f1sum = [sum(abs(r1 .^ 2)), sum(r2 .^ 2), sum(r3 .^ 2)];
f1sum = 1 - f1sum

[beta1, r1] = nlinfit(a3(:,1), a3(:,2), @f3fun2, b0);
[beta2, r2] = nlinfit(a3(:,1), a3(:,3), @f3fun2, b0);
[beta3, r3] = nlinfit(a3(:,1), a3(:,4), @f3fun2, b0);

f2sum = [sum(abs(r1 .^ 2)), sum(r2 .^ 2), sum(r3 .^ 2)];
f2sum = 1 - f2sum

xlabel('贷款年利率')
ylabel('客户流失率')
lgd = legend([p1, p2, p3], 'A','B','C', 'Location','southeast','NumColumns',2);
title(lgd, '企业评级')
hold off


