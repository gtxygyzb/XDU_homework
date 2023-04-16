clc, clear

load data.mat
load basic.mat

wc = 5200 * 10^3;
wa = 4500 * 10^3;

Se = 5.10083042*10^14;

n1 = 2*pi*(r1+r2)*wc / Se;
n2 = 2*pi*(r1+r2)*wa / Se;
disp(['按中国宽度，相当于多少倍地球表面积:', num2str(n1)])
disp(['按美国宽度，相当于多少倍地球表面积:', num2str(n2)])