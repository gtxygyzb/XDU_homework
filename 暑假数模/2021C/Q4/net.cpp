#include <bits/stdc++.h>
using namespace std;
const double inf = 1e8;

const int n = 68;  // 68家企业
int abc[n + 5], ed[n + 50], st[n + 50];
double fr[n + 50], r[n + 50];
const double V[] = {0, 0.6, 0.66, 0.72};
const int jz = 28200 * 1.05;
int fw; //二分答案

double rnd(int i)
{
    double bia = rand() % 2 ? ed[i] * (1 -r[i]) : -1 * st[i] * (1 - r[i]);
    bia *= rand() / 32767.0;
    if (fr[i] + bia > 5990.0) return 5990.0;
    return max(fr[i] + bia, 0.0);
}

int lim[70][70], ret[70][70], ans[70][70];
int vec[5][70], siz[5];

namespace Net
{
    const int N = 150 * 24;  //总结点数
    int S, T, etop=1, head[N], d[N];
    int pre[N], vis[N], tim;
    double dis[N], cost;
    struct Edge
    {
        int u, v, r, nxt;
        double c;
    }e[N * 50]; //双倍边 
    void addedge(int u,int v,int r,double c)
    {
        ++etop;
        e[etop].u = u; e[etop].v = v; e[etop].r = r; e[etop].c = c;
        e[etop].nxt = head[u];
        head[u] = etop;
    }
    void add(int u,int v,int r,double c)
    {
        addedge(u,v,r,c);
        addedge(v,u,0,-c);
    }
    bool spfa() //找费用最小的一条路 并用pre记录路径 
    {
        queue <int> q;
        q.push(S);
        memset(pre,0,sizeof(pre));
        for (int i = 0; i < N; i++)
            dis[i] = inf;
        dis[S]=0; vis[S]=++tim;
        while (!q.empty())
        {
            int u=q.front(); q.pop();
            for (int v,i=head[u];i;i=e[i].nxt)
            {
                v=e[i].v;
                if (e[i].r&&dis[v]>dis[u]+e[i].c)
                {
                    dis[v]=dis[u]+e[i].c;
                    pre[v]=i;
                    if (vis[v]!=tim)
                    {
                        vis[v]=tim;
                        q.push(v);
                    }
                }
            }
            vis[u]=0;
        }
        return dis[T] != inf;
    }
    double mcmf()
    {
        int flow = 0;
        while (spfa())
        {
            int minflow=inf;
            for (int i=pre[T];i;i=pre[e[i].u])
                minflow=min(minflow,e[i].r);
            for (int i=pre[T];i;i=pre[e[i].u])
            {
                e[i].r-=minflow;
                e[i^1].r+=minflow;
            } 
            flow += minflow;
            cost += dis[T]*minflow;
        }
        printf("%.3lf\n", cost);
    }
    void build_G()
    {
        int s = (1 + 3 + 68+68 + 3 + 1) * 24 + 1;
        int t = s + 1;
        S = t + 1; T = S + 1;

        for (int bia = 1; bia <= 3313; bia += 144) // 23 * 108 = 3312
        {
            add(bia, bia + 1, inf, 1.2 * V[1]);
            add(bia, bia + 2, inf, 1.1 * V[2]);
            add(bia, bia + 3, inf, V[3]);

            int xj = (bia == 1 || bia == 2) ? 2*fw : fw;
            add(s, bia, inf, 0);
            d[s] -= xj;
            d[bia] += xj;
        }

        for (int u, v, bia = 0, j = 1; bia <= 3312; bia += 144, j++)
        {
            for (int i = 2; i <= 144; i++)
            {
                u = bia + i;
                if (i >= 2 && i <= 4) //ABC -> 供应商
                    for (int j = 1; j <= n; j++)
                    {
                        if (i - 1 != abc[j]) continue; //购买点货物类型匹配上
                        v = bia + 4 + j;
                        add(u, v, inf, 0);
                        v += n;
                        add(v, bia + 2*n+3 + i, inf, 0); //后拆点连向储存点
                    }
                if (i >= 5 && i <= 5+n-1)
                {
                    lim[i - 4][j] = rnd(i - 4);
                    add(u, u + n, int(lim[i - 4][j] / V[abc[i - 4]]), 0); //企业间拆点连边
                }

                if (i >= 5+n*2 && i <= 7+n*2)
                {
                    double fy = V[i - 2*n+4];
                    fy *= 0.056;
                    add(u, bia + 144, inf, 0); //AS -> T1

                    v = bia != 3312 ? u + 144 : t; //最后一个点直接连t，不然就 +144
                    add(u, v, inf, fy); //上界inf，下界0
                }
                if (i == 144) //上界减下界为0，直接不连边
                {
                    d[u] -= fw;
                    d[t] += fw; //流向t
                }
            }
        }

        for (int u = 1; u <= t; u++)
        {
            if (d[u] < 0)
                add(u, T, -d[u], 0);
            if (d[u] > 0)
                add(S, u, d[u], 0);
        }
        add(t, s, inf, 0);
    }

    int t[4];
    void fill(int i, int A, int w)
    {
        while (A)
        {
            if (A)
            {
                int del = min(A, lim[vec[i][t[i]]][w] - ret[vec[i][t[i]]][w]);
                A -= del;
                ret[vec[i][t[i]]][w] += del;
                if (lim[vec[i][t[i]]][w] == ret[vec[i][t[i]]][w])
                    ++t[i];
            }
        }
    }
    void output(int A, int B, int C, int w) //产能要乘以VA,VB,VC
    {
        t[1] = t[2] = t[3] = 1;
        A *= V[1]; B *= V[2]; C *= V[3];
        
        fill(1, A, w);
        fill(3, C, w);
        while (B)
        {
            int del = min(B, lim[vec[2][t[2]]][w] - ret[vec[2][t[2]]][w]);
            B -= del;
            ret[vec[2][t[2]]][w] += del;
            if (lim[vec[2][t[2]]][w] == ret[vec[2][t[2]]][w]) //B企业填满了
                ++t[2];
        }
    }
    void work()
    {
        for (int i = 2, j = 1; j <= 24; i += 8, j++)
            output(e[i + 1].r, e[i + 3].r, e[i + 5].r, j);
        for (int i = 1; i <= n; i++)
            for (int j = 1; j <= 24; j++)
            {
                if (j == 1 && ans[i][j] == 0)
                    ans[i][j] = ret[i][j];
                if (j != 1) ans[i][j] += ret[i][j];
            }
    }
    void init()
    {
        etop=1;
        memset(head, 0, sizeof(head));
        memset(lim, 0, sizeof(lim));   
        memset(ret, 0, sizeof(ret));
        memset(d, 0, sizeof(d));
        cost = 0;
    }
}

int main()
{
    freopen("data.txt", "r", stdin);
    freopen("cost.txt", "w", stdout);
    srand(19260817);
    for (int i = 1; i <= n; i++)
    {
        scanf("%lf%d%d%d%lf", fr+i, abc+i, ed+i, st+i, r+i);
        vec[abc[i]][++siz[abc[i]]] = i;
    }
    int cs = 50;
    double bi = 1.423;
    fw = jz * bi;
    for (int uu = 1; uu <= cs; uu++)
    {
        Net::init();
        Net::build_G();
        Net::mcmf();
        Net::work();
    }
    freopen("ans4.txt", "w", stdout);
    for (int i = 1; i <= n; i++)
    {
        for (int j = 1; j <= 24; j++)
            printf("%d ", j != 1 ? ans[i][j] / cs : ans[i][j]);
        puts("");
    }
    return 0;
}
/*
1.建立附加源点SS，和附加汇点TT

2.对于原图中每一个点（包括源汇）u,令d[u]代表u点的所有入边的流量下界减去出边的流量下界

2.1.如果d[u]是负数，那么从u连一条边(u,TT,-d[u],0)到TT

2.2.如果d[u]是正数，那么从SS连一条边(SS,u,d[u],0)到u

3.对于原图中每一条边(u,v,w,l,r)，连边(u,v,r-l,w)

4.连边(t,s,inf,0)（注意这里是原图的源汇点！不是附加的源汇点！！）

这样以后，从SS到TT跑新图的最小费用最大流，再加上原图中每条边的下界流量乘以费用（必须跑的部分），就是最小费用可行流的费用了
*/