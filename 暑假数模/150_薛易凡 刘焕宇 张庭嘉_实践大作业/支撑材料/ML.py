import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from xgboost import XGBClassifier as Xg
from sklearn.neural_network import MLPClassifier
import joblib


def dtgs_search():
    par = {"criterion": ("gini", "entropy"),
           "splitter": ("best", "random"),
           "max_depth": [*range(1, 12)],
           "min_samples_leaf": [*range(1, 10, 1)]}
    gclf = DecisionTreeClassifier(random_state=25)
    gs = GridSearchCV(gclf, par, cv=10)
    gs.fit(Xtrain, Ytrain)
    print(gs.best_params_)
    print(gs.best_score_)


def rf():
    rfc = RandomForestClassifier(n_estimators=15, random_state=10,
                                 max_depth=8,
                                 criterion="gini")
    rfc.fit(Xtrain, Ytrain)
    # joblib.dump(rfc, './models/rf.pkl')
    return work(rfc)


def work(clf):
    score_tr = clf.score(Xtrain, Ytrain)
    score_te = cross_val_score(clf, x, y, cv=10).mean()
    print(score_tr, score_te)
    xdf = pd.read_excel('302_0-1.xls')
    xp = xdf.iloc[:, xdf.columns != "等级"]
    xp = xp.iloc[:, xp.columns != "违约"]
    pred = clf.predict(xp)
    return pred


def svm():
    svc = SVC(C=5, kernel="rbf", cache_size=2000, probability=True)
    svc.fit(Xtrain, Ytrain)
    joblib.dump(svc, './models/svc.pkl')
    return work(svc)


def xg():
    clf = Xg(eval_metric='auc', subsample=0.7, objective='multi:softmax',
             n_estimators=5, use_label_encoder=False,
             num_class=5,
             max_depth=6)
    clf.fit(Xtrain, Ytrain)
    joblib.dump(clf, './models/xg.pkl')
    return work(clf)


def nn():
    nw = MLPClassifier(solver='lbfgs', activation='logistic', hidden_layer_sizes=(10, 6, 4))
    nw.fit(Xtrain, Ytrain)
    return work(nw)


if __name__ == '__main__':
    df = pd.read_excel('123_0-1.xls')
    x = df.iloc[:, df.columns != "等级"]
    x = x.iloc[:, x.columns != "违约"]
    y = df.iloc[:, df.columns == "等级"]
    y *= 3
    y += 0.5
    y.loc[:, "等级"] = y.loc[:, "等级"].astype(int)
    Xtrain, Xtest, Ytrain, Ytest = train_test_split(x, y, test_size=0.3)
    for i in [Xtrain, Xtest, Ytrain, Ytest]:
        i.index = range(i.shape[0])
    print(rf())
