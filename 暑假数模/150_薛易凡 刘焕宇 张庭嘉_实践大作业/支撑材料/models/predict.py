import joblib
import numpy as np
import pandas as pd


if __name__ == '__main__':
    m = list()
    m.append(joblib.load('./nn.pkl'))
    m.append(joblib.load('./rf.pkl'))
    m.append(joblib.load('./svc.pkl'))
    m.append(joblib.load('./xg.pkl'))
    xdf = pd.read_excel('302_0-1.xls')
    xp = xdf.iloc[:, xdf.columns != "等级"]
    xp = xp.iloc[:, xp.columns != "违约"]
    ans = list()
    for model in m:
        ans.append(model.predict(xp).tolist())
    n = len(ans[0])
    data = []
    for i in range(0, n):
        cnt = np.zeros(4)
        for j in range(0, 4):
            cnt[ans[j][i]] += 1
            if ans[j][i] == 1:
                cnt[1] += 1
        for j in range(0, 4):
            if cnt[j] >= 2:
                data.append(j)
                break
    xdf["等级"] = data
    xdf.to_excel('final.xls')
