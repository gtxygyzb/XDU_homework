clc, clear

a = xlsread('123_0-1.xls');
n = size(a, 1);
y = a( :,1);
ty = y;
y( y==0 ) = 0.01;
y( y==1 ) = 0.99;
y = log((1-y)./y);
x = [ones(n, 1), a(:,3:7)];
[b, ~, ~, ~, ~] = regress(y, x)

Y = zeros(n, 1);
for i = 1 : n
    Y(i) = sum(b' .* x(i, :));
end
Y = 1 ./ (1 + exp(Y));
Y(Y > 0.85) = 1;
Y(Y <= 0.85) = 0;
tot = sum(ty);
f0 = 0;
f1 = 0;
for i = 1 : n
    if ty(i) == 0 && Y(i) ~= ty(i)
        f0 = f0 + 1;
    end
    if ty(i) == 1 && Y(i) ~= ty(i)
        f1 = f1 + 1;
    end
end
save('logistic_b.mat', 'b');
disp(['正确率: ', num2str(1 - (f0 + f1) / n)])
lis = [n - tot - f0, f0; f1, tot - f1];
disp(['违约预测正确率: ', num2str(lis(1,1) / (lis(1,1) + lis(1,2)) )])
disp(['不违约预测正确率: ', num2str(lis(2,2) / (lis(2,1) + lis(2,2)) )])
disp(lis)
        