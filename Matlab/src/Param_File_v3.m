% Herring parameters
function varargout=Param_File_v3(flag,capT,Param)

    if flag==1 && capT==0
        %Indpendent
        p=.25; %.3
        winf.star=0.02;%.24
        fractioneggmort=0.0;
        beggpredmult=0;
        DC_herring=0.0001; %.001 % proportion of diet that is herring at x1 = 0.5K
        % parameter file for delay differential model
        r=0.7;
        K=10; % in mt / km2
        
    elseif flag==1 && capT==1
        %Indpendent
        p=.25; %.3
        winf.star=0.02;%.24
        fractioneggmort=0.0;
        beggpredmult=0;
        DC_herring=0.0001; %.001 % proportion of diet that is herring at x1 = 0.5K
        % parameter file for delay differential model
        r=0.7;
        K=10; % in mt / km2
        %r=0.6; % these levels were fro CapT==1 but I am not sure why
        %9/14/2016
        %K=7; % in mt / km2
        
    elseif flag==2
        %Bottom-up, no egg predation
        p=.25;
        winf.star=0.02;
        fractioneggmort=0;  % this is maximum egg predation mortality (at 1/2 carrying capacity, expressed as a fraction of total mortality
        beggpredmult=0;
        DC_herring=Param; %0.25; % proportion of diet that is herring at x1 = 0.5K
        % parameter file for delay differential model
        r=0.7;
        K=10; % in mt / km2
        
    elseif flag==3
        %Egg predation with no depensation
        p=.25;
        winf.star=0.02;
        fractioneggmort=0.75;
        beggpredmult=0;
        DC_herring=Param; %0.25; % proportion of diet that is herring at x1 = 0.5K
        % parameter file for delay differential model
        r=0.7;
        K=10; % in mt / km2
        
    else
        %Egg with depensation
        p=.25;
        winf.star=0.02;
        fractioneggmort=0.75;
        beggpredmult=15;
        DC_herring=Param; %0.25; % proportion of diet that is herring at x1 = 0.5K
        % parameter file for delay differential model
        r=0.7;
        K=10; % in mt / km2

    end
    F1=0; F2=0;

% parameters for juvenile cod

% reproduction parameters
fprime=685; % fecundity, eggs per gram for mature females
f=fprime*(1000^2)*0.5; % fecundity in eggs per mt of total adult size (assume equal sex ratio)
Metotal=0.2; %2.00; % total egg mortality rate, d^-1

beggpred=(1/f)*beggpredmult;
alpha12max=Metotal*fractioneggmort*(1+beggpred*f)/(0.5*K);% alpha12.max is the maximum egg predation mortality when x1=0.5K and predators are rare
Te=20; % duration of egg stage (days)

Me=max(0,Metotal*(1-fractioneggmort));% mortality due to sources other than herring
  
a=6.1e-4;% beverton holt parameter, estimated from N. Sea cod data
b=2.93e-7;% beverton holt parameter, estimated from N. Sea cod data

% adult parameters
theta=0.65; % assimilation efficiency, from Hansson bioenergetics, assuming 10 year old cod
Cmax = 5.88; % maximum consumption rate of cod at optimal temp
Y=Cmax*p/((1+DC_herring)*(1-p));
alpha21=2*Cmax*DC_herring*p/(K*(1-p));

wr=0.005;
M2j=0.8;
tjuv=4;
d=0.75;
wave=0.01;
H=p*Cmax/(wave^(d-1));% # von bertalanffy parameters
vbk=(theta*H/(winf.star^(1-d))); % von bertalanffy parameters
kappa=exp(-vbk)*(1-d); % this is an approximation, seems to work OK but slows down growth a bit
 
M2=0.2;

varargout(1:22)={r, K, F1, Me, Te,f, alpha12max, beggpred,a,b,M2j,tjuv, theta, vbk,kappa,d,wr,Y, alpha21, Cmax, M2, F2};
