function [k, L] = dispersion(T,h)
    sigma = 2*pi/T;
    g = 9.81;
    k = -fzero(@(k) sigma^2-g*k*tanh(k*h),0); 
    L = 2*pi/k;
end