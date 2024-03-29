AA= SER.A;
BB= SER.B;
CC= SER.C;
DD= SER.D;
EE= SER.E;
II= eye(size(SER.A,1));
freq = s;
data = f;

fstart = 1; fstop=300; fstep=1;
unit = 0;

rl_pole_num =0;
com_pole_num =0;
for xx=1:1:50

     if isreal(AA(xx,xx))
       rl_pole_num = rl_pole_num +1;
       rrr_11(rl_pole_num) = CC(1,xx);
       ppr(rl_pole_num) = AA(xx,xx);
     else
       com_pole_num = com_pole_num +1;
       rrc_11(com_pole_num) = CC(1,xx);
       ppc(com_pole_num) = AA(xx,xx);
     end
     rrt_11(xx) = CC(1,xx);
     ppt(xx) = AA(xx,xx);
end




for x=fstart:fstep:fstop
  unit=unit+1;
  YY(:,:,unit) = CC*inv(freq(unit)*II-AA)*BB+DD+freq(unit)*EE;

  YY_11 = DD(1,1) + freq(unit)*EE(1,1);
  for xx=1:1:50
     YY_11 = YY_11 + CC(1,xx)/(freq(unit)-AA(xx,xx));

  end

end
reYY = zeros(1,300);
for ind = 1:300
    reYY(ind) = real(YY(1,1,ind));
end
kmm = zeros(1,300);
for ind = 1:300
    kmm(ind) = real(f(1,ind));
end
figure
plot(imag(freq),reYY)
figure
plot(imag(freq),real(f(1,:)),'k--')
figure
plot(imag(freq),real(YY_11),'r--')
%,imag(freq),real(f(1,:)),'k--',imag(freq),real(YY_11),'r--'
