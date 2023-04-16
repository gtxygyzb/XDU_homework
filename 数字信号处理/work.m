%%
clc, clear
syms t;
%% 三信号
S1t = exp(-abs(t));
F1 = fourier(S1t);
S2t = 10 * exp(-abs(t)) .* cos(5*t);
F2 = fourier(S2t);

Xat = S1t+S2t;
FXa = fourier(Xat);
%% 三信号时域图
figure(1);
fplot(S1t);
hold on
fplot(S2t);
fplot(Xat, 'Color', 'g');
axis([-5,5,-7.5,11.5]);
title('三信号时域波形');
xlabel('t');
legend('Sa_1', 'Sa_2', 'Xa')
grid on;
hold off

%% 三信号频域
figure(2);
fplot(F1);
hold on
fplot(F2);
fplot(FXa, 'Color', 'g');
axis([-15,0,0,13.5]);
title('三信号频域波形');
xlabel('ω');
legend('Sa_1', 'Sa_2', 'Xa')
grid on;
hold off
%% 采样得到s1/s2/xn
N = 100;
n = 0:1:N-1;
fs = 30;
Ts = 1/fs;
S1 = exp(-abs(n*Ts));
S2 = 10 * exp(-abs(n*Ts)) .* cos(5*n*Ts);
Xa = S1+S2;
S1k = abs(fft(S1,N)); 
S2k = abs(fft(S2,N)); 
Xak = abs(fft(Xa,N)); 

%% 三离散信号时域图
figure(3);
stem(n, S1, '.');
hold on
stem(n, S2, '.');
stem(n, Xa, '.', 'Color', 'g');
grid on; 
title('离散三信号时域波形');
xlabel('n');
legend('S_1', 'S_2', 'Xa')
hold off

%% 三离散信号频域
figure(4);
stem(n, S1k, '.');
hold on
stem(n, S2k, '.');
stem(n, Xak, '.', 'Color', 'g');
grid on; 
title('离散信号的频域波形');
xlabel('ω');
legend('S_1', 'S_2', 'Xa')
hold off


%% 滤波器
Wp = 3;
Ws = 7;
Rp = 20;
Rs = 40;
[N, Wc] = buttord(Wp, Ws, Rp, Rs, 's');
[B, A] = butter(N, Wc, 'low', 's');
[Bz, Az] = impinvar(B, A, fs); 
W = 0:0.001:50;
[H, W] = freqs(B, A, W);
phi = angle(H); 
H = 20 * log10(abs(H)); 
%% 滤波器画图
figure(5);
plot(W,H);
title('滤波器的幅频响应');
xlabel('w');
ylabel('|Hw|'); 
grid on;
 
figure(6)
plot(W,phi);
title('滤波器的相频响应');
xlabel('w');
ylabel('angle(Hw)');
grid on;

%% 滤波
yn = filter(Bz, Az, Xa); 
n = 0:length(yn)-1;
Yk=abs(fft(yn,length(yn)));

%% 滤波结果图 
figure(7)
plot(n, yn);
title('滤波之后的y_n时域波形'); 
xlabel('n');
ylabel('yn'); 
axis([0, length(n), -1, 5]);
grid on;
 
figure(8)
stem(n, Yk, '.');
title('滤波之后的y_n的频谱');
xlabel('w');
ylabel('Yk');
grid on;