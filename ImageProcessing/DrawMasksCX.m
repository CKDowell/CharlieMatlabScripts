 function varargout = DrawMasksCX(varargin)
% DRAWMASKSCX MATLAB code for DrawMasksCX.fig
%      DRAWMASKSCX, by itself, creates a new DRAWMASKSCX or raises the existing
%      singleton*.
%
%      H = DRAWMASKSCX returns the handle to a new DRAWMASKSCX or the handle to
%      the existing singleton*.
%
%      DRAWMASKSCX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRAWMASKSCX.M with the given input arguments.
%
%      DRAWMASKSCX('Property','Value',...) creates a new DRAWMASKSCX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DrawMasksCX_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DrawMasksCX_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DrawMasksCX

% Last Modified by GUIDE v2.5 04-Nov-2024 16:14:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DrawMasksCX_OpeningFcn, ...
                   'gui_OutputFcn',  @DrawMasksCX_OutputFcn, ...
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


% --- Executes just before DrawMasksCX is made visible.
function DrawMasksCX_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DrawMasksCX (see VARARGIN)
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
if numel(imdim)==2
    five = 1;
else
    five = mod(imdim(3),5);

end

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
% Choose default command line output for DrawMasksCX
handles.output = hObject;
handles.eboffset = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DrawMasksCX wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DrawMasksCX_OutputFcn(hObject, eventdata, handles) 
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
z = handles.z+1;
IM = handles.IM;
if z>size(IM,3)
    z = size(IM,3);
end
handles.z = z;

iscon = handles.iscon;
masknum = handles.masknum;
plotimage(handles)
% if iscon
%     IM = handles.IMcon;
%     if z>size(IM,3)
%         z = size(IM,3);
%     end
% 
%     condex = find(handles.imconmap==z);
%     thismask = handles.masks(masknum).mask(:,:,condex(1));
% else

%     thismask = handles.masks(masknum).mask(:,:,z);
% end
% thisim = IM(:,:,z);
% %imscale = [prctile(thisim(:),1),prctile(thisim(:),99)];
% imscale = [str2num(handles.edit4.String) str2num(handles.edit5.String)];
% if imscale(2)>0
%     thisim(thisim>imscale(2)) = imscale(2);
% end
% thisim = mat2gray(thisim);
% cmp = colormap('parula');
% imshow(imoverlay(thisim,thismask,[1 0 0]))
% g = gca;
% g.XTick = [];
% g.YTick = [];
% colormap(parula)
% handles.z = z;
% handles.text2.String = [num2str(z) '/' num2str(size(IM,3))];
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
handles.z = z;
plotimage(handles)
% iscon = handles.iscon;
% if iscon
%     IM = handles.IMcon;
%     condex = find(handles.imconmap==z);
%     thismask = handles.masks(masknum).mask(:,:,condex(1));
% else  
%     IM = handles.IM;
%     thismask = handles.masks(masknum).mask(:,:,z);
% end
% thisim = IM(:,:,z);
% %imscale = [prctile(thisim(:),1),prctile(thisim(:),99)];
% imscale = [str2num(handles.edit4.String) str2num(handles.edit5.String)];
% 
% if imscale(2)>0
%     thisim(thisim>imscale(2)) = imscale(2);
% end
% thisim = mat2gray(thisim);
% imshow(imoverlay(thisim,thismask,[1 0 0]))
% g = gca;
% g.XTick = [];
% g.YTick = [];
% colormap(parula)
% handles.z = z;
% handles.text2.String = [num2str(z) '/' num2str(size(IM,3))];
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
masknum = handles.masknum;
guimask = handles.masks(masknum).mask;
% Change numbering for PB glomeruli
pblist = [2,4,6,8,10,12,14,16,1,3,5,7,9,11,13,15];
if handles.popupmenu1.Value==2
    % Change numbering for PB glomeruli
    % Change from left-right numbering to numbering that matches the EB.
    for i = 1:size(guimask,4)
        guimask(:,:,:,i) = (guimask(:,:,:,i)>0).*pblist(i);
    end
else
    % Simple for loop to make sure values are correct
    for i = 1:size(guimask,4)
        guimask(:,:,:,i) = (guimask(:,:,:,i)>0).*i;
    end
end





guimask = sum(guimask,4);
savedir = handles.edit2.String;
savename = handles.masks(masknum).maskname;
save([savedir filesep savename '.mat'],'guimask')
tname = [savedir filesep savename '.tiff'];
guimask = uint8(guimask);
imwrite(guimask(:,:,1),tname,'Compression','lzw')
for i = 2:size(guimask,3)
    imwrite(guimask(:,:,i),tname,'Writemode','append','Compression','lzw')
end
guidata(hObject, handles);


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
layer = str2num(handles.editglom.String);
thismask = (poly2mask(X,Y,imdim(1),imdim(2))>0).*layer;
if handles.checkbox2.Value
    thismask =thismask==0;
end
if handles.iscon
    dex = handles.imconmap==z;
    if handles.checkbox1.Value
        handles.masks(masknum).mask(:,:,dex,layer) = handles.masks(masknum).mask(:,:,dex)+thismask;
        handles.masks(masknum).mask(:,:,dex) = (handles.masks(masknum).mask(:,:,dex)>0).*layer;
    else
        handles.masks(masknum).mask(:,:,dex,layer) = repmat(thismask,1,1,sum(dex))+thismask;
    end
else
    if handles.checkbox1.Value
        handles.masks(masknum).mask(:,:,z,layer) = handles.masks(masknum).mask(:,:,z,layer)+thismask;
        handles.masks(masknum).mask(:,:,z) = (handles.masks(masknum).mask(:,:,z)>0).*layer;
    else
        handles.masks(masknum).mask(:,:,z,layer) = thismask;
    end
end
handles.masknum = masknum;
plotimage(handles)
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
layer = str2num(handles.editglom.String);
iscon = handles.iscon;
masknum = handles.masknum;
z = handles.z;
IM = handles.IM;
% if iscon
%     IM = handles.IMcon;
%     if z>size(IM,3)
%         z = size(IM,3);
%     end
% 
%     condex = find(handles.imconmap==z);
%     thismask = handles.masks(masknum).mask(:,:,condex(1),layer);
% else
%     IM = handles.IM;
%     if z>size(IM,3)
%         z = size(IM,3);
%     end
%     thismask = handles.masks(masknum).mask(:,:,z,layer);
% end
thisim = IM(:,:,z);
% %imscale = [prctile(thisim(:),1),prctile(thisim(:),99)];
imscale = [str2num(handles.edit4.String) str2num(handles.edit5.String)];

if imscale(2)>0
    thisim(thisim>imscale(2)) = imscale(2);
end
thisim = mat2gray(thisim);

hold off
colormap('gray')
imshow(thisim,colormap('gray'))
imshow(thisim)
colormap('gray')
hold on
for l = 1:size(handles.masks(masknum).mask,4)
    thismask = handles.masks(masknum).mask(:,:,z,l);
    tm_im = repmat(thismask,1,1,3);
    tm_im(:,:,2:3) = 0;
    I = imshow(tm_im);
    alpha = (thismask>0).*0.5;
    I.AlphaData = alpha;
    stats = regionprops(thismask>0,'Centroid');
    if ~isempty(stats)
        for i = 1:length(stats)
            text(stats(i).Centroid(1),stats(i).Centroid(2),num2str(l),'Color','g')
        end
    end
end


g = gca;
g.XTick = [];
g.YTick = [];
colormap('gray')
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
        %handles.masks(masknum).mask(:,:,dex) = handles.masks(masknum).mask(:,:,dex)>0;
    else
        handles.masks(masknum).mask(:,:,dex) = repmat(thismask,1,1,sum(dex));
    end
else
    if handles.checkbox1.Value
        handles.masks(masknum).mask(:,:,z) = handles.masks(masknum).mask(:,:,z)+thismask;
        %handles.masks(masknum).mask(:,:,z) = handles.masks(masknum).mask(:,:,z)>0;
    else
        handles.masks(masknum).mask(:,:,z) = thismask;
    end
end
handles.masknum = masknum;
plotimage(handles)
guidata(hObject,handles);



function editglom_Callback(hObject, eventdata, handles)
% hObject    handle to editglom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editglom as text
%        str2double(get(hObject,'String')) returns contents of editglom as a double


% --- Executes during object creation, after setting all properties.
function editglom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editglom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
handles = guidata(hObject);
if handles.popupmenu1.Value==2
    handles.masknum = 2;

    handles.masks(handles.masknum).maskname = 'pbmask';
    handles.masks(handles.masknum).mask = zeros([size(handles.IM),16]);
    handles.edit1.String = 'pbmask';
elseif handles.popupmenu1.Value ==3
    % edit for FSB mask
    % Will need to add project and segment
    handles.masknum = 3;
    handles.masks(handles.masknum).maskname = 'fsbmask';
    handles.masks(handles.masknum).mask = zeros([size(handles.IM),16]);
    % Idea is to draw mask in first dim. This is then split into separate
    % dims via a special function
elseif handles.popupmenu1.Value ==4
    % edit for EB mask
    % Will need to add project and segment to mask
    handles.masknum = 4;
    handles.masks(handles.masknum).maskname = 'ebmask';
    handles.masks(handles.masknum).mask = zeros([size(handles.IM),16]);

end
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonFSB.
function pushbuttonFSB_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonFSB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
figure
meanim = nanmean(handles.IM,3);
% show mean image
meanim = mat2gray(meanim);

hold off
colormap('gray')
imshow(meanim,colormap('gray'))
hold on
makewholescreen
% Show projected mask
masknum = handles.masknum;
projmask = nansum(nansum(handles.masks(masknum).mask,4),3);
I = imshow(projmask);
alpha = (projmask>0).*0.5;
I.AlphaData = alpha;

% Draw lines
X = [];
Y = [];
hold on
for i = 1:2
    [x,y,] = ginputRed(1);
    if isempty(x)
        break
    end
    X= [X;x];
    Y = [Y;y];
    plot(X,Y,'Color',[0 1 0])
end

X2 = [];
Y2 = [];
for i = 1:2
    [x,y,] = ginputRed(1);
    if isempty(x)
        break
    end
    X2= [X2;x];
    Y2 = [Y2;y];
    plot(X2,Y2,'Color',[0 1 0])
end

% Segment FSB
% get angles
vec1 = [X(2)-X(1),Y(2)-Y(1)];
vec2 = [X2(2)-X2(1),Y2(2)-Y2(1)];
vec1_n = vec1./sqrt(sum(vec1.^2));
vec2_n = vec2./sqrt(sum(vec2.^2));
cos_theta = dot(vec1_n,vec2_n);
theta = acosd(cos_theta);
theta_inc = theta./16;

% find intersection
dx1 = X(1);dy1 = Y(1);
dx2 = X2(1);dy2 = Y2(1);

u = (vec1_n(1).*(dy2-dy1) - vec1_n(2).*(dx2-dx1))...
    ./...
    (vec1_n(2)*vec2_n(1) - vec1_n(1)*vec2_n(2));

int_point = [dx2,dy2] + vec2_n.*u;


% Create new vector on left hand edge
[~,lv] = max([Y(1),Y2(1)]); % Counts down
if lv ==1
    t_vec = vec1_n;
else
    t_vec = vec2_n;
end
theta_intp = atand(-t_vec(2)/t_vec(1));
old_theta = theta_intp;
old_vec = t_vec;
old_vec(1) = -old_vec(1);
fan = zeros(size(projmask));
fansize = size(fan);
[x,y] = meshgrid(1:fansize(2),1:fansize(1));
mult_factor = 0:.1:200;
% Get fan mesh to multiply to data
idx_array = 1:16;

for i = 1:16
    new_theta = old_theta -theta_inc;
    
    
    old_vec = [-cosd(old_theta),sind(old_theta)];
    
    new_vec = [-cosd(new_theta),sind(new_theta)]; 
    e_vec1 = int_point+mult_factor'.*old_vec;
    e_vec2 = int_point+mult_factor'.*new_vec;
    
    for xf = 1:fansize(2)
        xf1 = findnearestCD(xf,e_vec1(:,1));
        v1 = e_vec1(xf1,:);
        xf2 = findnearestCD(xf,e_vec2(:,1));
        v2 = e_vec2(xf2,:);
        t_grid = x==xf&y<v1(2)&y>v2(2);
        fan = fan+t_grid.*idx_array(i);
    end
    old_theta = new_theta;
    old_vec = new_vec;
    
end

this_mask = handles.masks(masknum).mask;
msize = size(this_mask);
if numel(msize)==2
    msize = [msize,1];
end
this_mask1 = this_mask(:,:,:,1);

figure
imagesc(fan)
hold on
plot(X,Y,'Color',[0 1 0])
plot(X2,Y2,'Color',[0 1 0])

for i = 1:16
    tm = this_mask1>0;
    tf = fan==i;
    tf = repmat(tf,1,1,msize(3));

    this_mask(:,:,:,i) = tm.*tf.*i;

end
handles.masks(masknum).simple_mask = handles.masks(masknum).mask;
handles.masks(masknum).mask = this_mask;

guidata(hObject, handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
figure
meanim = nanmean(handles.IM,3);
% show mean image
meanim = mat2gray(meanim);

hold off
colormap('gray')
imshow(meanim)
hold on
makewholescreen

masknum = handles.masknum;
projmaskO = nansum(nansum(handles.masks(masknum).mask,4),3);
projmask = repmat(projmaskO,1,1,3);
projmask(:,:,2:3) = 0;
I = imshow(projmask);
projmaskO = rescale(projmaskO,0,1);
alpha = projmaskO.*0.5;
I.AlphaData = alpha;
% Get Centroid of elipsoid body
[X,Y,] = ginputRed(1);
scatter(X,Y,'MarkerEdgeColor','b')

% Get wheel
fansize = size(projmaskO);
[x,y] = meshgrid(1:fansize(2),1:fansize(1));
X = round(X);
X= X-0.5;
Y = round(Y);
theta_old = 0-handles.eboffset;



theta_inc = 360/16;
r = 0:100000;
wheel = zeros(fansize);
id_array = [4     3     2     1  16    15    14    13    12    11    10     9     8     7     6     5 ];
%id_array = [13   14    15     16 1 2 3 4 5 6 7 8 9 10 11 12];

% EPG counted from bottom round 1 and 16 correspond to farmost edges of
% fanshaped body (1 to column 1, 16 to column 9) for PFG neurons 2 corresponds to FSB column 8, 15 to
% column 2.
for i = 1:16
    yold = r.*cosd(theta_old)+Y;
    xold = r.*sind(theta_old)+X;
    theta_new = theta_old+theta_inc;
    ynew = r.*cosd(theta_new)+Y;
    xnew = r.*sind(theta_new)+X;
    xrange = floor(min([xnew,xold])):1:ceil(max([xnew,xold]));
    xrange(xrange<0) = [];
    xrange(xrange>fansize(2)) = [];
    for xr = xrange
        xi1 = findnearestCD(xr,xold);
        xchk = abs(xold(xi1)-xr);
        xi2 = findnearestCD(xr,xnew);
        xchk2 = abs(xnew(xi2)-xr);
        if xchk>0.49&theta_old==0
            ylims = [1000 ynew(xi2)];
        elseif xchk>0.49&theta_old ==180
            ylims = [ynew(xi2) 0];
        elseif xchk2>0.49&theta_new==180
            ylims = [yold(xi1) 0];
        elseif xchk2>0.49&theta_new==360
            ylims = [1000 yold(xi1)];
            
        else
            ylims = [yold(xi1);ynew(xi2)];
            ylims = sort(ylims,'descend');
            
        end
        dx = x==xr&y>=ylims(2)&y<=ylims(1);
        wheel(dx) = id_array(i);
    end
    theta_old = theta_new;
end

this_mask = handles.masks(masknum).mask;
msize = size(this_mask);
this_mask1 = this_mask(:,:,:,1);
for i = 1:16
    tm = this_mask1>0;
    tf = wheel==i;
    tf = repmat(tf,1,1,msize(3));

    this_mask(:,:,:,i) = tm.*tf.*i;

end
handles.masks(masknum).simple_mask = handles.masks(masknum).mask;
handles.masks(masknum).mask = this_mask;

guidata(hObject,handles)


% --- Executes on button press in correctEB.
function correctEB_Callback(hObject, eventdata, handles)
% hObject    handle to correctEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
hold on
[X,Y,] = ginputRed(1);
scatter(X,Y,'MarkerEdgeColor','b')
text(X,Y,'Top')

[X2,Y2,] = ginputRed(1);
scatter(X2,Y2,'MarkerEdgeColor','b')
text(X2,Y2,'Bottom')
plot([X,X2],[Y,Y2],'Color','r')
hold off
handles.eboffset = atand((X2-X)/(Y-Y2));



guidata(hObject,handles)
