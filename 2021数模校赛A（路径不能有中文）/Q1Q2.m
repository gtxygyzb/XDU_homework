clc, clear
G = 6.67* 10^(-11); % 万有引力常数
M = 1.8982 * 10^27; % 木星质量
GM = G * M;
p = 1.326 * 10^3 *3; % 木星平均密度
R = (3*M /(4*p*pi))^(1/3); % 木星半径
g = 9.8; % 取地球重力为9.8 (SI)

gm = G*M/(R^2);
disp(['朝阳星半径R: ', num2str(R), ' m'])
disp(['朝阳星重力加速度g: ', num2str(gm), ' m*s^(-2)'])
h = sqrt(G*M/g);
disp(['静止状态下戴森环离球心的高度h: ', num2str(h - R), ' m'])

w = 2*pi / (24*60*60);
syms x;
f11 = w^2*x^3 + g*x^2 - G*M;
f22 = w^2*x^3 - g*x^2 - G*M;
r1 = solve(f11, 0);
r2 = solve(f22, 0);
r1 = double(r1(1));
r2 = double(r2(3));
disp(['永夜面半径: ', num2str(r1)])
disp(['永昼面半径: ', num2str(r2)])

T = 2273.5; % 木星表面温度
T1 = (R^2 * T^4 / (2 * r1^2))^(0.25);
T2 = (R^2 * T^4 / (2 * r2^2))^(0.25);

disp(['永夜面温度: ', num2str(T1-273.5)])
disp(['永昼面温度: ', num2str(T2-273.5)])

K = 273.5;
save('basic.mat', 'GM', 'T', 'R', 'g', 'K')

rx = 1e8:1e7:2e9;
ry = (R.^2 .* T.^4 ./ (2 .* rx.^2)).^(0.25) -273.5;
plot(rx, ry,'-r')
xlabel('星盟环半径 (h)')
ylabel('星盟环温度 (T)')