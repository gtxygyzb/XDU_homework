import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

def read(path, label, siz=50):
    df = pd.read_csv(path)
    data = df.values
    np.random.shuffle(data)
    if label:
        np.random.shuffle(data)
    n = len(data)
    if label:
        x = data[:, 1:].reshape(n, 28 * 28)
        x = x.astype("float32")
        y = data[:, 0].reshape(n)

        retx = np.zeros((siz * 10, 28 * 28))
        rety = np.zeros(siz * 10)

        cnt = np.zeros(10)
        top = 0
        for i, vec in enumerate(x):
            if cnt[y[i]] == siz:
                continue
            retx[top] = vec
            rety[top] = y[i]
            top += 1
            if top == siz * 10:
                break
        rety = rety.astype("int32")
        return retx, rety

    else:
        x = data.reshape(n, 28 * 28)
        x = x.astype("float32")
        return x


def getdis(x, y, typ=0):
    if typ == 0:  # 欧氏距离
        return np.linalg.norm(x - y, ord=2)
    elif typ == 1:  # 曼哈顿距离
        return np.linalg.norm(x - y, ord=1)
    elif typ == 2:  # 切比雪夫距离
        return np.linalg.norm(x - y, ord=np.inf)
    elif typ == 3:  # 余弦距离
        a_norm = np.linalg.norm(x)
        b_norm = np.linalg.norm(y)
        similiarity = np.dot(x, y.T) / (a_norm * b_norm)
        dist = 1. - similiarity
        return dist

def knn(typ=0):  # 默认欧氏距离
    dis = np.zeros((len(x_test), len(x_train)))
    idx = np.zeros((len(x_test), len(x_train)), dtype='int32')

    for i, u in enumerate(x_test):
        for j, v in enumerate(x_train):
            dis[i, j] = getdis(u, v, typ)
        idx[i] = np.argsort(dis[i])  # 从小到大的下标

    ACC = list()

    for k in range(1, kmax):
        acc = 0
        for i in range(len(x_test)):
            cnt = np.zeros(10)
            for j in range(k):  # 前k小的投票
                cnt[y_train[idx[i][j]]] += 1
            ans = np.argmax(cnt)
            if ans == y_test[i]:
                acc += 1
        acc /= len(x_test)
        ACC.append(acc)
    print(ACC)
    return ACC


if __name__ == "__main__":
    siz = 1000
    valid = int(siz * 9)
    x, y = read("./train.csv", label=True, siz=siz)  # 每类照片1000张
    x_train, y_train = x[:valid], y[: valid]
    x_test, y_test = x[valid:], y[valid:]

    kmax = 51
    ACC1 = knn(typ=0)
    ACC2 = knn(typ=1)
    ACC3 = knn(typ=2)
    ACC4 = knn(typ=3)

    px = range(1, kmax)
    col = ["r", "g", "b", "y"]
    plt.figure(figsize=(6, 4))
    plt.plot(px, ACC1, c=col[0])
    plt.plot(px, ACC2, c=col[1])
    plt.plot(px, ACC3, c=col[2])
    plt.plot(px, ACC4, c=col[3])

    plt.title('KNN')
    plt.xlabel('K')
    plt.ylabel('ACC')
    labels = ['Euclidean distance', 'Manhattan Distance', 'Chebyshev distance', 'Cosine Dsitance']
    plt.legend(labels, loc='best', fancybox=True)
    plt.show()
