clear

V = 12500 * pi;
m0 = f(100) * V;
f160 = 0.870268011206637;
format long
global T0 t
T150 = 0.751;

anss = 1e18;
ansT0 = 0;
ansy = [];
y = [];
lim = 10000; %稳定时间
for m = 0.9:0.01:0.9 %枚举
    m
    s = 0;
    cs = 1;
    k = (T150 - m)/lim;
    d2 = 0;
    for t = 0 : 10 : lim + 1000
        
        if t < lim
            T0 = k*t + m;
        else
            T0 = T150;
        end
        syms P
        q = floor(t/100);
        r = mod(t, 100);
        if (r >= 2.4)
            q = q + 1;
            r = 0;
        end
        d1 = q * 44 + jf(r);
        

        d2 = d2 + T0 * f160* 0.85 * 0.49 * pi * sqrt(2 * (160 - P) / f160);
        eq = f(P) * (V + d1) - m0 - d2 == 0;
        sol = double(vpasolve(eq, P));
        sol = sol(1);
        if t >= lim
            s = s + abs(150 - sol);
        end
        y(cs) = sol(1);
        cs = cs + 1;
    end
    disp(num2str(s))
    if s < anss
        anss = s;
        ansT0 = T0;
    end
end

x = 0 : 10 : lim + 1000;
plot(x, y)
axis([0 lim+1000,99,153])
xlabel('时间(ms)')
ylabel('压力(MPa)')


function y = jf(r)
    if r < 0.2
        y = 50 * r^2;
    elseif r < 2.2
        y = 2 + (r - 0.2) * 20;
    else
        y = 44 - 0.5*(2.4-r)*(20-100*(r-2.2));
    end
end