#include <bits/stdc++.h>
using namespace std;

const int n = 50;  // 50家企业
int abc[n + 5], ed[n + 50], st[n + 50];
double fr[n + 50], r[n + 50];
const double V[] = {0, 0.6, 0.66, 0.72};

double rnd(int val, int i)
{
    double bia = rand() < 27000 ? ed[i] * (1 + r[i]): -1 * st[i] * (1 - r[i]) * (1 - r[i]) * 0.75;
    bia *= rand() / 32767.0;
    if (val + bia > 5990.0) return 5990.0;
    return max(val + bia, 0.0);
}
int c[55][55], lo[55][55];
double lv[10][250];
double lost(int i)
{
    int x = rand()%240 + 1;
    while (lv[i][x] < 1e-8)
        x = rand()%240 + 1;
    return lv[i][x];
}

int work(int id = 0)
{
    double s = 28200 / 0.97;
    int cnt, tmp[30], tot = 0;;
    for (int w = 1; w <= 24; w ++)
    {
        for (int i = 1; i <= 50; i++)
        {
            if (c[i][w] == 0) continue;

            double x = rnd(c[i][w], i), cur;
            
            x -= x * lost(lo[i][w]);
            x /= V[abc[i]];
            s += x;
        }
        s -= 28200;
        tmp[++tot] = s;
        if (s >= 28200*1.75) cnt = 0;
        if (s < 28200*1.75 && w > 1) ++cnt;
        if (cnt >= 2) return 0;
    }
    if (id == 1)
    {
        for (int i = 1; i <= tot; i++)
            cout<<tmp[i]<<" ";
        puts("");
    }
    return 1;
}

int main()
{
    freopen("data.txt", "r", stdin);
    srand(time(0));
    for (int i = 1; i <= 50; i++)
        scanf("%lf%d%d%d%lf", fr+i, abc+i, ed+i, st+i, r+i);
    
    freopen("ans3.txt", "r", stdin);
    for (int i = 1; i <= 50; i++)
        for (int j = 1; j <= 24; j++)
            scanf("%d", &c[i][j]);
    freopen("tsel.txt", "r", stdin);
    for (int i = 1; i <= 50; i++)
        for (int j = 1; j <= 24; j++)
            scanf("%d", &lo[i][j]);

    freopen("lv.txt", "r", stdin);
    for (int i = 1; i <= 8; i++)
        for (int j = 1; j <= 240; j++)
        {
            scanf("%lf", &lv[i][j]);
            lv[i][j] *= 0.01;
        }

    int C = 100000, cnt = 0;
    for (int cs = 1; cs <= C; cs++) // 模拟十万次
        cnt += work();
    printf("%.5lf\n", 1.0 * cnt / C);
    freopen("5line.txt", "w", stdout);
    for (int cs = 1; cs <= 5; )
        cs += work(1);
        
    return 0;
}