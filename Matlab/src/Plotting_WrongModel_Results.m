% Plotting the biomass differences with wrong model


L1={'Indep','Bottom','Egg L','Egg NL'};
L2={'Egg NL','Egg L','Bottom','Indep'};

if BIOMASS==1
    
    for i=1:4
        dath(1,i)=100*([YVAL{CASE,1,i}(1,end)]/[X11or{CASE,1, 1}(end)])-100;
        dath(2,i)=100*([YVAL{CASE,2,i}(1,end)]/[X11or{CASE,2, 2}(end)])-100;
        dath(3,i)=100*([YVAL{CASE,3,i}(1,end)]/[X11or{CASE,3, 3}(end)])-100;
        dath(4,i)=100*([YVAL{CASE,4,i}(1,end)]/[X11or{CASE,4, 4}(end)])-100;
        
        datc(1,i)=100*([YVAL{CASE,1,i}(2,end)]/[X21or{CASE,1, 1}(end)])-100;
        datc(2,i)=100*([YVAL{CASE,2,i}(2,end)]/[X21or{CASE,2, 2}(end)])-100;
        datc(3,i)=100*([YVAL{CASE,3,i}(2,end)]/[X21or{CASE,3, 3}(end)])-100;
        datc(4,i)=100*([YVAL{CASE,4,i}(2,end)]/[X21or{CASE,4, 4}(end)])-100;
    end
    
    f=figure;
    set(f,'Position',[500 388 452 262]);
    table = uitable('Parent',f,'Data',dath,'ColumnName',cnames,...
        'RowName',rnames,'Position', [18 114 426 100]);
    set(table,'ColumnWidth','auto')
    
    f=figure;
    set(f,'Position',[500 388 452 262]);
    table = uitable('Parent',f,'Data',datc,'ColumnName',cnames,...
        'RowName',rnames,'Position', [18 114 426 100]);
    set(table,'ColumnWidth','auto')
    
    plotdatarange=[(1.1*min(min([datc dath]))) (1.1*max(max([datc dath])))];
    
    figure
    
    colormap('jet')
    subplot(121)
    h=imagesc(dath)
    set(gca,'XTick',1:4,'XAxisLocation','top')
    set(gca,'YTick', 1:4)
    set(gca,'XTickLabel',L1,'FontSize',FONT)
    set(gca,'YTickLabel',L1,'FontSize',FONT)
    xlabel('Assumed Model','FontSize',FONT)
    ylabel('True Model','FontSize',FONT)
    if CASE==1
        title('High Herring/High Cod - Biomass Herring','FontSize',FONT)
    elseif CASE==2
        title('Herring Low/High Cod- Biomass Herring','FontSize',FONT)
    elseif CASE==3
        title('Herring High/Low Cod - Biomass Herring','FontSize',FONT)
    else
        title('Herring Low/Low Cod - Biomass Herring','FontSize',FONT)
    end
    caxis(plotdatarange)
    colorbar
    colorbar('location', 'southoutside')
    
    subplot(122)
    h=imagesc(datc)
    set(gca,'XTick',1:4,'XAxisLocation','top')
    set(gca,'YTick', 1:4)
    set(gca,'XTickLabel',L1,'FontSize',FONT)
    set(gca,'YTickLabel',L1,'FontSize',FONT)
    xlabel('Assumed Model','FontSize',FONT)
    ylabel('True Model','FontSize',FONT)
    if CASE==1
        title('High Herring/High Cod - Biomass Cod','FontSize',FONT)
    elseif CASE==2
        title('Herring Low/High Cod- Biomass Cod','FontSize',FONT)
    elseif CASE==3
        title('Herring High/Low Cod - Biomass Cod','FontSize',FONT)
    else
        title('Herring Low/Low Cod - Biomass Cod','FontSize',FONT)
    end
    caxis(plotdatarange)
    colorbar
    colorbar('location', 'southoutside')
    
elseif BIOMASS==0  % plots the NPV cases
    
    plotdatarange=[-25 5];
    f=figure;
    set(f,'Position',[500 388 452 262]);
    
    for i=1:4
        dat(1,i)=100*([NPV{CASE,1,i}]/[NPV{CASE,1,1}])-100;
        dat(2,i)=100*([NPV{CASE,2,i}]/[NPV{CASE,2,2}])-100;
        dat(3,i)=100*([NPV{CASE,3,i}]/[NPV{CASE,3,3}])-100;
        dat(4,i)=100*([NPV{CASE,4,i}]/[NPV{CASE,4,4}])-100;
        
        dath(1,i)=100*([hNPV{CASE,1,i}]/[hNPV{CASE,1,1}])-100;
        dath(2,i)=100*([hNPV{CASE,2,i}]/[hNPV{CASE,2,2}])-100;
        dath(3,i)=100*([hNPV{CASE,3,i}]/[hNPV{CASE,3,3}])-100;
        dath(4,i)=100*([hNPV{CASE,4,i}]/[hNPV{CASE,4,4}])-100;
        
        datc(1,i)=100*([cNPV{CASE,1,i}]/[cNPV{CASE,1,1}])-100;
        datc(2,i)=100*([cNPV{CASE,2,i}]/[cNPV{CASE,2,2}])-100;
        datc(3,i)=100*([cNPV{CASE,3,i}]/[cNPV{CASE,3,3}])-100;
        datc(4,i)=100*([cNPV{CASE,4,i}]/[cNPV{CASE,4,4}])-100;
    end
    
    
    
    table = uitable('Parent',f,'Data',dat,'ColumnName',cnames,...
        'RowName',rnames,'Position', [18 114 426 100]);
    set(table,'ColumnWidth','auto')
    
    figure
    h=imagesc(dat)
    set(gca,'XTick',1:4,'XAxisLocation','top')
    set(gca,'YTick', 1:4)
    set(gca,'XTickLabel',L1,'FontSize',FONT)
    set(gca,'YTickLabel',L1,'FontSize',FONT)
    xlabel('Assumed Model','FontSize',FONT)
    ylabel('True Model','FontSize',FONT)
    if CASE==1
        title('High Herring/High Cod -NPV','FontSize',FONT)
    elseif CASE==2
        title('Herring Low/High Cod- NPV','FontSize',FONT)
    elseif CASE==3
        title('Herring High/Low Cod - NPV','FontSize',FONT)
    else
        title('Herring Low/Low Cod - NPV','FontSize',FONT)
    end
    caxis(plotdatarange)
    colorbar
    colorbar('location', 'southoutside')
    
    
else
    
    for i=1:4
        for CASE=1:4
            hIndDat(i,CASE )=([hNPV{CASE,1,i}]/[hNPV{CASE,1,1}])-1;
            hPreDat(i,CASE)=([hNPV{CASE,2,i}]/[hNPV{CASE,2,2}])-1;
            hEggDat(i,CASE)=([hNPV{CASE,3,i}]/[hNPV{CASE,3,3}])-1;
            hEgDDat(i,CASE)=([hNPV{CASE,4,i}]/[hNPV{CASE,4,4}])-1;
            
            cIndDat(i,CASE )=([cNPV{CASE,1,i}]/[cNPV{CASE,1,1}])-1;
            cPreDat(i,CASE)=([cNPV{CASE,2,i}]/[cNPV{CASE,2,2}])-1;
            cEggDat(i,CASE)=([cNPV{CASE,3,i}]/[cNPV{CASE,3,3}])-1;
            cEgDDat(i,CASE)=([cNPV{CASE,4,i}]/[cNPV{CASE,4,4}])-1;
            
            Inddath(i,CASE)=([YVAL{CASE,1,i}(1,end)]/[HerringT])-1;
            Predath(i,CASE)=([YVAL{CASE,2,i}(1,end)]/[HerringT])-1;
            Eggdath(i,CASE)=([YVAL{CASE,3,i}(1,end)]/[HerringT])-1;
            EgDdath(i,CASE)=([YVAL{CASE,4,i}(1,end)]/[HerringT])-1;
            
            Inddatc(i,CASE)=([YVAL{CASE,1,i}(2,end)]/[CodBT])-1;
            Predatc(i,CASE)=([YVAL{CASE,2,i}(2,end)]/[CodBT])-1;
            Eggdatc(i,CASE)=([YVAL{CASE,3,i}(2,end)]/[CodBT])-1;
            EgDdatc(i,CASE)=([YVAL{CASE,4,i}(2,end)]/[CodBT])-1;
            
            
        end
    end
    
    %% Grouping variables to do gscatter plots which will work better for our purposes
    
    CASECODE={'h H/h C','l H/h C','h H/l C','l H/l C'};
    for i=1:4
        for CASE=1:4
            II(i,CASE)=i;
            CX(i,CASE)=CASE;
        end
    end
    
    HInd=[reshape(hIndDat,16,1), reshape(Inddath,16,1) , reshape(II,16,1), reshape(CX,16,1)];
    HPre =[reshape(hPreDat,16,1), reshape(Predath,16,1), reshape(II,16,1), reshape(CX,16,1)];
    HEgg=[reshape(hEggDat,16,1), reshape(Eggdath,16,1),  reshape(II,16,1), reshape(CX,16,1)];
    HEgD=[reshape(hEgDDat,16,1), reshape(EgDdath,16,1),  reshape(II,16,1), reshape(CX,16,1)];
    
    CInd=[reshape(cIndDat,16,1), reshape(Inddatc,16,1) , reshape(II,16,1), reshape(CX,16,1)];
    CPre =[reshape(cPreDat,16,1), reshape(Predatc,16,1), reshape(II,16,1), reshape(CX,16,1)];
    CEgg=[reshape(cEggDat,16,1), reshape(Eggdatc,16,1),  reshape(II,16,1), reshape(CX,16,1)];
    CEgD=[reshape(cEgDDat,16,1), reshape(EgDdatc,16,1),  reshape(II,16,1), reshape(CX,16,1)];
    
    SYM = ['o','+','*','d'];
    
    xmin=-2; xmax=2; ymin=-2; ymax=2;
    COLOR= [0 0 0; 0 1 0; 0 0 1; 1 0 0];
    Marker = [8, 12, 16, 20];
    figure1=figure
    axes1 = axes('Parent',figure1); %,  'XTickLabel',['',sprintf('\n'),'']);
    xlim(axes1,[xmin xmax]);  ylim(axes1,[ymin ymax]);  hold(axes1,'all');
    for i=1:4
        for CASE=1:4
            line(hIndDat(i,CASE),Inddath(i,CASE),'Parent',axes1,'Marker',SYM(CASE),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(1), 'DisplayName','Indep');
            line(hPreDat(i,CASE),Predath(i,CASE),'Parent',axes1,'Marker',SYM(CASE),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Pred');
            line(hEggDat(i,CASE),Eggdath(i,CASE),'Parent',axes1,'Marker',SYM(CASE),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(3), 'DisplayName','Egg');
            line(hEgDDat(i,CASE),EgDdath(i,CASE),'Parent',axes1,'Marker',SYM(CASE),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(4), 'DisplayName','Egg D');
        end
    end
    plot(linspace(xmin,xmax,10),0*linspace(ymin,ymax,10),'Parent',axes1,'Color',[0 0 0])
    plot(linspace(xmin,xmax,10)*0,linspace(ymin,ymax,10),'Parent',axes1,'Color',[0 0 0])
    %legend(subplot1,'show');
    ylabel('Deviation off of target')
    xlabel('Deviation off of optimal NPV')
    title({'Herring', 'Symbol = Initial Cond, Color=Model, Size=True Model'})
    
    annotation(figure1,'textbox',...
        [0.7 0.430952380952381 0.183928571428571 0.47757142857143],...
        'String',{'o = h H/h C', '+ =l H/h C','* =h H/l C', 'd = l H/l C', 'Black = Ind', ...
        'Red =Egg D ', 'Blue=Egg ', 'Green=Pred', 'vSmall=Ind','Small=Pre','Large=Egg', 'vLarge=EggD'},...
        'LineStyle', 'none');
    
    %% New Figure 3 for paper
    xmin=-.5; xmax=.5; ymin=-.5; ymax=.5;
    COLOR= [0 0 0; 0 1 0; 0 0 1; 1 0 0];
    Marker = [8, 12, 16, 20];
    figure1=figure
    axes1 = axes('Parent',figure1); %,  'XTickLabel',['',sprintf('\n'),'']);
    xlim(axes1,[xmin xmax]);  ylim(axes1,[ymin ymax]);  hold(axes1,'all');
    for i=1:4
        for CASE=1
            line(hIndDat(i,CASE),Inddath(i,CASE),'Parent',axes1,'Marker',SYM(1),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Indep');
            line(hPreDat(i,CASE),Predath(i,CASE),'Parent',axes1,'Marker',SYM(2),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Pred');
            line(hEggDat(i,CASE),Eggdath(i,CASE),'Parent',axes1,'Marker',SYM(3),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Egg');
            line(hEgDDat(i,CASE),EgDdath(i,CASE),'Parent',axes1,'Marker',SYM(4),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Egg D');
        end
    end
    plot(linspace(xmin,xmax,10),0*linspace(ymin,ymax,10),'Parent',axes1,'Color',[0 0 0])
    plot(linspace(xmin,xmax,10)*0,linspace(ymin,ymax,10),'Parent',axes1,'Color',[0 0 0])
    %legend(subplot1,'show');
    ylabel('Deviation off of target', 'FontSize',12)
    xlabel('Deviation off of optimal NPV','FontSize',12)
    title({'Herring Case 1: H,H ', ' Color=Assumed Model, Symbol=True Model'},'FontSize',12)
    
    
    annotation(figure1,'textbox',...
        [0.7 0.430952380952381 0.183928571428571 0.47757142857143],...
        'String',{'o =Ind', '+ =Pre','* =Egg', 'd =EggD', 'Black = Ind', ...
        'Red =Egg D ', 'Blue=Egg ', 'Green=Pred'},...
        'LineStyle', 'none','FontSize',12);
    
    
    %%
    xmin=-2; xmax=2; ymin=-2; ymax=2;
    COLOR= [0 0 0; 0 1 0; 0 0 1; 1 0 0];
    Marker = [8, 12, 16, 20];
    figure1=figure
    axes2 = axes('Parent',figure1); %,  'XTickLabel',['',sprintf('\n'),'']);
    xlim(axes2,[xmin xmax]);  ylim(axes2,[ymin ymax]);  hold(axes2,'all');
    for i=1:4
        for CASE=3
            line(cIndDat(i,CASE),Inddatc(i,CASE),'Parent',axes2,'Marker',SYM(1),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Indep');
            line(cPreDat(i,CASE),Predatc(i,CASE),'Parent',axes2,'Marker',SYM(2),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Pred');
            line(cEggDat(i,CASE),Eggdatc(i,CASE),'Parent',axes2,'Marker',SYM(3),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Egg');
            line(cEgDDat(i,CASE),EgDdatc(i,CASE),'Parent',axes2,'Marker',SYM(4),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Egg D');
        end
    end
    plot(linspace(xmin,xmax,10),0*linspace(ymin,ymax,10),'Parent',axes2,'Color',[0 0 0])
    plot(linspace(xmin,xmax,10)*0,linspace(ymin,ymax,10),'Parent',axes2,'Color',[0 0 0])
    %legend(subplot1,'show');
    ylabel('Deviation off of target', 'FontSize',12)
    xlabel('Deviation off of optimal NPV','FontSize',12)
    title({'Cod Case 3 ', ' Color=Assumed Model, Symbol=True Model'},'FontSize',12)
    
    
    annotation(figure1,'textbox',...
        [0.7 0.430952380952381 0.183928571428571 0.47757142857143],...
        'String',{'o =Ind', '+ =Pre','* =Egg', 'd =EggD', 'Black = Ind', ...
        'Red =Egg D ', 'Blue=Egg ', 'Green=Pred'},...
        'LineStyle', 'none','FontSize',12);
    
    %%
    figure1=figure
    xmin=-.5; xmax=.5; ymin=-.5; ymax=.5;
    COLOR= [0 0 0; 0 1 0; 0 0 1; 1 0 0];
    Marker = [8, 12, 16, 20];
    for CASE=1:4
        subplot1 =subplot(2,2,CASE,'Parent', figure1)
        
        %axes1 = axes('Parent',subplot1); %,  'XTickLabel',['',sprintf('\n'),'']);
        xlim(subplot1,[xmin xmax]);  ylim(subplot1,[ymin ymax]);  hold(subplot1,'all');
        for i=1:4
            
            line(hIndDat(i,CASE),Inddath(i,CASE),'Parent',subplot1,'Marker',SYM(1),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Indep');
            line(hPreDat(i,CASE),Predath(i,CASE),'Parent',subplot1,'Marker',SYM(2),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Pred');
            line(hEggDat(i,CASE),Eggdath(i,CASE),'Parent',subplot1,'Marker',SYM(3),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Egg');
            line(hEgDDat(i,CASE),EgDdath(i,CASE),'Parent',subplot1,'Marker',SYM(4),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Egg D');
            
        end
        plot(linspace(xmin,xmax,10),0*linspace(ymin,ymax,10),'Parent',subplot1,'Color',[0 0 0])
        plot(linspace(xmin,xmax,10)*0,linspace(ymin,ymax,10),'Parent',subplot1,'Color',[0 0 0])
        %legend(subplot1,'show');
        ylabel('Deviation off of target', 'FontSize',12)
        xlabel('Deviation off of optimal NPV','FontSize',12)
        if CASE==1
            
            title({'Herring Case 1 ', ' Color=Assumed Model, Symbol=True Model'},'FontSize',12)
        elseif CASE==2
            title({'Herring Case 2 ', ' Color=Assumed Model, Symbol=True Model'},'FontSize',12)
        elseif CASE==3
            title({'Herring Case 3 ', ' Color=Assumed Model, Symbol=True Model'},'FontSize',12)
            
        else
            title({'Herring Case 4', ' Color=Assumed Model, Symbol=True Model'},'FontSize',12)
            annotation(figure1,'textbox',...
                [0.7 0.430952380952381 0.183928571428571 0.47757142857143],...
                'String',{'o =Ind', '+ =Pre','* =Egg', 'd =EggD', 'Black = Ind', ...
                'Red =Egg D ', 'Blue=Egg ', 'Green=Pred'},...
                'LineStyle', 'none','FontSize',12);
            
        end
        
        
        % annotation(subplot1,'textbox',...
        %            [0.7 0.430952380952381 0.183928571428571 0.47757142857143],...
        %            'String',{'o =Ind', '+ =Pre','* =Egg', 'd =EggD', 'Black = Ind', ...
        %              'Red =Egg D ', 'Blue=Egg ', 'Green=Pred'},...
        %            'LineStyle', 'none','FontSize',12);
        
    end
    
    figure1=figure
    xmin=-2.6; xmax=.5; ymin=-1.2; ymax=1;
    COLOR= [0 0 0; 0 1 0; 0 0 1; 1 0 0];
    Marker = [8, 12, 16, 20];
    for CASE=1:4
        subplot1 =subplot(2,2,CASE,'Parent', figure1)
        
        %axes1 = axes('Parent',subplot1); %,  'XTickLabel',['',sprintf('\n'),'']);
        xlim(subplot1,[xmin xmax]);  ylim(subplot1,[ymin ymax]);  hold(subplot1,'all');
        for i=1:4
            
            line(cIndDat(i,CASE),Inddatc(i,CASE),'Parent',subplot1,'Marker',SYM(1),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(3), 'DisplayName','Indep');
            line(cPreDat(i,CASE),Predatc(i,CASE),'Parent',subplot1,'Marker',SYM(2),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(3), 'DisplayName','Pred');
            line(cEggDat(i,CASE),Eggdatc(i,CASE),'Parent',subplot1,'Marker',SYM(3),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(3), 'DisplayName','Egg');
            line(cEgDDat(i,CASE),EgDdatc(i,CASE),'Parent',subplot1,'Marker',SYM(4),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(3), 'DisplayName','Egg D');
            
        end
        plot(linspace(xmin,xmax,10),0*linspace(ymin,ymax,10),'Parent',subplot1,'Color',[0 0 0])
        plot(linspace(xmin,xmax,10)*0,linspace(ymin,ymax,10),'Parent',subplot1,'Color',[0 0 0])
        %legend(subplot1,'show');
        ylabel('Deviation off of target', 'FontSize',12)
        xlabel('Deviation off of optimal NPV','FontSize',12)
        if CASE==1
            
            title({'Cod Case 1 ', ' Color=Assumed Model, Symbol=True Model'},'FontSize',12)
        elseif CASE==2
            title({'Cod Case 2 ', ' Color=Assumed Model, Symbol=True Model'},'FontSize',12)
        elseif CASE==3
            title({'Cod Case 3 ', ' Color=Assumed Model, Symbol=True Model'},'FontSize',12)
            
        else
            title({'Cod Case 4', ' Color=Assumed Model, Symbol=True Model'},'FontSize',12)
            annotation(figure1,'textbox',...
                [0.7 0.430952380952381 0.183928571428571 0.47757142857143],...
                'String',{'o =Ind', '+ =Pre','* =Egg', 'd =EggD', 'Black = Ind', ...
                'Red =Egg D ', 'Blue=Egg ', 'Green=Pred'},...
                'LineStyle', 'none','FontSize',12);
            
        end
        
        
        % annotation(subplot1,'textbox',...
        %            [0.7 0.430952380952381 0.183928571428571 0.47757142857143],...
        %            'String',{'o =Ind', '+ =Pre','* =Egg', 'd =EggD', 'Black = Ind', ...
        %              'Red =Egg D ', 'Blue=Egg ', 'Green=Pred'},...
        %            'LineStyle', 'none','FontSize',12);
        
    end
    
    
    figure2=figure
    axes2 = axes('Parent',figure2); %,  'XTickLabel',['',sprintf('\n'),'']);
    xlim(axes2,[xmin xmax]);  ylim(axes2,[ymin ymax]);  hold(axes2,'all');
    for i=1:4
        for CASE=3
            line(cIndDat(i,CASE),Inddatc(i,CASE),'Parent',axes2,'Marker',SYM(1),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(1), 'DisplayName','Indep');
            line(cPreDat(i,CASE),Predatc(i,CASE),'Parent',axes2,'Marker',SYM(2),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(2), 'DisplayName','Pred');
            line(cEggDat(i,CASE),Eggdatc(i,CASE),'Parent',axes2,'Marker',SYM(3),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(3), 'DisplayName','Egg');
            line(cEgDDat(i,CASE),EgDdatc(i,CASE),'Parent',axes2,'Marker',SYM(4),'LineStyle','none',...
                'Color', COLOR(i,:),'MarkerSize',Marker(4), 'DisplayName','Egg D');
        end
    end
    plot(linspace(xmin,xmax,10),0*linspace(ymin,ymax,10),'Parent',axes2,'Color',[0 0 0])
    plot(linspace(xmin,xmax,10)*0,linspace(ymin,ymax,10),'Parent',axes2,'Color',[0 0 0])
    %legend(subplot1,'show');
    ylabel('Deviation off of target')
    xlabel('Deviation off of optimal NPV')
    title({'Cod', 'Symbol = Initial Cond, Color=Model, Size=True Model'})
    
    annotation(figure2,'textbox',...
        [0.7 0.430952380952381 0.183928571428571 0.47757142857143],...
        'String',{'o = h H/h C', '+ =l H/h C','* =h H/l C', 'd = l H/l C', 'Black = Ind', ...
        'Red =Egg D ', 'Blue=Egg ', 'Green=Pred', 'vSmall=Ind','Small=Pre','Large=Egg', 'vLarge=EggD'},...
        'LineStyle', 'none');
    
    
    %% Trying a new figure 4 panel
    
    figure1=figure
    xmin=-.5; xmax=.5; ymin=-.5; ymax=.5;
    COLOR= [0 0 0; 0 1 0; 0 0 1; 1 0 0];
    Marker = [8, 12, 16, 20];
    for i=1:4
        subplot1 =subplot(2,2,i,'Parent', figure1)
        
        %axes1 = axes('Parent',subplot1); %,  'XTickLabel',['',sprintf('\n'),'']);
        xlim(subplot1,[xmin xmax]);  ylim(subplot1,[ymin ymax]);  hold(subplot1,'all');
        for CASE=1:4
            
            if i==1
                %line(hIndDat(i,CASE),Inddath(i,CASE),'Parent',subplot1,'Marker',SYM(1),'LineStyle','none',...
                %     'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Indep');
                line(hPreDat(i,CASE),Predath(i,CASE),'Parent',subplot1,'Marker',SYM(2),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Pred');
                line(hEggDat(i,CASE),Eggdath(i,CASE),'Parent',subplot1,'Marker',SYM(3),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Egg');
                line(hEgDDat(i,CASE),EgDdath(i,CASE),'Parent',subplot1,'Marker',SYM(4),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Egg D');
                
            elseif i==2
                line(hIndDat(i,CASE),Inddath(i,CASE),'Parent',subplot1,'Marker',SYM(1),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Indep');
                %line(hPreDat(i,CASE),Predath(i,CASE),'Parent',subplot1,'Marker',SYM(2),'LineStyle','none',...
                %     'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Pred');
                line(hEggDat(i,CASE),Eggdath(i,CASE),'Parent',subplot1,'Marker',SYM(3),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Egg');
                line(hEgDDat(i,CASE),EgDdath(i,CASE),'Parent',subplot1,'Marker',SYM(4),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Egg D');
                
            elseif i==3
                line(hIndDat(i,CASE),Inddath(i,CASE),'Parent',subplot1,'Marker',SYM(1),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Indep');
                line(hPreDat(i,CASE),Predath(i,CASE),'Parent',subplot1,'Marker',SYM(2),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Pred');
                %line(hEggDat(i,CASE),Eggdath(i,CASE),'Parent',subplot1,'Marker',SYM(3),'LineStyle','none',...
                %     'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Egg');
                line(hEgDDat(i,CASE),EgDdath(i,CASE),'Parent',subplot1,'Marker',SYM(4),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Egg D');
                
            else
                line(hIndDat(i,CASE),Inddath(i,CASE),'Parent',subplot1,'Marker',SYM(1),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Indep');
                line(hPreDat(i,CASE),Predath(i,CASE),'Parent',subplot1,'Marker',SYM(2),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Pred');
                line(hEggDat(i,CASE),Eggdath(i,CASE),'Parent',subplot1,'Marker',SYM(3),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Egg');
                %line(hEgDDat(i,CASE),EgDdath(i,CASE),'Parent',subplot1,'Marker',SYM(4),'LineStyle','none',...
                %     'Color', COLOR(CASE,:),'MarkerSize',Marker(2), 'DisplayName','Egg D');
                
            end
        end
        plot(linspace(xmin,xmax,10),0*linspace(ymin,ymax,10),'Parent',subplot1,'Color',[0 0 0])
        plot(linspace(xmin,xmax,10)*0,linspace(ymin,ymax,10),'Parent',subplot1,'Color',[0 0 0])
        %legend(subplot1,'show');
        ylabel('Deviation off of target', 'FontSize',12)
        xlabel('Deviation off of optimal NPV','FontSize',12)
        if i==1
            
            title({'Herring : Assumed = independent', ' Color=Case, Symbol=True'},'FontSize',12)
        elseif i==2
            title({'Herring : Assumed = predation', ' Color=Case, Symbol=True'},'FontSize',12)
        elseif i==3
            title({'Herring : Assumed = Egg', ' Color=Case, Symbol=True'},'FontSize',12)
            
        else
            title({'Herring: Assumed = Egg Dis.', ' Color=Case, Symbol=True'},'FontSize',12)
            annotation(figure1,'textbox',...
                [0.7 0.430952380952381 0.183928571428571 0.47757142857143],...
                'String',{'o =Ind', '+ =Pre','* =Egg', 'd =EggD', 'Black = H/H', ...
                'Red =H/L ', 'Blue=L/H ', 'Green=L/L'},...
                'LineStyle', 'none','FontSize',12);
            
        end
    end
    
    
    %%
    figure1=figure
    xmin=-2.6; xmax=.5; ymin=-1.2; ymax=1;
    COLOR= [0 0 0; 0 1 0; 0 0 1; 1 0 0];
    Marker = [8, 12, 16, 20];
    for i=1:4
        subplot1 =subplot(2,2,i,'Parent', figure1)
        
        %axes1 = axes('Parent',subplot1); %,  'XTickLabel',['',sprintf('\n'),'']);
        xlim(subplot1,[xmin xmax]);  ylim(subplot1,[ymin ymax]);  hold(subplot1,'all');
        for CASE=1:4
            
            if i==1
                %line(cIndDat(i,CASE),Inddatc(i,CASE),'Parent',subplot1,'Marker',SYM(1),'LineStyle','none',...
                %         'Color', COLOR(i,:),'MarkerSize',Marker(3), 'DisplayName','Indep');
                line(cPreDat(i,CASE),Predatc(i,CASE),'Parent',subplot1,'Marker',SYM(2),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(3), 'DisplayName','Pred');
                line(cEggDat(i,CASE),Eggdatc(i,CASE),'Parent',subplot1,'Marker',SYM(3),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(3), 'DisplayName','Egg');
                line(cEgDDat(i,CASE),EgDdatc(i,CASE),'Parent',subplot1,'Marker',SYM(4),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(3), 'DisplayName','Egg D');
                
                
            elseif i==2
                line(cIndDat(i,CASE),Inddatc(i,CASE),'Parent',subplot1,'Marker',SYM(1),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(3), 'DisplayName','Indep');
                
                %       line(cPreDat(i,CASE),Predatc(i,CASE),'Parent',subplot1,'Marker',SYM(2),'LineStyle','none',...
                %           'Color', COLOR(i,:),'MarkerSize',Marker(3), 'DisplayName','Pred');
                line(cEggDat(i,CASE),Eggdatc(i,CASE),'Parent',subplot1,'Marker',SYM(3),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(3), 'DisplayName','Egg');
                line(cEgDDat(i,CASE),EgDdatc(i,CASE),'Parent',subplot1,'Marker',SYM(4),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(3), 'DisplayName','Egg D');
                
                
            elseif i==3
                line(cIndDat(i,CASE),Inddatc(i,CASE),'Parent',subplot1,'Marker',SYM(1),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(3), 'DisplayName','Indep');
                line(cPreDat(i,CASE),Predatc(i,CASE),'Parent',subplot1,'Marker',SYM(2),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(3), 'DisplayName','Pred');
                %      line(cEggDat(i,CASE),Eggdatc(i,CASE),'Parent',subplot1,'Marker',SYM(3),'LineStyle','none',...
                %         'Color', COLOR(i,:),'MarkerSize',Marker(3), 'DisplayName','Egg');
                line(cEgDDat(i,CASE),EgDdatc(i,CASE),'Parent',subplot1,'Marker',SYM(4),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(3), 'DisplayName','Egg D');
                
                
            else
                line(cIndDat(i,CASE),Inddatc(i,CASE),'Parent',subplot1,'Marker',SYM(1),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(3), 'DisplayName','Indep');
                line(cPreDat(i,CASE),Predatc(i,CASE),'Parent',subplot1,'Marker',SYM(2),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(3), 'DisplayName','Pred');
                line(cEggDat(i,CASE),Eggdatc(i,CASE),'Parent',subplot1,'Marker',SYM(3),'LineStyle','none',...
                    'Color', COLOR(CASE,:),'MarkerSize',Marker(3), 'DisplayName','Egg');
                %      line(cEgDDat(i,CASE),EgDdatc(i,CASE),'Parent',subplot1,'Marker',SYM(4),'LineStyle','none',...
                %         'Color', COLOR(i,:),'MarkerSize',Marker(3), 'DisplayName','Egg D');
                
                
            end
        end
        plot(linspace(xmin,xmax,10),0*linspace(ymin,ymax,10),'Parent',subplot1,'Color',[0 0 0])
        plot(linspace(xmin,xmax,10)*0,linspace(ymin,ymax,10),'Parent',subplot1,'Color',[0 0 0])
        %legend(subplot1,'show');
        ylabel('Deviation off of target', 'FontSize',12)
        xlabel('Deviation off of optimal NPV','FontSize',12)
        if i==1
            
            title({'Cod : Assumed = independent', ' Color=Case, Symbol=True'},'FontSize',12)
        elseif i==2
            title({'Cod : Assumed = predation', ' Color=Case, Symbol=True'},'FontSize',12)
        elseif i==3
            title({'Cod : Assumed = Egg', ' Color=Case, Symbol=True'},'FontSize',12)
            
        else
            title({'Cod: Assumed = Egg Dis.', ' Color=Case, Symbol=True'},'FontSize',12)
            annotation(figure1,'textbox',...
                [0.7 0.430952380952381 0.183928571428571 0.47757142857143],...
                'String',{'o =Ind', '+ =Pre','* =Egg', 'd =EggD', 'Black = H/H', ...
                'Red =H/L ', 'Blue=L/H ', 'Green=L/L'},...
                'LineStyle', 'none','FontSize',12);
            
        end
    end
end
