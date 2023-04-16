clc, clear
format long
global f2 t9
t9 = tan(pi/20);
f2 = xlsread('f2.xlsx');

as = 1e18;
aw = 0; at = 0; am = 0;
global w %角速度
top = 25000;

global miu
for miu = 102
for dt = 30
    for w = 0.063
        P = 100;
        V = 12500 * pi;
        Pz = 0.5;
        mz = lou_P(Pz) * Vz(0);
        m = V * lou_P(P);
        s = 0;
        Tz = 2*pi/w; %转轮转一圈周期
        for t = 0.01:0.01:top
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
            otm = 0.01 * (Otm(t, P) + Otm(t - dt, P) + Rm(P)); % 流出
            m = m + inm - otm;
            mz = mz - inm;
            %重新计算压强
            P = P_lou(m / V);
            s = max(s, abs(P - 100));
        end
        disp([miu, dt, w])
        disp(s)
        if s < as
            as = s;
            aw = w;
            at = dt;
            am = miu;
        end
    end
end
end
disp([am, at, aw])
for miu = am
for dt = at
    for w = aw
        P = 100;
        V = 12500 * pi;
        Pz = 0.5;
        mz = lou_P(Pz) * Vz(0);
        m = V * lou_P(P);
        s = 0;
        cs = 1;
        y = [];
        Tz = 2*pi/w; %转轮转一圈周期
        for t = 0.01:0.01:top
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
            otm = 0.01 * (Otm(t, P) + Otm(t - dt, P) + Rm(P)); % 流出
            m = m + inm - otm;
            mz = mz - inm;
            %重新计算压强
            P = P_lou(m / V);
            s = max(s, abs(P - 100));
            y(cs) = P;
            cs = cs + 1;
        end
        if s < as
            as = s;
            aw = w;
            at = dt;
            am = miu;
        end
    end
end
end

plot(0.01:0.01:top, y)

xlabel('时间（ms）')
ylabel('压力（Mpa）')
axis([0, top, 96, 104])

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

function y = Rm(P)
    global miu
    if P <= miu
        y = 0;
    else
        y = 0.85 * 0.49 * pi * sqrt(2 * P * lou_P(P));
    end
end
function y = Otm(t, P)
    if t <= 0
        y = 0;
    else
        y = 0.85 * S(t) * sqrt(2 * P * lou_P(P));
    end
end

function y = Inm(Pz, P)
    y = 0.85 * 0.49 * pi * sqrt(2 *(Pz - P) * lou_P(Pz));
end
