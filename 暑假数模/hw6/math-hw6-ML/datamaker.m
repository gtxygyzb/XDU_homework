clc, clear
n = 200;
p1 = rand(50, 2);
p1 = [p1; rand(50, 2) - ones(50, 2)];
p2 = rand(50, 2) - [zeros(50, 1), ones(50, 1)];
p2 = [p2; rand(50, 2) - [ones(50, 1), zeros(50, 1)]];

hold on
plot(p1(:, 1), p1(:, 2), 'ob')
p1(:, 3) = -ones(100 ,1);
plot(p2(:, 1), p2(:, 2), 'or')
p2(:, 3) = ones(100, 1);
p = [p1 ;p2];
hold off