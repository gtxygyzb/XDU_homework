clc, clear

opt = 302; % 输入名字
if opt == 302
    load('302.mat')
else
    load('123.mat')
end

m = 7;
n = size(sumb, 1);
x = zeros(n, m);

for i = 1 : n
    if opt == 123
        x(i, 1) = y(i); % 违约
        x(i, 2) = rk(i); % 等级
    else
        x(i, 1) = rand();
        x(i, 2) = rand();
    end
    x(i, 3) = double(totn(i)) / double(tot(i)); % 无效发票占比
    x(i, 4) = sumb(i, 1); % 成本
    x(i, 5) = sumb(i, 2) - sumb(i, 1); % 利润
    x(i, 6) = (sum1(i, 2) - sum0(i, 2)) / (sum1(i, 1) - sum0(i, 1)); % 增长率
    x(i, 7) = num0(i) + num1(i); % （稳定性）关系企业数量，分三层
    if x(i, 7) > 250
        x(i, 7) = 0.75;
    elseif x(i, 7) > 50
        x(i, 7) = 0.5;
    else
        x(i, 7) = 0.25;
    end
end
mx = max(x);
mi = min(x);
for j = 1 : m
    if j > 4
        x(:, j) = (x(:, j) - mi(j)) / (mx(j) - mi(j));
    else
        x(:, j) = (mx(j) - x(:, j)) / (mx(j) - mi(j));
    end
end
name = ["违约", "等级", "无效发票占比", "成本", "利润", "增长率", "稳定性"];
if opt == 123
    xlswrite('123_0-1.xls', [name; x]);
else
    xlswrite('302_0-1.xls', [name; x]);
end

if opt == 123
    x(x == 0) = 0.0001;
    x(x == 1) = 0.9999;
    s = sum(x);
    p = x ./ s;

    e = p .* log(p);
    E = - sum(e) / log(n); 
    w = (1 - E) ./ (m - sum(E));
    dz = zeros(1, n);
    df = zeros(1, n);
    for i = 1 : n
        for j = 1 : m
            dz(i) = dz(i) + (w(j) * (x(i, j) - 1)) .^ 2;
            df(i) = df(i) + (w(j) * (x(i, j) - 0)) .^ 2;
        end
        dz(i) = sqrt(dz(i));
        df(i) = sqrt(df(i));
    end

    r = dz ./ (dz + df);
    save('topsis_ans.mat', 'w', 'r')
end
