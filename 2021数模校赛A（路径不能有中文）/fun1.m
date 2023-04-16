function f = fun1(x)

global v Te C0 Mny Cper Se Sm

S = 2*pi*x(1)*x(2);
tim = S/(v*x(3));
p = zeros(1,3);

if tim <= Te
    p(1) = 1;
else
    p(1) = 1 - (tim-Te)/(S/(v*1000) - Te);
end

C = x(3)*C0 + S*Cper;
Cy = C0 + S*Cper;
Cl = Mny;

p(2) = 1 - (C-Cy)/(Cl - Cy);
p(3) = (S - Se)/(Sm - Se);
S0 = sqrt( sum((1-p).^2) );
S1 = sqrt( sum(p.^2) );
f = S0/(S0+S1);

