clc, clear

a = xlsread('302_0-1.xls');
rk = a(:,2);
save('302.mat', 'rk')