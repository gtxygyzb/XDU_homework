clc, clear

m = [1 3/2 2;
    2/3 1 4/3;
    1/2 3/4 1;];
[cr1, eta1] = ahp(m)
m = [1 1/3 1/3 1/6 5 4 5 1/3 1;
     3 1 1 1/3 6 5 6 1 2;
     3 1 1 1/2 6 5 6 1/2 1;
     6 3 2 1 9 6 8 2 3;
     1/5 1/6 1/6 1/9 1 1/3 1/2 1/6 1/6;
     1/4 1/5 1/5 1/6 3 1 1 1/4 1/4;
     1/5 1/6 1/6 1/8 2 1 1 1/6 1/4;
     1/3 1 2 1/2 6 4 6 1 2;
     1 1/2 1 1/3 6 4 4 1/2 1;];
[cr2, eta2] = ahp(m)
%%
a2 = xlsread('tag.xlsx');
load('302.mat', 'sumb');
load('typ1.mat');
n = 302;
for i = 1:n
    if typ(i) < 0.999
        if (sumb(i) > 1e7)
            typ(i) = 3;
        else
            typ(i) = 2;
        end
    end
    A(i, 1) = eta1(typ(i));
    A(i, 2) = eta2(a2(i));
end
q1 = typ;
save('q1.mat', 'q1')
save('A.mat', 'A')