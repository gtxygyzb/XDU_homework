import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import copy


if __name__ == "__main__":
    df = pd.read_csv("sonar.all-data", header=None)
    df.replace('R', 0, inplace=True)
    df.replace('M', 1, inplace=True)
    data = np.array(df.values, dtype='float')

    x = data[:, :-1]
    y = data[:, -1]

    K = 2
    z = []  # K个聚类中心

    idx = np.arange(0, len(x))
    np.random.shuffle(idx)
    for i in range(K):
        z.append(x[idx[i], :])

    epoch = 0
    ACC = list()
    while True:
        pre = copy.copy(z)
        clusters = [[] for i in range(K)]  # K个聚类蔟中包含的点
        for i in range(len(x)):
            dis = []  # 该点到K个中心的距离表
            for j in range(K):
                dis.append(np.linalg.norm(x[i] - z[j]))
            nearest = dis.index(min(dis))  # 找出距离其最近的聚类中心
            clusters[nearest].append(i)
        flag = True
        for i in range(K):
            cluster_mean = np.zeros(len(z[i]))
            for j in range(len(clusters[i])):
                cluster_mean += x[clusters[i][j]] / len(clusters[i])
            z[i] = cluster_mean
            if (z[i] != pre[i]).all():
                flag = False
        epoch += 1
        # 计算分类准确率
        acc = 0
        for i in range(K):
            label_list = []
            for j in range(len(clusters[i])):
                label_list.append(y[clusters[i][j]])
            true_label = []
            for j in range(K):
                true_label.append(label_list.count(j))
            acc += max(true_label)  # 选取数量最大的标签作为其标签

        acc /= len(y)
        ACC.append(acc)
        if flag:
            print('已找到聚类结果')
            break

    px = np.arange(1, epoch + 1).astype(dtype='str')
    plt.plot(px, ACC, c='r')
    plt.grid()
    plt.xlabel('epoch')
    plt.ylabel('acc')
    labels = ['kmeans']
    plt.legend(labels, loc='best', fancybox=True)
    # plt.savefig('KMEANS-SONAR.png')
    plt.show()
