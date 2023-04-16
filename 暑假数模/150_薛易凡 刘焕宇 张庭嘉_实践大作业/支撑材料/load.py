import pandas as pd
import numpy as np
import scipy.io as scio


def check_null(d):  # 缺失值判断
    ck = np.any(d.isnull().values)
    print('信息缺失值判断:', ck)
    return ck


if __name__ == '__main__':
    fname = '302'
    df_i = pd.read_excel(fname + '.xlsx', '企业信息')
    df_b = pd.read_excel(fname + '.xlsx', '进项发票信息')
    df_s = pd.read_excel(fname + '.xlsx', '销项发票信息')
    dlis = [df_b, df_s, df_i]
    for df in dlis:
        df = df.loc[:, ~df.columns.str.contains('Unnamed')]
        if check_null(df):  # 缺失值判断
            df.dropna(axis=0, inplace=True)
            print('已删除缺失发票')

    rk = {}
    y = []
    if fname == '123':
        for i in range(0, df_i.shape[0]):
            a = df_i.iloc[i].values
            rk[a[0]] = ord(a[2]) - 65  # A-D : 0 1 2 3
            y.append(1 if a[3] == '是' else 0)
        y = np.array(y)

    tot = {}
    totn = {}
    sum89 = [{}, {}]
    sumb = [{}, {}]
    has = [{}, {}]
    num = [{}, {}]
    for t in range(0, 2):  # 0_buy 1_sell
        df = dlis[t]
        for i in range(0, df.shape[0]):
            val = df.iloc[i].values
            name = val[0]

            if name not in tot:
                tot[name] = 0
            tot[name] += 1

            if name not in totn:
                totn[name] = 0
            totn[name] += int(val[4] == "作废发票" or val[3] < 0)

            if val[4] == "作废发票":
                continue

            if name not in num[t]:
                num[t][name] = 0
            if name not in has[t]:
                has[t][name] = {}
            if val[2] not in has[t][name]:
                has[t][name][val[2]] = 1
                num[t][name] += 1

            if name not in sumb[t]:
                sumb[t][name] = 0
            sumb[t][name] += val[3]

            year = int((str(val[1]).split('-'))[0]) - 2018
            if 0 <= year <= 1:
                if name not in sum89[t]:
                    sum89[t][name] = [0 for i in range(0, 2)]
                sum89[t][name][year] += val[3]

    tot = np.array(list(tot.values()))  # 总发票数
    totn = np.array(list(totn.values()))  # 取消的交易数量
    num0 = np.array(list(num[0].values()))  # 上游关系企业数量
    num1 = np.array(list(num[1].values()))  # 下游关系企业数量

    tmp0 = list(sumb[0].values())
    tmp1 = list(sumb[1].values())
    sumb = np.array(list(zip(tmp0, tmp1)))  # 总买/卖销售额

    sum0 = np.array(list(sum89[0].values()))  # 18/19年买入总额
    sum1 = np.array(list(sum89[1].values()))  # 18/19年卖出总额

    scio.savemat('./' + fname + '.mat', {'tot': tot, 'totn': totn, 'num0': num0, 'num1': num1,
                                         'sumb': sumb, 'sum0': sum0, 'sum1': sum1})
    if fname == '123':
        rk = np.array(list(rk.values()))
        scio.savemat('./' + fname + '.mat', {'tot': tot, 'totn': totn, 'num0': num0, 'num1': num1,
                                             'sumb': sumb, 'sum0': sum0, 'sum1': sum1, 'y': y, 'rk': rk})
