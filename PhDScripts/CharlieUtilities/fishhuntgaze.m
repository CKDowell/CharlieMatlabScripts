function [newgaze,x,y,cone,coneL,coneR] = fishhuntgaze(langles,rangles,FOV,d)
%% Function Description
% Calculates the position of binocular overlap of the fish's eyes, its
% angle relative to the midline, and the size of the 'cone' of binocular
% overlap in the left and right visual fields.
% Typical parameter values:
% d: is distance between lenses 458e-6 in Bianco 2011
% FOV is eye field of view, 163 degrees in Easter and Nicolas 1996
% Charlie Dowell June 2020


% Find angle of leading edge of visual field
offset = (180-FOV)./2;
langles = 90-(langles-offset);
rangles =90 +(rangles+offset);
cone = 180-rangles-langles;
% Find point of cross over for binocular field
x = (d.*tand(rangles))./(tand(langles)+tand(rangles));  
y = x.*tand(langles);
% use cross over point to calculate angle

x = x-d./2;
newgaze = atand(x./y);
ng2 =atand(y./x);
coneL = nan(size(cone));
coneR = coneL;
dx = newgaze>0;
coneL(dx) = 180-rangles(dx)-ng2(dx);
coneR(dx) = ng2(dx)-langles(dx);
coneL(~dx) = -ng2(~dx)-rangles(~dx);
coneR(~dx) = 180-langles(~dx)+ng2(~dx);
end