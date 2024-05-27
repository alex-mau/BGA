function [d] = distance2ssc(H)
r = size(H,1);
d = 0;
e = ones(r,1)/sqrt(r-1);
for k = 1:r
    e_ek = e;
    e_ek(k) = 0;
    [~,resnorm] = lsqnonneg(H,e_ek);
    d = max(d,resnorm);
end
end