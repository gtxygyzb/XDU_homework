function [cr, eta] = ahp(m)
n = size(m, 1);
lam = 0;
[x, y] = eig(m);
for i = 1:n
    if y(i, i) > lam
        lam = y(i, i);
        eta = x(:, i);
    end
end
ci = (lam - n)/(n - 1);
if n == 3
    ri = 0.58;
else
    ri = 1.45;
end
cr = ci / ri;

if eta(1) <0
    eta = eta * -1;
end