function varargout = DrawMasks(varargin)
% DRAWMASKS MATLAB code for DrawMasks.fig
%      DRAWMASKS, by itself, creates a new DRAWMASKS or raises the existing
%      singleton*.
%
%      H = DRAWMASKS returns the handle to a new DRAWMASKS or the handle to
%      the existing singleton*.
%
%      DRAWMASKS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRAWMASKS.M with the given input arguments.
%
%      DRAWMASKS('Property','Value',...) creates a new DRAWMASKS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DrawMasks_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DrawMasks_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DrawMasks

% Last Modified by GUIDE v2.5 09-Dec-2020 16:43:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DrawMasks_OpeningFcn, ...
                   'gui_OutputFcn',  @DrawMasks_OutputFcn, ...
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


% --- Executes just before DrawMasks is made visible.
function DrawMasks_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DrawMasks (see VARARGIN)
tiffdir = varargin{1};
if length(varargin)>1
    maskdir = varargin{2};
    load(maskdir)
else
    gmMask = [];
end

if strcmp(tiffdir(end-1:end),'gz')
    IM = niftiread(tiffdir);
    IM = imrotate(IM,90);
    IM = flipud(IM);
else
    IM = tiff2stack(tiffdir);
end

handles.IMorig = IM;
IMcon = IM;
imdim =size(IM);
five = mod(imdim(3),5);
if five>0
    IMcon(:,:,end+1:end+5-five) = repmat(IM(:,:,end),1,1,5-five);
end
IMcon = reshape(IMcon,imdim(1),imdim(2),5,size(IMcon,3)./5);
IMcon = squeeze(mean(IMcon,3));
IMcondegree = 5;


imscale = [prctile(IM(:),1),prctile(IM(:),99.9)];
handles.edit4.String = num2str(imscale(1));
handles.edit5.String = num2str(imscale(2));
imshow(IM(:,:,1),imscale)
g = gca;
g.XTick = [];
g.YTick = [];
colormap(parula)
handles.IM = IM;
handles.IMcon = IM;
handles.z = 1;
handles.iscon = false;
handles.tiffdir = tiffdir;
handles.masknum = 1;
handles.masks(1).maskname = 'Mask1';
handles.masks(1).mask = zeros(size(IM));
sep = strfind(tiffdir,filesep);
handles.edit2.String = tiffdir(1:sep(end)-1);
% Choose default command line output for DrawMasks
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DrawMasks wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DrawMasks_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
z = handles.z;

z = z+1;
iscon = handles.iscon;
masknum = handles.masknum;

if iscon
    IM = handles.IMcon;
    if z>size(IM,3)
        z = size(IM,3);
    end
    
    condex = find(handles.imconmap==z);
    thismask = handles.masks(masknum).mask(:,:,condex(1));
else
    IM = handles.IM;
    if z>size(IM,3)
        z = size(IM,3);
    end
    thismask = handles.masks(masknum).mask(:,:,z);
end
thisim = IM(:,:,z);
%imscale = [prctile(thisim(:),1),prctile(thisim(:),99)];
imscale = [str2num(handles.edit4.String) str2num(handles.edit5.String)];
if imscale(2)>0
    thisim(thisim>imscale(2)) = imscale(2);
end
thisim = mat2gray(thisim);
cmp = colormap('parula');
imshow(imoverlay(thisim,thismask,[1 0 0]))
g = gca;
g.XTick = [];
g.YTick = [];
colormap(parula)
handles.z = z;
handles.text2.String = [num2str(z) '/' num2str(size(IM,3))];
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
z = handles.z;
z = z-1;
masknum = handles.masknum;
if z<1
        z = 1;
end
iscon = handles.iscon;
if iscon
    IM = handles.IMcon;
    condex = find(handles.imconmap==z);
    thismask = handles.masks(masknum).mask(:,:,condex(1));
else  
    IM = handles.IM;
    thismask = handles.masks(masknum).mask(:,:,z);
end
thisim = IM(:,:,z);
%imscale = [prctile(thisim(:),1),prctile(thisim(:),99)];
imscale = [str2num(handles.edit4.String) str2num(handles.edit5.String)];

if imscale(2)>0
    thisim(thisim>imscale(2)) = imscale(2);
end
thisim = mat2gray(thisim);
imshow(imoverlay(thisim,thismask,[1 0 0]))
g = gca;
g.XTick = [];
g.YTick = [];
colormap(parula)
handles.z = z;
handles.text2.String = [num2str(z) '/' num2str(size(IM,3))];
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
masknum = handles.masknum;
guimask = handles.masks(masknum).mask;
savedir = handles.edit2.String;
savename = handles.edit1.String;
save([savedir filesep savename '.mat'],'guimask')
tname = [savedir filesep savename '.tiff'];
imwrite(guimask(:,:,1),tname,'Compression','lzw')
for i = 2:size(guimask,3)
    imwrite(guimask(:,:,i),tname,'Writemode','append','Compression','lzw')
end
guidata(hObject, handles);
% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
handles = guidata(hObject);

handles.masknum = handles.listbox1.Value;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

handles.iscon = true;
IM = handles.IMorig;
IMcon = IM;
imdim =size(IM);

comp = handles.edit3.String;
if strcmp(comp,'Compression')
    handles.edit3.String = '5';
    comp = handles.edit3.String;
end
comp = str2num(comp);
five = mod(imdim(3),comp);
imconmap = 1:size(IM,3);
handles.imconmap = ceil(imconmap./comp);
if five>0
    IMcon(:,:,end+1:end+comp-five) = repmat(IM(:,:,end),1,1,comp-five);
end
IMcon = reshape(IMcon,imdim(1),imdim(2),comp,size(IMcon,3)./comp);
handles.IMcon = squeeze(mean(IMcon,3));
handles.IMcondegree = comp;
IM = IMcon;
z= 1;
handles.z = z;
%imscale = IM(:,:,z);
imscale = [str2num(handles.edit4.String) str2num(handles.edit5.String)];

%imscale = [prctile(imscale(:),1),prctile(imscale(:),99)];
colormap('parula')
cmp = parula(10);
imshow(IM(:,:,z),imscale,'Colormap',cmp)
g = gca;
g.XTick = [];
g.YTick = [];
colormap(parula)
handles.text2.String = [num2str(z) '/' num2str(size(IM,3))];
guidata(hObject, handles);


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
IM= handles.IM;
z = handles.z;
imdim = size(IM);

masknum = handles.masknum;
boxstring = handles.listbox1.String{masknum};
if strcmp(boxstring,'Listbox')
    maskname= handles.edit1.String;
    handles.listbox1.String{masknum} =maskname;
    handles.masks(masknum).mask = zeros(size(IM));
else
    maskname= handles.edit1.String;
    if ~strcmp(boxstring,maskname)
        masknum = masknum+1;
        handles.listbox1.String{masknum} =maskname;
        handles.masks(masknum).mask = zeros(size(IM));
    end
end
handles.listbox1.Value = masknum;
z = handles.z;
X = [];
Y = [];
hold on
for i = 1:1000
    [x,y,] = ginputRed(1);
    if isempty(x)
        break
    end
    X= [X;x];
    Y = [Y;y];
    plot(X,Y,'Color',[0 1 0])
end
X = [X;X(1)];
Y = [Y;Y(1)];
thismask = poly2mask(X,Y,imdim(1),imdim(2));
if handles.checkbox2.Value
    thismask =thismask==0;
end
if handles.iscon
    dex = handles.imconmap==z;
    if handles.checkbox1.Value
        handles.masks(masknum).mask(:,:,dex) = handles.masks(masknum).mask(:,:,dex)+thismask;
        handles.masks(masknum).mask(:,:,dex) = handles.masks(masknum).mask(:,:,dex)>0;
    else
        handles.masks(masknum).mask(:,:,dex) = repmat(thismask,1,1,sum(dex));
    end
else
    if handles.checkbox1.Value
        handles.masks(masknum).mask(:,:,z) = handles.masks(masknum).mask(:,:,z)+thismask;
        handles.masks(masknum).mask(:,:,z) = handles.masks(masknum).mask(:,:,z)>0;
    else
        handles.masks(masknum).mask(:,:,z) = thismask;
    end
end
handles.masknum = masknum;
guidata(hObject,handles);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = guidata(hObject);
z = round(handles.slider1.Value.*size(handles.IM,3));
handles.z = z;
plotimage(handles)
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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ThresholdMask.
function ThresholdMask_Callback(hObject, eventdata, handles)
% hObject    handle to ThresholdMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
z = handles.z;
IM= handles.IM;
z = handles.z;
imdim = size(IM);
masknum = handles.masknum;
boxstring = handles.listbox1.String{masknum};
if strcmp(boxstring,'Listbox')
    maskname= handles.edit1.String;
    handles.listbox1.String{masknum} =maskname;
    handles.masks(masknum).mask = zeros(size(IM));
else
    maskname= handles.edit1.String;
    if ~strcmp(boxstring,maskname)
        masknum = masknum+1;
        handles.listbox1.String{masknum} =maskname;
        handles.masks(masknum).mask = zeros(size(IM));
    end
end

iscon = handles.iscon;
if iscon
    IM = handles.IMcon;
else  
    IM = handles.IM;
end

thisim = IM(:,:,z);
LT = str2num(handles.LowerThresh.String);
UT = str2num(handles.UpperThresh.String);
minsize = str2num(handles.MinSize.String);
thismask = thisim>LT&thisim<UT;
L = bwlabel(thismask,4);
[c,u] = uniquecount(L(:));
usmall= u(c<minsize);
L(ismember(L(:),usmall)) = 0;
thismask = L>0;

if handles.checkbox2.Value
    thismask =thismask==0;
end
if handles.iscon
    dex = handles.imconmap==z;
    if handles.checkbox1.Value
        handles.masks(masknum).mask(:,:,dex) = handles.masks(masknum).mask(:,:,dex)+thismask;
        handles.masks(masknum).mask(:,:,dex) = handles.masks(masknum).mask(:,:,dex)>0;
    else
        handles.masks(masknum).mask(:,:,dex) = repmat(thismask,1,1,sum(dex));
    end
else
    if handles.checkbox1.Value
        handles.masks(masknum).mask(:,:,z) = handles.masks(masknum).mask(:,:,z)+thismask;
        handles.masks(masknum).mask(:,:,z) = handles.masks(masknum).mask(:,:,z)>0;
    else
        handles.masks(masknum).mask(:,:,z) = thismask;
    end
end



handles.masknum = masknum;
plotimage(handles)
guidata(hObject,handles);

function LowerThresh_Callback(hObject, eventdata, handles)
% hObject    handle to LowerThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LowerThresh as text
%        str2double(get(hObject,'String')) returns contents of LowerThresh as a double


% --- Executes during object creation, after setting all properties.
function LowerThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LowerThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UpperThresh_Callback(hObject, eventdata, handles)
% hObject    handle to UpperThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UpperThresh as text
%        str2double(get(hObject,'String')) returns contents of UpperThresh as a double


% --- Executes during object creation, after setting all properties.
function UpperThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UpperThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function plotimage(handles)
iscon = handles.iscon;
masknum = handles.masknum;
z = handles.z;
if iscon
    IM = handles.IMcon;
    if z>size(IM,3)
        z = size(IM,3);
    end
    
    condex = find(handles.imconmap==z);
    thismask = handles.masks(masknum).mask(:,:,condex(1));
else
    IM = handles.IM;
    if z>size(IM,3)
        z = size(IM,3);
    end
    thismask = handles.masks(masknum).mask(:,:,z);
end
thisim = IM(:,:,z);
%imscale = [prctile(thisim(:),1),prctile(thisim(:),99)];
imscale = [str2num(handles.edit4.String) str2num(handles.edit5.String)];

if imscale(2)>0
    thisim(thisim>imscale(2)) = imscale(2);
end
thisim = mat2gray(thisim);
imshow(imoverlay(thisim,thismask,[1 0 0]))
g = gca;
g.XTick = [];
g.YTick = [];
colormap(parula)
handles.text2.String = [num2str(z) '/' num2str(size(IM,3))];



function MinSize_Callback(hObject, eventdata, handles)
% hObject    handle to MinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinSize as text
%        str2double(get(hObject,'String')) returns contents of MinSize as a double


% --- Executes during object creation, after setting all properties.
function MinSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Trimmer.
function Trimmer_Callback(hObject, eventdata, handles)
% hObject    handle to Trimmer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
masknum = handles.masknum;
z = handles.z;
iscon = handles.iscon;
if iscon
    IM = handles.IMcon;
    if z>size(IM,3)
        z = size(IM,3);
    end 
    condex = find(handles.imconmap==z);
    thismask = handles.masks(masknum).mask(:,:,condex(1));
else
    IM = handles.IM;
    if z>size(IM,3)
        z = size(IM,3);
    end
    thismask = handles.masks(masknum).mask(:,:,z);
end
imdim = size(IM);
X = [];
Y = [];
hold on
for i = 1:1000
    [x,y,] = ginputRed(1);
    if isempty(x)
        break
    end
    X= [X;x];
    Y = [Y;y];
    plot(X,Y,'Color',[0 1 0])
end
X = [X;X(1)];
Y = [Y;Y(1)];
remmask = poly2mask(X,Y,imdim(1),imdim(2));
remmask = remmask>0;
thismask(remmask) = 0;
if handles.iscon
    dex = handles.imconmap==z;
    if handles.checkbox1.Value
        handles.masks(masknum).mask(:,:,dex) = handles.masks(masknum).mask(:,:,dex)+thismask;
        handles.masks(masknum).mask(:,:,dex) = handles.masks(masknum).mask(:,:,dex)>0;
    else
        handles.masks(masknum).mask(:,:,dex) = repmat(thismask,1,1,sum(dex));
    end
else
    if handles.checkbox1.Value
        handles.masks(masknum).mask(:,:,z) = handles.masks(masknum).mask(:,:,z)+thismask;
        handles.masks(masknum).mask(:,:,z) = handles.masks(masknum).mask(:,:,z)>0;
    else
        handles.masks(masknum).mask(:,:,z) = thismask;
    end
end
handles.masknum = masknum;
plotimage(handles)
guidata(hObject,handles);
