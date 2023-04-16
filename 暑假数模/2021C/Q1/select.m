clc % 在前两问的代码基础上跑
c = readmatrix('附件1 近5年402家供应商的相关数据.xlsx', 'Sheet', '企业的订货量（m³）', 'Range', 'B2:B403');
ret1 = zeros(50, 241);
ret2 = zeros(50, 241);
sel = r(1:50, 2);
for i = 1:50
    ret1(i, 1) = c(i);
    ret2(i, 1) = c(i);
    ret1(i, 2:241) = a1(r(i, 2), :);
    ret2(i, 2:241) = a2(r(i, 2), :);
end
writematrix(ret1, '50家企业的各项信息.xlsx', 'Sheet', '1')
writematrix(ret2, '50家企业的各项信息.xlsx', 'Sheet', '2')