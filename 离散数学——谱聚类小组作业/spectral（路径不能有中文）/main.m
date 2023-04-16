clc, clear, clf
load('twoCircles.mat')
d = A; % 读入数据
d = d / max(max(abs(d))); % 0/1规范化
k = 2; % 分为两类
sigma = 0.1; % 高斯核函数超参数
dis = pdist(d); % 计算欧氏距离
W = squareform(dis); % 整理成邻接矩阵
C = spectral(W, sigma, k);

plot(d(C==1,1),d(C==1,2),'r.', d(C==2,1),d(C==2,2),'b.');
