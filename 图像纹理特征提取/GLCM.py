import cv2 as cv
import numpy as np
import math
import common


class GLCM:
    # 读入图片转灰度图

    def __init__(self):
        cv.imwrite("d:/img.jpg",common.img)
        img = cv.resize(common.img, (128, 128))
        gry = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
        self.n, self.m = gry.shape  # 图片长宽
        self.gray_level = 256
        # 灰度等级，整张图的为256
        glcm = self.calc_glcm(gry, 0)
        cv.imwrite("d:/imgGray.jpg", glcm * 255)
        self.gray_level = 8  # 灰度等级，默认为8
        rec = 256 / self.gray_level
        for i in range(self.n):
            for j in range(self.m):
                gry[i][j] /= rec

        for i in range(0,8):
            ans = self.work(gry, i)
            cv.imwrite("d:/img" + str(i+1) + ".jpg", ans * 255)
        cv.waitKey(1)
        print('1')

    def calc_glcm(self, img, opt, d=1):  # Gray Level Co-occurrence Matrix 灰度共生矩阵
        # 默认步长d = 1，水平计算
        ret = np.zeros([self.gray_level, self.gray_level])
        # print(img)
        h = img.shape[0]
        w = img.shape[1]
        if opt != 7:
            for i in range(h):
                for j in range(w - d):
                    x = img[i][j]
                    y = img[i][j + d]
                    ret[x][y] += 1
        else:
            for i in range(h - d):
                for j in range(w):
                    x = img[i][j]
                    y = img[i + d][j]
                    ret[x][y] += 1
        ret /= ret.max()
        return ret

    def work(self, a, opt, win=5):
        pad = int(win / 2)
        ret = np.zeros([self.n, self.m])
        for i in range(pad, self.n - pad):
            for j in range(pad, self.m - pad):
                ag = self.calc_glcm(a[i - pad: i + pad + 1, j - pad: j + pad + 1], opt, )
                ret[i][j] = self.feature_computer(ag, opt)
        ret /= ret.max()
        return ret

    def feature_computer(self, a, opt):
        if opt == 0 or opt == 7:  # 均值
            return a.mean()
        if opt == 1:  # 标准差
            return a.std()
        Asm = 0.0  # 角二阶矩 Angular Second Moment (Energy)
        Ent = 0.0  # 熵
        Con = 0.0  # 对比度 Contrast
        Idm = 0.0  # 同质性
        for i in range(0,self.gray_level):
            for j in range(0,self.gray_level):
                Asm += a[i][j] ** 2
                Con += (i - j) ** 2 * a[i][j]
                if a[i][j] > 0:
                    Ent += a[i][j] * math.log(a[i][j])
                Idm += a[i][j] / (1 + (i - j) ** 2)

        if opt == 2 or opt == 5:  # 角二阶矩/ 能量
            return Asm
        if opt == 3:  # 熵
            return -Ent
        if opt == 4:  # 对比度
            return Con
        if opt == 6:  # 同质性
            return Idm
