
function [tvals,yvals]=RK_DDE_FIXEDSTEP(t0,tf,y0,tau,h,n,F1,F2, FLAG,CASE,INITIAL,capT, Param)
%*************************************
% t0 = initial time
% tf = termina time
% y0 = initial conditions
% tau = time delay
% h = step size
% n = steps
% F1 and F2 are the fishing mortality levels

peek=10; % 

y0=y0(:); % Converts y0 to column vector regardless of what it is

% Calls in the parameter file
[r, K, ~, Me, Te, fe, alpha12max, beggpred,a,b,M2j,tjuv, ...
    theta, vbk,kappa,d,wr,Y, alpha21, Cmax, M2, ~]=Param_File_v3(FLAG, capT,Param);

tc=t0; % initial start
yc=y0; % initial conditions
yp=yc; % Saving for later
tvals=tc;
ypvals=yc;
fc=feval(@derivs,tc,yc); %Starting value of F at the initial conditions
delsteps=round(tau/h); %  this is consistent with  tomlab 

for i=1:delsteps % integrate backward w/o delay to generate IC
    [tc,yp,fc]=RKstep(@derivs,tc,yp,fc,-h);
    ypvals=[y0 ypvals]; 
    tvals=[tc tvals];
end

tc=t0; yp=ypvals; fcp=feval(@derivsdel,tc,yc,yp(:,1),1);
yvals=yp;
% the system at time (t-tau) is the first column of yp
if (n>delsteps)
    yvals=yc;
    tvals=tc;
end

for j=1:n % integrate forward w/ delay
    [tc,yc,fcp]=RKdelstep(@derivsdel,tc,yc,yp,fcp,h,j);
    if mod(j,peek)==0
        yvals=[yvals yc];
        tvals=[tvals tc];
    end
    yp=[yp(:,2:delsteps+1) yc];
end


function [tnew,ynew,fnew]=RKdelstep(fname,tc,yc,yp,fcp,h,j)
ya=yp(:,1);
ya1=0.5*(yp(:,1)+yp(:,2));
ya2=yp(:,2);
k1 = h*fcp;
k2 = h*feval(fname,tc+(h/2),yc+(k1/2),ya1,j);
k3 = h*feval(fname,tc+(h/2),yc+(k2/2),ya1,j);
k4 = h*feval(fname,tc+h,yc+k3,ya2,j);
ynew = yc +(k1 + 2*k2 + 2*k3 +k4)/6;
tnew = tc+h;
fnew = feval(fname,tnew,ynew,yp(:,2),j);
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function Integrates backward at the step-size for the delay
%**************************************
function [tnew,ynew,fnew]=RKstep(fname,tc,yc,fc,h)
k1 = h*fc;
k2 = h*feval(fname,tc+(h/2),yc+(k1/2));
k3 = h*feval(fname,tc+(h/2),yc+(k2/2));
k4 = h*feval(fname,tc+h,yc+k3);
ynew = yc +(k1 + 2*k2 + 2*k3 +k4)/6;
tnew = tc+h;
fnew = feval(fname,tnew,ynew);
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the equation file with Delay
%**************************************
function dy = derivsdel(tc,yc,ya,j)
% Differential equations function for delaydifferential
% first row is dx1/dt, second is dx2/dt, third is dn2/dt
x1lag =ya(1,1);
x2lag=ya(2,1);
x1=yc(1);
x2=yc(2);
n2=yc(3);
% calculate changes in winf based on consumption rate
C=Cmax*(alpha21*x1+Y)/(Cmax+alpha21*x1+Y);
wref=0.01;
%ptmp=(alpha21*x1+Y)/(Cmax+alpha21*x1+Y);
H=C*(wref)^(1-d);
winf=(theta*H/vbk)^(1/(1-d));
%Me=Me*(1-sin(tc)*.25); % comment out if running Me=constant
% handy to calculate recruitment here:
alpha12=alpha12max/(1+beggpred*x2lag*fe);
J=fe*x2lag*exp(-(Me+alpha12*x1lag)*Te);
R=(a*J/(1+b*J))*exp(-M2j*tjuv);
 
dy=zeros(3,1);
dy(1) =(r/K)*x1*(K-x1)-(1-exp(-F1(j)))*x1-(Cmax*alpha21*x2*x1)/(Cmax+Y+alpha21*x1);
dy(2)= wr*R+kappa*winf*n2-(M2+(1-exp(-F2(j)))+kappa)*x2;
dy(3)= R-M2*n2-(1-exp(-F2(j)))*n2;
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the history file: Assuming constant
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function dy=derivs(tc,yc)
 dy=[yc(1);yc(2); yc(3)]; % History is the initial conditions
 end
end
