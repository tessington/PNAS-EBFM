% Profit calculation for Egg predation paper


        [tvals, yvals]=RK_DDE_FIXEDSTEP(t0,tf,y0,tau,h,STEPS,F1,F2,FLAG,CASE,INITCOND,capT,Param);
        
        tvals=[tvals(1:end-1),tf];
        YVAL{CASE,FLAG,SIM}(1,:)=yvals(1,:).*(yvals(1,:)>=0)+0*yvals(1,:);
        YVAL{CASE,FLAG,SIM}(2,:)=yvals(2,:).*(yvals(2,:)>=0)+0*yvals(2,:);
        TVAL{CASE,FLAG,SIM}=tvals;
        X11=interp1(Ti,x11T{CASE,FLAG}(time),tvals); % taking the optimal solutions and putting on same timsestep
        X21=interp1(Ti,x21T{CASE,FLAG}(time),tvals);
        X11or{CASE,FLAG, SIM}=X11;
        X21or{CASE,FLAG,SIM}=X21;
        
        
        f1=interp1(Tt,F1,tvals); % table look at tval steps
        f2=interp1(Tt,F2,tvals);
      
        % this was utilized to avoid cases where the biological population
        % level was very low and there was the potential for profits
        threshold=.0000001; 
      
        % These profit functions are more general than what was used in the paper
        % but given the parameter levels we assumed, they are idential
        cprofit = (YVAL{CASE,FLAG,SIM}(2,:)>threshold).*(P(2)*q(1)*(1-exp(-f2)).*YVAL{CASE,FLAG,SIM}(2,:).^BETA(2) - c0(2)*f2 - c1(2).*f2.^2) +0* (YVAL{CASE,FLAG,SIM}(2,:)<=threshold);
        hprofit = (YVAL{CASE,FLAG,SIM}(1,:)>threshold).*( P(1)*q(2)*(1-exp(-f1)).*YVAL{CASE,FLAG,SIM}(1,:).^BETA(1) - c0(1)*f1 -c1(1).*f1.^2)+0* (YVAL{CASE,FLAG,SIM}(1,:)<=threshold);
        
        hprofitss=(YVAL{CASE,FLAG,SIM}(1,end) >threshold).*(P(1)*q(1)*(1-exp(-f1(end))).*YVAL{CASE,FLAG,SIM}(1,end).^BETA(1) - c0(1).*f1(end)- c1(1).*f1(end)^.2)...
            +0*(YVAL{CASE,FLAG,SIM}(1,end) <=threshold);
       
        cprofitss=(YVAL{CASE,FLAG,SIM}(2,end) >threshold).*(P(2)*q(2)*(1-exp(-f2(end))).*YVAL{CASE,FLAG,SIM}(2,end).^BETA(2) - c0(2).*f2(end) - c1(2).*f2(end).^2)...
            +0*(YVAL{CASE,FLAG,SIM}(2,end) <=threshold);
        
        profit = cprofit + hprofit;
        profitSS =cprofitss+hprofitss;
        
        t=linspace(t0,tf,5000);
        Profit=interp1(tvals, profit,t);
       
        hProfit=interp1(tvals, hprofit,t);
        cProfit=interp1(tvals, cprofit,t);
       
        % Approximating the intergral at fixed data points
        objective  = trapz(t,exp(-dis*t)'.*Profit' ,1);  
        cObjective = trapz(t,exp(-dis*t)'.*cProfit',1);  
        hObjective = trapz(t,exp(-dis*t)'.*hProfit',1); 
        
        NPV{CASE, FLAG, SIM}=objective;
        PROFIT{CASE, FLAG, SIM}=Profit;
        cPROFIT{CASE, FLAG, SIM}=cProfit;
        hPROFIT{CASE, FLAG, SIM}=hProfit;
        cNPV{CASE, FLAG, SIM}=cObjective;
        hNPV{CASE, FLAG, SIM}=hObjective;
