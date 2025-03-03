function plotNtraceDendrites(trace,xi,yi,dvec,colour1,colour2)
hold on
for i = 2:size(trace,1)
    x1 = trace(i,xi);
    y1 = trace(i,yi);
    dx = trace(i,7);
    x2 = trace(dx,xi);
    y2 = trace(dx,yi);
    if ismember(i,dvec)
        plot([x2 x1],[y2 y1],'Color',colour2)
    else
        plot([x2 x1],[y2 y1],'Color',colour1)
    end
    drawnow
    %text(x1,y1,num2str(i),'Color','w');
end
hold off
end