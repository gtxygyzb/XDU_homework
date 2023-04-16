clc, clear

p = [1 1; 1 -1; -1 -1; -1 1; 0 0];
theta = [1 -1 1 -1 1];
gamma = 0.5;
X = -2:0.01:2;
Y = X;
n = length(X);
global m
m = length(theta);
Z = zeros(n, n);

for i = 1:n
    for j = 1:n
        Z(i, j) = f(X(i), Y(j), theta, gamma, p);
    end
end

[X, Y] = meshgrid(X, Y);
contour(X, Y, Z, 'ShowText', 'on')
colorbar
hold on
for i = 1:m
    plot(p(i, 1), p(i, 2), '*')
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