% Calling the equations for Egg predation model

wref=0.01;
% calculate changes in winf based on consumption rate
 C=Cmax*(alpha21*x1+Y)/(Cmax+alpha21*x1+Y);
 H=(Cmax*(alpha21*x1+Y)/(Cmax+alpha21*x1+Y)*(wref)^(1-d));
 winf=(theta*(Cmax*(alpha21*x1+Y)/(Cmax+alpha21*x1+Y)*(wref)^(1-d))/vbk)^(1/(1-d));
% 
% handy to calculate recruitment here:
 alpha12=(alpha12max/(1+beggpred*x2delayed*fe));
 J=fe*x2delayed*exp(-(Me+(alpha12max/(1+beggpred*x2delayed*fe))*x1delayed)*Te);
 R=(a*J/(1+b*J))*exp(-M2j*tjuv);
 
ceq = collocate({...
dot(x1) == (r/K)*x1*(K-x1)-q(1)*(1-exp(-E1))*x1-(Cmax*alpha21*x2*x1)/(Cmax+Y+alpha21*x1);
dot(x2) == wr*R+kappa*winf*n2-(M2+q(2)*(1-exp(-E2))+kappa)*x2;
dot(n2) == R-M2*n2-q(2)*(1-exp(-E2))*n2});

BETA = [1; 1];
% Note set q=1, E becomes F.
profit  = P(1)*q(1)*(1-exp(-E1))*(x1^BETA(1))-c0(1)*(E1)-c1(1)*(E1^2)+...
          P(2)*q(2)*(1-exp(-E2))*(x2^BETA(2))-c0(2)*(E2)-c1(2)*(E2^2);

objective = -integrate(exp(-dis*t).*profit); 



