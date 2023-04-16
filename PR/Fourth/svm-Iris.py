import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn import svm


def work(num, typ):
    ker = 'rbf'
    if typ == 2:
        ker = 'linear'
    elif typ == 3:
        ker = 'poly'
    clf = svm.SVC(C=num / 10, kernel=ker)  # C:惩罚函数，默认是1
    # kernel：核函数，默认是rbf高斯核，可以是‘linear’, ‘poly’, ‘rbf’, ‘sigmoid’, ‘precomputed’
    clf.fit(train, train_label)
    c = clf.score(test, test_label)
    return c


if __name__ == "__main__":
    df = pd.read_csv("iris.data", header=None)

    df.replace('Iris-setosa', 0, inplace=True)
    df.replace('Iris-versicolor', 1, inplace=True)
    df.replace('Iris-virginica', 2, inplace=True)
    data = np.array(df.values, dtype='float')

    siz = 20
    train = data[range(0, 0+siz), :]
    train = np.vstack((train, data[range(50, 50+siz), :]))
    train = np.vstack((train, data[range(100, 100+siz), :]))

    test = data[range(0+siz, 50), :]
    test = np.vstack((test, data[range(50+siz, 100), :]))
    test = np.vstack((test, data[range(100+siz, 150), :]))

    train_label = train[:, -1]
    train = train[:, :-1]

    test_label = test[:, -1]
    test = test[:, :-1]
    print(train.shape, train_label.shape)
    print(test.shape, test_label.shape)
    ACC1 = list()
    ACC2 = list()
    ACC3 = list()
    epoch = 10
    for num in range(1, epoch + 1):
        ACC1.append(work(num, 1))
        ACC2.append(work(num, 2))
        ACC3.append(work(num, 3))
    px = np.arange(1, epoch + 1).astype(dtype='str')
    plt.plot(px, ACC1, c='r')
    plt.plot(px, ACC2, c='g')
    plt.plot(px, ACC3, c='b')
    plt.grid()
    plt.xlabel('epoch')
    plt.ylabel('acc')
    labels = ['rbf', 'linear', 'poly']
    plt.legend(labels, loc='best', fancybox=True)
    # plt.savefig('SVM-IRIS.png')
    plt.show()
