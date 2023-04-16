%% 建立线性时不变离散系统的差分方程和系统输入序列的数学模型，产生输入序列
clc, clear
y(1)=0;
y(2)=1;
m = 40;
x=ones(1,m); % 输入序列
%给定输入序列和系统初始状态的系统响应
for n=3:m  %直接带入差分方程求解系统输出
    y(n)=x(n)- 0.2*y(n-1) + 0.9*y(n-2); 
end

figure(1)
stem(1:m,y);
xlabel('n');
ylabel('y(n)');
grid on;
figure(2)
stem(1:m,x);
xlabel('n');
ylabel('x(n)');
xlim([1,m]);
ylim([-1,2]);
grid on;

%% 求解系统:单位脉冲响应
b = [1];
a = [1,-0.2,0.9];
n = [1:m]';
[h,t] = impz(b,a,n);
figure(3)
stem(t,h);
title('单位脉冲响应');
%% 使用卷积求解单位脉冲零状态响应
xn = [1,zeros(1,m/2)];
B = 1;
A=[1,-0.2,0.9];
xi = filtic(B,A,0);
hn = filter(B,A,xn,xi);
x = [1,zeros(1,m/2)];
vn = conv(x,hn);
n = 0:length(vn)-1;
figure(4)
stem(n, vn, '.');
title('使用卷积求解零状态单位脉冲响应');
xlabel('n');
ylabel('v(n)');