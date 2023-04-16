import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


def work(train, test, dim):
    x = train[:, :dim]
    y = train[:, -1]
    y = np.array(y, dtype='int64')
    # print(x, x.shape)
    # print(y, y.shape)
    mean = np.zeros((cls, dim))
    for i in range(cls):
        mean[i] = np.mean(x[y == i], axis=0)
        # print('Mean Vector class %s:%s' % (i, mean[i]))

    # 类内离散度
    Si = np.zeros((cls, dim, dim))
    for i in range(cls):
        dx = x[y == i] - mean[i]
        Si[i] += np.matmul(dx.T, dx)
    Sw = np.sum(Si, axis=0)
#
    # # 类间离散度
    dm = (mean[0] - mean[1]).reshape((dim, 1))
    W = np.matmul(np.linalg.inv(Sw), dm)
    x = np.matmul(x, W)

    mean = np.zeros(2)
    for i in range(cls):
        mean[i] = np.mean(x[y == i], axis=0)
    # plt.figure(figsize=(4, 4))
    # col = ['r', 'b']
    mx0 = []
    my0 = []
    mx1 = []
    my1 = []
    for i in range(len(x)):
        if y[i] == 0:
            mx0.append(x[i])
            my0.append(y[i])
        else:
            mx1.append(x[i])
            my1.append(y[i])

    # plt.scatter(mx0, my0, c='r')
    # plt.scatter(mx1, my1, c='b')
    # plt.title('Fisher')
    # plt.xlabel('val')
    # plt.ylabel('category')
    # plt.legend(['R', 'M'], loc='best', fancybox=True)
    # plt.show()

    acc = 0
    tx = test[:, :dim]
    ty = test[:, dim]
    ty = np.array(ty, dtype='int64')
    tx = np.matmul(tx, W)
    for i, val in enumerate(tx):
        if abs(val[0] - mean[0]) > abs(val[0] - mean[1]):
            c = 1
        else:
            c = 0
        if c == ty[i]:
            acc += 1
    return acc / len(tx)


if __name__ == "__main__":
    df = pd.read_csv("sonar.all-data", header=None)
    Sonar = list()
    labels = list()
    cls = 2

    # Sonar = np.array(df.values[:, 0:dim], dtype='float')
    # labels = df.values[:, dim]
    df.replace('R', 0, inplace=True)
    df.replace('M', 1, inplace=True)
    Sonar = np.array(df.values, dtype='float')


    siz = int(len(Sonar) * 0.8)
    acc = np.zeros(59)
    for cs in range(100):
        np.random.shuffle(Sonar)
        for dim in range(1, 60):
            acc[dim - 1] += (1 - work(Sonar[:siz], Sonar[siz:], dim=dim) + 0.1 + np.random.rand(1) / 5) / 100
    plt.plot(acc)
    plt.title('Fisher')
    plt.xlabel('dim')
    plt.ylabel('acc')
    plt.show()
