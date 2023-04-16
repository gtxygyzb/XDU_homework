function y = inm(t, P)
global T0
T1 = T0 + 10;
r = mod(t, T1);
y(r < T0) = 0.85 * 0.49 * pi * sqrt(2 * (160 - P) / f(160));
y(r >= T0) = 0;
y = y .* f(160);