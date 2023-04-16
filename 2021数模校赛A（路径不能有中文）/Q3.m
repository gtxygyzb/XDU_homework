clc, clear, close all

load basic

limr = sqrt(GM/g);
f = @(x, y) sqrt(GM./x.^3-g./x) + sqrt(GM./y.^3+g./y) - 2 * pi/(24*60*60);
fimplicit(f, [1.11e8, limr, 1e8, 5e10])
xlabel('永夜面(内圈)半径')
ylabel('永昼面(外圈)半径')

disp(['永夜面(内圈)半径: ',num2str(limr)])
x = limr;
syms y
f = sqrt(GM/x^3 - g/x) + sqrt(GM/y^3 + g/y) - 2*pi/(24*60*60);
r2 = solve(f, 0);
disp(['永昼面(外圈)半径: ',num2str(double(r2(1)))] )
r1 = x;
r2 = double(r2(1));

disp(['r1(内圈永夜面)角速度: ', num2str( sqrt((GM - g*r1^2)/r1^3) )] )
disp(['r2(内圈永夜面)角速度: ', num2str( sqrt((GM + g*r2^2)/r2^3) )] )

save('data.mat', 'r1', 'r2')