import pandas as pd
import numpy as np
import scipy.io as scio

if __name__ == '__main__':
    df = pd.read_excel('tag.xlsx', '企业信息')
    n = 302
    a = []
    for i in range(n):
        if "个体经营" in df.loc[i, "企业名称"]:
            a.append(1)
        else:
            a.append(0)
    typ = np.array(a)
    scio.savemat('./typ1.mat', {'typ': typ})
