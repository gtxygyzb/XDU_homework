clc, clear

f = @(x)x^12 - 1;
l = 0; r = 2;
step = 10;  % 做10步逼近
error = zeros(step, 5);  % 5种方法误差
disp(['f(l) * f(r) = ', num2str(f(l)*f(r))])

syms x
df = matlabFunction(diff(f(x))); %求导
% 逐步搜索
a = l; b = r;
for i = 1:step
    h = (b - a) / 5;
    c = a + h;
    error(i, 1) = f(c);
    if f(c) == 0
        break;
    elseif f(c)*f(b) < 0
        a = c;
    else
        b = c;
    end
end
% 二分
a = l; b = r;
for i = 1:step
    c = (a + b) / 2;
    error(i, 1) = f(c);
    if f(c) == 0
        break;
    elseif f(c)*f(b) < 0
        a = c;
    else
        b = c;
    end
end
% 比例求根
a = l; b = r;
for i = 1:step
    c = a - f(a)/(f(a) - f(b)) * (a-b);
    error(i, 3) = f(c);
    if f(c) == 0
        break;
    elseif f(c)*f(b) < 0
        a = c;
    else
        b = c;
    end
end
% 牛顿法
c = r;
for i = 1:step
    c = c - f(c)./df(c);
    error(i, 4) = f(c);
    if f(c) == 0
        break;
    end
end
% 弦截法
c = l;
d = r;
for i = 1:step
    tmp = d;
    d = d - f(d) *(c-d)/(f(c)-f(d));
    c = tmp;
    error(i, 5) = f(d);
    if f(c) == 0
        break;
    end
end
error = abs(error);
hold on
plot(1:step, error(:, 1), 'r.-');
plot(1:step, error(:, 2), 'g.-');
plot(1:step, error(:, 3), 'b.-');
plot(1:step, error(:, 4), 'y.-');
plot(1:step, error(:, 5), 'k.-');
legend('逐步', '二分', '比例', '牛顿', '弦截')
set(gca, 'YLim', [0, 5]);
hold off
