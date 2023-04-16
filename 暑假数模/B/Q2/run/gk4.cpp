#include <bits/stdc++.h>
using namespace std;

const int n = 10; //简化后节点数
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
int ed = 10; //10为终点
void build_G()
{
    for (int i = 1; i <= 9; i++)
        if (i != 6) adds(i, i + 1);
    adds(5, 7);
    adds(6, 8);
    pm[7] = 1;
    pv[6] = 1;
}
//晴朗0 高温1 沙暴2
int wt[day];
int r1[] = {3, 9, 10}, r2[] = {4, 9, 10}; // 基础消耗量
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

void get_weather()
{
    wt[0] = rand() % 2;
    for (int i = 1; i < day; i++)
    {
        double sun = 0.3, high = 0.5, sand = 0.2;
        for (int j = 1; j <= 2; j++)
        {
            if (i - j <= 0) break;
            if (wt[i - j] == 0)
            {
                high += sun * 0.15;
                sun *= 0.85;
            }
            else if (wt[i - j] == 1)
            {
                sand += high * 0.15;
                high *= 0.85;
            }
            else
            {
                sun = 0.3, high = 0.5, sand = 0.2;
            }
        }
        int tmp = rand()%1000 + 1;
        wt[i] = tmp <= sun * 1000 ? 0 : (tmp > (sun+high)*1000 ? 2 : 1);
    }
}
void get_ans()
{
    short mxans = -1;
    Data st;
    for (int i = 1; i <= day; i++)
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
    tot = 0;
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
        printf("%d %d %d %d %d\n", u.i, u.j, ans[i], u.k, u.l);
    }
}
void dp()
{
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
}
int main()
{
    freopen("gk4.out", "w", stdout);
    srand(time(0));
    build_G(); //建图
    int T = 5;
    while (T--)
    {
        get_weather();
        dp();
        get_ans();
    }
    return 0;
}