clc, clear

a1 = readmatrix('附件1 近5年402家供应商的相关数据.xlsx', 'Sheet', '企业的订货量（m³）', 'Range', 'C2:IH403');
a2 = readmatrix('附件1 近5年402家供应商的相关数据.xlsx', 'Sheet', '供应商的供货量（m³）', 'Range', 'C2:IH403');
rk = readmatrix('第一问企业编号和分数.xlsx', 'Range', 'B1:B302');
yun = readmatrix('8家转运商平均损失率与编号.xlsx', 'Range', 'A1:A8');

%% 确认fr，为了随机函数
clc
for i = 1:302
    if i <= 7 || i == 12
        cnt = 0; % 大订单总数
        suc = 0; % 大订单成功数
        s = 0; % 大订单平均值
        u = rk(i);
        for j = 1:240
            if a2(u, j) >= 1000 && a1(u, j) >= 500
                cnt = cnt + 1;
                s = s + a2(u, j);
                if a2(u, j) / a1(u, j) >= 0.88
                    suc = suc + 1;
                end
            end
        end
        r(i) = s / cnt * suc / cnt;
    else
        u = rk(i);
        r(i) = mean(a2(u, :)); % 小企业直接取平均值
    end
end
%% 筛选
clc
all_d = 0;
all_w = 0;
tot = 0;
guji = 0;
for i = 1:302
    td = all_d;
    tw = all_w;
    tg = guji;
    u = rk(i);
    for j = 1:240
        td = td + a1(u, j);
        if a2(u, j) < a1(u, j)
            tw = tw + a1(u, j) - a2(u, j);
        end
    end
    wy = tw / td;
    tg = tg + r(i);
    zy_tot = ceil(tg / 6000);
    zy = mean(yun(1:zy_tot));
    zy = zy * 0.01;
    rao = wy + zy;
    if rao > 0.05
        continue
    end
    if (1 - rao) * (0.1085 - zy) < 0.08
        continue
    end
    
    tot = tot + 1;
    xuan(tot) = u;
    cx(tot) = i;
    all_d = td;
    all_w = tw;
    guji = tg;
end
writematrix(xuan, '第四问确定68家企业编号.xlsx')
%% 网络流数据预处理
clc
d = zeros(5, 68);
abc = readmatrix('附件1 近5年402家供应商的相关数据.xlsx', 'Sheet', '企业的订货量（m³）', 'Range', 'B2:B403');
rr = readmatrix('第一问企业编号和分数.xlsx', 'Range', 'A1:A302');
for i = 1:68
    d(1, i) = r(cx(i));
    d(2, i) = abc(xuan(i));
    d(5, i) = rr(cx(i));
end

for i = 1:68 % 最大上差值和下差值
    for j = 1:240
        u = xuan(i);
        if (a2(u, j) > a1(u, j))
            d(3, i) = max(d(3, i), a2(u, j) - a1(u, j));
        else
            d(4, i) = max(d(4, i), a1(u, j) - a2(u, j));
        end
    end
end
d = d';
writematrix(d, 'data.txt', 'Delimiter', ' ')