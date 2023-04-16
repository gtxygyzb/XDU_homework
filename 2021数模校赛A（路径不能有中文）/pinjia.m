clc, clear, close all

load basic
C0 = 1e18; %空间站费用
Cper = 4*1e5; %单位面积费用
v = 1e7; %建造速度
df = zeros(5,5);
ci = 1;
cs = 1;
for i = 2e6:2e6:1e7
    cj = 1;
    for j =2e23:2e23:1e24
        [df(ci,cj),tmpx] = fun([i,j]);
        anx(cs,1:3)=tmpx(1,1:3);
        anx(cs,3) = round(anx(cs,3));
        tr = anx(cs,1);
        anx(cs,4) = sqrt((GM + g*tr^2)/tr^3);
        disp([ci,cj]);
        cj = cj+1;
        cs = cs+1;
    end
    ci = ci+1;
end
disp(anx)
save('fulu.txt', 'anx', '-ascii')