clc, clear

load('topsis2_ans.mat')

n = 302;
global k tot
tot = 0;
for i = 1: n
    if rk(i) < 3
        tot = tot + 1;
        k(tot) = rk(i);
        a(tot) = r(i);
        id(tot) = i;
    end
end

global psb 
psb = 0.2 * a.^2;
psb = psb';

Ae = [ones(1, tot), zeros(1, tot)];
Be = [10000];
load('q3final.mat')
load('q1.mat')
typ = xlsread('tag.xlsx');
lb = zeros(tot * 2 ,1);
rb = zeros(tot * 2, 1);
for i = 1 : tot
%     if q1(i) == 1
%         psb(i) = psb(i) * 1.2;
%     elseif q1(i) == 2
%         psb(i) = psb(i) * 1.1;
%     else
%         psb(i) = psb(i) * 1.05;
%     end
    if c(i) == 9
        lb(i) = 10;
        rb(i) = 30;
        lb(i + tot) = 0.04;
        rb(i + tot) = 0.08;
    elseif c(i) == 1
        if typ(i) == 5
            lb(i) = 50;
            rb(i) = 100;
            lb(i + tot) = 0.04;
            rb(i + tot) = 0.06;
        else
            lb(i) = 10;
            rb(i) = 100;
            lb(i + tot) = 0.04;
            rb(i + tot) = 0.15;
        end
    elseif c(i) == 3
        if typ(i) == 5
            lb(i) = 10;
            rb(i) = 60;
            lb(i + tot) = 0.04;
            rb(i + tot) = 0.09;
        else
            lb(i) = 10;
            rb(i) = 40;
            lb(i + tot) = 0.04;
            rb(i + tot) = 0.15;
        end
    elseif c(i) == 4 || c(i)==2
        lb(i) = 10;
        rb(i) = 100;
        lb(i + tot) = 0.06;
        rb(i + tot) = 0.1;
    elseif c(i) == 5 || c(i)==6
        lb(i) = 10;
        rb(i) = 60;
        lb(i + tot) = 0.06;
        rb(i + tot) = 0.13;
    elseif c(i) == 7 || c(i) == 8
        lb(i) = 10;
        rb(i) = 50;
        lb(i + tot) = 0.07;
        rb(i + tot) = 0.15;
    end
end

options = optimoptions('fmincon','Algorithm','sqp');
ay = 0;
for cs = 1 : 10
    st1 = zeros(tot, 1);
    st2 = zeros(tot, 1);
    for i = 1:tot
        st1(i) = 10 + 90 * rand();
        st2(i) = 0.4 + 0.11 * rand();
    end
    [x, y] = fmincon('fun', [st1;st2], [], [], Ae, Be, lb, rb,[],options);
    if -y > ay
        ay = -y;
        ax = x;
    end
end

x = ax(1:tot);
t = ax(tot+1 : 2*tot);
df = zeros(n, 2);
for i = 1:tot
    df(id(i), 1) = x(i);
    df(id(i), 2) = t(i);
end

name = "";
for i = 1:n
    name(i) = string(['E' , num2str(i+123)]);
end
df = [name', df];
tit = ["企业名称", "贷款额度", "贷款利率"];
df = [tit; df];
xlswrite('T3.xlsx', df)
disp(['期望盈利:', num2str(ay)])




