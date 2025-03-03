function [Y,I] = mintolerance(data,tolerance)
% outputs min value that is lower than tolerance
[Y,I] = min(data);
if Y>tolerance
    Y = [];
    I = [];
end
end