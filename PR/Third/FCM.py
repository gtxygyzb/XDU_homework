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
    y = np.array(data[:, -1], dtype='int32')
    K = 2
    z = [0, 0]  # K个聚类中心

    U = np.random.rand(len(x), K)
    for i in range(len(x)):
        U[i] = U[i] / sum(U[i])

    J = 0
    a = 2  # 柔性参数
    epoch = 0
    ACC2 = list()
    ACC1 = list()
    while True:
        z_old = copy.copy(z)
        U_old = copy.copy(U)
        J_old = J
        # 计算新聚类中心
        for j in range(K):
            sum_ux = 0
            sum_u = 0
            for i in range(len(x)):
                sum_ux += (U[i][j] ** a) * x[i]
                sum_u += U[i][j] ** a
            z[j] = sum_ux / sum_u
        epoch += 1
        # 计算代价函数
        J = 0
        for j in range(K):
            for i in range(len(x)):
                J += (U[i][j] ** a) * (np.linalg.norm(z[j] - x[i]) ** 2)

        if abs(J - J_old) < 0.0001:
            break
        # 计算新矩阵U
        for i in range(len(x)):
            for j in range(K):
                sum_ud = 0
                for k in range(K):
                    sum_ud += ((np.linalg.norm(z[j] - x[i])) / (np.linalg.norm(z[k] - x[i])))\
                              ** (2 / (a - 1))
                U[i][j] = 1 / sum_ud

        # 计算第几蔟的实际标签是什么
        label_order = []
        for i in range(K):
            K_list = [0] * K
            for j in range(len(x)):
                if np.argmax(U[j]) == i:
                    K_list[y[j]] += 1
            label_order.append(K_list.index(max(K_list)))
        assert len(set(label_order)) == K, '出现了两类相同蔟！'

        un_label_order = [0] * K
        for i in range(K):
            un_label_order[label_order[i]] = i
        acc1 = 0
        for i in range(len(x)):
            if U[i][un_label_order[y[i]]] == max(U[i]):
                acc1 += 1
        acc1 /= len(x)
        ACC1.append(acc1)  # 归1分类

        acc2 = 0
        for i in range(len(x)):
            acc2 += U[i][un_label_order[y[i]]]
        acc2 /= len(x)
        ACC2.append(acc2)  # 模糊分类准确率

    plt.figure(figsize=(12, 5))
    px = np.arange(1, epoch).astype(dtype='str')
    plt.plot(px, ACC1, c='b')
    plt.plot(px, ACC2, c='r')
    plt.grid()
    plt.xlabel('epoch')
    plt.ylabel('acc')
    labels = ['Normalized classification', 'fuzzy classification']
    plt.legend(labels, loc='best', fancybox=True)
    # plt.savefig('FCM-SONAR.png')
    plt.show()


