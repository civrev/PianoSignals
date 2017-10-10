x = 2^8;
y = log2(x);
twoFactor = zeros(1, 9);
for i = 1:9
    twoFactor(i) = 1/(2^(i-1));
end