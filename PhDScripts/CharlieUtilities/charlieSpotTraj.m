function b = charlieSpotTraj(traj,maxa,R,f2s,sweepamp)
hmax = R.*sin(deg2rad(maxa));
signs = sign(traj);
traj = traj.*signs;
h = (traj./sweepamp).*hmax; % negative spotraj to switch from proj space to fish POV
theta = asin(h./R);

[b] = spotangl_e(rad2deg(theta), R, f2s);
b(signs==1) = -b(signs==1);
%b = b.*signs;
end


function [b,s]=spotangl_e(a,R,f)

%%
% written by IHB, July 2012
% see blue labbook for maths/diagrams

% b, angular location of spot wrt fish
% s, distance from fish to spot

% R = dish radius, in mm (eg 35 mm)
% a = angular location of spot relative to dish center
% f, distance from fish 2 screen

%%
a=deg2rad(a);
b=atan((R.*sin(a))./(f-R+sqrt((R.^2).*(1-(sin(a)).^2))));

s=R.*(sin(a)./sin(b));

b=rad2deg(b);
b(b<0)= b(b<0)+180;
end