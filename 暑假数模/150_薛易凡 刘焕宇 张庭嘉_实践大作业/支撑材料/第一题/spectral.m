function C = spectral(W, sigma, k)
% 谱聚类算法
% W : 邻接矩阵
% sigma : 高斯核函数参数
% k : 分类数
% 返回值C : 聚类结果, N * 1 矩阵
W = W .* W;
W = - W / (2 * sigma^2);
W = exp(W);

% 高斯核函数RBF计算W与相似矩阵S相同
n = size(W, 1);
D = zeros(n, n);
for i = 1:n
    D(i, i) = sum(W(:, i)); 
end
% 获得度矩阵D 将一列和加起来放在对角线上
L = D - W;
L = D^(-1/2) * L * D^(-1/2);
% 计算拉普拉斯矩阵并规范化
[V, ~] = eigs(L, k, 'smallestabs'); % 计算最小的特征值对应的特征向量
C = kmeans(V, k);


 