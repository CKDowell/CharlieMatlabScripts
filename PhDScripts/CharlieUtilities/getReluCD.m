function [yp,xxlin,yplin] = getReluCD(x,params)
if isnan(params(1))
    yp = ones(size(x)).*params(3);
    xxlin = [];
    yplin = [];
else
    if params(6)==1
        xmn = x<params(2);
        xlin = x>=params(2);
        yp = ones(size(x));
        yp(xmn) = params(3);
        yp(xlin) = [x(xlin) ones(sum(xlin),1)]*(params(4:5)');
    else
        xmn = x>params(2);
        xlin = x<=params(2);
        yp = ones(size(x));
        yp(xmn) = params(3);
        yp(xlin) = [x(xlin) ones(sum(xlin),1)]*(params(4:5)');

    end
    xxlin = x(xlin);
    yplin = yp(xlin);
end