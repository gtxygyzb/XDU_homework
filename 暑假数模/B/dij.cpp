#include <bits/stdc++.h>
using namespace std;

const int N=1e5+50,M=2e5+50;

int head[N],etop;
struct Edge
{
	int v,w,nxt;
}e[M];
void add(int u,int v,int w)
{
	e[++etop].v=v;
	e[etop].w=w;
	e[etop].nxt=head[u];
	head[u]=etop;	
}

struct Data
{
	int u,w;
	Data (int _u,int _w)
	{
		u=_u; w=_w;
	}
	bool operator <(const Data &t) const
	{
		return w>t.w;
	}
};

priority_queue <Data> q;
int vis[N],dis[N],n,m,S;
int main()
{
	scanf("%d%d%d",&n,&m,&S);
	for (int u,v,w;m--;)
	{
		scanf("%d%d%d",&u,&v,&w);
		add(u,v,w);
	}
	memset(dis,0x3f,sizeof(dis));
	q.push(Data(S,dis[S]=0));
	while (!q.empty())
	{
		int u=q.top().u; q.pop();
		if (vis[u]) continue;
		vis[u]=1;
		for (int v,i=head[u];i;i=e[i].nxt)
		{
			v=e[i].v;
			if (dis[v]>dis[u]+e[i].w)
			{
				dis[v]=dis[u]+e[i].w;
				q.push(Data(v,dis[v]));
			}
		}
	}
	for (int i=1;i<=n;i++)
		printf("%d ",dis[i]);
	puts("");
	return 0;
}
