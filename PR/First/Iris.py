import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import random


def work(Iris, test):
    print(len(Iris[0]))
    mean = np.zeros((cls, dim))
    for i in range(cls):
        mean[i] = np.mean(Iris[i], axis=0)
        print('Mean Vector class %s:%s' % (i, mean[i]))

    # 类内离散度
    Si = np.zeros((cls, dim, dim))
    for i in range(cls):
        for x in Iris[i]:
            dx = (x - mean[i]).reshape((dim, 1))
            Si[i] += np.matmul(dx, dx.T)
    Sw = np.sum(Si, axis=0)
    print("类内离散度 Sw: \n", Sw)

    # 类间离散度
    mu = np.mean(mean, axis=0)  # 总平均值
    Sb = np.zeros((dim, dim))
    for i in range(cls):
        dx = (mean[i] - mu).reshape((dim, 1))
        Sb += 50 * np.matmul(dx, dx.T)
    print("类间离散度 Sw: \n", Sb)

    eigvals, eigvecs = np.linalg.eig(np.linalg.inv(Sw) * Sb)  # 求特征值，特征向量
    np.testing.assert_array_almost_equal(np.mat(np.linalg.inv(Sw) * Sb) * np.mat(eigvecs[:, 0].reshape(4, 1)),
                                         eigvals[0] * np.mat(eigvecs[:, 0].reshape(4, 1)), decimal=6, err_msg='',
                                         verbose=True)
    # sorting the eigenvectors by decreasing eigenvalues
    eig_pairs = [(np.abs(eigvals[i]), eigvecs[:, i]) for i in range(len(eigvals))]
    eig_pairs = sorted(eig_pairs, key=lambda k: k[0], reverse=True)
    W = np.hstack((eig_pairs[0][1].reshape(dim, 1), eig_pairs[1][1].reshape(dim, 1)))
    print("求得的权值:\n", W)

    for i in range(cls):  # 数据降维
        Iris[i] = np.dot(Iris[i], W)  # 注意shape为(150, 2) X是行向量

    mean = np.zeros((3, 2))
    for i in range(cls):
        mean[i] = np.mean(Iris[i], axis=0)

    acc = 0
    for i in range(cls):
        test[i] = np.dot(test[i], W)
        for p in test[i]:
            dis = []
            for j in range(cls):
                dis.append(np.sum((p - mean[j]) * (p - mean[j])))
            mx = dis.index(min(dis))
            if mx == i:
                acc += 1

    acc = acc / (cls * len(test[0]))

    plt.figure(figsize=(4, 4))
    col = ["r", "g", "b"]
    for i in range(cls):
        px = list()
        py = list()
        for p in Iris[i]:
            px.append(p[0])
            py.append(p[1])
        plt.scatter(px, py, c=col[i])

    plt.title('my LDA')
    plt.xlabel('LD1')
    plt.ylabel('LD2')
    plt.legend(labels, loc='best', fancybox=True)
    plt.show()
    
    return acc


if __name__ == "__main__":
    df = pd.read_csv("iris.data", header=None)
    Iris = list()
    labels = list()
    cls = 3  # 3类
    dim = 4  # 4维

    for i in range(cls):
        Iris.append(np.array(df.values[i * 50: (i + 1) * 50, 0:4], dtype='float'))
        labels.append(df.values[i * 50, 4])
    print(labels)

    for i in range(cls):  # 随机打乱
        lis = [i for i in range(50)]
        random.shuffle(lis)
        Iris[i] = [Iris[i][j] for j in lis]

    siz = 40  # 训练集测试集 8 : 2
    train = list()
    test = list()
    for i in range(cls):
        train.append(Iris[i][:siz])
        test.append(Iris[i][siz:50])

    acc = work(train, test)
    print("acc: ", acc * 100, "%")
