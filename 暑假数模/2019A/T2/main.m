clc, clear
format long
global f2 t9
t9 = tan(pi/20);
f2 = xlsread('f2.xlsx');
P = 100;
V = 12500 * pi;
Pz = 0.5;
mz = lou_P(Pz) * Vz(0);
m = V * lou_P(P);


global w %角速度
for w = 0.0275
    y = [];
    cs = 1;
    s = 0;
    w
    Tz = 2*pi/w; %转轮转一圈周期
    for t = 0.01:0.01:5000
        
        r = mod(t, Tz);
        if (r >= 0 && r - 0.01 <= 0) % 更新压强
            Pz = 0.5;
            mz = lou_P(Pz) * Vz(0);
        end
        
        Pz = P_lou(mz / Vz(t)); % 左侧管压缩
        
        inm = 0;
        if Pz > P %压力大，有流入
            inm = 0.01 * Inm(Pz, P);
        end
        otm = 0.01 * Otm(t, P); % 流出
%         t, inm, otm
        m = m + inm - otm;
        mz = mz - inm;
        %重新计算压强
        P = P_lou(m / V);
        y(cs) = P;
        cs = cs + 1;
        s = s + abs(P - 100);
    end
end
disp(s / cs);
plot(0.01:0.01:5000, y)
xlabel('时间（ms）')
ylabel('压力（Mpa）')

function y = h_t(t)
    global f2
    t0 = mod(t, 100);
    t0 = roundn(t0, -2);
    if t0 >= 2.45
        y = 0;
    elseif t0 > 0.445 && t0 <= 2
        y = 2;
    else
        if t0 < 1
            id = roundn(t0*100+1, 0);
        else
            id = 45 + roundn((t0-2)*100, 0);
        end
        y = f2(id, 2);
    end
end

function y = lou_P(P)
    a = -0.000000670433507;
    b = 0.000525084977752;
    c = 0.803447529877140;
    y = a*P^2 + b*P + c;
end

function y = P_lou(x)
    a = -0.000000670433507;
    b = 0.000525084977752;
    c = 0.803447529877140 - x;
    del = b^2 - 4*a*c;
    y = (-b + sqrt(del))/(2*a);
end

function y = Vz(t)
    global w
    a = mod(w*t, 2*pi);
    R = 2.413*cos(a);
    y = 20 + (2.413 + R) * pi * 2.5^2;
end

function y = S(t)
    global t9
    h = h_t(t);
    if h > 1.153
        y = 0.49*pi;
    elseif h == 0
        y = 0;
    else
        R = 1.25;
        y = pi * (R + h*t9).^2 - pi * R^2;
    end
end

function y = Otm(t, P)
    y = 0.85 * S(t) * sqrt(2 * P * lou_P(P));
end

function y = Inm(Pz, P)
    y = 0.85 * 0.49 * pi * sqrt(2 *(Pz - P) * lou_P(Pz));
end
