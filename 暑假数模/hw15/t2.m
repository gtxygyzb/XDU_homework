clc, clear

%%使用内置函数求解
x = optimvar('x', 2);
eq1 = x(1)^2 + 2 * x(2)^2 - 8 == 0;
eq2 = x(2) - exp(x(1)) + 1 == 0;
prob = eqnproblem;
prob.Equations.eq1 = eq1;
prob.Equations.eq2 = eq2;
x0.x = [1 2];
[sol, fval, exitflag] = solve(prob, x0);
exitflag
disp(num2str(sol.x))

%% 解另外一组解
f = @(x, y) x^2 + 2 * y^2 - 8;
g = @(x, y) y - exp(x) + 1;

syms x y
fx = matlabFunction(diff(f(x, y), x));
fy = matlabFunction(diff(f(x, y), y));
gx = matlabFunction(diff(g(x, y), x));
gy = matlabFunction(diff(g(x, y), y));
x = -2; y = -1;
step = 10;
for i = 1:10
    A1 = [-f(x, y) fy(y); -g(x, y) gy()];
    A2 = [fx(x) -f(x, y); gx(x) -g(x, y)];
    B = [fx(x) fy(y); gx(x) gy()];
    x = x + det(A1) / det(B);
    y = y + det(A2) / det(B);
end
disp(num2str(x))
disp(num2str(y));
