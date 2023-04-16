clc, clear

format long

syms x
a = int(log(x), 1, 2)
a = double(a)  % 标准答案

% 三种积分方式，不同积分次数相对误差的函数
cs = 1:10
for i = 1:10
    f1(i) = abs(Tn(1, 2, i) - a) / a;
    f2(i) = abs(Sn(1, 2, i) - a) / a;
    f3(i) = abs(Cn(1, 2, i) - a) / a;
end

plot(cs, f1(cs), 'r');
hold on
plot(cs, f2(cs), 'g');
plot(cs, f3(cs), 'b');
hold off


function f = f(x)
    format long
    f = log(x);
end

function Tn = Tn(a, b, n)  % 复梯形求积
   format long
   h = (b - a) ./ n;
   sum = 0;
   for k = 1:n-1
       sum = sum + f(a + k .* h);
   end
   Tn = (f(a) + 2 * sum + f(b)) * h / 2;
end

function Sn = Sn(a, b, n)  % 复simpson
    format long
    h = (b-a) ./ n;
    sum1 = 0;
    sum2 = 0;
    for i = 0:n-1  % 4倍的(a+b)/2
        sum1 = sum1 + f(a+(i+1/2).*h);
    end
    for j = 1:n-1  % 两倍的a,b
        sum2 = sum2 + f(a+j.*h);
    end
    Sn = h/6 .* (f(a) + 4*sum1 + 2*sum2 + f(b));
end

function Cn = Cn(a, b, n)  % 复cotes
    format long
    h = (b-a) ./ n;
    sum1 = 0;
    sum2 = 0;
    for i = 0:n-1
        sum1 = sum1 + 32 * f(a + h .* (i+0.25)) + 12 * f(a + h .* (i+0.5)) + 32 * f(a + h .* (i+0.75));
    end
    for j = 1:n-1  % 14倍的a,b
        sum2 = sum2 + 14 * f(a+j.*h);
    end
    Cn = h/90 * (7*f(a) + sum1 + sum2 + 7*f(b));
end
    