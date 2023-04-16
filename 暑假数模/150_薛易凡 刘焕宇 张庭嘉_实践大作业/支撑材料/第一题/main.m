clc, clear, clf
load('A.mat')
d = A; % 读入数据
d = d / max(max(abs(d))); % 0/1规范化
k = 9; % 分为两类
sigma = 0.1; % 高斯核函数超参数
dis = pdist(d); % 计算欧氏距离
W = squareform(dis); % 整理成邻接矩阵
C = spectral(W, sigma, k);

n = 302;
for i = 1 : n
    if A(i, 1) > 0.6
        c(i) = 9;
    elseif A(i, 1) < 0.45
        if A(i, 2) < 0.15
            c(i) = 1;
        elseif A(i, 2) < 0.3
            c(i) = 2;
        elseif A(i, 2) < 0.5
            c(i) = 5;
        else
            c(i) = 7;
        end
    else
        if A(i, 2) < 0.15
            c(i) = 3;
        elseif A(i, 2) < 0.3
            c(i) = 4;
        elseif A(i, 2) < 0.5
            c(i) = 6;
        else
            c(i) = 8;
        end
    end
end

plot(A(c==1,1),A(c==1,2),'rx', A(c==2,1),A(c==2,2),'bx',...
     A(c==3,1),A(c==3,2),'gx',...
     A(c==4,1),A(c==4,2),'cx', A(c==5,1),A(c==5,2),'mx',...
     A(c==6,1),A(c==6,2),'mx',...
     A(c==7,1),A(c==7,2),'kx', A(c==8,1),A(c==8,2),'rx',...
     A(c==9,1),A(c==9,2),'gx', 'MarkerSize', 10);
xlabel('企业规模')
ylabel('企业类型')
save('q3final.mat', 'c')