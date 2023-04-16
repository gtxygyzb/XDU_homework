clc, clear
a = readmatrix('ans4.txt');
id = readmatrix('第四问确定68家企业编号.xlsx', 'Range', 'A1:BP1');

dyz = readmatrix('附件A 订购方案数据结果.xlsx', 'Range', 'B7:B408');
n = 68;
%% 第一个表
clc
ret = zeros(402, 24);
for i = 1:n
    for j = 1:24
        ret(id(i), j) = a(i, j);
    end
end
dyz(isnan(dyz)) = 0;
for i = 1:402
    for j = 1:2
        ret(i, j) = max(ret(i, j), dyz(i));
    end
end
% ret(ret==0) = NaN;
% writematrix(ret, '附件A 订购方案数据结果.xlsx', 'Sheet', '问题4的订购方案结果', 'Range', 'B7:Y408')

%% 运输率排序
clc
b = readmatrix('附件2 近5年8家转运商的相关数据.xlsx', 'Range', 'B2:IG9');
% writematrix(b, 'lv.txt', 'Delimiter', ' ')
for i = 1:8
    cnt = 0; s = 0;
    for j = 1:240
        if b(i, j) > eps
            cnt = cnt + 1;
            s = s + b(i, j);
        end
    end
    me(i) = s / cnt;
end
    
yid = zeros(8, 2);
yid(:, 1) = me;
yid(:, 2) = 1:8;
yid = sortrows(yid);
% writematrix(yid, '8家转运商平均损失率与编号.xlsx')

%% 确认所有的企业
clc
tot = 0;
for i = 1:402
    p = 0;
    for j = 1:24
        if ret(i, j) > 0
            p = 1;
            break
        end
    end
    if (p > 0)
        tot = tot + 1;
        gh(tot) = i;
    end
end
gh

%% 运输方案的确定
clc
mp = yid(:,2);
abc = readmatrix('附件1 近5年402家供应商的相关数据.xlsx', 'Range', 'B2:B403');
fang = zeros(402, 8*24);
fei = 0;
sel = zeros(50, 24);
for w = 1:24
    yu = ones(8, 1) * 6000;
    xid = zeros(tot, 2);
    xid(:, 2) = gh(1:tot);
    cnt = 0;
    for i = 1:tot
        % 给供应商进行排序，按照购买数量/V_ABC
        xid(i, 1) = ret(gh(i), w);
        if abc(gh(i)) == 1
            V = 0.6;
        elseif abc(gh(i)) == 2
            V = 0.66;
        else
            V = 0.72;
        end
        xid(i, 1) = xid(i, 1) / V;
        if (xid(i, 1) > eps) % 统计订购企业数
            cnt = cnt + 1;
        end
    end
    xid = sortrows(xid, 'descend');
    xmp = xid(:, 2);
    for i = 1:tot
        for j = 1:8
            if yu(mp(j)) >= ret(xmp(i), w)
                yu(mp(j)) = yu(mp(j)) - ret(xmp(i), w);
                fang(xmp(i), (w-1)*8 + mp(j)) = ret(xmp(i), w);
                sel(xmp(i), w) = mp(j);
                break
            end
        end
    end
    for j = 1:8
        fei = fei + (6000 - yu(j)) * 0.2;
    end
end
fang(fang==0) = NaN;
writematrix(fang, '附件B 转运方案数据结果.xlsx', 'Sheet', '问题4的转运方案结果', 'Range', 'B7:GK408')
% writematrix(sel, 'tsel.txt', 'Delimiter', ' ')
% bf = readmatrix('cost3.txt');
% disp(['总费用:', num2str(mean(bf) + fei)])