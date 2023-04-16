clc, clear
a = readmatrix('cost4.txt');
plot(a(:, 1), a(:, 2))
xlabel('生产量提升倍数')
ylabel('平均最大材料供应费用')
