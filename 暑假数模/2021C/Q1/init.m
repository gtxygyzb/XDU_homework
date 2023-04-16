clc, clear

a1 = readmatrix('附件1 近5年402家供应商的相关数据.xlsx', 'Sheet', '企业的订货量（m³）', 'Range', 'C2:IH403');
a2 = readmatrix('附件1 近5年402家供应商的相关数据.xlsx', 'Sheet', '供应商的供货量（m³）', 'Range', 'C2:IH403');
% 缺值判断
if isempty(find(isnan(a1), 1)) && isempty(find(isnan(a2), 1))
    disp('没有缺失值')
end
%% 确定小型供应商
clc
n = 402; m = 240;
m2 = zeros(n, 1);
for i = 1:n  % 计算订单和供货的平均值
    sum2 = 0;
    num = 0;
    for j = 1:m
        if a1(i, j) ~= 0  % 有订货才算和
            sum2 = sum2 + a2(i, j);  
            num = num + 1;
        end
    end
    m2(i, 1) = sum2 / num; %供货平均值
end
% writematrix(m2(:, 1), '企业单次供应量平均值分布图.xlsx')  % 绘制供货量直方图
%% 确定违约
clc
cs = 0;
tmp = [];
for i = 1:n
    for j = 1:m
        if a1(i, j) ~= 0 && a2(i, j) ~= 0 && a1(i, j) > a2(i, j)  % 供货不足
            cs = cs + 1;
            tmp(cs) = a2(i, j) / a1(i, j);
        end
    end
end
sig = std(tmp);
me = mean(tmp);
me, sig
lim = me - sig;  % 算出阈值

tot = 0;  % 小型供应商剔除
del = []; % 剔除企业编号

for i = 1:n
    if m2(i, 1) <= 11 % 属于小型企业
        s = 0; cnt = 0;
        for j = 1:m
            if a1(i, j) ~= 0
                s = s + a2(i, j) / a1(i, j);
                cnt = cnt + 1;
            end
        end
        if s / cnt <= lim % 将该企业剔除
            tot = tot + 1;
            del(tot) = i;
        end
    end
end

%% 确定大型供应商
cs = 0;
qian = [];
for i = 1:n
    if m2(i, 1) >= 50 % 属于大型企业
        s = 0;
        for j = 1:m
            if a1(i, j) ~= 0 && a1(i, j) > a2(i, j)
                s = s + a1(i, j) - a2(i, j);
            end
        end
        cs = cs + 1;
        qian(cs) = s;
        if (s >= 50000)
            tot = tot + 1;
            del(tot) = i;
        end
    end
end
qian = qian';
% writematrix(qian, '企业拖欠订单总额分布图.xlsx')
%%
del = sort(del);
d = zeros(402, 1);
for i = 1:tot
    d(del(i)) = 1;
end
% writematrix(del, '第一步剔除企业编号.xlsx')