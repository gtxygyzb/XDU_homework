function y = L(g, x)

global tot
y = zeros(tot, 1);
for i = 1 : tot
    if g(i) == 0
        y(i) = 640.9444 * x(i)^3 - 258.5704 * x(i)^2 + 37.9695 * x(i) - 1.1215;
    elseif g(i) == 1
        y(i) = 552.8291 * x(i)^3 - 225.0505 * x(i)^2 + 33.9947 * x(i) - 1.0165;
    else
        y(i) = 504.7170 * x(i)^3 - 207.3859 * x(i)^2 + 32.1569 * x(i) - 0.9735;
    end
end