function [af, anx] = fun(inp)

%先时间再金钱
global v Cper C0 Te Mny
Cper = 4*1e5; %单位面积费用
C0 = 1e18; %空间站费用
v = 1e7; %建造速度

Te = inp(1);
Mny = inp(2);
global R T K 
T = 2273.5;
K = 273.5;
global T1 T2 %T1小, R_R大  T2大, R_L小
T1 = 10 + K;
T2 = 80 + K;

global Se Sm
Se = 100 * 5.10083042*10^14; %100倍地球表面积
Sm = (Mny - C0)/Cper;

load basic

rst = R * T^2 / (T2^2 * sqrt(2));
red = R * T^2 / (T1^2 * sqrt(2));


wst = Se / (2*pi*rst); %当r最小时,w要符合100倍的最小宽度
wed = Sm / (2*pi*rst);
nst = 1000;
ned = (Mny - Cper * Se)/C0;

af = inf;

for cs = 1:100000
    while 1
        x = [rst + (red - rst) * rand(1,1);
               wst + (wed - wst) * rand(1,1);
               nst + (ned - nst) * rand(1,1)];
        if x(3)*C0 + 2*pi*x(1)*x(2)*Cper - Mny <0
            break
        end
    end
    inp = fun1(x);
    if inp<af
        af = fun1(x);
        anx(:) = x(:);
    end
end
