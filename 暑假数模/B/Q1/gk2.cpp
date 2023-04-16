#include <bits/stdc++.h>
using namespace std;

const int n = 15; //简化后节点数
const int M = 1200;  //负重上限
const int day = 30; //30天
const int c0 = 10000;  //初始资金
const int c1 = 5, c2 = 10;  //水和食物的基准价格
const int m1 = 3, m2 = 2;  //水和食物的每箱质量

int etop, head[n + 1];
struct Edge
{
    int v, nxt;
}e[n * n];
void add(int u, int v)
{
    e[++etop].v = v;
    e[etop].nxt = head[u];
    head[u] = etop;
}
void adds(int u, int v) {add(u, v); add(v, u);}
int pv[n+1], pm[n+1]; //是否为村庄、矿山
int mp[] = {0, 1, 2, 3, 4, 5, 13, 22, 30, 39, 47, 55, 56, 62, 63, 64}; //映射
int ed = 15; //15为终点
void build_G()
{
    for (int i = 1; i <= 14; i++)
        if (i != 12) adds(i, i + 1);
    adds(10, 12);
    adds(11, 13);
    adds(11, 14);
    adds(12, 14);
    adds(12, 15);
    pv[9] = pv[13] = 1;
    pm[8] = pm[11] = 1;
}
//晴朗0 高温1 沙暴2
int wt[] = {1, 1, 0, 2, 0, 1, 2, 0, 1, 1,
            2, 1, 0, 1, 1, 1, 2, 2, 1, 1,
            0, 0, 1, 0, 2, 1, 0, 0, 1, 1};
int r1[] = {5, 8, 10}, r2[] = {7, 6, 10}; // 基础消耗量
int mny = 1000; //挖矿收益

struct Data
{
    char i, j;
    short k, l;
    Data () {}
    Data (char _i, char _j, short _k, short _l)
    {
        i = _i, j = _j, k = _k, l = _l;
    }
}p[day + 1][n + 1][M/m1 + 1][M/m2 + 1]; //path

short f[day + 1][n + 1][M/m1 + 1][M/m2 + 1];

void mx(int ni, int nj, int nk, int nl, int i, int j, int k, int l, int val=0)
{
    if (nk < 0 || nl < 0) return ;
    if (f[ni][nj][nk][nl] < f[i][j][k][l] + val)
    {
        f[ni][nj][nk][nl] = f[i][j][k][l] + val;
        p[ni][nj][nk][nl] = Data(i, j, k, l);
    }
}
int v1 = M / m1;
void buy(int d, int u, int k, int l)
{
    for (int ak = 0;; ak++) //买ak箱水
    {
        int tmp1 = (k + ak) * m1 + l * m2;
        if (tmp1 > M) break; //超出负重上限
        for (int al = 0;; al++) //买al箱食物
        {
            if (ak == 0 && al == 0) continue;
            int tmp2 = al * m2;
            if (tmp1 + tmp2 > M || f[d][u][k][l] - 2*ak*c1 - 2*al*c2 < 0) //超出负重或钱不够用
                break;
            mx(d, u, k + ak, l + al, d, u, k, l, - 2*ak*c1 - 2*al*c2); //当前层的更新
        }
    }
}

const int N = 1e5 + 50;
short ans[N], tot = 0;
Data ansp[N];
void get_ans()
{
    short mxans = -1;
    Data st;
    for (int i = 1; i <= 30; i++)
        for (int k = 0; k <= v1; k++)
        {
            int lim = (M - k * m1) / m2;
            for (int l = 0; l <= lim; l++)
            {
                if (f[i][ed][k][l] > mxans)
                {
                    mxans = f[i][ed][k][l] + k*c1/2 + k*c2/2;
                    st = Data(i, ed, k, l);
                }
            }
        }
    while (st.i)
    {
        ansp[++tot] = st;
        ans[tot] = f[st.i][st.j][st.k][st.l];
        st = p[st.i][st.j][st.k][st.l];
    }
    reverse(ans + 1, ans + tot + 1);
    reverse(ansp + 1, ansp + tot + 1);
    for (int i = 1; i <= tot; i++)
    {
        Data u = ansp[i];
        printf("%d %d %d %d %d\n", u.i, mp[u.j], ans[i], u.k, u.l);
    }
}

int main()
{
    freopen("gk2.out", "w", stdout);
    build_G(); //建图
    memset(f, -0x3f, sizeof(f)); //不可达状态设为 -inf
    for (int k = 0; k <= v1; k++) //带多少箱水
    {
        int lim = (M - k * m1) / m2;  //最多还能带多少箱食物
        for (int l = 0; l <= lim; l++)
            f[0][1][k][l] = c0 - k*c1 - l*c2; //初值
    }

    for (int w, d = 0; d < day; d++) //天
    {
        w = wt[d]; //当前天气
        for (int u = 1; u <= n; u++) //当前点
        {
            if (pv[u]) //当前位于村庄
                for (int k = 0; k <= v1; k++)
                {
                    int lim = (M - k * m1) / m2;
                    for (int l = 0; l <= lim; l++)
                    {
                        if (f[d][u][k][l] < 0) continue;
                        buy(d, u, k, l);
                    }
                }

            for (int k = 0; k <= v1; k++)
            {
                int lim = (M - k * m1) / m2;
                for (int l = 0; l <= lim; l++)
                {
                    if (f[d][u][k][l] < 0) continue; //当前状态不合法，跳过
                    mx(d + 1, u, k - r1[w], l - r2[w], d, u, k, l); //1. 停
                    if (w != 2) //不是沙暴
                        for (int v, i = head[u]; i; i = e[i].nxt) //2. 移动
                        {
                            v = e[i].v; //下一个点
                            mx(d + 1, v, k - (r1[w]<<1), l - (r2[w]<<1), d, u, k, l); //两倍消耗
                        }
                    if (pm[u]) //当前位于矿场
                        mx(d + 1, u, k - 3 * r1[w], l - 3 * r2[w], d, u, k, l, mny); //3.挖矿
                }
            }
        }
    }
    get_ans();
    return 0;
}