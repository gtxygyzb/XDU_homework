%%
clc, clear
n = 10;
B = randi(10, n, 2);
C = randi(10, 2, n);
A = B * C;
a = A;
m = 30;
id = randperm(n * n);
a(id(1:m)) = inf;

%%
% A为nxn，B为nxr, C为rxn
r = 2; % 猜测r
x0 = randi(10, n+n, r);
% 非线性最小二乘法
fun = @(x)fmatrix(x, n, a);
x = lsqnonlin(fun, x0);

A_Recover = round(x(1:n, :) * x(n+1:n+n, :)');
a(a == inf) = A_Recover(a == inf);
a
b = sum(sum((a - A).^2))
disp(['残差平方和: ', num2str(b)]);

function y = fmatrix(x, n, a)
y = a - x(1:n, :) * x(n+1:n+n, :)';
y(y == inf) = 0;
end