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
% jsanchirico@ucdavis.ed

% Read me - 12/14/2017
%
% To run this program, you will need the accompaning files:
% (1) Main program file
% (2) Parameter file

% As mentioned in the paper, the code utilizes the Tomlab solvers,
% specifically propt. You will need these solvers to run to the code. You
% can go to the website for Tomlab (https://tomopt.com/) and request a demo version.

% Copyrighted by Jim Sanchirico


%% *Main program file*
clear all
close all
clear classes

%% Economic parameters
% 1 = herring; 2=Cod

% Prices
p1=512;
p2=1191;

% Catchability coefficient
q1=1; q2=1; % Set to one, E becomes F

% Linear cost parameters for fishing mortality
c10=511;
c20=811;

% Below cost parameters are not used but can be used to introduce quadratic
% costs with respect to fishing mortality
c11=0;
c12=0;

% Putting paramters in arrays
P=[p1,p2]; q=[q1,q2]; c0=[c10, c20]; c1=[c11, c12];

% Discount rate
dis = 0.04;

%% Dynamic parameters
% Terminal target stock levels
HerringT =5.0; CodBT =1.133;  CodNT= 207.5676;

% Initial conditions (fishing history) for the 4 cases
INITCOND= ...
    [1 9.28	2.73	 336.15
    2 1.43	2.73	 336.15
    3 9.29	0.77	 82
    4 1.43	0.77	 82];

% Time period of analysis
t0=0;  T=30;

% Vector of #'s of collocation nodes
NN=[5 10 45 55 75 90 100 110 120 130 140];

% Time lag in cod population dynamics
tau=0; % Set to zero initially

% Parameter used in the sensitivity analysis (diet parameters)
Param=0.25;


%% Main dynamic analysis

% Generating the initial guess for the solutions using tau=4 and independent system (didn't seem to matter using tau=0)

Solution={}; SolutionT={};

toms t
Phas=tomPhase('Phas',t,t0,T,NN(3));
% Note I tried Cheby points and it didn't work.
% I am going to try different points in the collocation
% that didn't work either.
setPhase(Phas)

tomStates x1 x2 n2
tomControls E1 E2

% initial guess
x0 = { icollocate({x1 == 4.9153/2
    x2 == 0.952/2
    n2 == 123/2})
    collocate(E1==.1)
    collocate(E2==.1)};

cbox = { 0 <= icollocate(x1)
    0 <= collocate(E1)
    0 <= icollocate(x2)
    0 <= collocate(E2)};

cterm = final({x1==HerringT;
    x2==CodBT});
 

% Generating initial guesses for runs below (using independent case only FLAG==1)
FLAG=1; capT=1;
[r, K, F1, Me, Te, fe, alpha12max, beggpred,a,b,M2j,...
    tjuv, theta, vbk,kappa,d,wr,Y, alpha21, Cmax, M2, F2]=Param_File_v3(FLAG, capT, Param);
for CASE=1:4;
    cbnd = initial({x1==INITCOND(CASE,2)
        x2==INITCOND(CASE,3)
        n2==INITCOND(CASE,4)});
    
    x1delayed = ifThenElse(t<tau, INITCOND(CASE,2), subs(x1,t,t-tau));
    x2delayed = ifThenElse(t<tau, INITCOND(CASE,3), subs(x2,t,t-tau));
    Equations_EggPredation % calls a file with all equations
    options=struct;
    options.name = 'Deriving Initial paths';
    options.solver = 'snopt';
    Solution{CASE}=ezsolve(objective, {cbnd,ceq,cbox, cterm},x0,options);
end


TRIAL=1; % This set to one does 1/2 the code to test run before going on to second part of the analysis
counter=0;
capT=1; % indicator to utilize the fixed endpoints in the analysis

for FLAG=1:4 % different ecological models
    
    % Calls to a parameter file for all of the ecological parameters
    [r, K, F1, Me, Te, fe, alpha12max, beggpred,a,b,M2j,...
        tjuv, theta, vbk,kappa,d,wr,Y, alpha21, Cmax, M2, F2]=Param_File_v3(FLAG, capT, Param);
    

    for CASE=1:4  % Initial condition cases
        
        
        % Collocation nodes (starting with a small number and building up to solutoins with greater numbers.
        for  ii=[3 5 7]
            
            % Tomlab/propt specific calls
            toms t
            Phas=tomPhase('Phas',t,t0,T,NN(ii));
            setPhase(Phas)
               tomStates x1 x2 n2
               tomControls E1 E2
        
            cbnd = initial({x1==INITCOND(CASE,2)
            x2==INITCOND(CASE,3)
            n2==INITCOND(CASE,4)});
        
            % Non-negativity constraints
            cbox = { 0 <= icollocate(x1)
                0 <= collocate(E1)
                0 <= icollocate(x2)
                0 <= collocate(E2)};
            
            % Terminal conditions on T biomass levels
            cterm = final({x1==HerringT;
                x2==CodBT});
            
            % generating starting conditions using the case with no time delay
            
            for STARTING=1:2
                
                % uses the prior run results as initial guess for the next
                % solution with greater number of collocation nodes
                if ii>3 && STARTING==1
                    x0 = { icollocate({x1 == x11no{CASE,FLAG}
                        x2 == x21no{CASE,FLAG}
                        n2 == n21no{CASE,FLAG}})
                        collocate(E1==E11no{CASE,FLAG})
                        collocate(E2==E21no{CASE,FLAG})};
                    
                elseif ii>3 && STARTING~=1
                    x0 = { icollocate({x1 == x11{CASE,FLAG}
                        x2 == x21{CASE,FLAG}
                        n2 == n21{CASE,FLAG}})
                        collocate(E1==E11{CASE,FLAG})
                        collocate(E2==E21{CASE,FLAG})};
                end
                
                % if  STARTING==1, tau=0; elseif STARTING==2, tau=2; else tau=4; end;
                if  STARTING==1, tau=0; else tau=4; end;
                
                
                % Code to incorporate the time lag in state equations
                x1delayed = ifThenElse(t<tau, INITCOND(CASE,2), subs(x1,t,t-tau));
                x2delayed = ifThenElse(t<tau, INITCOND(CASE,3), subs(x2,t,t-tau));
                
                % calls a file with all equations
                Equations_EggPredation
                
                
                options.name = ['Dyanmics: Flag=' num2str(FLAG) ': CASE=' num2str(CASE) ':Starting=' num2str(STARTING) ': CollocationNodes=' num2str(ii)]
                options.solver = 'snopt';
                
                if STARTING==1 && ii==3;
                    
                    solution=ezsolve(objective, {cbnd,ceq,cbox, cterm},Solution{CASE},options);
                    t11no{CASE,FLAG}=subs(icollocate(t),solution);
                    E11no{CASE,FLAG}=subs(icollocate(E1),solution);
                    x11no{CASE,FLAG}=subs(icollocate(x1),solution);
                    E21no{CASE,FLAG}=subs(icollocate(E2),solution);
                    x21no{CASE,FLAG}=subs(icollocate(x2),solution);
                    n21no{CASE,FLAG}=subs(icollocate(n2),solution);
                    
                    
                elseif STARTING==1 && ii>3;
                    
                    solution=ezsolve(objective, {cbnd,ceq,cbox, cterm},x0,options);
                    t11no{CASE,FLAG}=subs(icollocate(t),solution);
                    E11no{CASE,FLAG}=subs(icollocate(E1),solution);
                    x11no{CASE,FLAG}=subs(icollocate(x1),solution);
                    E21no{CASE,FLAG}=subs(icollocate(E2),solution);
                    x21no{CASE,FLAG}=subs(icollocate(x2),solution);
                    n21no{CASE,FLAG}=subs(icollocate(n2),solution);
                    
                elseif ii==3 && STARTING~=1
                    solution=ezsolve(objective, {cbnd,ceq,cbox,cterm},solution,options); % Uses the no lag solution as X0
                    t11{CASE,FLAG}=subs(icollocate(t),solution);
                    E11{CASE,FLAG}=subs(icollocate(E1),solution);
                    x11{CASE,FLAG}=subs(icollocate(x1),solution);
                    E21{CASE,FLAG}=subs(icollocate(E2),solution);
                    x21{CASE,FLAG}=subs(icollocate(x2),solution);
                    n21{CASE,FLAG}=subs(icollocate(n2),solution);
                else
                    
                    Prob=sym2prob(objective, {cbnd,ceq,cbox,cterm},x0, options);
                    Prob.SOL.optPar(12)=1e-9; % Increasing optimality tolerance
                    Prob.SOL.optPar(11)=1e-9;
                    Prob.SOL.options.MAXIT=15000;
                    Prob.SOL.optPar(30)=10000;
                    Result = tomRun('snopt',Prob,1);
                    solution=getSolution(Result);
                    
                    
                    % solution=ezsolve(objective, {cbnd,ceq,cbox,cterm},x0,options); % Uses the previous run with smaller N as Guess
                    t11{CASE,FLAG}=subs(icollocate(t),solution);
                    E11{CASE,FLAG}=subs(icollocate(E1),solution);
                    x11{CASE,FLAG}=subs(icollocate(x1),solution);
                    E21{CASE,FLAG}=subs(icollocate(E2),solution);
                    x21{CASE,FLAG}=subs(icollocate(x2),solution);
                    n21{CASE,FLAG}=subs(icollocate(n2),solution);
                end
                
            end % Goes to starting loop/lag operator
            
            
        end
        
        %Variables used for graphing (note these are redundant to above
        %but are kept due to code below
        
        t11T{CASE,FLAG}=subs(icollocate(t),solution);
        E11T{CASE,FLAG}=subs(icollocate(E1),solution);
        x11T{CASE,FLAG}=subs(icollocate(x1),solution);
        E21T{CASE,FLAG}=subs(icollocate(E2),solution);
        x21T{CASE,FLAG}=subs(icollocate(x2),solution);
        n21T{CASE,FLAG}=subs(icollocate(n2),solution);
        
    end
    
end

% Time length for results
L=length(subs(icollocate(t),solution));
tstart=1*(t0==0)+tau*(t0~=0);
tend=round(L);
time=tstart:tend;

%% Robustness Check 1
% Plots the solution with and without a lag. The turnpike should visually be equal,
% as the lag should not impact the steady-state solution.

for FLAG=1:4
    for CASE=1:4
        
        counter=counter+1;
        figure(counter)
        subplot(121)
        plot(t11{CASE,FLAG}(time),q(1)*E11{CASE,FLAG}(time),t11{CASE,FLAG}(time),q(2)*E21{CASE,FLAG}(time),...
            t11{CASE,FLAG}(time),q(1)*E11no{CASE,FLAG}(time),t11{CASE,FLAG}(time),q(2)*E21no{CASE,FLAG}(time))
        legend('F1','F2','F1no','F2no')
        title(['Flag: ' num2str(FLAG) ' CASE: ' num2str(CASE)])
        subplot(122)
        plot(t11{CASE,FLAG}(time),x11{CASE,FLAG}(time),t11{CASE,FLAG}(time),x21{CASE,FLAG}(time),...
            t11{CASE,FLAG}(time),x11no{CASE,FLAG}(time),t11{CASE,FLAG}(time),x21no{CASE,FLAG}(time))
        legend('x1','x2','x1no','x2no')
        
    end
end


%% Robustness Check 2:
% Plots the solution from all four initial conditions on the same plot
% to check to see if all are going to the same turnpike. If the numerical
% model is working, they should all be the same on the turnpike.

LINE={'r','b','m','k'};
for FLAG=1:4
    counter=counter+1;
    figure(counter)
    for CASE=1:4
        subplot(221)
        hold on;
        plot(t11{CASE,FLAG}(time),q(1)*E11{CASE,FLAG}(time),LINE{CASE})
        title(['Flag: ' num2str(FLAG) ' F1: Herring'])
        box on
        subplot(222)
        hold on;
        plot(t11{CASE,FLAG}(time),q(2)*E21{CASE,FLAG}(time),LINE{CASE})
        title(['Flag: ' num2str(FLAG) ' F2: Cod'])
        box on
        subplot(223)
        hold on;
        plot(t11{CASE,FLAG}(time),x11{CASE,FLAG}(time),LINE{CASE})
        title(['Flag: ' num2str(FLAG) ' Herring'])
        box on
        subplot(224)
        hold on;
        plot(t11{CASE,FLAG}(time),x21{CASE,FLAG}(time),LINE{CASE})
        title(['Flag: ' num2str(FLAG) ' Cod'])
        box on
        hold off
    end
end

%% Graphs that are the basis for plots in the main paper
% (note this is not the same code, as the graphs in the paper
% were generated in R)

LINE={'r','b','m','k'};
LW=3;
TFINAL=35;
figure
for FLAG=3
    for CASE=1:4
        subplot1=subplot(221)
        hold on;
        plot(t11{CASE,FLAG}(time),x11{CASE,FLAG}(time),LINE{CASE},'LineWidth',LW)
        xlim(subplot1,[0 TFINAL]);
        title(['Flag: ' num2str(FLAG) ' Herring'])
        box on
        
        
        subplot1=subplot(222)
        hold on;
        plot(t11{CASE,FLAG}(time),x21{CASE,FLAG}(time),LINE{CASE},'LineWidth',LW)
        xlim(subplot1,[0 TFINAL]);
        title(['Flag: ' num2str(FLAG) ' Cod'])
        box on
        
        
        subplot1=subplot(223)
        hold on;
        plot(t11{CASE,FLAG}(time),q(1)*(1-exp(-E11{CASE,FLAG}(time))),LINE{CASE},'LineWidth',LW)
        xlim(subplot1,[0 TFINAL]);
        title(['Flag: ' num2str(FLAG) ' F1: Herring'])
        box on
        
        subplot1=subplot(224)
        hold on;
        plot(t11{CASE,FLAG}(time),q(2)*(1-exp(-E21{CASE,FLAG}(time))),LINE{CASE},'LineWidth',LW)
        xlim(subplot1,[0 TFINAL]);
        title(['Flag: ' num2str(FLAG) ' F2: Cod'])
        box on
        
        hold off
    end
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Biomass Plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
CASE1=[1 3 5 7]; CASE2=[2 4 6 8];%LINE={'-r','-.b',':m','--k'};
INIT = {'High/High','H Low/ C High','H High/C Low','Low/Low'};

for CASE=1:4
    for FLAG=1:4
        subplot(400+20+CASE1(CASE))
        if CASE==1, title('Prey Biomass over time'); end;
        %if CASE==4, xlabel('Time'); end;
        hold on
        plot(t11{CASE,FLAG}(time),x11{CASE,FLAG}(time)/INITCOND(CASE,2),LINE{FLAG})
        hold off
        ylabel(INIT{CASE})
        subplot(400+20+CASE2(CASE))
        hold on
        if CASE==1, title('Predator Biomass over time'); end;
        plot(t11{CASE,FLAG}(time),x21{CASE,FLAG}(time)/INITCOND(CASE,3),LINE{FLAG})
        %if CASE==4, xlabel('Time'); end;
        hold off
    end
end
legend1=legend('Indep','Bottom-up','Egg Pred.','Egg w/Depens');
set(legend1,'Orientation','horizontal',...
    'Position',[0.210132911273101 0.0252207516880775 0.591383812010444 0.0306122448979592]); %[0.192535863175222 0.00276068070316185 0.62396694214876 0.0372670807453416]);

%% Fishing mortality plotting
figure
for CASE=1:4
    for FLAG=1:4
        subplot(400+20+CASE1(CASE))
        if CASE==1, title('Prey F over time'); end;
        %if CASE==4, xlabel('Time'); end;
        hold on
        plot(t11{CASE,FLAG}(time),1-exp(-E11{CASE,FLAG}(time)),LINE{FLAG})
        hold off
        ylabel(INIT{CASE})
        subplot(400+20+CASE2(CASE))
        hold on
        if CASE==1, title('Predator F over time'); end;
        plot(t11{CASE,FLAG}(time),1-exp(-E21{CASE,FLAG}(time)),LINE{FLAG})
        %if CASE==4, xlabel('Time'); end;
        hold off
    end
end
legend1=legend('Indep','Bottom-up','Egg Pred.','Egg w/Depens');
set(legend1,'Orientation','horizontal',...
    'Position',[0.192535863175222 0.00276068070316185 0.62396694214876 0.0372670807453416]);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Running results from one model in the differential equations of the other model with fixed T
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%  Lag and step-size
tau=4; h=.01; % Step-size used in RK solver

% Case 1:  Independent in other cases
% Generating the solution on equivalent time steps

L=length(subs(icollocate(t),solution));
tend=L;
time=1:tend;
for CASE=1:4
    FLAG=1; SIM=1; % FLAG=1 is independent
    Ti=t11T{CASE,FLAG}(time);
    t0=min(Ti); tf=max(Ti);
    STEPS=round((tf-t0)/h);
    F1e=E11T{CASE,FLAG}(time); % optimal F
    Tt=linspace(t0,tf,STEPS);
    F1=interp1(Ti,F1e,Tt);
    F2e=E21T{CASE,FLAG}(time);
    F2=interp1(Ti,F2e,Tt);
    y0=[INITCOND(CASE,2), INITCOND(CASE,3),INITCOND(CASE,4)];
    
    for FLAG=1:4
        % Calls another file to do the calculation
        ProfitCalculation
        
    end
    
end

%Plotting results
for FLAG=[1 2 3 4]
    figure
    for CASE=1:4
        subplot(400+20+CASE1(CASE))
        if CASE==1, title(['Prey biomass: 1->' num2str(FLAG)]); end;
        if CASE==4, xlabel('Time'); end;
        hold on
        plot(TVAL{CASE,FLAG},X11or{CASE,FLAG,SIM}/INITCOND(CASE,2),TVAL{CASE,FLAG},YVAL{CASE,FLAG,SIM}(1,:)/INITCOND(CASE,2))
        hold off
        ylabel(INIT{CASE})
        subplot(400+20+CASE2(CASE))
        hold on
        if CASE==1, title(['Predator Biomass 1->' num2str(FLAG)]); end;
        plot(TVAL{CASE,FLAG},X21or{CASE,FLAG,SIM}/INITCOND(CASE,3),TVAL{CASE,FLAG},YVAL{CASE,FLAG,SIM}(2,:)/INITCOND(CASE,3))
        if CASE==4, xlabel('Time'); end;
        hold off
    end
    legend1=legend('Optimal','Indep');
    set(legend1,'Orientation','horizontal',...
        'Position',[0.348824786324786 0.00869025450031037 0.334401709401709 0.0446927374301676]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Case 2: Bottom-up in other cases (2->1 3 4)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for CASE=1:4
    FLAG=2; SIM=2; % FLAG=1 is bottom-up
    Ti=t11T{CASE,FLAG}(time);
    t0=min(Ti); tf=max(Ti);
    STEPS=round((tf-t0)/h);
    F1e=E11T{CASE,FLAG}(time); % optimal F
    Tt=linspace(t0,tf,STEPS);
    F1=interp1(Ti,F1e,Tt);
    F2e=E21T{CASE,FLAG}(time);
    F2=interp1(Ti,F2e,Tt);
    y0=[INITCOND(CASE,2), INITCOND(CASE,3),INITCOND(CASE,4)];
    
    for FLAG=1:4
        ProfitCalculation
        
    end
    
    
end

% Plotting results
for FLAG=[1 2 3 4]
    figure
    for CASE=1:4
        subplot(400+20+CASE1(CASE))
        if CASE==1, title(['Prey biomass: 2->' num2str(FLAG)]); end;
        if CASE==4, xlabel('Time'); end;
        hold on
        plot(TVAL{CASE,FLAG},X11or{CASE,FLAG,SIM}/INITCOND(CASE,2),TVAL{CASE,FLAG},YVAL{CASE,FLAG,SIM}(1,:)/INITCOND(CASE,2))
        hold off
        ylabel(INIT{CASE})
        subplot(400+20+CASE2(CASE))
        hold on
        if CASE==1, title(['Predator Biomass 2->' num2str(FLAG)]); end;
        plot(TVAL{CASE,FLAG},X21or{CASE,FLAG,SIM}/INITCOND(CASE,3),TVAL{CASE,FLAG},YVAL{CASE,FLAG,SIM}(2,:)/INITCOND(CASE,3))
        if CASE==4, xlabel('Time'); end;
        hold off
    end
    legend1=legend('Optimal','Bottom-up');
    set(legend1,'Orientation','horizontal',...
        'Position',[0.348824786324786 0.00869025450031037 0.334401709401709 0.0446927374301676]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Case 3: Egg predation in other cases (3-> 1 2 4)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for CASE=1:4
    FLAG=3; SIM=3;
    Ti=t11T{CASE,FLAG}(time);
    t0=min(Ti); tf=max(Ti);
    STEPS=round((tf-t0)/h);
    F1e=E11T{CASE,FLAG}(time); % optimal F
    Tt=linspace(t0,tf,STEPS);
    F1=interp1(Ti,F1e,Tt);
    F2e=E21T{CASE,FLAG}(time);
    F2=interp1(Ti,F2e,Tt);
    y0=[INITCOND(CASE,2), INITCOND(CASE,3),INITCOND(CASE,4)];
    
    for FLAG=1:4
        % Calls another file
        ProfitCalculation
        
    end
    
    
end

%  Plotting results
for FLAG=[1 2 3 4]
    figure
    for CASE=1:4
        subplot(400+20+CASE1(CASE))
        if CASE==1, title(['Prey biomass: 3->' num2str(FLAG)]); end;
        if CASE==4, xlabel('Time'); end;
        hold on
        plot(TVAL{CASE,FLAG},X11or{CASE,FLAG,SIM}/INITCOND(CASE,2),TVAL{CASE,FLAG},YVAL{CASE,FLAG,SIM}(1,:)/INITCOND(CASE,2))
        hold off
        ylabel(INIT{CASE})
        subplot(400+20+CASE2(CASE))
        hold on
        if CASE==1, title(['Predator Biomass 3->' num2str(FLAG)]); end;
        plot(TVAL{CASE,FLAG},X21or{CASE,FLAG,SIM}/INITCOND(CASE,3),TVAL{CASE,FLAG},YVAL{CASE,FLAG,SIM}(2,:)/INITCOND(CASE,3))
        if CASE==4, xlabel('Time'); end;
        hold off
    end
    legend1=legend('Optimal','Egg');
    set(legend1,'Orientation','horizontal',...
        'Position',[0.348824786324786 0.00869025450031037 0.334401709401709 0.0446927374301676]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Case 4: Depsenation in other cases (4-> 1 2 3 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for CASE=1:4
    FLAG=4; SIM=4;
    Ti=t11T{CASE,FLAG}(time);
    t0=min(Ti); tf=max(Ti);
    STEPS=round((tf-t0)/h);
    F1e=E11T{CASE,FLAG}(time); % optimal F
    Tt=linspace(t0,tf,STEPS);
    F1=interp1(Ti,F1e,Tt);
    F2e=E21T{CASE,FLAG}(time);
    F2=interp1(Ti,F2e,Tt);
    y0=[INITCOND(CASE,2), INITCOND(CASE,3),INITCOND(CASE,4)];
    
    for FLAG=1:4
        ProfitCalculation
    end
    
    
end

% % Plotting results
for FLAG=[1 2 3 4]
    figure
    for CASE=1:4
        subplot(400+20+CASE1(CASE))
        if CASE==1, title(['Prey biomass: 4->' num2str(FLAG)]); end;
        if CASE==4, xlabel('Time'); end;
        hold on
        plot(TVAL{CASE,FLAG},X11or{CASE,FLAG,SIM}/INITCOND(CASE,2),TVAL{CASE,FLAG},YVAL{CASE,FLAG,SIM}(1,:)/INITCOND(CASE,2))
        hold off
        ylabel(INIT{CASE})
        subplot(400+20+CASE2(CASE))
        hold on
        if CASE==1, title(['Predator Biomass 4->' num2str(FLAG)]); end;
        plot(TVAL{CASE,FLAG},X21or{CASE,FLAG,SIM}/INITCOND(CASE,3),TVAL{CASE,FLAG},YVAL{CASE,FLAG,SIM}(2,:)/INITCOND(CASE,3))
        if CASE==4, xlabel('Time'); end;
        hold off
    end
    legend1=legend('Optimal','Egg w/dep.');
    set(legend1,'Orientation','horizontal',...
        'Position',[0.348824786324786 0.00869025450031037 0.334401709401709 0.0446927374301676]);
end


%% Robustness check on results
% The following figures illustrate the optimal and sub-optimal dynamics of
% the DDE. A robustness check that the DDE solver is working is that the
% dynamics of the optimal solution, as generated by the optimal control
% problem should be the same that are being predicted by the DDE solver
% when we plug in the optimal solution under the same model assumptions.

% Legend is read 1<-2 means optimal solution from 2 (bottom-up) is inserted
% into independent model

LINE={'--g','-r','-.b',':m','k'};
for FLAG=1:4;
    figure
    for CASE=1:4
        subplot(400+20+CASE1(CASE))
        plot(TVAL{CASE,FLAG},X11or{CASE,FLAG,FLAG}/INITCOND(CASE,2),LINE{1})
        hold on
        if CASE==1, title(['Prey biomass']); end;
        
        for SIM=1:4
            plot(...
                TVAL{CASE,FLAG},YVAL{CASE,FLAG,SIM}(1,:)/INITCOND(CASE,2),LINE{SIM+1})
        end
        hold off
        ylabel(INIT{CASE})
        subplot(400+20+CASE2(CASE))
        plot(TVAL{CASE,FLAG},X21or{CASE,FLAG,FLAG}/INITCOND(CASE,3),LINE{1})
        hold on
        if CASE==1, title(['Predator Biomass']); end;
        for SIM=1:4
            plot(...
                TVAL{CASE,FLAG},YVAL{CASE,FLAG,SIM}(2,:)/INITCOND(CASE,3),LINE{SIM+1})
        end
        hold off
        
        if FLAG==1
            legend1=legend('optimal','1<-1','1<-2','1<-3','1<-4');
        elseif FLAG==2
            legend1=legend('optimal','2<-1','2<-2','2<-3','2<-4');
        elseif FLAG==3
            legend1=legend('optimal','3<-1','3<-2','3<-3','3<-4');
        else
            legend1=legend('optimal','4<-1','4<-2','4<-3','4<-4');
        end
        set(legend1,'Orientation','horizontal',...
            'Position',[0.348824786324786 0.00869025450031037 0.334401709401709 0.0446927374301676]);
    end
end

% Now without the robustness check from above.
LINE={'--k','-r','-.b',':m','g'};
for FLAG=1:4;
    zz=figure;
    for CASE=1:4
        subplot(400+20+CASE1(CASE))
        hold on
        if CASE==1, title(['Prey biomass']); end;
        for SIM=1:4
            plot(TVAL{CASE,FLAG},YVAL{CASE,FLAG,SIM}(1,:)/INITCOND(CASE,2),LINE{SIM+1})
        end
        hold off
        ylabel(INIT{CASE})
        subplot(400+20+CASE2(CASE))
        hold on
        if CASE==1, title(['Predator Biomass']); end;
        for SIM=1:4
            plot(TVAL{CASE,FLAG},YVAL{CASE,FLAG,SIM}(2,:)/INITCOND(CASE,3),LINE{SIM+1})
        end
        hold off
        
        if FLAG==1
            legend1=legend('Optimal','1<-2','1<-3','1<-4');
        elseif FLAG==2
            legend1=legend('2<-1','Optimal','2<-3','2<-4');
        elseif FLAG==3
            legend1=legend('3<-1','3<-2','Optimal','3<-4');
        else
            legend1=legend('Egg NL<-Indep','Egg NL<-Bottom','Egg NL<-Egg L','Optimal');
        end
        set(legend1,'Orientation','horizontal',...
            'Position',[0.348824786324786 0.00869025450031037 0.334401709401709 0.0446927374301676]);
    end
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tables and plots capturing change in NPV from assuming wrong model
% *Columns are the truth, rows are assumed models*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colormap('jet')
FONT=12;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Case 1: High/High
BIOMASS=0;
cnames = {'Indep','Bottom-up','Egg Pred','Depensation'};
rnames = cnames;
CASE=1;
Plotting_WrongModel_Results

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NPV Case 2: Low/High
CASE=2;
Plotting_WrongModel_Results

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NPV Case 3: High/Low
CASE=3;
Plotting_WrongModel_Results

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NPV Case 4: Low/Low
CASE=4;
Plotting_WrongModel_Results


%% Tables and plots capturing the difference between the stock levels in the different cases

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Case 1: High/High
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BIOMASS=1;
cnames = {'Indep','Bottom-up','Egg Pred','Depensation'};
rnames = cnames;
CASE=1;
Plotting_WrongModel_Results

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Biomass Case 2: Low/High
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CASE=2;
Plotting_WrongModel_Results


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Biomass Case 3: High/Low
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CASE=3;
Plotting_WrongModel_Results


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Biomass Case 4: Low/Low
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CASE=4;
Plotting_WrongModel_Results


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Scatter plots of NPV and biomass
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BIOMASS=3;
Plotting_WrongModel_Results


