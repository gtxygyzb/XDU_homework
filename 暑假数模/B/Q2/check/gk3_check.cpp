#include <bits/stdc++.h>
using namespace std;

const int n = 7; //简化后节点数
const int M = 1200;  //负重上限
const int day = 10; //10天
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
int ed = 7; //7为终点
void build_G()
{
    for (int i = 1; i <= 4; i++)
        adds(i, i + 1);
    adds(5, 7);
    adds(2, 6);
    adds(6, 7);
    pm[4] = 1;
}
//晴朗0 高温1 沙暴2
int wt[day];
int r1[] = {3, 9, 10}, r2[] = {4, 9, 10}; // 基础消耗量
int mny = 200; //挖矿收益

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

const int N = 1e5 + 50;
short ans[N], tot = 0;
Data ansp[N];

void get_weather()
{
    wt[0] = rand() % 2;
    for (int i = 1; i < day; i++)
    {
        double sun = 0.5, high = 0.5, sand = 0; //没有沙暴，各五十
        for (int j = 1; j <= 2; j++)
        {
            if (i - j <= 0) break;
            if (wt[i - j] == 0)
            {
                high += sun * 0.15;
                sun *= 0.85;
            }
            else
            {
                sun += high * 0.15;
                high *= 0.85;
            }
        }
        wt[i] = rand()%1000 + 1 <= sun * 1000 ? 0 : 1;
    }
}
int pcnt[2];
int fans[N], ftot, ts[N];
int main()
{
    freopen("gk3_check.out", "w", stdout);
    srand(time(0));
    build_G(); //建图
    int T = 1000;
    int water = 45, food = 50;
    double toto = 0;
    while (T--)
    {
        get_weather();
        int hf1 = 0, hf2 = 0;
        for (int i = 1; i <= 3; i++)
        {
            hf1 += r1[wt[i]]*2;
            hf2 += r2[wt[i]]*2;
        }
        if (hf1 <= water && hf2 <= food)
        {
            pcnt[0]++;
            toto += (water - hf1) * c1 / 2.0 + (food - hf2) * c2 / 2.0;
        }
        else pcnt[1]++;
    }
    cout<<pcnt[0]<<" "<<pcnt[1]<<endl;
    cout<< (10000 - 45 * c1 - 50 * c2) + (toto/1000)<<endl;
    return 0;
}