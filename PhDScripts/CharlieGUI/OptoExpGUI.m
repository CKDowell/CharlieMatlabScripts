function varargout = OptoExpGUI(varargin)
% OPTOEXPGUI MATLAB code for OptoExpGUI.fig
%      OPTOEXPGUI, by itself, creates a new OPTOEXPGUI or raises the existing
%      singleton*.
%
%      H = OPTOEXPGUI returns the handle to a new OPTOEXPGUI or the handle to
%      the existing singleton*.
%
%      OPTOEXPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTOEXPGUI.M with the given input arguments.
%
%      OPTOEXPGUI('Property','Value',...) creates a new OPTOEXPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OptoExpGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OptoExpGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OptoExpGUI

% Last Modified by GUIDE v2.5 09-Nov-2020 18:12:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OptoExpGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OptoExpGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before OptoExpGUI is made visible.
function OptoExpGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OptoExpGUI (see VARARGIN)

% Choose default command line output for OptoExpGUI
handles.output = hObject;
datadir = varargin{1};
anatdir = fullfile(datadir,'registration');
handles.datadir = datadir;
handles.anatdir = anatdir;
%% Anatomy structure
load(fullfile(anatdir,'gmOptoAnat.mat'))
z = 1;
im = 1;
handles.im = 1;
if ~isfield(gmOptoAnat,'coords')
    coords = nan(5*length(gmOptoAnat.expdirs),3);
    coorddex = 1:length(gmOptoAnat.expdirs);
    coorddex = repmat(coorddex,5,1);
    coorddex = coorddex(:); %5 coords, middle, TL,TR,BR,BL corners
    gmOptoAnat.coords = coords;
    gmOptoAnat.coorddex = coorddex;
end

handles.gmOptoAnat = gmOptoAnat;
%% Plot first stack image
axes(handles.axes1)
imagesc(gmOptoAnat.master(:,:,z))
colormap('gray')
xticks([])
yticks([])
%% Plot first image
plot_righthandside(handles)
%% Update handles structure
handles.z =1;
handles.logtracker = 0;
handles.logtrackerR = 0;
guidata(hObject, handles);

% UIWAIT makes OptoExpGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OptoExpGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = guidata(hObject);
v = handles.slider1.Value;
gmOptoAnat = handles.gmOptoAnat;
imrange = 1:size(handles.gmOptoAnat.master,3);
imterp = linspace(0,1,size(handles.gmOptoAnat.master,3));
imd =findnearest(v,imterp,-1);
z = imrange(imd);
handles.z = z;
plot_lefthandside(handles)
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in leftbutton.
function leftbutton_Callback(hObject, eventdata, handles)
% hObject    handle to leftbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
z = handles.z;
handles.z = max(z-1,1);

imrange = 1:size(handles.gmOptoAnat.master,3);
imterp = linspace(0,1,size(handles.gmOptoAnat.master,3));
f = imrange==handles.z;
handles.slider1.Value= imterp(f);

plot_lefthandside(handles)
guidata(hObject,handles);

% --- Executes on button press in rightbutton.
function rightbutton_Callback(hObject, eventdata, handles)
% hObject    handle to rightbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
m = size(handles.gmOptoAnat.master,3);
z = handles.z;
handles.z = min(z+1,m);

imrange = 1:size(handles.gmOptoAnat.master,3);
imterp = linspace(0,1,size(handles.gmOptoAnat.master,3));
f = imrange==handles.z;
handles.slider1.Value= imterp(f);
plot_lefthandside(handles)
guidata(hObject,handles);

% --- Executes on button press in MarkROI.
function MarkROI_Callback(hObject, eventdata, handles)
% hObject    handle to MarkROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
gmOptoAnat = handles.gmOptoAnat;
z = handles.z;
[x,y,] = ginputRed(1);
rawcoords = nan(5,3);
rawcoords(1,1:2) =[x,y];
rawcoords(:,3) = z;
im = handles.im;
fovsize = gmOptoAnat.FOVs(im,:);
yscale = gmOptoAnat.master_gm.ypx;
xscale = gmOptoAnat.master_gm.xpx;
% For Box around point
rawcoords(2,1) = x - fovsize(1)./(2*xscale);
rawcoords(3,1) = x + fovsize(1)./(2*xscale);
rawcoords(4,1) = x + fovsize(1)./(2*xscale);
rawcoords(5,1) = x - fovsize(1)./(2*xscale);

rawcoords(2,2) = y + fovsize(2)./(2*yscale);
rawcoords(3,2) = y + fovsize(2)./(2*yscale);
rawcoords(4,2) = y - fovsize(2)./(2*yscale);
rawcoords(5,2) = y - fovsize(2)./(2*yscale);

cdx = gmOptoAnat.coorddex==handles.im;
gmOptoAnat.coords(cdx,:) =rawcoords;
handles.gmOptoAnat = gmOptoAnat;
plot_lefthandside(handles);
guidata(hObject,handles);

function planenumber_Callback(hObject, eventdata, handles)
% hObject    handle to planenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of planenumber as text
%        str2double(get(hObject,'String')) returns contents of planenumber as a double


% --- Executes during object creation, after setting all properties.
function planenumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to planenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in previousstimplane.
function previousstimplane_Callback(hObject, eventdata, handles)
% hObject    handle to previousstimplane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
im = handles.im;
handles.im = max(im-1,1);
plot_righthandside(handles)
guidata(hObject,handles);

% --- Executes on button press in nextstimplane.
function nextstimplane_Callback(hObject, eventdata, handles)
% hObject    handle to nextstimplane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
m = length(handles.gmOptoAnat.expdirs);
im = handles.im;
handles.im = min(im+1,m);
plot_righthandside(handles)
guidata(hObject,handles);

% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
disp('saving...')
anatdir = handles.anatdir;
gmOptoAnat = handles.gmOptoAnat;
if handles.logtracker>0
    gmOptoAnat.master = handles.masterO;
end
% if handles.logtrackerR>0
%     gmOptoAnat.exp_planes = handles.exp_planesO;
% end
save(fullfile(anatdir,'gmOptoAnat.mat'),'gmOptoAnat');
zpx = diff(gmOptoAnat.master_gm.zrange(1:2));
xpx = gmOptoAnat.master_gm.xpx;
ypx = gmOptoAnat.master_gm.ypx;
csvcoords = gmOptoAnat.coords.*[xpx ypx zpx];
csvcoords(:,4:6) = [ones(size(csvcoords,1),2) NaN(size(csvcoords,1),1)];
T = array2table(csvcoords,'VariableNames',{'x','y','z','t','label','comment'});
savedir = fullfile(anatdir,['centroids2ref_' gmOptoAnat.id '.csv']);

writetable(T,savedir);
disp('saved.')
guidata(hObject,handles);


function expnum_Callback(hObject, eventdata, handles)
% hObject    handle to expnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of expnum as text
%        str2double(get(hObject,'String')) returns contents of expnum as a double


% --- Executes during object creation, after setting all properties.
function expnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on plot LHS
function plot_lefthandside(handles)
axes(handles.axes1)
coords = handles.gmOptoAnat.coords;
z = handles.z;
thisim = handles.gmOptoAnat.master(:,:,z);
imagesc(thisim)
imdims = size(thisim);
colormap('gray')
imdx = handles.gmOptoAnat.coorddex==handles.im;
handles.planenumber.String = num2str(z);
xticks([])
yticks([])
if sum(~isnan(coords(imdx,1)))==sum(imdx)&z==nanmean(coords(imdx,3))
    hold on
    coords = handles.gmOptoAnat.coords(imdx,:);
    scatter(coords(1,1),coords(1,2),100,'+','MarkerEdgeColor','r')
    plot([coords(1,1) coords(1,1)],[1 imdims(1)],'Color','r')
    plot([1 imdims(2)],[coords(1,2) coords(1,2)],'Color','r')
    for i = 1:3
        plot(coords(i+1:i+2,1),coords(i+1:i+2,2),'LineWidth',2,'Color','r')
    end
    plot(coords([5 2],1),coords([5 2],2),'LineWidth',2,'Color','r')
    hold off
end

% --- Executes on plot RHS
function plot_righthandside(handles)
axes(handles.axes2)
gmOptoAnat = handles.gmOptoAnat;
im = handles.im;
fovsize = gmOptoAnat.FOVs(im,:);
imdx = gmOptoAnat.IMindex(im);
thisimage = gmOptoAnat.AllIMs(imdx).IM;
imagesc(thisimage)
imdims = size(thisimage);
colormap('gray')
hold on

%% need to edit to account for change in scan software

offsets = gmOptoAnat.FOV_offsets(im,:);

mdpnt = imdims./2+(imdims./2).*fliplr(offsets);
scatter(mdpnt(2),mdpnt(1),100,'+','MarkerEdgeColor','r')
plot([mdpnt(2) mdpnt(2)],[1 imdims(1)],'Color','r')
plot([1 imdims(2)],[mdpnt(1) mdpnt(1)],'Color','r')
yscale = gmOptoAnat.AllIMs(imdx).gm.ypx;
xscale = gmOptoAnat.AllIMs(imdx).gm.xpx;
xes = [mdpnt(2)+fovsize(1)./(2*xscale),mdpnt(2)-fovsize(1)./(2*xscale)];
yes = [mdpnt(1)+fovsize(2)./(2*yscale),mdpnt(1)-fovsize(2)./(2*yscale)];
plot(xes,[yes(1) yes(1)],'Color','r','LineWidth',2)
plot(xes,[yes(2) yes(2)],'Color','r','LineWidth',2)
plot([xes(1) xes(1)],yes,'Color','r','LineWidth',2)
plot([xes(2) xes(2)],yes,'Color','r','LineWidth',2)
xticks([])
yticks([])
hold off
handles.expnum.String = num2str(im);


% --- Executes on button press in logLHS.
function logLHS_Callback(hObject, eventdata, handles)
% hObject    handle to logLHS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
z = handles.z;
handles.logtracker = handles.logtracker+1;
if  handles.logtracker ==1
    handles.masterO = handles.gmOptoAnat.master;%keep original master
end

handles.gmOptoAnat.master(:,:,z) = log(handles.gmOptoAnat.master(:,:,z));
plot_lefthandside(handles)
guidata(hObject,handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
im = handles.im;
handles.logtrackerR = handles.logtrackerR+1;
% if  handles.logtrackerR ==1
%     handles.exp_planesO = handles.gmOptoAnat.exp_planes;%keep original master
% end
gmOptoAnat = handles.gmOptoAnat;
im = handles.im;
imdx = gmOptoAnat.IMindex(im);
thisimage = gmOptoAnat.AllIMs(imdx).IM;
thisimage = rescale(thisimage,1,255);
handles.gmOptoAnat.AllIMs(imdx).IM = log(thisimage);
plot_righthandside(handles)
guidata(hObject,handles);
