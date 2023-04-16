clc, clear
a = readmatrix('ans2.txt');
id = readmatrix('第一问企业编号和分数.xlsx', 'Range', 'B1:B50');

%% 第一个表
ret = zeros(402, 24);
for i = 1:50
    for j = 1:24
        ret(id(i), j) = a(i, j);
    end
end
ret(ret==0) = NaN;
writematrix(ret, '附件A 订购方案数据结果.xlsx', 'Sheet', '问题2的订购方案结果', 'Range', 'B7:Y408')

%% 运输率排序
clc
b = readmatrix('附件2 近5年8家转运商的相关数据.xlsx', 'Range', 'B2:IG9');
writematrix(b, 'lv.txt', 'Delimiter', ' ')
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

%% 运输方案的确定
clc
mp = yid(:,2);
abc = readmatrix('50家企业的各项信息.xlsx', 'Range', 'A1:A50');
mx = 0;
fang = zeros(402, 8*24);
fei = 0;
sel = zeros(50, 24);
for w = 1:24
    yu = ones(8, 1) * 6000;
    xid = zeros(50, 2);
    xid(:, 2) = 1:50;
    cnt = 0;
    for i = 1:50
        % 给供应商进行排序，按照购买数量/V_ABC
        xid(i, 1) = a(i, w);
        if abc(i) == 1
            V = 0.6;
        elseif abc(i) == 2
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
    for i = 1:50
        for j = 1:8
            if yu(mp(j)) >= a(xmp(i), w)
                yu(mp(j)) = yu(mp(j)) - a(xmp(i), w);
                fang(id(xmp(i)), (w-1)*8 + mp(j)) = a(xmp(i), w);
                sel(xmp(i), w) = mp(j);
                break
            end
        end
    end
    for j = 1:8
        fei = fei + (6000 - yu(j)) * 0.2;
    end
    if w == 1
        disp(['第一周供应商数量', num2str(cnt)]);
    else
        mx = max(mx, cnt);
    end
end
disp(['其余周至少需要的供应商数量', num2str(mx)]);
fang(fang==0) = NaN;
writematrix(fang, '附件B 转运方案数据结果.xlsx', 'Sheet', '问题2的转运方案结果', 'Range', 'B7:GK408')
writematrix(sel, 'tsel.txt', 'Delimiter', ' ')
bf = readmatrix('cost2.txt');
disp(['总费用:', num2str(mean(bf) + fei)])