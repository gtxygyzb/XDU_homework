%%
clc, clear
[x, Fs] = audioread('test.m4a'); % Fs为取样频率
x = x(:, 1)';  % 只对这个声道进行处理
sound(x, Fs)
%% 做出时域图
Ts = 1 / Fs;  % Ts为取样周期
tot = length(x);  % 音频总长度
t = 1:tot;
t = t * Ts;  % 做出时间轴
fig = figure;  % 建立画布
fig.Position(3:4) = [1000 300]; % 调整画布大小
plot(t, x) % 作图
xlabel('Time (seconds)') % 坐标轴标签
ylabel('Amplitude')
xlim([0 tot*Ts]) % 坐标轴范围

%% 声谱图
spectrogram(x,256,250,256, Fs,'xaxis')
xlim([0 5])
title('混声的声图谱')
%% 低通
[x, Fs] = audioread('test.m4a'); % Fs为取样频率
x = x(:, 1)';  % 只对这个声道进行处理
x = lowpass(x, 1700, Fs, 'Steepness',0.99);
audiowrite('lowpass.wav', x, Fs)

[x, Fs] = audioread('test.m4a'); % Fs为取样频率
x = x(:, 1)';  % 只对这个声道进行处理
lowpass(x, 1700, Fs, 'Steepness',0.99); % 绘图
xlim([0 5])
%% 带通
x = bandpass(x, [2500, 3500], fs);
audiowrite('bandpass.wav', x, Fs)