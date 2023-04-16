%%
clc, clear
[x, Fs] = audioread('media.wav'); % Fs为取样频率
x = x(:, 1)';  % 只对这个声道进行处理
audiowrite('media_channel.wav', x, Fs) %保存音频
%% 做出时域图
Ts = 1 / Fs;  % Ts为取样周期
tot = length(x);  % 音频总长度
t = 1:tot;
t = t * Ts;  % 做出时间轴
fig = figure;  % 建立画布
len = 5000; % 取前5000个点
fig.Position(3:4) = [1000 300]; % 调整画布大小
plot(t(1:len), x(1:len)) % 作图
xlabel('Time (seconds)') % 坐标轴标签
ylabel('Amplitude')
xlim([0 len*Ts]) % 坐标轴范围

%%
y = fft(x); % 傅里叶变换
f = (0:length(y)-1)*Fs/length(y); % 频率轴

plot(f,abs(y)) % 作图
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Magnitude')

%%
y = fft(x);
for i = 60000:length(y)
    y(i) = 0;
end
plot(f,abs(y))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Magnitude')

x1 = ifft(y, 'symmetric');
sound(x1, Fs)
audiowrite('noise_reduction.wav', x1, Fs)