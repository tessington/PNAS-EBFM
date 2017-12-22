% Code used in "Economic value of ecological information in ecosystem-based natural
% resource management depends on exploitation history"
%
%
% Timothy E. Essington
% School of Aquatic and Fishery Sciences
% University of Washington
%
% James N. Sanchirico
% Department of Environmental Science and Policy
% University of California Davis
%
% Marissa L. Baskett
% Department of Environmental Science and Policy
% University of California Davis

% For questions on the code, contact Jim Sanchirico at
% jsanchirico@ucdavis.edu

% Calling the equations for Egg predation model

wref=0.01;
% calculate changes in winf based on consumption rate
 C=Cmax*(alpha21*x1+Y)/(Cmax+alpha21*x1+Y);
 H=(Cmax*(alpha21*x1+Y)/(Cmax+alpha21*x1+Y)*(wref)^(1-d));
 winf=(theta*(Cmax*(alpha21*x1+Y)/(Cmax+alpha21*x1+Y)*(wref)^(1-d))/vbk)^(1/(1-d));
 
% handy to calculate recruitment here:
 alpha12=(alpha12max/(1+beggpred*x2delayed*fe));
 J=fe*x2delayed*exp(-(Me+(alpha12max/(1+beggpred*x2delayed*fe))*x1delayed)*Te);
 R=(a*J/(1+b*J))*exp(-M2j*tjuv);

% State equations
ceq = collocate({...
dot(x1) == (r/K)*x1*(K-x1)-q(1)*(1-exp(-E1))*x1-(Cmax*alpha21*x2*x1)/(Cmax+Y+alpha21*x1);
dot(x2) == wr*R+kappa*winf*n2-(M2+q(2)*(1-exp(-E2))+kappa)*x2;
dot(n2) == R-M2*n2-q(2)*(1-exp(-E2))*n2});

BETA = [1; 1]; % not used but permits a more flexibile catch function
% Note set q=1, E becomes F.

% Sum of profits (note Beta=1 and C1=0)
profit  = P(1)*q(1)*(1-exp(-E1))*(x1^BETA(1))-c0(1)*(E1)-c1(1)*(E1^2)+...
          P(2)*q(2)*(1-exp(-E2))*(x2^BETA(2))-c0(2)*(E2)-c1(2)*(E2^2);

% Objective function
objective = -integrate(exp(-dis*t).*profit); 



