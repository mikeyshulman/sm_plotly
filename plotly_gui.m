function varargout = plotly_gui(varargin)
% PLOTLY_GUI MATLAB code for plotly_gui.fig
%      PLOTLY_GUI, by itself, creates a new PLOTLY_GUI or raises the existing
%      singleton*.
%
%      H = PLOTLY_GUI returns the handle to a new PLOTLY_GUI or the handle to
%      the existing singleton*.
%
%      PLOTLY_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTLY_GUI.M with the given input arguments.
%
%      PLOTLY_GUI('Property','Value',...) creates a new PLOTLY_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotly_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotly_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotly_gui

% Last Modified by GUIDE v2.5 12-Mar-2014 16:45:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotly_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @plotly_gui_OutputFcn, ...
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
global smscan;
% End initialization code - DO NOT EDIT


% --- Executes just before plotly_gui is made visible.
function plotly_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotly_gui (see VARARGIN)

% Choose default command line output for plotly_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotly_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotly_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
%pd.export_aborted=get(hObject,'Value'); 


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
%pd.auto_export=get(hObject,'Value'); 


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
%pd.dir_pattern = get(hObject,'String');

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
set(hObject,'String','yyyy_mm_dd');


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% this function sets up plotly data.
% looks through all the fields in the gui, and populates them
% see sm_plotly_cleanup for all of the allowed fields of plotlydata
global plotlydata;
plotlydata.kwargs = struct();
plotlydata.export_aborted = get(handles.checkbox1,'Value');
plotlydata.auto_export = get(handles.checkbox2,'Value');
tmp = get(handles.edit1,'String');
if iscell(tmp)
    tmp = tmp{1};
end
if ~isempty(tmp)
    try
        foo = datestr(now,tmp);
    catch
        error('unrecognized format for datestr, %s', tmp);
    end
end
plotlydata.dir_pattern = tmp;

% look at the file-option field. if it's not empty, check if its the right
% format and populate it. if it's empty, remove plotlydata.fileopt
tmp2 = get(handles.edit2,'String');
if ~isempty(tmp2)
    if iscell(tmp2)
        tmp2 = tmp2{1};
    end
    if ischar(tmp2)
        switch tmp2
            case {'new', 'overwrite','append',''}
                plotlydata.kwargs.fileopt = tmp2;
            otherwise
                warning('unkown fileopt %s, ignoring...',tmp2);
                if isfield(plotlydata.kwargs,'fileopt')
                    plotlydata.kwargs = rmfield(plotlydata.kwargs,'fileopt');
                end
        end
    else
        warning('fileopt args of class %s? ignoring',class(tmp))
        if isfield(plotlydata.kwargs,'fileopt')
            plotlydata.kwargs = rmfield(plotlydata.kwargs,'fileopt');
        end
    end
else
    if isfield(plotlydata.kwargs,'fileopt')
        plotlydata.kwargs = rmfield(plotlydata.kwargs,'fileopt');
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


% % --- Executes on selection change in listbox1.
% function listbox1_Callback(hObject, eventdata, handles)
% % hObject    handle to listbox1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from listbox1
% 
% 
% % --- Executes during object creation, after setting all properties.
% function listbox1_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to listbox1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: listbox controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% global smscan;
% if ~isempty(smscan) && ~isempty(smscan.disp)
%    dd = cell(length(smscan.disp),1);
%    for j = 1:length(dd)
%       dd{j} = sprintf('disp %i>> \t loop: %i, channel: %i, dim %i',...
%           j,smscan.disp(j).loop,smscan.disp(j).channel, smscan.disp(j).dim); 
%    end
%    set(hObject,'String',dd);
%    set(hObject,'Max',length(dd));
%    set(hObject,'Min',0);
% else
%     set(hObject,'String','cannot find smscan. is it global?');
% end
