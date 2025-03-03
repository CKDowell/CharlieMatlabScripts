function varargout = EyeEventGUI(varargin)
% EYEEVENTGUI MATLAB code for EyeEventGUI.fig
%      EYEEVENTGUI, by itself, creates a new EYEEVENTGUI or raises the existing
%      singleton*.
%
%      H = EYEEVENTGUI returns the handle to a new EYEEVENTGUI or the handle to
%      the existing singleton*.
%
%      EYEEVENTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EYEEVENTGUI.M with the given input arguments.
%
%      EYEEVENTGUI('Property','Value',...) creates a new EYEEVENTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EyeEventGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EyeEventGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EyeEventGUI

% Last Modified by GUIDE v2.5 16-Nov-2018 19:05:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EyeEventGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @EyeEventGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    if ~strcmp(varargin{1},'text1_CreateFcn')
        gui_mainfcn(gui_State, varargin{:});
    end
end
% End initialization code - DO NOT EDIT

% --- Executes just before EyeEventGUI is made visible.
function EyeEventGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EyeEventGUI (see VARARGIN)
gmb= varargin{1};
if exist(varargin{2})
    handles.edit2.String = varargin{2};
    load([varargin{2} filesep 'gmbt.mat'])
    handles.gmbt = gmbt;
    Tall = cat(2,gmbt.p.cumtail);
    Tstd = std(Tall);
    handles.tstd = Tstd;
end
if isfield(gmb,'LConjLe')
    handles.gmb =gmb;
else
    disp('Recalculating gmb')
    handles.gmb = gmGetConj([],gmb);
    disp('Done')
end

disp('Calculating false negatives')
handles.ConvFN = get_convFN(gmb);
disp('Done')
handles.Conv = handles.gmb.convergences;
trials = 1:length(gmb.p);
xtraConv = trials(~ismember(trials',unique(handles.Conv(:,1))));
xtraConv = [xtraConv',zeros(numel(xtraConv),size(handles.Conv,2)-1)];
handles.Conv = [handles.Conv;xtraConv];
handles.Conv = sortrows(handles.Conv,[1,2]);
handles.ConvKeep = 1:size(gmb.convergences,1);
handles.ConvFNKeep = [];
handles.current_data= handles.Conv;
handles.LConj = handles.gmb.LConjLe;
xtraLConj = trials(~ismember(trials',unique(handles.LConj(:,1))));
xtraLConj = [xtraLConj',zeros(numel(xtraLConj),size(handles.LConj,2)-1)];
handles.LConj = [handles.LConj;xtraLConj];
handles.LConj = sortrows(handles.LConj,[1,2]);
LConjR = [handles.gmb.LConjRe;xtraLConj];
LConjR = sortrows(LConjR,[1,2]);
handles.LConj(:,:,2) = LConjR;
handles.LConjKeep = 1:size(handles.gmb.LConjLe,1);
handles.RConj = handles.gmb.RConjLe;
xtraRConj = trials(~ismember(trials',unique(handles.RConj(:,1))));
xtraRConj = [xtraRConj',zeros(numel(xtraRConj),size(handles.RConj,2)-1)];
handles.RConj = [handles.RConj;xtraRConj];
handles.RConj = sortrows(handles.RConj,[1,2]);
RConjR = [handles.gmb.RConjRe;xtraRConj];
RConjR = sortrows(RConjR,[1,2]);
handles.RConj(:,:,2) = RConjR;
handles.RConjKeep = 1:size(handles.gmb.RConjLe,1);
handles.thesedata = 'Conv';
if ~isfield(handles,'p')
    handles.p = 1;
end
handles.toggle = 'Conv';
plot_gmb4GUI(handles.p,handles.current_data,handles.gmb,handles.toggle,handles.gmbt,handles.tstd);
% Choose default command line output for EyeEventGUI
handles.output = hObject;
handles.text1.String = {[num2str(handles.p) '/' num2str(size(handles.current_data,1))]};
handles.uitable2.Data = handles.current_data(handles.p,:);
handles.uitable3.Data = handles.gmb.p(handles.current_data(handles.p,1)).visstim;
% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using EyeEventGUI.
if strcmp(get(hObject,'Visible'),'off')
    %plot(rand(5));

end



% UIWAIT makes EyeEventGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EyeEventGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function datatype = popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
str = get(hObject,'String');


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

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Delete button

handles = guidata(hObject);
p = handles.p;
switch handles.thesedata
    case 'Conv'
        trials = 1:size(handles.gmb.convergences,1);
        getrid = trials(ismember(handles.gmb.convergences,handles.current_data(p,:),'rows'));
        handles.ConvKeep(handles.ConvKeep == getrid) = [];
        isdel = true;
    case 'ConvFN'
        trials = 1:size(handles.gmb.convergences,1);
        getrid = trials(ismember(handles.ConvFN,handles.current_data(p,:),'rows'));
        handles.ConvFNKeep(handles.ConvFNKeep==getrid) = [];
        if ~ismember(getrid,handles.ConvFNKeep)
            isdel = true;
        end    
    case 'LConj'
       trials = 1:size(handles.gmb.LConjLe);
       getrid = trials(ismember(handles.gmb.LConjLe,handles.current_data(p,:,1),'rows'));
       handles.LConjKeep(handles.LConjKeep == getrid) = [];
       isdel = true;
    case 'RConj'
        trials = 1:size(handles.gmb.RConjLe);
        getrid = trials(ismember(handles.gmb.RConjLe,handles.current_data(p,:,1),'rows'));
        handles.RConjKeep(handles.RConjKeep == getrid) = [];
        isdel = true;
end
plot_gmb4GUI(handles.p,handles.current_data,handles.gmb,handles.toggle,handles.gmbt,handles.tstd,isdel)
handles.slider2.Value = handles.p./size(handles.current_data,1);
handles.uitable2.Data = handles.current_data(handles.p,:);
handles.uitable3.Data = handles.gmb.p(handles.current_data(handles.p,1)).visstim;
handles.text1.String = {[num2str(handles.p) '/' num2str(size(handles.current_data,1))]};
handles.text3.String = {[num2str('P = ') num2str(handles.current_data(handles.p,1))]};
guidata(hObject,handles);


% --- Executes on button press in pushbutton4.
function handles = pushbutton4_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
handles.p = max(handles.p-1,1);
p = handles.p;
isdel  = false;
switch handles.thesedata
    case 'Conv'
        trials = 1:size(handles.gmb.convergences,1);
        if ~ismember(trials(ismember(handles.gmb.convergences,handles.current_data(p,:),'rows')),handles.ConvKeep)
            isdel = true;
        end
    case 'ConvFN'
        trials = 1:size(handles.gmb.convergences,1);
        getrid = trials(ismember(handles.ConvFN,handles.current_data(p,:),'rows'));
        if ~ismember(getrid,handles.ConvFNKeep)
            isdel = true;
        end
    case 'LConj'
        trials = 1:size(handles.gmb.LConjLe,1);
        getrid = trials(ismember(handles.gmb.LConjLe,handles.current_data(p,:,1),'rows'));
        if ~ismember(getrid,handles.LConjKeep)
            isdel = true;
        end
    case 'RConj'
        trials = 1:size(handles.gmb.RConjLe,1);
        getrid = trials(ismember(handles.gmb.RConjLe,handles.current_data(p,:,1),'rows'));
        if ~ismember(getrid,handles.RConjKeep)
            isdel = true;
        end
end
plot_gmb4GUI(handles.p,handles.current_data,handles.gmb,handles.toggle,handles.gmbt,handles.tstd,isdel)
handles.uitable2.Data = handles.current_data(handles.p,:);
handles.uitable3.Data = handles.gmb.p(handles.current_data(handles.p,1)).visstim;
handles.slider2.Value = handles.p./size(handles.current_data,1);
handles.text1.String = {[num2str(handles.p) '/' num2str(size(handles.current_data,1))]};
handles.text3.String = {[num2str('P = ') num2str(handles.current_data(handles.p,1))]};
guidata(hObject,handles);
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function handles = pushbutton5_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
handles.p = min(handles.p+1,size(handles.current_data,1));
p = handles.p;
isdel  = false;
switch handles.thesedata
    case 'Conv'
        trials = 1:size(handles.gmb.convergences,1);
        if ~ismember(trials(ismember(handles.gmb.convergences,handles.current_data(p,:),'rows')),handles.ConvKeep)
            isdel = true;
        end
        if sum(abs(handles.gmb.convergences(:,5))>0)<size(handles.gmb.convergences,1)
            
        end
    case 'ConvFN'
        trials = 1:size(handles.gmb.convergences,1);
        getrid = trials(ismember(handles.ConvFN,handles.current_data(p,:),'rows'));
        if ~ismember(getrid,handles.ConvFNKeep)
            isdel = true;
        end
    case 'LConj'
        trials = 1:size(handles.gmb.LConjLe,1);
        getrid = trials(ismember(handles.gmb.LConjLe,handles.current_data(p,:,1),'rows'));
        if ~ismember(getrid,handles.LConjKeep)
            isdel = true;
        end
    case 'RConj'
        trials = 1:size(handles.gmb.RConjLe,1);
        getrid = trials(ismember(handles.gmb.RConjLe,handles.current_data(p,:,1),'rows'));
        if ~ismember(getrid,handles.RConjKeep)
            isdel = true;
        end
end
plot_gmb4GUI(handles.p,handles.current_data,handles.gmb,handles.toggle,handles.gmbt,handles.tstd,isdel)
handles.uitable2.Data = handles.current_data(handles.p,:);
handles.uitable3.Data = handles.gmb.p(handles.current_data(handles.p,1)).visstim;
handles.slider2.Value = handles.p./size(handles.current_data,1);
handles.text1.String = {[num2str(handles.p) '/' num2str(size(handles.current_data,1))]};
handles.text3.String = {[num2str('P = ') num2str(handles.current_data(handles.p,1))]};
guidata(hObject,handles);
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
handles = guidata(hObject);
str = get(hObject, 'String');
val = get(hObject,'Value');
switch str{val}
    case 'Convergences'
        handles.current_data = handles.Conv;
        handles.p = 1;
        handles.toggle = 'Conv';
        handles.thesedata = 'Conv';
    case 'Left Conj'
        handles.current_data = handles.LConj;
        handles.p = 1;
        handles.toggle = 'Conj';
        handles.thesedata = 'LConj';
    case 'Right Conj'
        handles.current_data = handles.RConj;
        handles.p = 1;
        handles.toggle = 'Conj';
        handles.thesedata = 'RConj';
end
plot_gmb4GUI(handles.p,handles.current_data,handles.gmb,handles.toggle,handles.gmbt,handles.tstd)
handles.uitable2.Data = handles.current_data(handles.p,:);
handles.uitable3.Data = handles.gmb.p(handles.current_data(handles.p,1)).visstim;
handles.slider2.Value = 0;
handles.text1.String = {[num2str(handles.p) '/' num2str(size(handles.current_data,1))]};
handles.text3.String = {[num2str('P = ') num2str(handles.current_data(handles.p,1))]};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Undo
handles = guidata(hObject);
isdel = true;
p = handles.p;
switch handles.thesedata
    case 'Conv'
        trials = 1:size(handles.gmb.convergences,1);
        getrid = trials(ismember(handles.gmb.convergences,handles.current_data(p,:),'rows'));
        if ~ismember(getrid,handles.ConvKeep)
            handles.ConvKeep = sort([handles.ConvKeep,getrid]);
            isdel = false;
        end
    case 'ConvFN'
        trials = 1:size(handles.gmb.convergences,1);
        getrid = trials(ismember(handles.ConvFN,handles.current_data(p,:),'rows'));
        if ismember(getrid,handles.ConvFNKeep)
            handles.ConvFNKeep(handles.ConvFNKeep==handles.p) = [];
            isdel = true;
        else 
            isdel = false;
        end
    case 'LConj'
        trials = 1:size(handles.gmb.LConjLe,1);
        getrid = trials(ismember(handles.gmb.LConjLe,handles.current_data(p,:,1),'rows'));
        if ~ismember(getrid,handles.LConjKeep)
            handles.LConjKeep = sort([handles.LConjKeep,getrid]);
            isdel = false;
        end
    case 'RConj'
        trials = 1:size(handles.gmb.RConjLe,1);
        getrid = trials(ismember(handles.gmb.RConjLe,handles.current_data(p,:,1),'rows'));
        if ~ismember(getrid,handles.RConjKeep)
            handles.RConjKeep = sort([handles.RConjKeep,getrid]);
            isdel = false;
        end
end
plot_gmb4GUI(handles.p,handles.current_data,handles.gmb,handles.toggle,handles.gmbt,handles.tstd,isdel)
handles.uitable2.Data = handles.current_data(handles.p,:);
handles.uitable3.Data = handles.gmb.p(handles.current_data(handles.p,1)).visstim;
handles.text1.String = {[num2str(handles.p) '/' num2str(size(handles.current_data,1))]};
handles.text3.String = {[num2str('P = ') num2str(handles.current_data(handles.p,1))]};
guidata(hObject,handles);


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = guidata(hObject);

handles.p = ceil(handles.slider2.Value*size(handles.current_data,1));
handles.p = max(handles.p,1);
p = handles.p;
isdel  = false;
switch handles.thesedata
    case 'Conv'
        trials = 1:size(handles.gmb.convergences,1);
        if ~ismember(trials(ismember(handles.gmb.convergences,handles.current_data(p,:),'rows')),handles.ConvKeep)
            isdel = true;
        end
    case 'ConvFN'
        trials = 1:size(handles.gmb.convergences,1);
        getrid = trials(ismember(handles.ConvFN,handles.current_data(p,:),'rows'));
        if ~ismember(getrid,handles.ConvFNKeep)
            isdel = true;
        end
    case 'LConj'
        trials = 1:size(handles.gmb.LConjLe,1);
        getrid = trials(ismember(handles.gmb.LConjLe,handles.current_data(p,:,1),'rows'));
        if ~ismember(getrid,handles.LConjKeep)
            isdel = true;
        end
    case 'RConj'
        trials = 1:size(handles.gmb.RConjLe,1);
        getrid = trials(ismember(handles.gmb.RConjLe,handles.current_data(p,:,1),'rows'));
        if ~ismember(getrid,handles.RConjKeep)
            isdel = true;
        end
end
plot_gmb4GUI(handles.p,handles.current_data,handles.gmb,handles.toggle,handles.gmbt,handles.tstd,isdel)
handles.uitable2.Data = handles.current_data(handles.p,:);
handles.uitable3.Data = handles.gmb.p(handles.current_data(handles.p,1)).visstim;
handles.text1.String = {[num2str(handles.p) '/' num2str(size(handles.current_data,1))]};
handles.text3.String = {[num2str('P = ') num2str(handles.current_data(handles.p,1))]};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles = guidata(hObject);
handles.p = str2num(handles.edit1.String);
p = handles.p;
isdel  = false;
switch handles.thesedata
    case 'Conv'
        trials = 1:size(handles.gmb.convergences,1);
        if ~ismember(trials(ismember(handles.gmb.convergences,handles.current_data(p,:),'rows')),handles.ConvKeep)
            isdel = true;
        end
    case 'ConvFN'
        trials = 1:size(handles.gmb.convergences,1);
        getrid = trials(ismember(handles.ConvFN,handles.current_data(p,:),'rows'));
        if ~ismember(getrid,handles.ConvFNKeep)
            isdel = true;
        end
    case 'LConj'
        trials = 1:size(handles.gmb.LConjLe,1);
        getrid = trials(ismember(handles.gmb.LConjLe,handles.current_data(p,:,1),'rows'));
        if ~ismember(getrid,handles.LConjKeep)
            isdel = true;
        end
    case 'RConj'
        trials = 1:size(handles.gmb.RConjLe,1);
        getrid = trials(ismember(handles.gmb.RConjLe,handles.current_data(p,:,1),'rows'));
        if ~ismember(getrid,handles.RConjKeep)
            isdel = true;
        end
end
plot_gmb4GUI(handles.p,handles.current_data,handles.gmb,handles.toggle,handles.gmbt,handles.tstd,isdel)
handles.uitable2.Data = handles.current_data(handles.p,:);
handles.uitable3.Data = handles.gmb.p(handles.current_data(handles.p,1)).visstim;
handles.slider2.Value = handles.p./size(handles.current_data,1);
handles.text1.String = {[num2str(handles.p) '/' num2str(size(handles.current_data,1))]};
guidata(hObject,handles);


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


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
gmb = handles.gmb;
gmb.convergences = gmb.convergences(handles.ConvKeep,:);
gmb.convergences = [gmb.convergences;handles.ConvFN(handles.ConvFNKeep,:)];
[~,I] = sortrows(gmb.convergences,[1,2]);
gmb.convergences = gmb.convergences(I,:);
gmb.LConjLe = gmb.LConjLe(handles.LConjKeep,:);
gmb.LConjRe = gmb.LConjRe(handles.LConjKeep,:);
gmb.RConjLe = gmb.RConjLe(handles.RConjKeep,:);
gmb.RConjRe = gmb.RConjRe(handles.RConjKeep,:);
if ~logical(handles.checkbox1.Value)
    gmb
else
    if strcmp(handles.edit2.String,'Save Directory')
        uisave('gmb')
    else
        disp('Saving..')
        if strcmp(handles.edit2.String(1),'Z')
            smb = gmb;
            save([handles.edit2.String '\smb.mat'],'smb')
        else
            save([handles.edit2.String '\gmb.mat'],'gmb')
        end
    end
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
handles = guidata(hObject);
str = handles.popupmenu2.String;
val = handles.popupmenu2.Value;
switch str{val}
    case 'Convergences'
        if handles.checkbox2.Value==1
        handles.current_data = handles.ConvFN;
        handles.p = 1;
        handles.toggle = 'Conv';
        handles.thesedata = 'ConvFN';
        isdel = true;
        plot_gmb4GUI(handles.p,handles.current_data,handles.gmb,handles.toggle,handles.gmbt,handles.tstd,isdel)
        handles.slider2.Value = handles.p./size(handles.current_data,1);
        handles.text1.String = {[num2str(handles.p) '/' num2str(size(handles.current_data,1))]};
        else
        handles.current_data = handles.Conv;
        handles.p = 1;
        handles.toggle = 'Conv';
        handles.thesedata = 'Conv';  
        end
    case 'Left Conj'
        handles.checkbox2.Value = 0;
    case 'Right Conj'
        handles.checkbox2.Value = 0;
end
guidata(hObject,handles);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if handles.checkbox2.Value==1
    thisConvFN = ismember(handles.current_data,handles.current_data(handles.p,:),'rows');
    handles.ConvFNKeep = [handles.ConvFNKeep;find(thisConvFN>0)];
    isdel = false;
    plot_gmb4GUI(handles.p,handles.current_data,handles.gmb,handles.toggle,handles.gmbt,handles.tstd,isdel)
    handles.slider2.Value = handles.p./size(handles.current_data,1);
    handles.text1.String = {[num2str(handles.p) '/' num2str(size(handles.current_data,1))]};
end
guidata(hObject,handles);



% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
keyPressed = eventdata.Key;
if strcmpi(keyPressed,'j')
    
        uicontrol(handles.pushbutton4);
        pushbutton4_Callback(hObject, [], handles);      
elseif strcmpi(keyPressed,'l')
        uicontrol(handles.pushbutton5);
        pushbutton5_Callback(hObject, [], handles);
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
p = handles.p;
t = ginput(1);
t = t(1);
handles.current_data(p,2) = t;
str = handles.popupmenu2.String;
val = handles.popupmenu2.Value;
isdel  = false;

switch str{val}
    case 'Convergences'

        if handles.checkbox2.Value==1
        handles.gmb.ConvFN(p,2) = t;
        handles.toggle = 'Conv';
        handles.thesedata = 'ConvFN';
        isdel = true;
        handles.ConvFN(p,2) = t;
        trials = 1:size(handles.gmb.convergences,1);
        if ~ismember(trials(ismember(handles.gmb.convergences,handles.current_data(p,:),'rows')),handles.ConvFNKeep)
            isdel = true;
        end
        else
            trials = 1:size(handles.gmb.convergences,1);
            thistrial = trials(ismember(handles.gmb.convergences,handles.current_data(p,:),'rows'));
            handles.gmb.convergences(thistrial,2) = t;
            handles.Conv(p,2) = t;
            handles.toggle = 'Conv';
            handles.thesedata = 'Conv';
            handles.current_data = handles.Conv;
            trials = 1:size(handles.gmb.convergences,1);
        if ~ismember(thistrial,handles.ConvFNKeep)
            isdel = true;
        end
        end
        if sum(abs(handles.gmb.convergences(:,5))>0)<size(handles.gmb.convergences,1)
            keyboard
        end
    case 'Left Conj'
       trials = 1:size(handles.gmb.LConjLe,1);
       thistrial = trials(ismember(handles.gmb.LConjLe,handles.current_data(p,:,1),'rows'));
       handles.gmb.LConjLe(thistrial,2) = t;
       handles.gmb.LConjRe(thistrial,2) = t;
       handles.LConjLe(p,2) = t;
       handles.LConjRe(p,2) = t;
       trials = 1:size(handles.gmb.LConjLe,1);
       handles.current_data(p,2,1) = t;
       handles.currentdata(p,2,2) =t;
        if ~ismember(thistrial,handles.LConjKeep)
            isdel = true;
        end
    case 'Right Conj'
       trials = 1:size(handles.gmb.RConjLe,1);
       thistrial = trials(ismember(handles.gmb.RConjLe,handles.current_data(p,:,1),'rows'));
       handles.gmb.RConjLe(thistrial,2) = t;
       handles.gmb.LConjLe(thistrial,2) = t;
       handles.RConjLe(p,2) = t;
       handles.RConjRe(p,2) = t;
       handles.current_data(p,2,1) = t;
       handles.currentdata(p,2,2) =t;
        if ~ismember(thistrial,handles.RConjKeep)
            isdel = true;
        end

end
plot_gmb4GUI(handles.p,handles.current_data,handles.gmb,handles.toggle,handles.gmbt,handles.tstd,isdel)
guidata(hObject,handles);
        
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Add event
handles = guidata(hObject);
p = handles.p;
t1 = gtext('Start');
t = t1.Position(1);
trial = handles.current_data(p,1);
str = handles.popupmenu2.String;
val = handles.popupmenu2.Value;
if handles.current_data(p,2)==0
            waszero = true;
else
    waszero = false;
end
isdel = false;
[g,g2] = gmbfromGUI(trial,t,handles.gmb,str{val});
switch str{val}
    case 'Convergences'
        handles.gmb.convergences = [handles.gmb.convergences;g];
        handles.gmb.convergences = sortrows(handles.gmb.convergences,[1,2]);
        if waszero
            handles.current_data(p,:) = [];
            handles.Conv(p,:) = [];
        end
        handles.current_data = [handles.current_data;g];
        handles.current_data = sortrows(handles.current_data,[1,2]);
        handles.Conv = handles.current_data;
        alltrials = 1:size(handles.gmb.convergences,1);
        thiskeep = alltrials(ismember(handles.gmb.convergences,g,'rows'));
        handles.ConvKeep(handles.ConvKeep>thiskeep-1) = handles.ConvKeep(handles.ConvKeep>thiskeep-1)+1;
        handles.ConvKeep = [handles.ConvKeep,thiskeep];
        handles.ConvKeep = sort(handles.ConvKeep);
        if ~ismember(thiskeep,handles.ConvKeep)
            isdel = true;
        end
        if sum(abs(handles.gmb.convergences(:,5))>0)<size(handles.gmb.convergences,1)
            keyboard
        end
    case 'Left Conj'
        handles.gmb.LConjLe = [handles.gmb.LConjLe;g];
        handles.gmb.LConjLe = sortrows(handles.gmb.LConjLe,[1, 2]);
        handles.gmb.LConjRe = [handles.gmb.LConjRe;g2];
        handles.gmb.LConjRe = sortrows(handles.gmb.LConjLe,[1,2]);
        if waszero
            handles.current_data(p,:,:) = [];
        end
        currentL = [handles.current_data(:,:,1);g];
        currentR = [handles.current_data(:,:,2);g2];
        [handles.current_data,I] = sortrows(currentL,[1,2]);
        handles.current_data(:,:,2) = currentR(I,:);
        handles.LConj = handles.current_data;
        alltrials = 1:size(handles.gmb.LConjLe,1);
        thiskeep  =alltrials(ismember(handles.gmb.LConjLe,g,'rows'));
        handles.LConjKeep(handles.LConjKeep>thiskeep-1) = handles.LConjKeep(handles.LConjKeep>thiskeep-1)+1;
        handles.LConjKeep = [handles.LConjKeep,thiskeep];
        handles.LConjKeep = sort(handles.LConjKeep);
        if ~ismember(thiskeep,handles.LConjKeep)
            isdel = true;
        end
    case 'Right Conj'
        handles.gmb.RConjLe = [handles.gmb.RConjLe;g];
        handles.gmb.RConjLe = sortrows(handles.gmb.RConjLe,[1, 2]);
        handles.gmb.RConjRe = [handles.gmb.RConjRe;g2];
        handles.gmb.RConjRe = sortrows(handles.gmb.RConjLe,[1,2]);
        if waszero
            handles.current_data(p,:,:) = [];
        end
        currentL = [handles.current_data(:,:,1);g];
        currentR = [handles.current_data(:,:,2),;g2];
        [handles.current_data,I] = sortrows(currentL,[1,2]);
        handles.current_data(:,:,2) = currentR(I,:);
        handles.RConj = handles.current_data;
        alltrials = 1:size(handles.gmb.RConjLe,1);
        alltrials = alltrials';
        thiskeep  =alltrials(ismember(handles.gmb.RConjLe,g,'rows'));
        handles.RConjKeep(handles.RConjKeep>thiskeep-1) = handles.RConjKeep(handles.RConjKeep>thiskeep-1)+1;
        handles.RConjKeep = [handles.RConjKeep,thiskeep];
        handles.RConjKeep = sort(handles.RConjKeep);
        if ~ismember(thiskeep,handles.RConjKeep)
            isdel = true;
        end
end
plot_gmb4GUI(handles.p,handles.current_data,handles.gmb,handles.toggle,handles.gmbt,handles.tstd,isdel)
guidata(hObject,handles);
% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
