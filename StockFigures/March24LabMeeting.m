%% Sines offset from one another
x = -pi:0.01:pi;
close all
savedir = 'Y:\Presentations\2024\MarchLabMeeting';
offsets = -pi:pi/8:pi;
for o = offsets
    goal = cos(x+o);
    PFL_L = cos(x-pi/4);
    PFL_R = cos(x+pi/4);
    
    
    
    figure
    subplot(2,1,1)
    plot(x,goal,'Color',[0.8 0.5 0])
    hold on
    plot(x,PFL_L,'Color',[0.5 0.5 1])
    plot(x,PFL_R,'Color',[1 0.5 0.5])
    g = gca;
    g.TickDir = 'out';
    g.FontSize = 15;
    xlim([-pi,pi])
    xticks([-pi:pi/2:pi])
    xticklabels({'-\pi';'-\pi/2';'0';'\pi/2';'\pi'})
    xlabel('Goal and orientation bumps')
    g.Box ='off';
    
    subplot(2,1,2)
    PFL_Lout = exp(PFL_L+goal);
    PFL_Rout = exp(PFL_R+goal);
    plot(x,PFL_Lout,'Color',[0.5 0.5 1])
    hold on
    plot(x,PFL_Rout,'Color',[1 0.5 0.5])
    g = gca;
    g.TickDir = 'out';
    g.FontSize = 15;
    g.Box ='off';
    xlim([-pi,pi])
    xticks([-pi:pi/2:pi])
    xticklabels({'-\pi';'-\pi/2';'0';'\pi/2';'\pi'})
    print(gcf,fullfile(savedir,['PFL_goal_off' num2str(pi/o) '.eps']),'-painters','-depsc')
end


%%
x = -pi:0.01:pi;
close all
savedir = 'Y:\Presentations\2024\MarchLabMeeting';
offsets = -pi:pi/8:pi;
cnt = 0;
for o = offsets
    cnt = cnt+1;
    goal = cos(x);
    PFL_L = cos(x-pi/4+o);
    PFL_R = cos(x+pi/4+o);
    
    
    
    figure
    subplot(2,1,1)
    plot(x,goal,'Color',[0.8 0.5 0])
    hold on
    plot(x,PFL_L,'Color',[0.5 0.5 1])
    plot(x,PFL_R,'Color',[1 0.5 0.5])
    g = gca;
    g.TickDir = 'out';
    g.FontSize = 15;
    xlim([-pi,pi])
    xticks([-pi:pi/2:pi])
    xticklabels({'-\pi';'-\pi/2';'0';'\pi/2';'\pi'})
    xlabel('Goal and orientation bumps')
    g.Box ='off';
    
    subplot(2,1,2)
    PFL_Lout = exp(PFL_L+goal);
    PFL_Rout = exp(PFL_R+goal);
    plot(x,PFL_Lout,'Color',[0.5 0.5 1])
    hold on
    plot(x,PFL_Rout,'Color',[1 0.5 0.5])
    g = gca;
    g.TickDir = 'out';
    g.FontSize = 15;
    g.Box ='off';
    xlim([-pi,pi])
    xticks([-pi:pi/2:pi])
    xticklabels({'-\pi';'-\pi/2';'0';'\pi/2';'\pi'})
    print(gcf,fullfile(savedir,['PFL_orientation_off' num2str(cnt) '.eps']),'-painters','-depsc')
end

%%

x = linspace(-pi,pi,16);
r = sin(x)+1;
x1 = r.*sin(x);
y1 = r.*cos(x);
%scatter(x1,y1)
hold on
xplot = [zeros(size(x1));x1];
yplot = [zeros(size(y1));y1];
plot(xplot,yplot,'Color','k')
xlim([-2,2])
ylim([-2 2])

xmean = sum(x1);
ymean = sum(y1);
plot([0,xmean],[0,ymean],'Color','k','LineWidth',3)

