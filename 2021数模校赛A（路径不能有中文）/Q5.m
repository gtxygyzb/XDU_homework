clc, clear

load basic

global v Cper C0 Te Mny
Cper = 4*1e5; %单位面积费用
C0 = 1e18; %空间站费用
v = 1e7; %建造速度

Te = 1e6;
Mny = 1e24;
disp('最优期望时间:')
disp(Te)
disp('限制资金,')
disp(Mny)
global R T K 

global T1 T2 %T1小, R_R大  T2大, R_L小
T1 = 10 + K;
T2 = 80 + K;

global Se Sm
Se = 100 * 5.10083042*10^14; %100倍地球表面积
Sm = (Mny - C0)/Cper;

rst = R * T^2 / (T2^2 * sqrt(2));
red = R * T^2 / (T1^2 * sqrt(2));
wst = Se / (2*pi*rst); %当r最小时,w要符合100倍的最小宽度
wed = Sm / (2*pi*rst);
nst = 10;
ned = (Mny - Cper * Se)/C0;

af = inf;
ansx = zeros(1, 3);

for cs = 1:1000000
    while 1
        x = [rst + (red - rst) * rand(1,1);
               wst + (wed - wst) * rand(1,1);
               nst + (ned - nst) * rand(1,1)];
        if x(3)*C0 + 2*pi*x(1)*x(2)*Cper - Mny <0
            break
        end
    end
    tmp = fun1(x);
    if tmp<af
        af = fun1(x);
        ansx = x;
    end
end

ansx(3) = round(ansx(3));
disp(['有 ', num2str(round(ansx(3))), ' 个空间站, 评价指标为: ', num2str(af)])
disp(['半径为: ', num2str( ansx(1) ) ])
disp(['宽度为: ', num2str(ansx(2))])
tr = ansx(1);
disp(['角速度为: ', num2str( sqrt((GM + g*tr^2)/tr^3) )])
C = ansx(3)*C0 + 2*pi*ansx(1)*ansx(2)*Cper;
tim = 2*pi*ansx(1)*ansx(2)/(v*ansx(3));
disp(['花费资金为: ', num2str(C)])
disp(['花费时间为: ', num2str(tim)])