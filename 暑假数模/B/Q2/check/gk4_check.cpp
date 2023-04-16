#include <bits/stdc++.h>
#define fi first
#define se second
#define pa pair<int, int>
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

const int N = 1e5 + 50;

void get_weather()
{
    wt[0] = rand() % 2;
    for (int i = 1; i < day; i++)
    {
        double sun = 0.5, high = 0.4, sand = 0.1;
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
                sun = 0.4, high = 0.5, sand = 0.1;
            }
        }
        int tmp = rand()%1000 + 1;
        wt[i] = tmp <= sun * 1000 ? 0 : (tmp > (sun+high)*1000 ? 2 : 1);
    }
}

double bfs(int u, int d, int k, int l, int f, int goal)
{
    if (l < 0 || k < 0)
    {
       // cout<<u<<" "<<k<<" "<<l<<endl;
        return -1;
        }
    if (u == 10) return f + k * c1 * 0.5 + l * c2 * 0.5;
    if (wt[d] > 0 && u != 7)
        return bfs(u, d + 1, k - r1[wt[d]], l - r2[wt[d]], f, goal);
    
    if (u < 5 || u == 9)
        return bfs(u + 1, d + 1, k - 2 *r1[wt[d]], l - 2 *r2[wt[d]], f, goal);
    if (u == 5)
    {
        if (k >= 80) 
            return bfs(7, d + 1, k - 2 *r1[wt[d]], l - 2 *r2[wt[d]], f, goal);
        else
            return bfs(6, d + 1, k - 2 *r1[wt[d]], l - 2 *r2[wt[d]], f, goal);
    }
    if (u == 6) //在村庄，补充物质水210，食物220
    {
        int dk = max(0, 210 - k);
        int dl = max(0, 220 - l);
        int nf = f - dk * c1 * 2 + dl * c2 * 2;
        return bfs(8, d+1, k + dk, l + dl, nf, 7);
    }
    if (u == 7)
    {
        if (wt[d] == 2)
        {
            if (k >= 80 && l >= 80)
                return bfs(u, d + 1,  k - 3 *r1[wt[d]], l - 3 *r2[wt[d]], f + mny, 7);
            else
                return bfs(u, d + 1, k - r1[wt[d]], l - r2[wt[d]], f, goal);
            //资源少就待一天，资源多就挖矿
        }
        if (k < 30 || l < 30)
            return bfs(u + 1, d + 1, k - 2 *r1[wt[d]], l - 2 *r2[wt[d]], f, 6);
        else if (k < 60 || l < 60)
            return bfs(u + 1, d + 1, k - 2 *r1[wt[d]], l - 2 *r2[wt[d]], f, 9);
        else 
            return bfs(u, d + 1,  k - 3 *r1[wt[d]], l - 3 *r2[wt[d]], f + mny, 7);

    }
    if (u == 8)
        return bfs(goal, d + 1, k - 2 *r1[wt[d]], l - 2 *r2[wt[d]], f, goal);

}
int rcnt[2];
int main()
{
    //freopen("gk4_check.out", "w", stdout);
    srand(time(0));
    build_G(); //建图
    int T = 10000, ftot = 0;
    double fans = 0;
    while (T--)
    {
        get_weather();
        int water = 150, food = 300; //初始水和食物
        double ans = bfs(1, 0, water, food, 10000 - c1 * water - c2 * food, 5);
        if (ans == -1) ++rcnt[1];
        else
        {
            ++rcnt[0];
            ++ftot;
            fans += ans;
        }
    }
    cout<<rcnt[0]<<" "<<rcnt[1]<<endl;
    cout<<"qiwang:"<<1.0*fans/ftot<<endl;
    return 0;
}
/*
第一次到达13点时判断所剩物资：水>=80时决策为先去矿山，其余情况先去村庄补给。
当水<30或食物<30时立刻返回村庄补给；30<水<50且30<食物<50时直接走向终点。

起始水130-150
食物300-350
高温停留
一般都是200-230
食物比水多6-20都有
*/