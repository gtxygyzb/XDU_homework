function y = fun(x)

global psb k tot
t = x(tot + 1 : tot * 2);
val = x(1:tot);
c = L(k, t);
c = 1 - c;
y = -sum(c .*( (1 - psb) .* val .* t - psb .* val));
