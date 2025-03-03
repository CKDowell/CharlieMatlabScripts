function varargout = OptoTouchGUI(varargin)
% OPTOTOUCHGUI MATLAB code for OptoTouchGUI.fig
%      OPTOTOUCHGUI, by itself, creates a new OPTOTOUCHGUI or raises the existing
%      singleton*.
%
%      H = OPTOTOUCHGUI returns the handle to a new OPTOTOUCHGUI or the handle to
%      the existing singleton*.
%
%      OPTOTOUCHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTOTOUCHGUI.M with the given input arguments.
%
%      OPTOTOUCHGUI('Property','Value',...) creates a new OPTOTOUCHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OptoTouchGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OptoTouchGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OptoTouchGUI

% Last Modified by GUIDE v2.5 20-Aug-2021 14:29:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OptoTouchGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OptoTouchGUI_OutputFcn, ...
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


% --- Executes just before OptoTouchGUI is made visible.
function OptoTouchGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OptoTouchGUI (see VARARGIN)
rootdir = varargin{1};
handles.rootdir = rootdir;
handles.RootDir.String = rootdir;
% Choose default command line output for OptoTouchGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OptoTouchGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OptoTouchGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function RootDir_Callback(hObject, eventdata, handles)
% hObject    handle to RootDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RootDir as text
%        str2double(get(hObject,'String')) returns contents of RootDir as a double


% --- Executes during object creation, after setting all properties.
function RootDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RootDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function foldername_Callback(hObject, eventdata, handles)
% hObject    handle to foldername (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of foldername as text
%        str2double(get(hObject,'String')) returns contents of foldername as a double


% --- Executes during object creation, after setting all properties.
function foldername_CreateFcn(hObject, eventdata, handles)
% hObject    handle to foldername (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in foldernames.
function foldernames_Callback(hObject, eventdata, handles)
% hObject    handle to foldernames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns foldernames contents as cell array
%        contents{get(hObject,'Value')} returns selected item from foldernames


% --- Executes during object creation, after setting all properties.
function foldernames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to foldernames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ProcessData.
function ProcessData_Callback(hObject, eventdata, handles)
% hObject    handle to ProcessData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
rootdir = handles.RootDir.String;
folderdir = handles.foldername.String;
if strcmp(handles.foldername.String,'Folder Name')
    error('Choose Folder name!')
end
datadir = fullfile(rootdir,folderdir);
figure
Opto_multiROI_data = Opto_multiROI(datadir);
guidata(hObject, handles);

% --- Executes on button press in analyselist.
function analyselist_Callback(hObject, eventdata, handles)
% hObject    handle to analyselist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
foldernames = handles.foldernames.String;
rootdir = handles.RootDir.String;
colours = customcolormap([0 0.5 1],[0 0 0.3; 0 0.3 0.7; 0.7 0.7 0.8],length(foldernames));
plots = [];
for i = 1:length(foldernames)
    datadir = fullfile(rootdir,foldernames{i},'Opto_multiROI_data.mat');
    load(datadir)
    stim = Opto_multiROI_data.led_stim;
    [c,stim_u] = uniquecount(stim,'rows');
    rnum = Opto_multiROI_data.ROI_num;
    responseprob = nan(size(stim_u,1),rnum);
    for s = 1:size(stim_u,1)
        ts = ismember(stim,stim_u(s,:),'rows');
        for r = 1:rnum
            responseprob(s,r) = nanmean(Opto_multiROI_data.ROI_data(r).r(ts));
        end
    end
    dur = unique(stim(:,2));
    for d = 1:numel(dur)
        figure(100+d)
        ts = stim_u(:,2)==dur(d);
        tr = responseprob(ts,:);
        tr_mn = nanmean(tr,2);
        tr_se = nanstd(tr,[],2)./sqrt(rnum);
        x = stim_u(ts,1);
        hold on
        plots(d).scats(i) = scatter(x,tr_mn,75,'MarkerFaceColor',colours(i,:),'MarkerEdgeColor',colours(i,:));
        plot(x,tr_mn,'LineWidth',2,'Color',colours(i,:))
        yup = tr_mn+tr_se;ylo = tr_mn-tr_se;
        plot([x,x]',[yup,ylo]','LineWidth',2,'Color',colours(i,:))
        hold off
    end
end
for d = 1:numel(dur)
    figure(100+d)
    ts = stim_u(:,2)==dur(d);
    standardiseLinePlots(gca,1,1,1,1)
    xticks(stim_u(ts,1))
    xlabel('Duty Cycle Power')
    ylabel('Response Probability')
    yticks([0:0.25:1])
    legend(plots(d).scats(:),foldernames)
end
guidata(hObject, handles);

% --- Executes on button press in add2list.
function add2list_Callback(hObject, eventdata, handles)
% hObject    handle to add2list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

if size(handles.foldernames.String,1)==1
    if strcmp(handles.foldernames.String,'foldernames')
        handles.foldernames.String = {handles.foldername.String};
    else
        handles.foldernames.String{2} = handles.foldername.String;
    end
else
    handles.foldernames.String{end+1} = handles.foldername.String;
end
guidata(hObject, handles);
