clc, clear

x = xlsread('302_0-1.xls');
x = x(:, 3:7);
load('logistic_b.mat')

n = size(x, 1);
Y = zeros(n, 1);
x = [ones(n, 1), x];
for i = 1 : n
    Y(i) = sum(b' .* x(i, :));
end
Y = 1 ./ (1 + exp(Y));
Y(Y > 0.85) = 1;
Y(Y <= 0.85) = 0;
xlswrite('302_0-1.xls', Y, 'Sheet1', 'A2:A303')