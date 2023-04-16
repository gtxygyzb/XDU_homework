% 非线性最小二乘法
clc
fun = @(x)f_lsq(x, p);
global m
m = length(p);
x0 = rand(n+1, 1);
x = lsqnonlin(fun, x0);


gamma = x(end);
theta = x(1:end-1);
X = -2:0.01:2;
Y = X;
Z = zeros(length(X),length(Y));
for i = 1:length(X)
    for j = 1:length(Y)
        Z(i,j) = f(X(i) , Y(j) , theta , gamma, p(:, 1:2) );
    end
end

[X,Y] = meshgrid(X,Y);

contour(X, Y, Z, 'ShowText', 'on')
colorbar
hold on
for i = 1:m
    if (p(i, 3)>0)
        opt = "ob";
    else
        opt = "or";
    end
    plot(p(i, 1), p(i, 2), opt)
end
hold off

function z = f(x, y, theta, gamma, p)
    z = 0;
    global m
    for i = 1:m
        z = z + theta(i) * exp(-gamma .* norm([x, y] - p(i, :)));
    end
    return ;
end

function z = f_lsq(x, p)
    gamma = x(end);
    theta = x(1:end-1);
    global m
    z = zeros(1, m);
    for i = 1:m
        z(i) = f(p(i,1), p(i,2) , theta, gamma, p(:, 1:2) ) - p(i, 3);
    end
    
end