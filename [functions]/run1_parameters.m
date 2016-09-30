function varargout = run1_parameters(varargin)
% RUN1_PARAMETERS MATLAB code for run1_parameters.fig
%      RUN1_PARAMETERS, by itself, creates a new RUN1_PARAMETERS or raises the existing
%      singleton*.
%
%      H = RUN1_PARAMETERS returns the handle to a new RUN1_PARAMETERS or the handle to
%      the existing singleton*.
%
%      RUN1_PARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUN1_PARAMETERS.M with the given input arguments.
%
%      RUN1_PARAMETERS('Property','Value',...) creates a new RUN1_PARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before run1_parameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to run1_parameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help run1_parameters

% Last Modified by GUIDE v2.5 28-Sep-2016 12:24:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @run1_parameters_OpeningFcn, ...
                   'gui_OutputFcn',  @run1_parameters_OutputFcn, ...
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
end

% --- Outputs from this function are returned to the command line.
function varargout = run1_parameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load p.mat
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);

% Hint: delete(hObject) closes the figure
if now_image ==0
    set(handles.edit1,'String',num2str(io.p.id_x1));
    set(handles.edit2,'String',num2str(io.p.id_y1));
    set(handles.edit3,'String',num2str(io.p.id_z1));
    set(handles.edit4,'String',num2str(io.p.id_noisemin));
    set(handles.edit5,'String',num2str(io.p.id_noisemax));
    set(handles.edit6,'String',num2str(io.p.id_r));
    set(handles.edit7,'String',num2str(io.p.id_distniegh));
    set(handles.edit8,'String',num2str(io.p.id_PHHcutoff));
    set(handles.edit9,'String',num2str(io.p.id_divcut));
    set(handles.edit11,'String',num2str(io.p.id_dist));
    set(handles.checkbox1,'Value',io.p.id_removeYSL);
else
    d_fol = data_folder{now_image};
    d_fol = [d_fol '/p.mat'];
    if ispc ==1
        d_fol(findstr(d_fol, '/'))='\';
    end
    load(d_fol);
    
    set(handles.edit1,'String',num2str(p.id_x1));
    set(handles.edit2,'String',num2str(p.id_y1));
    set(handles.edit3,'String',num2str(p.id_z1));
    set(handles.edit4,'String',num2str(p.id_noisemin));
    set(handles.edit5,'String',num2str(p.id_noisemax));
    set(handles.edit6,'String',num2str(p.id_r));
    set(handles.edit7,'String',num2str(p.id_distniegh));
    set(handles.edit8,'String',num2str(p.id_PHHcutoff));
    set(handles.edit9,'String',num2str(p.id_divcut));
    set(handles.edit11,'String',num2str(p.id_dist));
    set(handles.checkbox1,'Value',p.id_removeYSL);
    
end
% Update handles structure
guidata(hObject, handles);

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% find p.mat in [function] folder
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);


% Hint: delete(hObject) closes the figure
if now_image ==0
    io.p.id_x1=str2double(get(handles.edit1,'String'));
    io.p.id_y1=str2double(get(handles.edit2,'String'));
    io.p.id_z1=str2double(get(handles.edit3,'String'));
    io.p.id_noisemin=str2double(get(handles.edit4,'String'));
    io.p.id_noisemax=str2double(get(handles.edit5,'String'));
    io.p.id_r=str2double(get(handles.edit6,'String'));
    io.p.id_distniegh=str2double(get(handles.edit7,'String'));
    io.p.id_PHHcutoff=str2double(get(handles.edit8,'String'));
    io.p.id_divcut=str2double(get(handles.edit9,'String'));
    io.p.id_dist=str2double(get(handles.edit11,'String'));
    io.p.id_removeYSL=get(handles.checkbox1,'Value');
    
    % find p.mat in [function] folder
    rootfolder = pwd;
    savefolder = [rootfolder '/[functions]/io.mat'];
    if ispc ==1
        savefolder(findstr(savefolder, '/'))='\';
    end
    if exist(savefolder,'file')~=0
        save(savefolder,'io','-append');
    end
    
    % update all p.io using new parameters in data folders
    for i=1:size(data_folder,2)
            d_fol = data_folder{i};
            if ispc ==1
                d_fol(findstr(d_fol, '/'))='\';
            end       
        if exist([d_fol 'p.mat'],'file')~=0
            load([d_fol 'p.mat']);

            p.id_x1=str2double(get(handles.edit1,'String'));
            p.id_y1=str2double(get(handles.edit2,'String'));
            p.id_z1=str2double(get(handles.edit3,'String'));
            p.id_noisemin=str2double(get(handles.edit4,'String'));
            p.id_noisemax=str2double(get(handles.edit5,'String'));
            p.id_r=str2double(get(handles.edit6,'String'));
            p.id_distniegh=str2double(get(handles.edit7,'String'));
            p.id_PHHcutoff=str2double(get(handles.edit8,'String'));
            p.id_divcut=str2double(get(handles.edit9,'String'));
            p.id_dist=str2double(get(handles.edit11,'String'));
            p.id_removeYSL=get(handles.checkbox1,'Value');

            % find p.mat in [function] folder
            if exist([d_fol 'p.mat'],'file')~=0
                save([d_fol 'p.mat'],'p','-append');
            end
        end  
    end
    
    
else
    d_fol = data_folder{now_image};
    if ispc ==1
        d_fol(findstr(d_fol, '/'))='\';
    end
    load([d_fol 'p.mat']);
    
    p.id_x1=str2double(get(handles.edit1,'String'));
    p.id_y1=str2double(get(handles.edit2,'String'));
    p.id_z1=str2double(get(handles.edit3,'String'));
    p.id_noisemin=str2double(get(handles.edit4,'String'));
    p.id_noisemax=str2double(get(handles.edit5,'String'));
    p.id_r=str2double(get(handles.edit6,'String'));
    p.id_distniegh=str2double(get(handles.edit7,'String'));
    p.id_PHHcutoff=str2double(get(handles.edit8,'String'));
    p.id_divcut=str2double(get(handles.edit9,'String'));
    p.id_dist=str2double(get(handles.edit11,'String'));
    p.id_removeYSL=get(handles.checkbox1,'Value');
    
    % find p.mat in [function] folder

    if exist([d_fol 'p.mat'],'file')~=0
        save([d_fol 'p.mat'],'p','-append');
    end
    
end

delete(hObject);
end

% ------------------------------------------------

% --- Executes just before run1_parameters is made visible.
function run1_parameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to run1_parameters (see VARARGIN)

% Choose default command line output for run1_parameters
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes run1_parameters wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

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
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
end

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
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
end

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
end

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
end

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
end


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
end

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
end


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
end

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
end

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
end

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
end

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
end


function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
end

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
