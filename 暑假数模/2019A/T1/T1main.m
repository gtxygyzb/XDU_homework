clc, clear

V = 12500 * pi;
m0 = f(150) * V;
f160 = 0.870268011206637;
format long
global T0 t
anss = 1e18;
ansT0 = 0;
ansy = [];
y = [];
c = 1;
for T0 = 0.751 : 0.001 : 0.751 %枚举
    T0
    s = 0;
    cs = 1;
    for t = 0 : 10 : 1000
        syms P

        q = floor(t/100);
        r = mod(t, 100);
        if (r >= 2.4)
            q = q + 1;
            r = 0;
        end
        d1 = q * 44 + jf(r);
        
        T1 = T0 + 10;
        q = floor(t / T1);
        r = mod(t, T1);
        if r >= T0
            q = q + 1;
            r = 0;
        end
        d2 = (q * T0 + r) *f160* 0.85 * 0.49 * pi * sqrt(2 * (160 - P) / f160);
        eq = f(P) * (V + d1) - m0 - d2 == 0;
        sol = double(vpasolve(eq, P));
        sol = sol(1);
        s = s + abs(150 - sol);
        y(cs) = sol(1);
        cs = cs + 1;
    end
    disp(num2str(s))
    ansy(c) = s;
    c = c + 1;
    if s < anss
        anss = s;
        ansT0 = T0;
    end
end

x = 0 : 10 : 1000;
plot(x, y)
axis([0 1000,146,152])
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