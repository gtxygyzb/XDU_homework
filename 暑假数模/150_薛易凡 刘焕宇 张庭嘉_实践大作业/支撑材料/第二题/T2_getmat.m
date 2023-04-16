clc, clear

load('topsis_ans.mat')

x = xlsread('302_0-1.xls');

n = 302;
for i = 1:n
    if x(i, 1) < 0.5
        x(i, 1) = 0.0001;
    else
        x(i, 1) = 0.9999;
    end
end
rk = 3 - int32(x(:,2));
m = 7;
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
save('topsis2_ans.mat', 'w', 'r', 'rk')