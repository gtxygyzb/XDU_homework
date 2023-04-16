clc, clear

syms mat n;

mat = [0, 1, 0; 0, 0, 1; 1/3, 1/3, 1/3];
M = real(double(limit(mat^n, n, inf)))
