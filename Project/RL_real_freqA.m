% real RL case frequency analysis
decades = [1, 10:10:100000];
num = SER.C[a,b*p];
pol = p;
freqA = 20*log(num./(decades-pol));
plot(decades,freqA);
