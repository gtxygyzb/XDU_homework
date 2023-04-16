clc, clear

a1 = readmatrix('50家企业的各项信息.xlsx', 'Sheet', '1', 'Range', 'B1:IG50');
a2 = readmatrix('50家企业的各项信息.xlsx', 'Sheet', '2', 'Range', 'B1:IG50');
%%
clc
x = mean(a2, 2);
y = std(a2, 0, 2);
a = zeros(50, 2);
a(:, 1) = x;
a(:, 2) = y;
C = kmeans(a, 2);

%%
clc
r = zeros(5, 50);
for i = 1:50
    if C(i) == 1  % 小企业直接取平均值
        r(1, i) = mean(a2(i, :));
    else
        cnt = 0; % 大订单总数
        suc = 0; % 大订单成功数
        s = 0; % 大订单平均值
        for j = 1:240
            if a2(i, j) >= 1000 && a1(i, j) >= 500
                cnt = cnt + 1;
                s = s + a2(i, j);
                if a2(i, j) / a1(i, j) >= 0.88
                    suc = suc + 1;
                end
            end
        end
        r(1, i) = s / cnt * suc / cnt;
    end
end
c = readmatrix('50家企业的各项信息.xlsx', 'Sheet', '1', 'Range', 'A1:A50');
r(2, :) = c';

for i = 1:50 % 最大上差值和下差值
    for j = 1:240
        if (a2(i, j) > a1(i, j))
            r(3, i) = max(r(3, i), a2(i, j) - a1(i, j));
        else
            r(4, i) = max(r(4, i), a1(i, j) - a2(i, j));
        end
    end
end
c = readmatrix('第一问企业编号和分数.xlsx', 'Sheet', '1', 'Range', 'A1:A50');
r(5, :) = c'; r = r';
writematrix(r, 'data.txt', 'Delimiter', ' ')
%%
hold on
scatter(x(C == 1), y(C == 1), 50, 'bx');
scatter(x(C == 2), y(C == 2), 50, 'rx');
hold off
xlabel('平均值')
ylabel('标准差')

%% 大订单指标
clc
cs = 0; y = [];
for i = 1:12
    if C(i) == 1
        continue
    end
    for j = 1:204
        if a1(i, j) ~= 0
            cs = cs + 1;
            y(cs) = a2(i, j);
        end
    end
end
y = y';
writematrix(y, '大企业供货额度分布图.xlsx')