clc % 继承上一步变量
nn = n - 100; m = 240;
k = 9; % 9个指标
x = zeros(nn, k);

x(:, 1) = sum(a1(d(:)==0, :), 2); % 总数
x(:, 2) = sum(a2(d(:)==0, :), 2);
x(:, 3) = max(a1(d(:)==0, :), [],  2); % 最大值
x(:, 4) = max(a2(d(:)==0, :), [], 2);

cs = 0;
for i = 1:402  % 平均值
    if d(i) == 1
        continue
    end
    cs = cs + 1;
    s1 = 0; s2 = 0;
    num = 0;
    for j = 1:m
        if a1(i, j) ~= 0
            s1 = s1 + a1(i, j);
            s2 = s2 + a2(i, j);
            num = num + 1;
        end
    end
    x(cs, 5) = s1 / num;
    x(cs, 6) = s2 / num;
end
cs = 0;
for i = 1:n  % 交货小于订货占总交易周数数的比
    if d(i) == 1
        continue
    end
    cs = cs + 1;
    s = 0; num = 0;
    for j = 1:m
        if a1(i, j) ~= 0  % 发生交易
            num = num + 1;
            if a2(i, j) < a1(i, j)
                s = s + 1;
                x(cs, 8) = x(cs, 8) + a1(i, j) - a2(i, j); %违约总金额
            end
        end
    end
    x(cs ,7) = s / num; % 计算比例
end
cs = 0;
for i = 1:n
    if d(i) == 1
        continue
    end
    cs = cs + 1;
    num = 0;
    for j = 1:m
        if a1(i, j) ~= 0 && a2(i, j) >= a1(i, j)  % 发生交易且供货量多了
            num = num + 1;
            x(cs, 9) = x(cs, 9) + a2(i, j)/a1(i, j);  % 累加比率
        end
    end
    x(cs, 9) = x(cs, 9) / num;  % 最后除以周数
end
m0 = mean(x(:,9));
%%
mx = max(x);
mi = min(x);
for j = 1 : k
    if j <= 6
        x(:, j) = (x(:, j) - mi(j)) / (mx(j) - mi(j));
    elseif j <= 8
        x(:, j) = (mx(j) - x(:, j)) / (mx(j) - mi(j));
    else
        for i = 1:nn
            if x(i, j) <= lim
                x(i, j) = 1;
            else
                x(i, j) = 1 - (m0 - x(i, j))/(m0 - mx(j));
            end
        end
    end
end
%%
x(x <= 0.0001) = 0.0001;
x(x >= 0.9999) = 0.9999;
s = sum(x);
p = x ./ s;
e = p .* log(p);
E = - sum(e) / log(n); 
w = (1 - E) ./ (k - sum(E))

%% 灰度模型
mx = 0; mi = inf;
for i = 1:nn
    for j = 1:k
        mx = max(mx, 1 - x(i, j));
        mi = min(mi, 1 - x(i, j));
    end
end
eta = zeros(nn, k);
for i = 1:nn
    for j = 1:k
        eta(i, j) = (mi + 0.5*mx)/(1 - x(i,j) + 0.5*mx);
    end
end
r = zeros(nn, 2);
cs = 0;
for i = 1:n
    if d(i) == 1
        continue
    end
    cs = cs + 1;
    r(cs, 1) = sum(w .* eta(cs,:));
    r(cs, 2) = i;
end
r = sortrows(r, 'descend');
writematrix(r, '第一问企业编号和分数.xlsx')