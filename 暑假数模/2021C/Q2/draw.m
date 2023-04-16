clc, clear
y = readmatrix('5line.txt');

hold on
for i = 1:5
    plot(1:24, y(i,:), '-o', 'MarkerSize', 2)
end
p1 = plot(0:25, ones(26, 1) * 28200 * 2, '--', 'LineWidth',2);
p2 = plot(0:25, ones(26, 1) * 28200 * 1.75, '--', 'LineWidth',2);

xlabel('周数')
ylabel('仓储生产力（m³）')
axis([0 , 25, 35000, 70000])

lgd = legend([p1, p2], '两倍库存量','通过线', 'Location','southeast','NumColumns',2);
hold off