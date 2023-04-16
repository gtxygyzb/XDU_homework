clear,clc;

rgb = imread('Lenna.png');
rgb = imresize(rgb, 0.5, 'nearest');
A = rgb2gray(rgb);
disp(['原图秩：', num2str(rank(double(A)))])
[n , m] = size(A);
p = 5000;  % 噪点数量
id = randperm(n * m);
a = A;
a(id(1:p)) = inf;
infa = a;
imshow(a, [0,255]);

%%
clc
% A为nxm，B为nxr, C为rxm
r = 5; % 假设秩为5
a = double(a);
A = double(A);
x0 = randi(16, n+m, r);
% 非线性最小二乘法
fun = @(x)fmatrix(x, n, m, A);
% x = lsqnonlin(fun, x0);

A_Recover = round(x(1:n, :) * x(n+1:n+m, :)');
a(id(1:p)) = A_Recover(id(1:p));
imshow(a, [0,255]);

function y = fmatrix(x, n, m, a)
y = a - x(1:n, :) * x(n+1:n+m, :)';
y(y == inf) = 0;
end
