function varargout = SEG3D(varargin)
% SEG3D MATLAB code for SEG3D.fig
%      SEG3D, by itself, creates a new SEG3D or raises the existing
%      singleton*.
%
%      H = SEG3D returns the handle to a new SEG3D or the handle to
%      the existing singleton*.
%
%      SEG3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEG3D.M with the given input arguments.
%
%      SEG3D('Property','Value',...) creates a new SEG3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SEG3D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SEG3D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SEG3D

% Last Modified by GUIDE v2.5 05-Oct-2016 18:56:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SEG3D_OpeningFcn, ...
                   'gui_OutputFcn',  @SEG3D_OutputFcn, ...
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
end
% End initialization code - DO NOT EDIT


% ====/ Main GUI functions /=====================================================
% --- Executes just before SEG3D is made visible.
function SEG3D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SEG3D (see VARARGIN)

%% Vision information
display('  SEG3D v.beta4   made by Geoge. 2016.10.05 11:27pm  ');


% Choose default command line output for SEG3D
handles.output = hObject;

% save parameter_setting file
addpath('[functions]');
rootfolder = pwd;
[p,io]=p_setting();
savefolder = [rootfolder '/[functions]/'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
now_image = 0;
io.p=p;
save([savefolder 'io.mat'],'io','now_image');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SEG3D wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- SEG3D Outputs
function varargout = SEG3D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- pushbutton3: Open image file
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rootfolder = pwd;
[p]=p_setting();
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);
now_image = 0;io.p=p;
save(savefolder,'io','now_image');


imagename=load_tif_lsm(hObject,handles,p,io);
if imagename{1}~=0
    set(handles.pushbutton2,'enable','on');
    set(handles.pushbutton12,'enable','on');
    set(handles.pushbutton13,'enable','on');
    set(handles.pushbutton14,'enable','on');
    set(handles.pushbutton4,'enable','on');
end
% Update handles
guidata(hObject, handles);
end

% --- pushbutton3: Open images in one folder
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rootfolder = pwd;
[p]=p_setting();
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);
now_image = 0;io.p=p;
save(savefolder,'io','now_image');


image_folder=load_tif_lsm_folder(hObject,handles,p,io);
if image_folder~=0
    set(handles.pushbutton2,'enable','on');
    set(handles.pushbutton12,'enable','on');
    set(handles.pushbutton13,'enable','on');
    set(handles.pushbutton14,'enable','on');
    set(handles.pushbutton4,'enable','on');
end
% Update handles
guidata(hObject, handles);
end

% --- Setting GUI
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

main_setting();

%{
%% convert image into multi-stack and save stack.mat and p.mat
% load p.mat
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);

for i=1:size(basename,2)
    
    % convert image into multi-stack
    load([data_folder{i} 'stack.mat']);load([data_folder{i} 'p.mat']);
    
    % Create channel info
    for c=1:io.totchan
        eval(['chal_info{c,1} = io.chal' num2str(c) '_show;']);
        chal_info{c,2} = 0;
        eval(['if io.chal' num2str(c) '_no ==1;chal_info{c,2} = 1;end']);
        eval(['if io.chal' num2str(c) '_no ==1;chal_info{c,3} = ''Nuclei'';end']);
        eval(['if io.chal' num2str(c) '_no ==2;chal_info{c,3} = ''Signal 1'';end']);
        eval(['if io.chal' num2str(c) '_no ==3;chal_info{c,3} = ''Signal 2'';end']);
        eval(['if io.chal' num2str(c) '_no ==4;chal_info{c,3} = ''Signal 3'';end']);
        eval(['if io.chal' num2str(c) '_no ==5;chal_info{c,3} = ''none'';end']);
        eval(['if io.chal' num2str(c) '_no ==5;chal_info{c,2} = -1;end']);
        eval(['if strcmp(io.chal' num2str(c) '_name,'''')~=1;chal_info{c,3} = io.chal' num2str(c) '_name;end']);
    end

    % export to stack
    endim=iinfo.pageN/io.totchan;
    for chal=1:io.totchan
        startim=chal;j=1;
        for t=startim:io.totchan:startim+(endim-1)*io.totchan
            NFstk{chal}(:,:,j)=lsm_stack(1,t).data;
            j=j+1;
        end;
    end
    p.io=io;
    save([data_folder{i} 'stack.mat'],'lsm_stack','NFstk','-v7.3');
    save([data_folder{i} 'p.mat'],'p','iinfo','chal_info');


%% Save tiff files
    if io.savetiff==1
        if exist([data_folder{i} 'tiff_image.tif'],'file')~=0
            delete([data_folder{i} 'tiff_image.tif']);
        end
        for chal=1:io.totchan
            for m=1:size(NFstk{chal},3)
                imwrite(NFstk{chal}(:,:,m),[data_folder{i} 'tiff_image.tif'], 'writemode', 'append');
            end
        end
    end
clear NFstk iinfo chal_info
end
%}

%{
rootfolder = pwd;
p=p_setting();
guifolder = [rootfolder '/[functions]/'];
if ispc ==1
    guifolder(findstr(guifolder, '/'))='\';
end
eval([guifolder 'main_setting']);
%}
end

% --- RUN1 parameters GUI
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run1_parameters;
end

% --- step 1: identify nuclei and eliminate dividing cells
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% load p.mat
step1_nuclearidentification(hObject, handles);

%% active step2 button units
set(handles.pushbutton16,'enable','on');
set(handles.pushbutton19,'enable','on');
set(handles.pushbutton22,'enable','on');
set(handles.pushbutton13,'enable','on');
set(handles.pushbutton14,'enable','on');


%% active axes1 units
set(handles.text5,'enable','on');
set(handles.text6,'enable','on');
set(handles.edit2,'enable','on');
set(handles.popupmenu1,'enable','on');
set(handles.popupmenu3,'enable','on');
set(handles.checkbox1,'enable','on');
set(handles.pushbutton25,'enable','on');


%% Load io.mat and setup handles.popupmenu1 menu
% load io.mat
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);

% set handles.popupmenu1 String = image names
for i=1:size(imagename,2)
    popname{i,1} = imagename{1,i};
end
set(handles.popupmenu1,'String',popname);


%% load first image information and save handles.popupmenu3
% load p.mat and stack.mat
d_fol = data_folder{1};
s_fol = [d_fol 'stack.mat'];
d_fol = [d_fol 'p.mat'];
if ispc ==1
    d_fol(findstr(d_fol, '/'))='\';
    s_fol(findstr(s_fol, '/'))='\';
end
load(d_fol);load(s_fol);

% figure_show{1,oo} = figure will be shown  
oo = 1;
if exist('xyzintsegdat','var')~=0
    figure_show{1,oo} = '__xyzI';
    oo=oo+1;
end
% [README: if add more options..]
%if exist('xyzintsegdat','var')~=0 [if add other figures....]
%    handles.show_axis_opt{oo} = 'xyzintsegdat';
%    oo=oo+1;
%end

% chala{1,o1} = chale name will be shown
data_i = find(cell2mat(chal_info(:,1)));o1=1;
for oo=1:size(data_i,1)
    chala{1,oo}=chal_info(data_i(oo),3);
end
    
% create handles.popupmenu3 menu
if exist('figure_show')~=0&&exist('chala')~=0     
    for i1 = 1:size(figure_show,2)
        for i2 = 1:size(chala,2)
            temp=chala{1,i2};
            show_axis_opt{i2+(i1-1)*(size(figure_show,2)),1}=[temp{1} figure_show{1,i1}];
        end
    end       
else    
end
set(handles.popupmenu3,'String',show_axis_opt);


% Update handles
set(handles.edit1,'String','RUN1 Finished!');pause(0.1);
guidata(hObject, handles);

end

% --- step 3: parallel to x-y plane, First round of DV plane finding.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
step3_alignment(hObject, handles);

set(handles.pushbutton17,'enable','on');
set(handles.pushbutton20,'enable','on');
set(handles.pushbutton23,'enable','on');
% Update handles
guidata(hObject, handles);
end

% --- step 4: RUN profiel extraction
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.pushbutton18,'enable','on');
set(handles.pushbutton21,'enable','on');
set(handles.pushbutton24,'enable','on');
% Update handles
guidata(hObject, handles);
end

% --- Raw image GUI
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% data folder and image format

set(handles.edit1,'String','Loading Raw_image ...');pause(0.1);
guidata(hObject, handles);
Raw_image;
end


% ====/ GUI axes1 functions /=====================================================

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% load p.mat
set(handles.edit1,'String','Drawing figure ...');pause(0.1);
guidata(hObject, handles);
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);


%% input popupmenu1 value
image_no= get(handles.popupmenu1,'Value');


%% Default load first image information
d_fol = data_folder{image_no};
s_fol = [d_fol 'stack.mat'];
d_fol = [d_fol 'p.mat'];
if ispc ==1
    d_fol(findstr(d_fol, '/'))='\';
    s_fol(findstr(s_fol, '/'))='\';
end
load(d_fol);load(s_fol);



%% load edit1, popupmenu3 properties
chal_no=get(handles.popupmenu3,'Value');
chal_string=get(handles.popupmenu3,'String');
chal_string=chal_string{chal_no,1};
ax=1;
for ci=1:size(chal_info,1)    
    if isempty(findstr(chal_string,chal_info{ci,3}))~=1;ax=ci;end
end
n=findstr(chal_string,'__');
figure_name = chal_string(n+2:end);


%% load maxcolorbar properties
maxcolorbar_input=str2num(get(handles.edit2,'String'));
if isempty(maxcolorbar_input)==1||maxcolorbar_input==0
    if iinfo.BitDepth==16
        maxcolorbar_input = 65535;
    else
        maxcolorbar_input = 256;
    end
end


%% Show GUI axes1 and output figures in data folder
% axes1

set(handles.axes1,'Units','pixels');
axes(handles.axes1);
if strcmp(figure_name,'xyzI')==1
    eval(['scatter3(xyzintsegdat{' num2str(ax) '}(:,1),xyzintsegdat{' num2str(ax) '}(:,2),xyzintsegdat{' num2str(ax) '}(:,3),20,xyzintsegdat{' num2str(ax) '}(:,5));']);
    caxis([0, maxcolorbar_input]);colormap(jet);colorbar;title([basename{1} '  ' chal_info{ax,3}]);pause(0.1);h=rotate3d;
    set(h,'Enable','on');
end

% output figures
%{
for i=1:size(data_i,1)
    s=data_i(i,1);
    ax=s;
    fh = figure;set(fh,'Units','pixels','visible','off');
    eval(['scatter3(xyzintsegdat{' num2str(ax) '}(:,1),xyzintsegdat{' num2str(ax) '}(:,2),xyzintsegdat{' num2str(ax) '}(:,3),20,xyzintsegdat{' num2str(ax) '}(:,5));']);
    caxis([0, 65535]);colormap(jet);colorbar;title([basename '  ' chal_info{ax,3}]);pause(0.1);h=rotate3d;
    if ispc ==1
        set(fh,'visible','on');
        eval(['saveas(fh, [basename ''\xyzintsegdat{' num2str(ax) '}.fig'']);']);
        close(fh);
    else
        set(fh,'visible','on');
        eval(['saveas(fh, [basename ''/xyzintsegdat{' num2str(ax) '}.fig'']);']);
        close(fh);
    end
end
%}
% Finish process
set(handles.edit1,'String','Finished!');
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
end

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% load p.mat
set(handles.edit1,'String','Drawing figure ...');pause(0.1);
guidata(hObject, handles);
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);


%% input popupmenu1 value
image_no= get(handles.popupmenu1,'Value');


%% Default load first image information
d_fol = data_folder{image_no};
s_fol = [d_fol 'stack.mat'];
d_fol = [d_fol 'p.mat'];
if ispc ==1
    d_fol(findstr(d_fol, '/'))='\';
    s_fol(findstr(s_fol, '/'))='\';
end
load(d_fol);load(s_fol);



%% load edit1, popupmenu3 properties
chal_no=get(handles.popupmenu3,'Value');
chal_string=get(handles.popupmenu3,'String');
chal_string=chal_string{chal_no,1};
ax=1;
for ci=1:size(chal_info,1)    
    if isempty(findstr(chal_string,chal_info{ci,3}))~=1;ax=ci;end
end
n=findstr(chal_string,'__');
figure_name = chal_string(n+2:end);


%% load maxcolorbar properties
maxcolorbar_input=str2num(get(handles.edit2,'String'));
if isempty(maxcolorbar_input)==1||maxcolorbar_input==0
    if iinfo.BitDepth==16
        maxcolorbar_input = 65535;
    else
        maxcolorbar_input = 256;
    end
end


%% Show GUI axes1 and output figures in data folder
% axes1

set(handles.axes1,'Units','pixels');
axes(handles.axes1);
if strcmp(figure_name,'xyzI')==1
    eval(['scatter3(xyzintsegdat{' num2str(ax) '}(:,1),xyzintsegdat{' num2str(ax) '}(:,2),xyzintsegdat{' num2str(ax) '}(:,3),20,xyzintsegdat{' num2str(ax) '}(:,5));']);
    caxis([0, maxcolorbar_input]);colormap(jet);colorbar;title([basename{1} '  ' chal_info{ax,3}]);pause(0.1);h=rotate3d;
    set(h,'Enable','on');
end

% output figures
%{
for i=1:size(data_i,1)
    s=data_i(i,1);
    ax=s;
    fh = figure;set(fh,'Units','pixels','visible','off');
    eval(['scatter3(xyzintsegdat{' num2str(ax) '}(:,1),xyzintsegdat{' num2str(ax) '}(:,2),xyzintsegdat{' num2str(ax) '}(:,3),20,xyzintsegdat{' num2str(ax) '}(:,5));']);
    caxis([0, 65535]);colormap(jet);colorbar;title([basename '  ' chal_info{ax,3}]);pause(0.1);h=rotate3d;
    if ispc ==1
        set(fh,'visible','on');
        eval(['saveas(fh, [basename ''\xyzintsegdat{' num2str(ax) '}.fig'']);']);
        close(fh);
    else
        set(fh,'visible','on');
        eval(['saveas(fh, [basename ''/xyzintsegdat{' num2str(ax) '}.fig'']);']);
        close(fh);
    end
end
%}
% Finish process
set(handles.edit1,'String','Finished!');
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
maxyo=get(handles.checkbox1,'Value');
if maxyo==1
    set(handles.edit2,'Visible','Off');
    set(handles.edit2,'String','0');
    
        %% load p.mat
        set(handles.edit1,'String','Drawing figure ...');pause(0.1);
        guidata(hObject, handles);
        rootfolder = pwd;
        savefolder = [rootfolder '/[functions]/io.mat'];
        if ispc ==1
            savefolder(findstr(savefolder, '/'))='\';
        end
        load(savefolder);


        %% input popupmenu1 value
        image_no= get(handles.popupmenu1,'Value');


        %% Default load first image information
        d_fol = data_folder{image_no};
        s_fol = [d_fol 'stack.mat'];
        d_fol = [d_fol 'p.mat'];
        if ispc ==1
            d_fol(findstr(d_fol, '/'))='\';
            s_fol(findstr(s_fol, '/'))='\';
        end
        load(d_fol);load(s_fol);



        %% load edit1, popupmenu3 properties
        chal_no=get(handles.popupmenu3,'Value');
        chal_string=get(handles.popupmenu3,'String');
        chal_string=chal_string{chal_no,1};
        ax=1;
        for ci=1:size(chal_info,1)    
            if isempty(findstr(chal_string,chal_info{ci,3}))~=1;ax=ci;end
        end
        n=findstr(chal_string,'__');
        figure_name = chal_string(n+2:end);


        %% load maxcolorbar properties
        maxcolorbar_input=str2num(get(handles.edit2,'String'));
        if isempty(maxcolorbar_input)==1||maxcolorbar_input==0
            if iinfo.BitDepth==16
                maxcolorbar_input = 65535;
            else
                maxcolorbar_input = 256;
            end
        end


        %% Show GUI axes1 and output figures in data folder
        % axes1

        set(handles.axes1,'Units','pixels');
        axes(handles.axes1);
        if strcmp(figure_name,'xyzI')==1
            eval(['scatter3(xyzintsegdat{' num2str(ax) '}(:,1),xyzintsegdat{' num2str(ax) '}(:,2),xyzintsegdat{' num2str(ax) '}(:,3),20,xyzintsegdat{' num2str(ax) '}(:,5));']);
            caxis([0, maxcolorbar_input]);colormap(jet);colorbar;title([basename{1} '  ' chal_info{ax,3}]);pause(0.1);h=rotate3d;
            set(h,'Enable','on');
        end

        % output figures
        %{
        for i=1:size(data_i,1)
            s=data_i(i,1);
            ax=s;
            fh = figure;set(fh,'Units','pixels','visible','off');
            eval(['scatter3(xyzintsegdat{' num2str(ax) '}(:,1),xyzintsegdat{' num2str(ax) '}(:,2),xyzintsegdat{' num2str(ax) '}(:,3),20,xyzintsegdat{' num2str(ax) '}(:,5));']);
            caxis([0, 65535]);colormap(jet);colorbar;title([basename '  ' chal_info{ax,3}]);pause(0.1);h=rotate3d;
            if ispc ==1
                set(fh,'visible','on');
                eval(['saveas(fh, [basename ''\xyzintsegdat{' num2str(ax) '}.fig'']);']);
                close(fh);
            else
                set(fh,'visible','on');
                eval(['saveas(fh, [basename ''/xyzintsegdat{' num2str(ax) '}.fig'']);']);
                close(fh);
            end
        end
        %}
        % Finish process
        set(handles.edit1,'String','Finished!');
        guidata(hObject, handles);
elseif maxyo==0
    set(handles.edit1,'String','Input value ...');pause(0.1);
    guidata(hObject, handles);
    set(handles.edit2,'Visible','On');
end
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% load p.mat
set(handles.edit1,'String','Drawing figure ...');pause(0.1);
guidata(hObject, handles);
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);


%% input popupmenu1 value
image_no= get(handles.popupmenu1,'Value');


%% Default load first image information
d_fol = data_folder{image_no};
s_fol = [d_fol 'stack.mat'];
d_fol = [d_fol 'p.mat'];
if ispc ==1
    d_fol(findstr(d_fol, '/'))='\';
    s_fol(findstr(s_fol, '/'))='\';
end
load(d_fol);load(s_fol);



%% load edit1, popupmenu3 properties
chal_no=get(handles.popupmenu3,'Value');
chal_string=get(handles.popupmenu3,'String');
chal_string=chal_string{chal_no,1};
ax=1;
for ci=1:size(chal_info,1)    
    if isempty(findstr(chal_string,chal_info{ci,3}))~=1;ax=ci;end
end
n=findstr(chal_string,'__');
figure_name = chal_string(n+2:end);


%% load maxcolorbar properties
maxcolorbar_input=str2num(get(handles.edit2,'String'));
if isempty(maxcolorbar_input)==1||maxcolorbar_input==0
    if iinfo.BitDepth==16
        maxcolorbar_input = 65535;
    else
        maxcolorbar_input = 256;
    end
end


%% Show GUI axes1 and output figures in data folder
% axes1

set(handles.axes1,'Units','pixels');
axes(handles.axes1);
if strcmp(figure_name,'xyzI')==1
    eval(['scatter3(xyzintsegdat{' num2str(ax) '}(:,1),xyzintsegdat{' num2str(ax) '}(:,2),xyzintsegdat{' num2str(ax) '}(:,3),20,xyzintsegdat{' num2str(ax) '}(:,5));']);
    caxis([0, maxcolorbar_input]);colormap(jet);colorbar;title([basename{1} '  ' chal_info{ax,3}]);pause(0.1);h=rotate3d;
    set(h,'Enable','on');
end

% output figures
%{
for i=1:size(data_i,1)
    s=data_i(i,1);
    ax=s;
    fh = figure;set(fh,'Units','pixels','visible','off');
    eval(['scatter3(xyzintsegdat{' num2str(ax) '}(:,1),xyzintsegdat{' num2str(ax) '}(:,2),xyzintsegdat{' num2str(ax) '}(:,3),20,xyzintsegdat{' num2str(ax) '}(:,5));']);
    caxis([0, 65535]);colormap(jet);colorbar;title([basename '  ' chal_info{ax,3}]);pause(0.1);h=rotate3d;
    if ispc ==1
        set(fh,'visible','on');
        eval(['saveas(fh, [basename ''\xyzintsegdat{' num2str(ax) '}.fig'']);']);
        close(fh);
    else
        set(fh,'visible','on');
        eval(['saveas(fh, [basename ''/xyzintsegdat{' num2str(ax) '}.fig'']);']);
        close(fh);
    end
end
%}
% Finish process
set(handles.edit1,'String','Finished!');
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
end

% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)

%% load p.mat
set(handles.edit1,'String','Saving figure ...');pause(0.1);
guidata(hObject, handles);
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);


%% input popupmenu1 value
image_no= get(handles.popupmenu1,'Value');


%% Default load first image information
d_fol = data_folder{image_no};
s_fol = [d_fol 'stack.mat'];
d_fol = [d_fol 'p.mat'];
if ispc ==1
    d_fol(findstr(d_fol, '/'))='\';
    s_fol(findstr(s_fol, '/'))='\';
end
load(d_fol);load(s_fol);



%% load edit1, popupmenu3 properties
chal_no=get(handles.popupmenu3,'Value');
chal_string=get(handles.popupmenu3,'String');
chal_string=chal_string{chal_no,1};
ax=1;
for ci=1:size(chal_info,1)    
    if isempty(findstr(chal_string,chal_info{ci,3}))~=1;ax=ci;end
end
n=findstr(chal_string,'__');
figure_name = chal_string(n+2:end);


%% load maxcolorbar properties
maxcolorbar_input=str2num(get(handles.edit2,'String'));
if isempty(maxcolorbar_input)==1||maxcolorbar_input==0
    if iinfo.BitDepth==16
        maxcolorbar_input = 65535;
    else
        maxcolorbar_input = 256;
    end
end


%% Show GUI axes1 and output figures in data folder
% axes1
%{
set(handles.axes1,'Units','pixels');
axes(handles.axes1);
if strcmp(figure_name,'xyzI')==1
    eval(['scatter3(xyzintsegdat{' num2str(ax) '}(:,1),xyzintsegdat{' num2str(ax) '}(:,2),xyzintsegdat{' num2str(ax) '}(:,3),20,xyzintsegdat{' num2str(ax) '}(:,5));']);
    caxis([0, maxcolorbar_input]);colormap(jet);colorbar;title([basename{1} '  ' chal_info{ax,3}]);pause(0.1);h=rotate3d;
    set(h,'Enable','on');
end
%}
% output figures
fh = figure;set(fh,'Units','pixels','visible','off');
set(fh,'Units','pixels','visible','off');
if strcmp(figure_name,'xyzI')==1
    eval(['scatter3(xyzintsegdat{' num2str(ax) '}(:,1),xyzintsegdat{' num2str(ax) '}(:,2),xyzintsegdat{' num2str(ax) '}(:,3),20,xyzintsegdat{' num2str(ax) '}(:,5));']);
    caxis([0, maxcolorbar_input]);colormap(jet);colorbar;title([basename{1} '  ' chal_info{ax,3}]);pause(0.1);h=rotate3d;

    set(fh,'visible','on');
    eval(['saveas(fh,''' data_folder{image_no} chal_string '.fig'');']);
    close(fh);

end


% Finish process
set(handles.edit1,'String','Finished!');
guidata(hObject, handles);

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% ====/ other GUI functions /=====================================================

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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

% --- Executes on button press in pushbutton4.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

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
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
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

% ================================================================

function segmentation3D(handles)

% step 1: identify nuclei and eliminate dividing cells
step1_nuclearidentification(hObject, handles);

% step 2: 
% each embryo is saved as ['filename' # '_xyz']
% open all arrays and save them together as 'NFall.mat'

% step 3: parallel to x-y plane, First round of DV plane finding.
step3_alignment(hObject, handles)

% step 4: CPD registration of all to CNFT1 (stk1)
step4_registration(p);

% step 5:
Step5_averagingontosphere(p);

% step 6a:
Step6a_display3Daverage(p)

% step 6b:
Step6b_TTestcompare(p);

% step 6c:
Step6c_DisplayMarginGradient(p);


end
function [p,io]=p_setting()

% Main parameter, IO
%io.segindex = 2;      % 2 segindex= the channel to be used to ID maxima
%io.intindex = 1;      % 1 intindex= the experimental channel to be measured
io.savetiff = 1;      % save all tif files to folder
io.totchan = 2;       % 2
io.dataorder = 1;     % =1: chal1(1,4,7,10), =2: chal1(1,2,3,4)

io.chal1_show = 1;    % Show Channel 1 measurement = 0(no show) or 1(show)
io.chal2_show = 1;
io.chal3_show = 0;
io.chal4_show = 0;
io.chal1_no = 1;      % Channel 1 name = {1,2,3,4,5} = {'Nuclei','signal1','signal2','signal3','none'}
io.chal2_no = 2;
io.chal3_no = 3;
io.chal4_no = 4;
io.chal1_name = '';    % Input Channel 1 name, For example: DAPI
io.chal2_name = '';
io.chal3_name = '';
io.chal4_name = '';



% step1
p.id_x1 = 9;            % x1= width of average nucei in pixels (usually 9)
p.id_y1 = 9;            % y1= height of average nuclei in pixels (usually 9)
p.id_z1 = 3;            % z1= depth of average nuclei in pixles (usually 3)
p.id_noisemin = 10;     % noisemin=during segmenting, minima below this value will be supressed (usually 9)
p.id_noisemax = 10;     % noisemax=during segmenting, maxima below this value will be supressed (usually 9)
p.id_dist = 6;          % dist=maxima closer than this will be combined.  (usually 6)
p.id_showimage = 0;
p.id_saveim = 0;
p.id_r = 4;
p.id_distniegh = 20; 
p.id_PHHcutoff = 256;
p.id_divcut = 1.4;
p.id_removeYSL = 0;



% step3
p.ali_stknum = [1];     %array of stk numbers
p.ali_show = 0;         % show every iteration of regression and rotation (0: not show, 1: show)
p.ali_maxNO = 40;       % max number of iterations
p.ali_limit = 1e-8;     %if the angle between the test and reference regression planes reaches below this limit, regression stops
p.ali_dvmethod = 1;
p.ali_stapo1 = -100;
p.ali_endpo1 = 0;
p.ali_bandwidth = 60;
p.ali_NOmaxPo = 10;
p.ali_stapo2 = -60;
p.ali_endpo2 = 0;
p.ali_dvmethod2 = 2;


% step4
p.reg_stknum = p.ali_stknum;
p.reg_method='affine'; % use affine registration
p.reg_viz=1;           % 1: show every iteration, 0: do not show
p.reg_outliers=0.1;    % 0.1: default, set outlier filter level

p.reg_normalize=1;    % normalize to unit variance and zero mean before registering (default)
p.reg_scale=1;        % estimate global scaling too (default)
p.reg_rot=1;          % estimate strictly rotational matrix (default)
p.reg_corresp=1;      % compute the correspondence vector at the end of registration 

p.reg_max_it=75;      % max number of iterations allowed
p.reg_tol=1e-8;       % tolerance of noise
p.reg_fgt=0;          % [0,1,2], if=0, normal operation, slower but accurate, if>0, use FGT (Fast Gaussian Transform). 
                    % case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    % case 2: FGT, followed by truncated Gaussian approximation 
                    %         (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

                    
% step5
p.avre_stknum = p.ali_stknum;
p.avre_plot = 1; 
p.avre_numper = 0.2;


end

% Main functions
function imagename=load_tif_lsm(hObject,handles,p,io)
% Load tiff and lsm image files and convert into stack, save into stack.mat and convert into tiff files


%% data folder and image format
set(handles.edit1,'String','Loading Images ...');pause(0.1);
guidata(hObject, handles);
imagename{1}=uigetfile({'*.tif;*.lsm','Image Files (*.tif,*.lsm)'});
if imagename{1}==0
    set(handles.edit1,'String','');pause(0.1);
    guidata(hObject, handles);
    return;
end


%% load images tiff and lism and convert to basename and imageformat
basename{1}=imagename{1}(1:strfind(imagename{1},'.')-1);
imageformat{1}=imagename{1}(strfind(imagename{1},'.'):end);
rootfolder = pwd;


%% save current folder information to io.mat
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end

% Create data folder
if ismac||isunix==1
    data_folder{1} = [rootfolder '/' basename{1} '/'];
elseif ispc==1
    data_folder{1} = [rootfolder '/' basename{1} '/'];
end
if exist(data_folder{1}) ~= 7
    mkdir(data_folder{1});
end
addpath(data_folder{1});
save(savefolder,'imagename','basename','imageformat','savefolder','data_folder','-append');


%% convert image into multi-stack and save stack.mat and p.mat
try
    lsm_stack = tiffread(imagename{1});
catch
    if strcmp(imageformat,'.tif')==1
        lsm_stack = readlsm_tif(imagename{1});        
    else
        lsm_stack = readlsm(imagename{1});     
    end
end
%lsm_stack=lsm_stack(1,1:60);    %[test_code]George

% image information
iinfo.Width = lsm_stack(1).width;
iinfo.Height = lsm_stack(1).height;
iinfo.BitDepth = lsm_stack(1).bits;
iinfo.chalN = size(imread(imagename{1}),3);
if iscell(lsm_stack(1).data)==1
    iinfo.pageN = size(lsm_stack,2);
else
    iinfo.pageN = size(lsm_stack,2)/iinfo.chalN;
end

% Create channel info
for c=1:iinfo.chalN
    eval(['chal_info{c,1} = io.chal' num2str(c) '_show;']);
    chal_info{c,2} = 0;
    eval(['if io.chal' num2str(c) '_no ==1;chal_info{c,2} = 1;end']);
    eval(['if io.chal' num2str(c) '_no ==1;chal_info{c,3} = ''Nuclei'';end']);
    eval(['if io.chal' num2str(c) '_no ==2;chal_info{c,3} = ''Signal 1'';end']);
    eval(['if io.chal' num2str(c) '_no ==3;chal_info{c,3} = ''Signal 2'';end']);
    eval(['if io.chal' num2str(c) '_no ==4;chal_info{c,3} = ''Signal 3'';end']);
    eval(['if io.chal' num2str(c) '_no ==5;chal_info{c,3} = ''none'';end']);
    eval(['if io.chal' num2str(c) '_no ==5;chal_info{c,2} = -1;end']);
    eval(['if strcmp(io.chal' num2str(c) '_name,'''')~=1;chal_info{c,3} = io.chal' num2str(c) '_name;end']);
end

% export to stack
if iscell(lsm_stack(1).data)==1     % lsm image (lsm_stack.data is cell{1xN})
    
    if io.totchan == iinfo.chalN
        for chal=1:io.totchan
            startim=chal;j=1;
            for t=1:iinfo.pageN
                NFstk{chal}(:,:,j)=lsm_stack(1,t).data{1,chal};
                j=j+1;
            end;
        end
    else
        display('chal total number not match');
        for chal=1:iinfo.chalN
            startim=chal;j=1;
            for t=1:iinfo.pageN
                NFstk{chal}(:,:,j)=lsm_stack(1,t).data{1,chal};
                j=j+1;
            end;
        end
    end
    
else                                 % tiff image (lsm_stack.data not cell)
    
    if io.totchan == iinfo.chalN
        for chal=1:io.totchan
            startim=chal;j=1;
            for t=startim:io.totchan:startim+(iinfo.pageN-1)*io.totchan
                NFstk{chal}(:,:,j)=lsm_stack(1,t).data;
                j=j+1;
            end;
        end
    else
        display('chal total number not match');
        for chal=1:iinfo.chalN
            startim=chal;j=1;
            for t=startim:iinfo.chalN:startim+(iinfo.pageN-1)*iinfo.chalN
                NFstk{chal}(:,:,j)=lsm_stack(1,t).data;
                j=j+1;
            end;
        end
    end
    
end

p.io=io;
save([data_folder{1} 'stack.mat'],'NFstk','-v7.3');
save([data_folder{1} 'p.mat'],'p','iinfo','chal_info');


%% Save tiff files
if io.savetiff==1
    if exist([data_folder{1} 'tiff_image.tif'],'file')~=0
        delete([data_folder{1} 'tiff_image.tif']);
    end    
    for chal=1:iinfo.chalN
        for m=1:size(NFstk{chal},3)
            imwrite(NFstk{chal}(:,:,m),[data_folder{1} 'tiff_image.tif'], 'writemode', 'append');
        end
    end
end
clear NFstk iinfo chal_info

% Finish process
set(handles.edit1,'String','Finished!');
guidata(hObject, handles);

end
function image_folder=load_tif_lsm_folder(hObject,handles,p,io)
% Load tiff and lsm image files and convert into stack, save into stack.mat and convert into tiff files


%% data folder and image format
set(handles.edit1,'String','Loading Images ...');pause(0.1);
guidata(hObject, handles);
rootfolder = pwd;
image_folder=uigetdir(rootfolder);
if image_folder==0
    set(handles.edit1,'String','');pause(0.1);
    guidata(hObject, handles);
    return;
end    
image_folder1 = [image_folder '/*.tif'];
image_folder2 = [image_folder '/*.lsm'];
if ispc==1
    image_folder1(findstr(image_folder1, '/'))='\';
    image_folder2(findstr(image_folder2, '/'))='\';
end
finf1 = dir(image_folder1);finf2 = dir(image_folder2);


%% load images tiff and lism and convert to basename and imageformat
if isempty(finf1)==1&&isempty(finf2)==0
    for i=1:size(finf2,1)
        imagename{i}=finf2(i).name;
        basename{i}=imagename{i}(1:strfind(imagename{i},'.')-1);
        imageformat{i}=imagename{i}(strfind(imagename{i},'.'):end);
    end
elseif isempty(finf1)==0&&isempty(finf2)==1
    for i=1:size(finf1,1)
        imagename{i}=finf1(i).name;
        basename{i}=imagename{i}(1:strfind(imagename{i},'.')-1);
        imageformat{i}=imagename{i}(strfind(imagename{i},'.'):end);
    end
    
elseif isempty(finf1)==0&&isempty(finf2)==0
    for i=1:size(finf1,1)
        imagename{i}=finf1(i).name;
        basename{i}=imagename{i}(1:strfind(imagename{i},'.')-1);
        imageformat{i}=imagename{i}(strfind(imagename{i},'.'):end);
    end
    for i=1:size(finf2,1)
        imagename{size(finf1,1)+i}=finf2(i).name;
        basename{size(finf1,1)+i}=imagename{size(finf1,1)+i}(1:strfind(imagename{size(finf1,1)+i},'.')-1);
        imageformat{size(finf1,1)+i}=imagename{size(finf1,1)+i}(strfind(imagename{size(finf1,1)+i},'.'):end);
    end    
else
    set(handles.edit1,'String','Error: No images!');
    guidata(hObject, handles);
    return;
end


%% save current folder information to io.mat
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end

% Create data folder
if ismac||isunix==1
    for i=1:size(basename,2)
        data_folder{i} = [rootfolder '/' basename{i} '/'];
        if exist(data_folder{i}) ~= 7
            mkdir(data_folder{i});
        end
        addpath(data_folder{i});
    end
elseif ispc==1
    for i=1:size(basename,2)
        data_folder{i} = [rootfolder '/' basename{i} '/'];
        if exist(data_folder{i}) ~= 7
            mkdir(data_folder{i});
        end
        addpath(data_folder{i});
    end
end
save(savefolder,'imagename','basename','imageformat','savefolder','data_folder','-append');


%% convert image into multi-stack and save stack.mat and p.mat
for i=1:size(basename,2)
    eval(['set(handles.edit1,''String'',''Loading Images [' num2str(i) '/' num2str(size(basename,2)) '] ..'');pause(0.1);']);
    guidata(hObject, handles);
    % convert image into multi-stack
    try
        lsm_stack = tiffread(imagename{i});
    catch
        if strcmp(imageformat{i},'.tif')==1
            lsm_stack = readlsm_tif(imagename{i});        
        else
            lsm_stack = readlsm(imagename{i});     
        end
    end
    %lsm_stack=lsm_stack(1,1:60);    %[test_code]George
    
    % image information
    iinfo.Width = lsm_stack(1).width;
    iinfo.Height = lsm_stack(1).height;
    iinfo.BitDepth = lsm_stack(1).bits;
    iinfo.chalN = size(imread(imagename{i}),3);
    if iscell(lsm_stack(1).data)==1
        iinfo.pageN = size(lsm_stack,2);
    else
        iinfo.pageN = size(lsm_stack,2)/iinfo.chalN;
    end
    
    % Create channel info
    for c=1:iinfo.chalN
        eval(['chal_info{c,1} = io.chal' num2str(c) '_show;']);
        chal_info{c,2} = 0;
        eval(['if io.chal' num2str(c) '_no ==1;chal_info{c,2} = 1;end']);
        eval(['if io.chal' num2str(c) '_no ==1;chal_info{c,3} = ''Nuclei'';end']);
        eval(['if io.chal' num2str(c) '_no ==2;chal_info{c,3} = ''Signal 1'';end']);
        eval(['if io.chal' num2str(c) '_no ==3;chal_info{c,3} = ''Signal 2'';end']);
        eval(['if io.chal' num2str(c) '_no ==4;chal_info{c,3} = ''Signal 3'';end']);
        eval(['if io.chal' num2str(c) '_no ==5;chal_info{c,3} = ''none'';end']);
        eval(['if io.chal' num2str(c) '_no ==5;chal_info{c,2} = -1;end']);
        eval(['if strcmp(io.chal' num2str(c) '_name,'''')~=1;chal_info{c,3} = io.chal' num2str(c) '_name;end']);
    end

    % export to stack
    if iscell(lsm_stack(1).data)==1     % lsm image (lsm_stack.data is cell{1xN})

        if io.totchan == iinfo.chalN
            for chal=1:io.totchan
                startim=chal;j=1;
                for t=1:iinfo.pageN
                    NFstk{chal}(:,:,j)=lsm_stack(1,t).data{1,chal};
                    j=j+1;
                end;
            end
        else
            display('chal total number not match');
            for chal=1:iinfo.chalN
                startim=chal;j=1;
                for t=1:iinfo.pageN
                    NFstk{chal}(:,:,j)=lsm_stack(1,t).data{1,chal};
                    j=j+1;
                end;
            end
        end

    else                                 % tiff image (lsm_stack.data not cell)

        if io.totchan == iinfo.chalN
            for chal=1:io.totchan
                startim=chal;j=1;
                for t=startim:io.totchan:startim+(iinfo.pageN-1)*io.totchan
                    NFstk{chal}(:,:,j)=lsm_stack(1,t).data;
                    j=j+1;
                end;
            end
        else
            display('chal total number not match');
            for chal=1:iinfo.chalN
                startim=chal;j=1;
                for t=startim:iinfo.chalN:startim+(iinfo.pageN-1)*iinfo.chalN
                    NFstk{chal}(:,:,j)=lsm_stack(1,t).data;
                    j=j+1;
                end;
            end
        end

    end
        
    p.io=io;
    save([data_folder{i} 'stack.mat'],'lsm_stack','NFstk','-v7.3');
    save([data_folder{i} 'p.mat'],'p','iinfo','chal_info');


%% Save tiff files
    if io.savetiff==1
        if exist([data_folder{i} 'tiff_image.tif'],'file')~=0
            delete([data_folder{i} 'tiff_image.tif']);
        end
        for chal=1:iinfo.chalN
            for m=1:size(NFstk{chal},3)
                imwrite(NFstk{chal}(:,:,m),[data_folder{i} 'tiff_image.tif'], 'writemode', 'append');
            end
        end
    end
clear NFstk iinfo chal_info
end

% Finish process
set(handles.edit1,'String','Finished!');
guidata(hObject, handles);

end
function step1_nuclearidentification(hObject, handles)
% step 1: identify nuclei and eliminate dividing cells

% pre
set(handles.edit1,'String','Run step1_nuclearidentification ...');pause(0.1);
guidata(hObject, handles);

% load io.mat
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);

for i=1:size(imagename,2)
    
    eval(['set(handles.edit1,''String'',''Run step1 [' num2str(i) '/' num2str(size(imagename,2)) '] ...'');']);
    pause(0.1);
    guidata(hObject, handles);
    
    now_image = i;
    save(savefolder,'now_image','-append');
    load([data_folder{i} 'stack.mat']);load([data_folder{i} 'p.mat']);

    [xyzintsegdat,coloroverlay]=seg_auto(hObject, handles, NFstk, p, iinfo, basename{i},chal_info); %% identify nuclei centerpoints and extract nuclear intensities
    for j=1:size(xyzintsegdat,2)
        if isempty(xyzintsegdat{j})~=1
            NFstk_xyz{j} = plotnieghbors(xyzintsegdat{j}, p.id_r, p.id_distniegh, p.id_PHHcutoff, p.id_divcut);  %% eliminates dividing cells
        end
    end
    % Finish process
    save([data_folder{i} 'stack.mat'],'xyzintsegdat','NFstk_xyz','coloroverlay','-append');
    
    if p.id_removeYSL==1
        [xyzintsegdat_noYSL] = removeYSL(xyzintsegdat);
        show_xyzintsegdat_noYSL(hObject,handles,xyzintsegdat_noYSL,basename{i})
        save([data_folder{i} 'stack.mat'],'xyzintsegdat_noYSL','-append');
    end
end

%set(handles.edit1,'String','RUN1 Finished!');pause(0.1);
%guidata(hObject, handles);

end
function step2_

end
function step3_alignment(hObject, handles)

% cnf640.  Joe zinski 7/1/13
% CPD image registration of zebrafish nuclei cloud data.
% input features: 
%    %    4D data sets, x, y, z coordinates and p-smad intensity
%    data stored in m*5 matrix, Col 1-3: x,y,z coordinates, Col 4: Histone 
%    intensity, Col 5: p-smad intenstiy. We use Col 1-3 and 5 for 4D
%       
% Steps of Image Analysis:
%        (1) Segmentation of nulcei   ( done by Joe Zinski )
%        (2) First round of Dorsal-Ventral (DV) plane finding (approxiamation) *
%        (3) YSL deletion   ( done by Joe Zinski )
%        (4) Second round of DV plane finding (exact)
%        (5) CPD registration                  
%        (6) Outer layer nuclei deletion
%        (7) Profile extration
%        (8) Profile plotting
%
% * (current step)
set(handles.edit1,'String','Run step3_alignment ...');pause(0.1);
guidata(hObject, handles);

% load p.mat
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/p.mat'];
load(savefolder);

for ii=1:size(imagename,2)
    load([data_folder{ii} 'stack.mat']);

    %input all relavent labels here:
    stknum= p.ali_stknum;        %array of stk numbers
    stkname= 'NFall';    %string, filename
    stkmatname= 'NFstk';   %string, matlab filename

    %---------------------------- 1st DV finding ------------------------------

    Y = xyzintsegdat;
    Y(:,1:2)=Y(:,1:2)*0.5535; Y(:,3)=-Y(:,3)*2.2; % Set position data in units of microns. 
    eval(['data.set' int2str(ii) '= Y']);

    %%%%%%%% Plane regression to be parallel to x-y plane %%%%%%%
    % Set the options for plane regression and rotation
    opti.show = p.ali_show;     % show every iteration of regression and rotation (0: not show, 1: show)
    opti.maxNO = p.ali_maxNO;   % max number of iterations
    opti.limit = p.ali_limit; % if the angle between the test and reference regression planes reaches below this limit, regression stops could be 1e-6 to 1e-8

    x_y_plane= [1000*rand(10,1) 1000*rand(10,1) zeros(10,1)];   
    % set three points in the xy plane to determine the xy plane for use of the function CPD_preprocessing for plane regression

    for i=stknum                % Rotate the Nuclei data and make its regression plane parallel to x_y_plane
        eval(['[x, y, b] = CPD_preprocessing(x_y_plane, data.set' int2str(i) '(:,1:3), opti);']);
        eval(['data.set' int2str(i) '(:,1:3) = y;']);
    end;

    % 4D plot for each individual stk after plane regression and rotation
    % figure, scatter3(data.set1(:,1), data.set1(:,2), data.set1(:,3), 20, data.set1(:,5), 'filled'); colormap('HSV');
    % figure, scatter3(data.set2(:,1), data.set2(:,2), data.set2(:,3), 20, data.set2(:,5), 'filled'); colormap('HSV');
    % figure, scatter3(data.set3(:,1), data.set3(:,2), data.set3(:,3), 20, data.set3(:,5), 'filled'); colormap('HSV');
    % figure, scatter3(data.set4(:,1), data.set4(:,2), data.set4(:,3), 20, data.set4(:,5), 'filled'); colormap('HSV');
    % figure, scatter3(data.set5(:,1), data.set5(:,2), data.set5(:,3), 20, data.set5(:,5), 'filled'); colormap('HSV');
    % figure, scatter3(data.set6(:,1), data.set6(:,2), data.set6(:,3), 20, data.set6(:,5), 'filled'); colormap('HSV');


    %%%%%%%% DV plane finding (dvmethod = 2 (ployfit method), approximate) %%%%%%%%
    % Set parameters for dv plane finding, set parameters for and test each embryo one by one
    parameters.dvmethod = p.ali_dvmethod;
    parameters.stapo = p.ali_stapo1; 
    parameters.endpo = p.ali_endpo1;

    for i=stknum
        stkNO = i;
        % if dvmethod 2 doesn't work well, use the following method 1
        % DV plane finding (dvmethod = 1 (default: line regression method), approximate) %%%%%%%%
        % Set parameters for dv plane finding, set parameters for and test each embryo one by one
        parameters.bandwidth = p.ali_bandwidth;   % to change
        parameters.NOmaxPo = p.ali_NOmaxPo;      % to change  
        parameters.stapo = p.ali_stapo2;      % to change
        parameters.endpo = p.ali_endpo2;        % to change
        % stkNO = 2;                  % to change

       % data used for dvplane shall be stored in a structure with name ____.set1, ____.set2, ......  
        dataNew = dvplane(data, stkNO, parameters);

        % plot nuclei cloud after dvplane finding (dvmethod = 1)
        %figure, scatter3(dataNew(:,1), dataNew(:,2), dataNew(:,3), 20, dataNew(:,5),'filled'); colormap('HSV'); colorbar; caxis([0 256]); % plot DV-adjusted final data
        tem1 = [];
        for k=1:size(dataNew,1)
            datatemp = dataNew(k,3);
            if datatemp > -70 && datatemp < -40
               tem1 = cat(1, tem1, dataNew(k,:));    
            end;
        end;  
        figure, scatter(tem1(:,1), tem1(:,2), 20, tem1(:,5),'filled');  colormap('HSV'); colorbar; caxis([0 256]); % plot DV-adjusted final data posterior band
        save( [stkname int2str(i) '_pre_YSL_deletion'], 'dataNew');
    end;

    for i=stknum
        eval(['load(''' stkname int2str(i) '_pre_YSL_deletion'');']);
        [dataNew_noYSL] = removeYSL(dataNew);
        save( [stkname int2str(i) '_noYSL'], 'dataNew_noYSL');
    end
    data=[];

    for i=stknum    
        eval(['load(''' stkname int2str(i) '_noYSL'');']);
        Y = dataNew_noYSL;  
        %Y(:,1:2)=Y(:,1:2)*0.5535; Y(:,3)=-Y(:,3)*2.2; % Set position data in units of microns. 
        eval(['data.set' int2str(i) '= Y']);
    end;    

    %%%%%%%% Plane regression to be parallel to x-y plane %%%%%%%
    % Set the options for plane regression and rotation
    opti.show = p.ali_show;     % show every iteration of regression and rotation (0: not show, 1: show)
    opti.maxNO = p.ali_maxNO;   % max number of iterations
    opti.limit = p.ali_limit; % if the angle between the test and reference regression planes reaches below this limit, regression stops
    %could be 1e-6 to 1e-8
    x_y_plane= [1000*rand(10,1) 1000*rand(10,1) zeros(10,1)];   
    % set three points in the xy plane to determine the xy plane for use of the function CPD_preprocessing for plane regression

    for i=stknum                % Rotate the Nuclei data and make its regression plane parallel to x_y_plane
        eval(['[x, y, b] = CPD_preprocessing(x_y_plane, data.set' int2str(i) '(:,1:3), opti);']);
        eval(['data.set' int2str(i) '(:,1:3) = y;']);
    end;

    % 4D plot for each individual stk after plane regression and rotation
    % figure, scatter3(data.set1(:,1), data.set1(:,2), data.set1(:,3), 20, data.set1(:,5), 'filled'); colormap('HSV');
    % figure, scatter3(data.set2(:,1), data.set2(:,2), data.set2(:,3), 20, data.set2(:,5), 'filled'); colormap('HSV');
    % figure, scatter3(data.set3(:,1), data.set3(:,2), data.set3(:,3), 20, data.set3(:,5), 'filled'); colormap('HSV');
    % figure, scatter3(data.set4(:,1), data.set4(:,2), data.set4(:,3), 20, data.set4(:,5), 'filled'); colormap('HSV');
    % figure, scatter3(data.set5(:,1), data.set5(:,2), data.set5(:,3), 20, data.set5(:,5), 'filled'); colormap('HSV');
    % figure, scatter3(data.set6(:,1), data.set6(:,2), data.set6(:,3), 20, data.set6(:,5), 'filled'); colormap('HSV');


    %%%%%%%% DV plane finding (dvmethod = 2 (ployfit method), approximate) %%%%%%%%
    % Set parameters for dv plane finding, set parameters for and test each embryo one by one
    parameters.dvmethod = p.ali_dvmethod2;
    parameters.stapo = p.ali_stapo1; 
    parameters.endpo = p.ali_endpo1;

    for i=stknum
    stkNO = i;                  % to change
            % if dvmethod 2 doesn't work well, use the following method 1
    %     %%%%%%%% DV plane finding (dvmethod = 1 (default: line regression method), approximate) %%%%%%%%
    %         % Set parameters for dv plane finding, set parameters for and test each embryo one by one
     parameters.bandwidth = p.ali_bandwidth;   % to change
     parameters.NOmaxPo = p.ali_NOmaxPo;      % to change  
     parameters.stapo = p.ali_stapo2;      % to change
     parameters.endpo = p.ali_endpo2;        % to change
    % stkNO = 2;                  % to change

    % data used for dvplane shall be stored in a structure with name ____.set1, ____.set2, ......  
    dataNew = dvplane(data, stkNO, parameters);

    % plot nuclei cloud after dvplane finding (dvmethod = 1)
    %figure, scatter3(dataNew(:,1), dataNew(:,2), dataNew(:,3), 20, dataNew(:,5),'filled'); colormap('HSV'); colorbar; caxis([0 256]); % plot DV-adjusted final data
    tem1 = [];
    for k=1:size(dataNew,1)
        datatemp = dataNew(k,3);
        if datatemp > -70 && datatemp < -40
           tem1 = cat(1, tem1, dataNew(k,:));    
        end;
    end;  
    figure, scatter(tem1(:,1), tem1(:,2), 20, tem1(:,5),'filled');  colormap('HSV'); colorbar; caxis([0 256]); % plot DV-adjusted final data posterior band

    save( [stkname int2str(i) '_poststp4'], 'dataNew');
    end;

end

end
function step4_registration(hObject, handles)

% registration_cnf640.   jz 7/3/13
% CPD image registration of zebrafish nuclei cloud data.
% Data features: 
%    4D data sets, x, y, z coordinates and p-smad intensity
%    data stored in m*5 matrix, Col 1-3: x,y,z coordinates, Col 4: Histone 
%    intensity, Col 5: p-smad intenstiy. We use Col 1-3 and 5 for 4D
%       Chd-/- NF Mo : stk1, stk3, stk4, stk6 
%       Chd+/- NF Mo : stk2, stk5, stk7
%
% Steps of Image Analysis:
%        (1) Segmentation of nulcei     ( done by Joe Zinski )
%        (2) First round of Dorsal-Ventral (DV) plane finding (approxiamation)
%        (3) YSL deletion     ( done by Joe Zinski )
%        (4) Second round of DV plane finding (exact)
%        (5) CPD registration *                 
%        (6) Outer layer nuclei deletion
%        (7) Profile extration
%        (8) Profile plotting
%
% * (current step)
% CNFT1stk1 can be used as the referene model for registration.

clc; clear;

%--------- CPD registration of all to CNFT1 (stk1)  ----------
      
   % set the options for CPD registration, using affine method
opt.method=p.reg_method; % use affine registration
opt.viz=p.reg_viz;           % 1: show every iteration, 0: do not show
opt.outliers=p.reg_outliers;    % 0.1: default, set outlier filter level

opt.normalize=p.reg_normalize;    % normalize to unit variance and zero mean before registering (default)
opt.scale=p.reg_scale;        % estimate global scaling too (default)
opt.rot=p.reg_rot;          % estimate strictly rotational matrix (default)
opt.corresp=p.reg_corresp;      % compute the correspondence vector at the end of registration 

opt.max_it=p.reg_max_it;      % max number of iterations allowed
opt.tol=p.reg_tol;       % tolerance of noise
opt.fgt=p.reg_fgt;          % [0,1,2], if=0, normal operation, slower but accurate, if>0, use FGT (Fast Gaussian Transform). 
                    % case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    % case 2: FGT, followed by truncated Gaussian approximation 
                    %         (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

   % load reference data sets
   
referstknm='NFall1_poststp4';
stknm='NFall';
   
load(referstknm);
referstk = dataNew;
clear dataNew;

cpd_make;  % set C complier fro MATLAB C mixed programming
for i=p.reg_stknum % start CPD registration
    disp(['Registering stk' int2str(i) ' to Ref ...']);
     % load the rest 5 data sets one at each time as the test set
    load([stknm int2str(i) '_poststp4']);                                   
    eval(['dataSTK' int2str(i) ' = dataNew;']);
    clear dataNew;

    eval(['[Transform, C]=cpd_register(referstk(:,1:3),dataSTK' int2str(i) '(:,1:3),opt);']);
%     close(figure(gcf));   % close current figure window    
    
    eval(['dataSTK' int2str(i) 'T = [Transform.Y dataSTK' int2str(i) '(:,4:5)];']);    
    save ([stknm int2str(i) '_after_CPD'], ['dataSTK' int2str(i) 'T'], 'C');
end    



end
function Step5_averagingontosphere(hObject, handles)

[NFdata, NFsides, NFnodes]=icosoproj(p,'nfall', p.avre_stknum);  %n=9
end
function Step6a_display3Daverage(hObject, handles)

icosograph(NF57sides, NF57nodes);
end
function Step6b_TTestcompare(hObject, handles)

[sign]=TTestV1(NFdata, WTdata, '-', [0,.2,.7],[.7,.2,0], .05, 20, 10,0);
end
function Step6c_DisplayMarginGradient(hObject, handles)

ls=6;
[profile, databand, R, wt47allout]=sigmaXV5S(NFdata, '-', [.7,0,0], .05,20,10,0,ls,2);

end

%step 1 sub functions
function [xyzintsegdat,coloroverlay]=seg_auto(hObject, handles, stack, p, iinfo, basename,chal_info)
%{
% 1. imports a tiff confocal stack with 2 channels [importstackone()]
% 2. smooths nuclei labeled image in 3-D [smooth3D()]
% 3. finds nuclei maxima from smoothed image [maxima3D()]
% 4. exctracts intensities from pixels surrounding maxima [intensityfinder3D()]

%%% inputs
%basename= the name of the image not including .tif
%segindex= the channel to be used to ID maxima
%intindex= the experimental channel to be measured
%x1= width of average nucei in pixels (usually 9)
%y1= height of average nuclei in pixels (usually 9)
%z1= depth of average nuclei in pixles (usually 3)
%noisemin=during segmenting, minima below this value will be supressed (usually 9)
%noisemax=during segmenting, maxima below this value will be supressed (usually 9)
%pix=pixels of xy plane of image. example: 1024
%dist=maxima closer than this will be combined.  (usually 6)

%output
%maximaxyintz= a 5 by X matrix where X is the number of nuclei.  column 1
%is x coordinate, column 2 is Y coordinate, column 3 is segsuffix image,
%column 4 is intsuffix image, colum 5 is Z coordinate

%6.6.12= updated so that it only takes intenisty from center slice
%7.2.12= the normalizedim3D function was removed.  it was deemed no longer
%necessary as the maxima3D function is robust and variation of intensity
%with the new imaging protocals is minimal.  removed when normalizer removed:  ", normfac, thresh)"
%7.1.14 reannotated
%imagename=uigetfile('*.tif');

% for troubleshooting, removed %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %displaymean=input('Do you want to display the mean for each image? (1=yes, 0=no) ');
    %showimage=input('show images with maximas? (1=yes, 2=no) ');
    %if showimage==1
    %saveim=input('save images with maximas? (1=yes, 2=no) ');
    %end;
%}

%% pre-process
tic
%maximaxyintz=[];   %'maximaxyz' will hold the xyz coordinates of all maxima in each plane


%% find nuclei channel and obtain xyzintseg matrix
chal_matrix = cell2mat(chal_info(:,1:2));
nuc_i = find(chal_matrix(:,2));
segstack = stack{nuc_i};
[imstksm]=smooth3D(segstack, p.id_x1, p.id_y1, p.id_z1); % smooths the nuclei label channel
[maximaintclean, fragall, fragconc, coloroverlay]=maxima3D(imstksm, p, iinfo); % finds maximas of all nuclei from smoothed channel
[xyzintseg]=intensityfinder3D(segstack, maximaintclean, p.id_x1, p.id_y1, p.id_z1); %finds the intensities in each stack at the maxima points
  

%% find signal channel and obtain data show matrix
data_i = find(chal_matrix(:,1));
for i=1:size(data_i,1)
    s=data_i(i,1);
    eval(['[xyzintsegdat{' num2str(s) '}]=intensityfinder3D(stack{s}, xyzintseg, p.id_x1, p.id_y1, p.id_z1);']);   % finds the intensities in each stack at the maxima points
end


%% Show GUI axes1 and output figures in data folder
% axes1
ax = data_i(1,1);
set(handles.axes1,'Units','pixels');
axes(handles.axes1);
eval(['scatter3(xyzintsegdat{' num2str(ax) '}(:,1),xyzintsegdat{' num2str(ax) '}(:,2),xyzintsegdat{' num2str(ax) '}(:,3),20,xyzintsegdat{' num2str(ax) '}(:,5));']);
caxis([0, 65535]);colormap(jet);colorbar;title([basename '  ' chal_info{ax,3}]);pause(0.1);h=rotate3d;
set(h,'Enable','on');

% output figures
%{
for i=1:size(data_i,1)
    s=data_i(i,1);
    ax=s;
    fh = figure;set(fh,'Units','pixels','visible','off');
    eval(['scatter3(xyzintsegdat{' num2str(ax) '}(:,1),xyzintsegdat{' num2str(ax) '}(:,2),xyzintsegdat{' num2str(ax) '}(:,3),20,xyzintsegdat{' num2str(ax) '}(:,5));']);
    caxis([0, 65535]);colormap(jet);colorbar;title([basename '  ' chal_info{ax,3}]);pause(0.1);h=rotate3d;
    if ispc ==1
        set(fh,'visible','on');
        eval(['saveas(fh, [basename ''\xyzintsegdat{' num2str(ax) '}.fig'']);']);
        close(fh);
    else
        set(fh,'visible','on');
        eval(['saveas(fh, [basename ''/xyzintsegdat{' num2str(ax) '}.fig'']);']);
        close(fh);
    end
end
%}

% Finish process
set(handles.edit1,'String','Finished!');
guidata(hObject, handles);

end
function show_xyzintsegdat_noYSL(hObject,handles,xyzintsegdat,basename)

% Axes1
set(handles.axes1,'Units','pixels');
%resizePos = get(handles.axes1,'Position');
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
%imagesc(myImage);
%set(handles.axes1,'Units','normalized');
scatter3(xyzintsegdat(:,1),xyzintsegdat(:,2),xyzintsegdat(:,3),20,xyzintsegdat(:,5));
caxis([0, 65535]);colormap(jet);colorbar;title(basename);pause(0.1);h=rotate3d;
set(h,'Enable','on');

fh = figure;set(fh,'Units','pixels','visible','off');
scatter3(xyzintsegdat(:,1),xyzintsegdat(:,2),xyzintsegdat(:,3),20,xyzintsegdat(:,5));
caxis([0, 65535]);colormap(jet);colorbar;title([basename '/_noYSL']);pause(0.1);h=rotate3d;
if ispc ==1
    set(fh,'visible','on');
    saveas(fh, [basename '\xyzintsegdat_noYSL.fig']);
    close(fh);
else
    set(fh,'visible','on');
    saveas(fh, [basename '/xyzintsegdat_noYSL.fig']);
    close(fh);
end

end
function [xyzintsegdat] = stacksegint3D140plus(basename, segindex, intindex, x1, y1, z1, noisemin, noisemax, pix, dist)

%like stacksegintauto, except the input can handle stacks of 140 or more by
%dividing it into a stack beow 90 and above 90 and finding maxima in each
%and the combining the results.

%basename= the name of the image sequence up to the image numbers.  the
%for example: 'name_z'
%firstim=number of first image in sequence. example: 1
%lastim=number of last image in sequence. example: 20
%segsuffix=the channel suffix of desired images to be used for seg,menting and to normalize against. example: '_c0002'
%intsuffix=the channel suffix of desired images to be used for intensity measuring. example: '_c0003'
%radius= radius of disk smoother used for segmenting. example: 5
%noisemin=during segmenting, minima below this value will be surpressed (hmin).  example: 10
%noisemax=during segmenting, maxima below this value will be surpressed
%(hmax). example: 10
%pix=pixels of xy plane of image. example: 1024
%dist=maxima closer than this will be combined.  example: 5
    %normfac= the average intensity of pix above 20 will be averaged to this

%output
%maximaxyintz= a 5 by X matrix where X is the number of nuclei.  column 1
%is x coordinate, column 2 is Y coordinate, column 3 is segsuffix image,
%column 4 is intsuffix image, colum 5 is Z coordinate

%6.6.12= updated so that it only takes intenisty from center slice
%7.2.12= the normalizedim3D function was removed.  it was deemed no longer
%necessary as the maxima3D function is robust and variation of intensity
%with the new imaging protocals is minimal.  removed when normalizer removed:  ", normfac, thresh)"


saveim=0;
showimage=0;
        %displaymean=input('Do you want to display the mean for each image? (1=yes, 0=no) ');
%showimage=input('show images with maximas? (1=yes, 2=no) ');
%if showimage==1
%saveim=input('save images with maximas? (1=yes, 2=no) ');
%end;

starttime=clock;
tic

maximaxyintz=[];                   %'maximaxyz' will hold the xyz coordinates of all maxima in each plane

[segstack]=importstackone(basename, 2, segindex);
[datstack]=importstackone(basename, 2, intindex);

%%%%%%%%%%%%%%%%
%divide the stacks into 2 analysis clusters
totnums=numel(segstack(1,1,:));
segstack1=segstack(:,:,1:90);
segstack2=segstack(:,:,80:totnums);


datstack1=datstack(:,:,1:90);
datstack2=datstack(:,:,80:totnums);

clear datstack
clear segstack
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


disp('import complete')
        %[segstacknorm,~] = normalizeim3D(segstack, thresh, normfac, displaymean);  
toc


[imstksm1]=smooth3D(segstack1, x1, y1, z1);
[imstksm2]=smooth3D(segstack2, x1, y1, z1);
disp('normalize smooth complete')
toc


[maximaintclean1, fragall1, fragconc1, ~]=maxima3D(imstksm1, noisemin, noisemax, pix, dist, showimage, saveim, x1, y1, z1);
[maximaintclean2, fragall2, fragconc2, ~]=maxima3D(imstksm2, noisemin, noisemax, pix, dist, showimage, saveim, x1, y1, z1);


disp('segmentation complete')
toc


[xyzintseg1]=intensityfinder3D(segstack1, maximaintclean1, x1, y1, z1);
[xyzintsegdat1]=intensityfinder3D(datstack1, xyzintseg1, x1, y1, z1);
%[xyzintsegdat1]=dividerfinder3D(segstack1, xyzintsegdat1, x1, y1, z1);
%[xyzintsegdat1]=dividerfinder3D(segstack1, xyzintsegdat1, 2, 2, z1);

[xyzintseg2]=intensityfinder3D(segstack2, maximaintclean2, x1, y1, z1);
[xyzintsegdat2]=intensityfinder3D(datstack2, xyzintseg2, x1, y1, z1);
%[xyzintsegdat2]=dividerfinder3D(segstack2, xyzintsegdat2, x1, y1, z1);
%[xyzintsegdat2]=dividerfinder3D(segstack2, xyzintsegdat2, 2, 2, z1);

%%%%%%%%%%%%%%%%%%
%concatenate xyzintsegdat1 and 2

xyzintsegdat2(:,3)=xyzintsegdat2(:,3)+80;
[rowsblw86,b]=find(xyzintsegdat1(:,3)<86);
[rowsabv86,b]=find(xyzintsegdat2(:,3)>85);

xyzintsegdat=cat(1, xyzintsegdat1(rowsblw86,:),xyzintsegdat2(rowsabv86,:)); 
%%%%%%%%%%%%%%%%%%

fragall=cat(1, fragall1, fragall2)

fragconc=cat(1, fragconc1, fragconc2)

toc
endtime=clock;

elapsed=etime(endtime, starttime);

disp(elapsed)






end
function [outnn, outnd] = plotnieghbors(xyzin, r, distniegh, PHHcutoff, divcut)
%xyzin= input coordinates. column 1,2,3 is x,y,z.  column 6 is intensity
%distance in um to nearest nuclei.  assumes voxel size of .55X.55X2.2 um

%outputs: 
%col1=row of neighbor, col2=intensity of nieghbor, col3=intensity
%of nuclei, col4=row of nuclei in input file


xyzin=double(xyzin);
outnn=[0,0,0,0];
dividercount=0;

for i=1:numel(xyzin(:,4))
    xnuc=xyzin(i,1);
    ynuc=xyzin(i,2);
    znuc=xyzin(i,3);
    PHH=0;
    cont=xyzin(i,r);
    if PHH>PHHcutoff
        dividercount=dividercount+1;
    end;
    
    if PHH<PHHcutoff
        testxview = (((xyzin(:,1)-xnuc)*.55).^2 + ((xyzin(:,2)-ynuc)*.55).^2 + ((xyzin(:,3)-znuc)*2.2).^2).^.5;
    
        [nucrow, ~] = find(abs(testxview(:,1)) < distniegh & testxview(:,1) ~= 0 & PHH<PHHcutoff);
    
    
    
        if isempty(nucrow) == 0
        
            nucrow(:,2)=xyzin(nucrow, r);
            nucrow(:,3)=cont;
            nucrow(:,4)=i;
        
            outnn=cat(1,outnn, nucrow);
        
        end;
    end;
end;

[d]=nucvsneigh(outnn);



%figure
%plot(d(:,2),xyzin(:,5), '.')

[divrow,~]=find(d(:,2)>divcut);
outnd=xyzin;
outnd(divrow,:)=[];

1-sum(abs(outnn(:,2)-outnn(:,3)).^2)/sum(abs(outnn(:,2)-mean(outnn(:,2))).^2);

%dividercount
end
function [stack] = importstackone(stackname, totchan, deschan)
%designed to input images from a single stack of tif images with 2
%channels.  it starts at im 1 and goes through the whole imageset

%stackname= the name of the image sequence up to the image numbers.  the
%for example: 'name_z'
%startim=number of first image in sequence. example: 1
%endim=number of last image in sequence. example: 20
%suffix=the channel suffix of desired images. example: '_c0002'

%stack= output of all images in x by y by z matrix

endim=numel(imfinfo([stackname '.tif']))/totchan;
startim=1;

startim=deschan+startim*totchan-totchan;
endim=deschan+endim*totchan-totchan;
j=1;
for i=startim:totchan:endim
    
    

stack(:,:,j)=imread([stackname '.tif'], 'index', i);


    j=j+1;
    
end;

end
function [imstksm]=smooth3D(imstk, x1, y1, z1)
%outputs a 3-D smoothed stack in identical format
%imstk=stack of incoming images  (x by y by z)
%x1=diamteter of cell in x direction  (usually 9)
%y1=diameter of cell in y direction (usually 9)
%z1=diameter of cell in z direction (usually 3)


imstk8=uint8(imstk);



%smooths%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%diskfilter:
%smoothdapi8=imfilter(dapi8, fspecial('disk', radius));

h = fspecial3_mod('gaussian', [x1,y1,z1],[x1,y1,z1]);   %generates a 3-D kernel

imstksm=imfilter(imstk,h);   %filers in 3-D
end
function [maximaintclean, fragall, fragconc, coloroverlay]=maxima3D(smoothdapi, p,iinfo)
%outputs maximas from a 3-D matlab image
%the main OUTPUT:
%maximaintclean= a matrix output of the maxima coordinates in
%[x1,y1;xy,y2;,x3,y3;...] format
%
%other outputs (not used except for troubleshooting)
%fragall=all of the maxima that were closer together than 'dist'
%fragconc=the maxima after they are combined into a single averaged point
%coloroverlay: 2D slices showing the gaussian smoothed images with
%centerpoints highlighted in purple
%
% INPUT
%smoothdapi=stack of greyscale images  (x by y by z array)
%noisemax=maxima below this threshhold will be flattenned (imhmax()) (usually 10)
%noisemin=minima less than this value are eliminated using (imhmin()) (usually 10)
%pix=number of pixels in xy direction (usually 1024)
%dist=2 nuclei closer than this in pixels will be combined  (usually 6)
%showimage:determines whether to show the images or not  (0=no, 1=yes)
%x1, y1, z1 size of disk in pixels for display purposes.  2/3 of the entered x and y used.
%note: z1 has been locked at 1


%% load parameters
noisemin=p.id_noisemin;
noisemax=p.id_noisemax;
dist=p.id_dist;
showimage=p.id_showimage;
saveim=p.id_saveim;
x1=p.id_x1;
y1=p.id_y1;
z1=p.id_z1;
zxyratio=3.2051;          %ratio over distance in z direction per pixel over distance in xy per pixel (3.97 is for 2.2 um z slices)
fragconc=[];
fragall=[];
maximaintclean=[];


%% Convert image 16bit intensity(0-65535) into 0-256
if max(max(max(smoothdapi)))>500
    smoothdapi8=double(smoothdapi)/65535*256;
else
    smoothdapi8=uint8(smoothdapi);
end


%% finds maximas(centroids) and puts the into the format [x1,y1,z1;x2,y2,z2;x3,y3,z3...]
% -- use H-min, H-max and imregionalmax to define possible nuclei
blobmax=imhmin(smoothdapi8, noisemin);      % Local min + 10
blobmax=imhmax(blobmax, noisemax);          % Local max -10
blobmax=imregionalmax(blobmax);             % Find local max
sharpmax=bwulterode(blobmax);               % Ultimate erosion

% -- finds middle of each maxima cluster
maximas=regionprops(sharpmax, 'Centroid');  % maximas: Nx1 struct, call using maximas(1).Centroid = [x,y,z] 

% -- converts structured array to numerical
maximacell=struct2cell(maximas);
maximamat=cell2mat(maximacell);
maximanum=ctranspose(reshape(maximamat,3,[]));       %turns [x1,y1,x2,y2,x3,y3...]-->[x1,x2,x3;y1,y2,y3...]-->[x1,y1;x2,y2;x3,y3...]   
maximaint=round(maximanum);                         %'maximaint is a rounded version of maximanum for purposes of points = [x1,y1,z1;x2,y2,z2;x3,y3,z3...]


%% This sections combines maxima that are too close to each other
% -- identifies any points closer than 'dist' to each other
for i=1:size(maximanum, 1)        % loops i from 2 to the bottom of the zview input matrix, marking the row.
    xvalue=maximanum(i,1);
    yvalue=maximanum(i,2);
    Zvalue=maximanum(i,3);
    
    % -- distance from this point to all other points
    testdist= ((maximanum(:,1)- xvalue).^2 + (maximanum(:,2)- yvalue).^2+((maximanum(:,3)- Zvalue).*zxyratio).^2).^.5 ;     % subtracts these values from the entire corresponding zyx columns from the xview     
    nucrow=[];
    [nucrow, ~]=find(abs(testdist)<dist );          %finds any rows in the incoming column whos xy distance is less than 'dist' away from the point in question
    
    % -- records all maxima that did not have any other maxima closer than 'dist'
    if numel(nucrow) <= 1                           
        maximaintin=maximaint(i,:);
        maximaintclean=cat(1,maximaintclean,maximaintin);
    end;
    
    % -- this row records all nuclei that were closer together than dist
    if numel(nucrow) > 1                            
        fragin=maximaint(i,:);
        fragall=cat(1,fragall,fragin);
    end;
end;


%% combines points identified in previous step as being too close.  averages them and makes a single point
if numel(fragall)>0   
    fragsort=sortrows(fragall);

    for u=1:size(fragsort,1)
        testdist2= ((fragsort(:,1)-fragsort(u,1) ).^2 + (fragsort(:,2)-fragsort(u,2)).^2+((fragsort(:,3)-fragsort(u,3)).*zxyratio).^2).^.5 ;     %subtracts these values from the entire corresponding zyx columns from the xview 
        nucrow2=[];
        [nucrow2, ~]=find(abs(testdist2)<dist );

        %fragsort(nucrow2, 3)=u;
        coprow=[];
        fragconcin=round(cat(2,mean(fragsort(nucrow2,1)), mean(fragsort(nucrow2,2)), mean(fragsort(nucrow2,3))));           %this makes the xy coordinates of any nuclei within the critical distance the average of those nuclei

        if u==1                                                                 %this if statement parsaes each member of the list and removes duplicates
            fragconc=cat(1, fragconc, fragconcin);              
        else
            [coprow, ~]=find(fragconc(:,1)==fragconcin(1,1) & fragconc(:,2)==fragconcin(1,2) & fragconc(:,3)==fragconcin(1,3));
            if isempty(coprow)==1
                fragconc=cat(1, fragconc, fragconcin);
            end
        end
    end
end
maximaintclean=cat(1,maximaintclean,fragconc);  %adds the combined points into the rest of the set


%% optional: Outputs centroids of image onto old image in color%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
currentim=uint8(zeros(iinfo.Height, iinfo.Width, size(smoothdapi8, 3)));   %creates new binary cube of all zeros
disksize=round(max(iinfo.Height, iinfo.Width)/1024*4);                 %specifies disk size relative to pixels
   
        for z=1:size(maximaintclean, 1)                              %takes image of 0s and makes maximas 255
             currentim(maximaintclean(z,2),maximaintclean(z,1), maximaintclean(z,3))=150;

        end;

        %dialimage=imdilate(currentim, strel('disk',disksize));              %dilates those maximas (labelled 255) to disks of 'disksize'
        z1=1;
        h = fspecial3_mod('ellipsoid', [round(x1*2/3),round(y1*2/3),z1]);

        dialimage=imfilter(currentim,h);
        dialimage=dialimage.*64;
        %coloroverlay=uint8(zeros(pix, pix, 3*size(smoothdapi8, 3)));
        %colorlist=cat(3,dialimage,smoothdapi8, smoothdapi8);
        coloroverlay=[];
        coloroverlay=dialimage(:,:,1);
        coloroverlay=cat(3, coloroverlay, smoothdapi8(:,:,1));
        coloroverlay=cat(3, coloroverlay, smoothdapi8(:,:,1));
        
        for u=2:size(smoothdapi8, 3)
            %overlays maxima onto original and displays
            coloroverlay=cat(3,coloroverlay, dialimage(:,:,u));
            coloroverlay=cat(3, coloroverlay, smoothdapi8(:,:,u));
            coloroverlay=cat(3, coloroverlay, smoothdapi8(:,:,u));

            
        end;
        
if showimage==1        
        
        for u=1:3:size(coloroverlay, 3)
            figure(round(u/3)+1)
            imshow(coloroverlay(:,:,u:u+2))
            if saveim==1
                        saveas(figure(round(u/3)+1), ['slice ' num2str(round(u/3)+1) 'maximas.jpg'])
            end;
                close(figure(round(u/3)+1))
        end;
end;


end
function [xyzintensities]=intensityfinder3D(imagein, xyzcoordinatein, x1, y1, z1)

%imagein= the NON smoothed NON normalized raw image
%xycoordinatesin= the xy coordinates of every nuclei point to be measured
%in [x1,y1;x2,y2;x3,y3;...] format
%x1, y1, z1= the diameter in the x direction, y direction, and z direction
%of a given ellipsoid
%note 6.6.12: z1 is set to 1 for all instances currently
z1=3;

nucnum=size(xyzcoordinatein, 1);

h2 = fspecial3_mod('ellipsoid',[round(x1*2/3),round(y1*2/3),z1]);

smoothimage=imfilter(imagein, h2);

xyintensitiestemp=zeros(nucnum,1);

for i=1:nucnum
    xcur=xyzcoordinatein(i,1);
    ycur=xyzcoordinatein(i,2);
    zcur=xyzcoordinatein(i,3);
    
    xyintensitiestemp(i,1)=smoothimage(ycur,xcur, zcur);
    
end;

xyzintensities=cat(2, xyzcoordinatein, xyintensitiestemp);
    
    




end
function h = fspecial3_mod(type,siz,siz2)
%FSPECIAL3 Create predefined 3-D filters.
%   H = FSPECIAL3(TYPE,SIZE) creates a 3-dimensional filter H of the
%   specified type and size. Possible values for TYPE are:
%
%     'average'    averaging filter
%     'ellipsoid'  ellipsoidal averaging filter
%     'gaussian'   Gaussian lowpass filter
%     'laplacian'  Laplacian operator
%     'log'        Laplacian of Gaussian filter
%
%   The default SIZE is [5 5 5]. If SIZE is a scalar then H is a 3D cubic
%   filter of dimension SIZE^3.
%
%   H = FSPECIAL3('average',SIZE) returns an averaging filter H of size
%   SIZE. SIZE can be a 3-element vector specifying the dimensions in
%   H or a scalar, in which case H is a cubic array.
%
%   H = FSPECIAL3('ellipsoid',SIZE) returns an ellipsoidal averaging filter.
%
%   H = FSPECIAL3('gaussian',SIZE) returns a centered Gaussian lowpass
%   filter of size SIZE with standard deviations defined as
%   SIZE/(4*sqrt(2*log(2))) so that FWHM equals half filter size
%   (http://en.wikipedia.org/wiki/FWHM). Such a FWHM-dependent standard
%   deviation yields a congruous Gaussian shape (what should be expected
%   for a Gaussian filter!).
%
%   H = FSPECIAL3('laplacian') returns a 3-by-3-by-3 filter approximating
%   the shape of the three-dimensional Laplacian operator. REMARK: the
%   shape of the Laplacian cannot be adjusted. An infinite number of 3D
%   Laplacian could be defined. If you know any simple formulation allowing
%   one to control the shape, please contact me.
%
%   H = FSPECIAL3('log',SIZE) returns a rotationally symmetric Laplacian of
%   Gaussian filter of size SIZE with standard deviation defined as
%   SIZE/(4*sqrt(2*log(2))).
%
%   Class Support
%   -------------
%   H is of class double.
%
%   Example
%   -------
%      I = single(rand(80,40,20));
%      h = fspecial3('gaussian',[9 5 3]); 
%      Inew = imfilter(I,h,'replicate');
%       
%   See also IMFILTER, FSPECIAL.
%
%   -- Damien Garcia -- 2007/08

type = lower(type);

if nargin==1
        siz = 5;
end

if numel(siz)==1
    siz = round(repmat(siz,1,3));
elseif numel(siz)~=3
    error('Number of elements in SIZ must be 1 or 3')
else
    siz = round(siz(:)');
end

switch type
    
    case 'average'
        h = ones(siz)/prod(siz);
        
    case 'gaussian'
        sig = siz2/(4*sqrt(2*log(2)));
        siz   = (siz-1)/2;
        [x,y,z] = ndgrid(-siz(1):siz(1),-siz(2):siz(2),-siz(3):siz(3));
        h = exp(-(x.*x/2/sig(1)^2 + y.*y/2/sig(2)^2 + z.*z/2/sig(3)^2));
        h = h/sum(h(:));
        
    case 'ellipsoid'
        R = siz/2;
        R(R==0) = 1;
        h = ones(siz);
        siz = (siz-1)/2;
        [x,y,z] = ndgrid(-siz(1):siz(1),-siz(2):siz(2),-siz(3):siz(3));
        I = (x.*x/R(1)^2+y.*y/R(2)^2+z.*z/R(3)^2)>1;
        h(I) = 0;
        h = h/sum(h(:));
        
    case 'laplacian'
        h = zeros(3,3,3);
        h(:,:,1) = [0 3 0;3 10 3;0 3 0];
        h(:,:,3) = h(:,:,1);
        h(:,:,2) = [3 10 3;10 -96 10;3 10 3];
        
    case 'log'
        sig = siz/(4*sqrt(2*log(2)));
        siz   = (siz-1)/2;
        [x,y,z] = ndgrid(-siz(1):siz(1),-siz(2):siz(2),-siz(3):siz(3));
        h = exp(-(x.*x/2/sig(1)^2 + y.*y/2/sig(2)^2 + z.*z/2/sig(3)^2));
        h = h/sum(h(:));
        arg = (x.*x/sig(1)^4 + y.*y/sig(2)^4 + z.*z/sig(3)^4 - ...
            (1/sig(1)^2 + 1/sig(2)^2 + 1/sig(3)^2));
        h = arg.*h;
        h = h-sum(h(:))/prod(2*siz+1);
        
    otherwise
        error('Unknown filter type.')
        
end
end
function lsmconvert(p)
%clear all

%% Parameter setting: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


file_num_temp=[];file_name_temp=[];  %[fix 0330]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
if isa(p.lf_name,'char') && strcmp(p.lf_name(end-3:end),'.xls')
    list_name = p.lf_name;
    [num_list, folder_list] = xlsread(list_name);
    num_list = []; folder_list = []
    if ismac||isunix
        folder_list = strrep(folder_list, '\', '/');
    elseif ispc
        folder_list = strrep(folder_list, '/', '\');
    end
    folder_list = folder_list(strcmpi('T',folder_list(:,6)),:);
elseif isa(p.lf_name,'cell')
    folder_list = p.lf_name;
else
    error('Incorrect input!')
end
[N1,N2] = size(folder_list);

for list_I = 1:N1
    input_folder = folder_list{list_I,1};
    if isempty(folder_list{list_I,2})
        match_list = [];
    else
        match_list = eval(folder_list{list_I,2});
    end
    all_channel = eval(folder_list{list_I,3});
    DAPI_channel = all_channel(1);
    WGA_channel = all_channel(2);
    signal1_channel = all_channel(3);
    signal2_channel = all_channel(4);
    if length(all_channel) > 4
        signal3_channel = all_channel(5:end);
    else
        signal3_channel = zeros(1);
    end
    match_channel = WGA_channel;
    all_other = eval(folder_list{list_I,4});
    Nbin = all_other(1);
    Mdim = all_other(2);
    
%% LSM file loading/resave: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    lsm_name = dir([input_folder,p.lsm_type]);
    if exist([input_folder,p.out_folder_stack]) ~= 7
        mkdir([input_folder,p.out_folder_stack]);
    end

    file_name = cell(length(lsm_name),2);
    file_num = zeros(length(lsm_name),12);
    output_I = 0;
    output_switch = false;

    for I_file = 1:length(lsm_name)   % for each *.tiff images in /stack folder
        input_name = lsm_name(I_file).name;
        lsm_stack = tiffread([input_folder,input_name]); %%% Lsm file loading
        if lsm_stack(1).bits==8
            lsm_stack=convert8to16lsm(lsm_stack);   % convert unit8 lsm into unit16 lsm
        end
        pack_num = 1;
        stack_num = 0;
        bin_num = 0;
        if  ~isempty(strfind(input_name,p.match_key))
            bin_size = Nbin*2-1+(Nbin == 1);
        else
            bin_size = 1;
        end
        if ~(ismember(input_name(find(input_name == '.',1,'last')-1),'Bb') && input_name(find(input_name == '.',1,'last')-2) == '_')
            output_I = output_I+1;
        end
        
        while stack_num(end) < length(lsm_stack)
            bin_num = bin_num+1;
            pack_num = pack_num+(bin_num > bin_size);
            output_I = output_I+(bin_num > bin_size);
            bin_num = mod(bin_num,bin_size);
            if bin_num == 0
                bin_num = bin_size;
            end
            stack_num = stack_num(end)+[1:lsm_stack(stack_num(end)+1).lsm.DimensionZ];
            
    %%% Output folder setup: %%% ------------------------------------------
            if  bin_size*lsm_stack(1).lsm.DimensionZ >= length(lsm_stack)
                pack_name = '';
            else
                pack_name = ['_',num2str(pack_num,'%03u')];
            end
            if ~isempty(strfind(input_name,p.match_key))
                match_name = ['_',char('B'-mod(bin_num,2))];
            else
                match_name = '';
            end
            if ismac||isunix
                output_name = [input_name(1:(find(input_name == '.',1,'last')-1)),pack_name,match_name,'/'];
            elseif ispc
                output_name = [input_name(1:(find(input_name == '.',1,'last')-1)),pack_name,match_name,'\'];
            end
            if exist([input_folder,p.out_folder_stack,output_name]) ~= 7
                mkdir([input_folder,p.out_folder_stack,output_name]);
            end
    %%% -------------------------------------------------------------------
    
            for I_layer = stack_num
                stack_raw = lsm_stack(I_layer).data;    % stack_raw: 4 channel tiff images
                tiff_image = zeros(0);
                if iscell(stack_raw)
                    for I_color = 1:length(stack_raw)
                        tiff_image = cat(3,tiff_image,stack_raw{I_color});
                    end
                else
                    tiff_image = stack_raw;
                end
                
                if size(tiff_image,3) == 1
                    tiff_image(:,:,2) = tiff_image(:,:,1);
                end
                if size(tiff_image,3) == 2
                    tiff_image(:,:,3) = tiff_image(:,:,2);
                end
    %%% Image output: %%% -------------------------------------------------
                if length(lsm_stack) > 1
                    out_num = num2str(I_layer-stack_num(1)+1,'%02u');
                else
                    out_num = '';
                end
                out_stack = [p.tif_name,out_num,p.figure_tail_tif];
                if bin_num <= 2
                    imwrite(tiff_image,[input_folder,p.out_folder_stack,output_name,out_stack]);
                else
                    temp_old = imread([input_folder,p.out_folder_stack,output_name,out_stack]);
                    tiff_image = cat(Mdim,temp_old,tiff_image);
                    imwrite(tiff_image,[input_folder,p.out_folder_stack,output_name,out_stack]);
                end
    %%% -------------------------------------------------------------------
            end
    
%%% matchlist.xls output: %%%==============================================
            if ismember(output_name(length(output_name)-1),'Bb') && output_name(length(output_name)-2) == '_'
                output_switch = true;
            else
                output_switch = false;
            end
            file_name{output_I,output_switch+1} = output_name;
            %match_layer = ceil(length(lsm_stack)/2);
            if isempty(match_list)
                match_layer = 1;
            else
                match_layer = match_list(output_I);
            end
            resolution = lsm_stack(1).lsm.VoxelSizeX/(1e-6);
            resolutionz = lsm_stack(1).lsm.VoxelSizeZ/(1e-6);
            file_num(output_I,:) = [match_layer,Nbin,Mdim,match_channel,p.compare_ratio,WGA_channel,DAPI_channel,signal1_channel,resolution,signal2_channel,resolutionz,signal3_channel];
%%% =======================================================================
        end
    end
%}
    
    %file_num(strmatch(else_name,{lsm_name.name}),:) = [match_layer,eNbin,eMdim,eWGA_channel,p.compare_ratio,eWGA_channel,eDAPI_channel,esignal_channel,resolution];
    %xlswrite([input_folder,p.out_folder_stack,match_file],cat(2,file_name,num2cell(file_num)));
    %[fix] replace xls file as mat(158-160)
    num_id={'match_layer','Nbin','Mdim','match_channel','p.compare_ratio','WGA_channel','DAPI_channel','signal1_channel','resolution','signal2_channel','resolutionz','signal3_channel'};
    %num_listm=[num_listm;[zeros(size(file_num,1),size(file_name,2)) file_num]];
    file_num_temp=[file_num_temp;file_num];file_name_temp=[file_name_temp;file_name];

%end
    file_num=file_num_temp;file_name=file_name_temp;
    eval(['save(''' p.lf_name '.mat'',''num_list'',''folder_list'',''num_id'');'])
    save([input_folder,p.out_folder_stack,p.match_file],'file_num','file_name');
  
end
function lsm_stack = readlsm(lsmfile)

tiff_info = imfinfo(lsmfile);
for i=1:size(tiff_info,1)/2
    
    lsm_stack(i).filename = tiff_info(2*i-1).Filename;
    lsm_stack(i).width = tiff_info(2*i-1).Width;
    lsm_stack(i).height = tiff_info(2*i-1).Height;
    lsm_stack(i).bits = tiff_info(2*i-1).BitsPerSample(1);
    stackdata = imread(lsmfile,2*i-1);
    for j=1:size(stackdata,3)
        lsm_stack(i).data = stackdata(:,:,j);
    end
    lsm_stack(i).lsm.VoxelSizeX = 1.0982e-07;
    lsm_stack(i).lsm.VoxelSizeZ = 1.0982e-07;
end

end
function lsm_stack = readlsm_tif(lsmfile)

tiff_info = imfinfo(lsmfile);
m = size(imread(lsmfile,1),3);
k=1;
for i=1:size(tiff_info,1)
    for j=1:m
        lsm_stack(k).filename = tiff_info(i).Filename;
        lsm_stack(k).width = tiff_info(i).Width;
        lsm_stack(k).height = tiff_info(i).Height;
        lsm_stack(k).bits = tiff_info(i).BitsPerSample(1);
        stackdata = imread(lsmfile,i);
        lsm_stack(k).data = stackdata(:,:,j);
        lsm_stack(k).lsm.VoxelSizeX = 1.0982e-07;
        lsm_stack(k).lsm.VoxelSizeZ = 1.0982e-07;
        k=k+1;
    end
end

end
function lsm_stack = readlsm_p(lsmfile)
xrange = 3301:4300;yrange=4701:5700;
%xrange = 3201:3600;yrange=4101:4500;

tiff_info = imfinfo(lsmfile);
for i=1:size(tiff_info,1)/2
    
    lsm_stack(i).filename = tiff_info(2*i-1).Filename;
    lsm_stack(i).width = length(xrange); %tiff_info(2*i-1).Width;
    lsm_stack(i).height = length(yrange); %tiff_info(2*i-1).Height;
    lsm_stack(i).bits = tiff_info(2*i-1).BitsPerSample(1);
    stackdata = imread(lsmfile,2*i-1);
    for j=1:size(stackdata,3)
        lsm_stack(i).data{1,j} = stackdata(xrange,yrange,j);
    end
    lsm_stack(i).lsm.VoxelSizeX = 1.0982e-07;
    lsm_stack(i).lsm.VoxelSizeZ = 1.0982e-07;
end

end
function stack = tiffread(filename, indices)

% tiffread, version 2.9 May 10, 2010
%
% stack = tiffread;
% stack = tiffread(filename);
% stack = tiffread(filename, indices);
%
% Reads 8,16,32 bits uncompressed grayscale and (some) color tiff files,
% as well as stacks or multiple tiff images, for example those produced
% by metamorph, Zeiss LSM or NIH-image.
%
% The function can be called with a file name in the current directory,
% or without argument, in which case it pops up a file opening dialog
% to allow for a manual selection of the file.
% If the stacks contains multiples images, reading can be restricted by
% specifying the indices of the desired images (eg. 1:5), or just one index (eg. 2).
%
% The returned value 'stack' is a vector struct containing the images 
% and their meta-data. The length of the vector is the number of images.
% The image pixels values are stored in a field .data, which is a simple
% matrix for gray-scale images, or a cell-array of matrices for color images.
%
% The pixels values are returned in their native (usually integer) format,
% and must be converted to be used in most matlab functions.
%
% Example:
% im = tiffread('spindle.stk');
% imshow( double(im(5).data) );
%
% Only a fraction of the TIFF standard is supported, but you may extend support
% by modifying this file. If you do so, please return your modification to us,
% such that the added functionality can be redistributed to everyone.
%
% Copyright (C) 1999-2010 Francois Nedelec, 
% with contributions from:
%   Kendra Burbank for the waitbar
%   Hidenao Iwai for the code to read floating point images,
%   Stephen Lang to be more compliant with PlanarConfiguration
%   Jan-Ulrich Kreft for Zeiss LSM support
%   Elias Beauchanp and David Kolin for additional Metamorph support
%   Jean-Pierre Ghobril for requesting that image indices may be specified
%   Urs Utzinger for the better handling of color images, and LSM meta-data
%   O. Scott Sands for support of GeoTIFF tags
%   
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details:
% <http://www.gnu.org/licenses/>.
%
% Francois Nedelec
% nedelec (at) embl.de
% Cell Biology and Biophysics, EMBL; Meyerhofstrasse 1; 69117 Heidelberg; Germany
% http://www.embl.org
% http://www.cytosim.org
warning off;



%Optimization: join adjacent TIF strips: this results in faster reads
consolidateStrips = 1;

%without argument, we ask the user to choose a file:
if nargin < 1
    [filename, pathname] = uigetfile('*.tif;*.stk;*.lsm', 'select image file');
    filename = [ pathname, filename ];
end

if (nargin<=1);  indices = 1:10000; end


% not all valid tiff tags have been included, as they are really a lot...
% if needed, tags can easily be added to this code
% See the official list of tags:
% http://partners.adobe.com/asn/developer/pdfs/tn/TIFF6.pdf
%
% the structure IMG is returned to the user, while TIF is not.
% so tags usefull to the user should be stored as fields in IMG, while
% those used only internally can be stored in TIF.

global TIF;
TIF = [];

%counters for the number of images read and skipped
img_skip  = 0;
img_read  = 1;
hWaitbar  = [];

%% set defaults values :
TIF.SampleFormat     = 1;
TIF.SamplesPerPixel  = 1;
TIF.BOS              = 'ieee-le';          %byte order string

if  isempty(findstr(filename,'.'))
    filename = [filename,'.tif'];
end

TIF.file = fopen(filename,'r','l');
if TIF.file == -1
    stkname = strrep(filename, '.tif', '.stk');
    TIF.file = fopen(stkname,'r','l');
    if TIF.file == -1
        error(['File "',filename,'" not found.']);
    else
        filename = stkname;
    end
end
[s, m] = fileattrib(filename);

% obtain the full file path:
filename = m.Name;

% find the file size in bytes:
% m = dir(filename);
% filesize = m.bytes;


%% read header
% read byte order: II = little endian, MM = big endian
byte_order = fread(TIF.file, 2, '*char');
if ( strcmp(byte_order', 'II') )
    TIF.BOS = 'ieee-le';                                % Intel little-endian format
elseif ( strcmp(byte_order','MM') )
    TIF.BOS = 'ieee-be';
else
    error('This is not a TIFF file (no MM or II).');
end


%% ---- read in a number which identifies file as TIFF format
tiff_id = fread(TIF.file,1,'uint16', TIF.BOS);
if (tiff_id ~= 42)
    error('This is not a TIFF file (missing 42).');
end

%% ---- read the byte offset for the first image file directory (IFD)
TIF.img_pos = fread(TIF.file, 1, 'uint32', TIF.BOS);

while  TIF.img_pos ~= 0 

    clear IMG;
    IMG.filename = filename;
    % move in the file to the first IFD
    status = fseek(TIF.file, TIF.img_pos, -1);
    if status == -1
        error('invalid file offset (error on fseek)');
    end

    %disp(strcat('reading img at pos :',num2str(TIF.img_pos)));

    %read in the number of IFD entries
    num_entries = fread(TIF.file,1,'uint16', TIF.BOS);
    %disp(strcat('num_entries =', num2str(num_entries)));

    %read and process each IFD entry
    for i = 1:num_entries

        % save the current position in the file
        file_pos  = ftell(TIF.file);

        % read entry tag
        TIF.entry_tag = fread(TIF.file, 1, 'uint16', TIF.BOS);
        % read entry
        entry = readIFDentry;
        %disp(strcat('reading entry <',num2str(TIF.entry_tag),'>'));

        switch TIF.entry_tag
            case 254
                TIF.NewSubfiletype = entry.val;
            case 256         % image width - number of column
                IMG.width          = entry.val;
            case 257         % image height - number of row
                IMG.height         = entry.val;
                TIF.ImageLength    = entry.val;
            case 258         % BitsPerSample per sample
                TIF.BitsPerSample  = entry.val;
                TIF.BytesPerSample = TIF.BitsPerSample / 8;
                IMG.bits           = TIF.BitsPerSample(1);
                %fprintf('BitsPerSample %i %i %i\n', entry.val);
            case 259         % compression
                if ( entry.val ~= 1 )
                    error(['Compression format ', num2str(entry.val),' not supported.']);
                end
            case 262         % photometric interpretation
                TIF.PhotometricInterpretation = entry.val;
                if ( TIF.PhotometricInterpretation == 3 )
                    warning('tiffread2:LookUp', 'Ignoring TIFF look-up table');
                end
            case 269
                IMG.document_name  = entry.val;
            case 270         % comments:
                IMG.info           = entry.val;
            case 271
                IMG.make           = entry.val;
            case 273         % strip offset
                if ~exist('previous_offset','var')
                    previous_offset = zeros(size(entry.val));
                    current_offset = zeros(size(entry.val));
                    wrap_offset = zeros(size(entry.val));
                end
                current_offset = entry.val;

                if ~exist('stack','var') || (IMG.width == stack(1).width && IMG.height == stack(1).height)
                    wrap_offset = wrap_offset+2^32.*(current_offset < previous_offset);
                    previous_offset = entry.val;
                    TIF.StripOffsets   = current_offset+wrap_offset;
                else
                    TIF.StripOffsets   = current_offset;
                end

                TIF.StripNumber    = entry.cnt;
                %fprintf('StripNumber = %i, size(StripOffsets) = %i %i\n', TIF.StripNumber, size(TIF.StripOffsets));
            case 277         % sample_per pixel
                TIF.SamplesPerPixel  = entry.val;
                %fprintf('Color image: sample_per_pixel=%i\n',  TIF.SamplesPerPixel);
            case 278         % rows per strip
                TIF.RowsPerStrip   = entry.val;
            case 279         % strip byte counts - number of bytes in each strip after any compressio
                TIF.StripByteCounts= entry.val;
            case 282         % X resolution
                IMG.x_resolution   = entry.val;
            case 283         % Y resolution
                IMG.y_resolution   = entry.val;
            case 284         %planar configuration describe the order of RGB
                TIF.PlanarConfiguration = entry.val;
            case 296         % resolution unit
                IMG.resolution_unit= entry.val;
            case 305         % software
                IMG.software       = entry.val;
            case 306         % datetime
                IMG.datetime       = entry.val;
            case 315
                IMG.artist         = entry.val;
            case 317        %predictor for compression
                if (entry.val ~= 1); error('unsuported predictor value'); end
            case 320         % color map
                IMG.cmap           = entry.val;
                IMG.colors         = entry.cnt/3;
            case 339
                TIF.SampleFormat   = entry.val;
            case 33550       % GeoTIFF ModelPixelScaleTag
                IMG.ModelPixelScaleTag    = entry.val;
            case 33628       %metamorph specific data
                IMG.MM_private1    = entry.val;
            case 33629       %this tag identify the image as a Metamorph stack!
                TIF.MM_stack       = entry.val;
                TIF.MM_stackCnt    = entry.cnt;
            case 33630       %metamorph stack data: wavelength
                TIF.MM_wavelength  = entry.val;
            case 33631       %metamorph stack data: gain/background?
                TIF.MM_private2    = entry.val;
            case 33922       % GeoTIFF ModelTiePointTag
                IMG.ModelTiePointTag    = entry.val;
            case 34412       % Zeiss LSM data
                LSM_info           = entry.val;
            case 34735       % GeoTIFF GeoKeyDirectory
                IMG.GeoKeyDirTag       = entry.val;
            case 34737       % GeoTIFF GeoASCIIParameters
                IMG.GeoASCII       = entry.val;
            case 42113       % GeoTIFF GDAL_NODATA
                IMG.GDAL_NODATA    = entry.val;
            otherwise
                fprintf( 'Ignored TIFF entry with tag %i (cnt %i)\n', TIF.entry_tag, entry.cnt);
        end
        
        % calculate bounding box  if you've got the stuff
        if isfield(IMG, 'ModelPixelScaleTag') && isfield(IMG, 'ModelTiePointTag') && isfield(IMG, 'height')&& isfield(IMG, 'width'),
            IMG.North=IMG.ModelTiePointTag(5)-IMG.ModelPixelScaleTag(2)*IMG.ModelTiePointTag(2);
            IMG.South=IMG.North-IMG.height*IMG.ModelPixelScaleTag(2);
            IMG.West=IMG.ModelTiePointTag(4)+IMG.ModelPixelScaleTag(1)*IMG.ModelTiePointTag(1);
            IMG.East=IMG.West+IMG.width*IMG.ModelPixelScaleTag(1);
        end

        % move to next IFD entry in the file
        status = fseek(TIF.file, file_pos+12, -1);
        if status == -1
            error('invalid file offset (error on fseek)');
        end
    end

    %Planar configuration is not fully supported
    %Per tiff spec 6.0 PlanarConfiguration irrelevent if SamplesPerPixel==1
    %Contributed by Stephen Lang
    if (TIF.SamplesPerPixel ~= 1) && ( ~isfield(TIF, 'PlanarConfiguration') || TIF.PlanarConfiguration == 1 )
        error('PlanarConfiguration = 1 is not supported');
    end

    %total number of bytes per image:
    PlaneBytesCnt = IMG.width * IMG.height * TIF.BytesPerSample;

    %% try to consolidate the TIFF strips if possible
    
    if consolidateStrips
        %Try to consolidate the strips into a single one to speed-up reading:
        BytesCnt = TIF.StripByteCounts(1);

        if BytesCnt < PlaneBytesCnt

            ConsolidateCnt = 1;
            %Count how many Strip are needed to produce a plane
            while TIF.StripOffsets(1) + BytesCnt == TIF.StripOffsets(ConsolidateCnt+1)
                ConsolidateCnt = ConsolidateCnt + 1;
                BytesCnt = BytesCnt + TIF.StripByteCounts(ConsolidateCnt);
                if ( BytesCnt >= PlaneBytesCnt ); break; end
            end

            %Consolidate the Strips
            if ( BytesCnt <= PlaneBytesCnt(1) ) && ( ConsolidateCnt > 1 )
                %fprintf('Consolidating %i stripes out of %i', ConsolidateCnt, TIF.StripNumber);
                TIF.StripByteCounts = [BytesCnt; TIF.StripByteCounts(ConsolidateCnt+1:TIF.StripNumber ) ];
                TIF.StripOffsets = TIF.StripOffsets( [1 , ConsolidateCnt+1:TIF.StripNumber] );
                TIF.StripNumber  = 1 + TIF.StripNumber - ConsolidateCnt;
            end
        end
    end

    %% read the next IFD address:
    TIF.img_pos = fread(TIF.file, 1, 'uint32', TIF.BOS);
    %if (TIF.img_pos) disp(['next ifd at', num2str(TIF.img_pos)]); end

    if isfield( TIF, 'MM_stack' )

        sel = ( indices <= TIF.MM_stackCnt );
        indices = indices(sel);
        
        if numel(indices) > 1
            hWaitbar = waitbar(0,'Reading images...','Name','TiffRead');
        end

        %this loop reads metamorph stacks:
        for ii = indices

            TIF.StripCnt = 1;
            offset = PlaneBytesCnt * (ii-1);

            %read the image channels
            for c = 1:TIF.SamplesPerPixel
                IMG.data{c} = read_plane(offset, IMG.width, IMG.height, c);
            end

            % print a text timer on the main window, or update the waitbar
            % fprintf('img_read %i img_skip %i\n', img_read, img_skip);
            if ~isempty( hWaitbar )
                waitbar(img_read/numel(indices), hWaitbar);
            end
            
            [ IMG.MM_stack, IMG.MM_wavelength, IMG.MM_private2 ] = splitMetamorph(ii);
            
            stack(img_read) = IMG;
            img_read = img_read + 1;

        end
        break;

    else

        %this part reads a normal TIFF stack:
        
        read_img = any( img_skip+img_read == indices );
        if exist('stack','var')
            if IMG.width ~= stack(1).width || IMG.height ~= stack(1).height
                %setting read_it=0 will skip dissimilar images:
                %comment-out the line below to allow dissimilar stacks
                read_img = 0;
            end
        end
        
        if read_img
            TIF.StripCnt = 1;
            %read the image channels
            for c = 1:TIF.SamplesPerPixel
                IMG.data{c} = read_plane(0, IMG.width, IMG.height, c);
            end

            try
                stack(img_read) = IMG;  % = orderfields(IMG);
                img_read = img_read + 1;
            catch
                fprintf('Tiffread skipped dissimilar image %i\n', img_read+img_skip);
                img_skip = img_skip + 1;
             end
            
            if  all( img_skip+img_read > indices )
                break;
            end

        else
            img_skip = img_skip + 1;
        end

    end
end

%% remove the cell structure if there is always only one channel
flat = 1;
for i = 1:numel(stack)
    if numel(stack(i).data) ~= 1
        flat = 0;
        break;
    end
end

if flat
    for i = 1:numel(stack)
        stack(i).data = stack(i).data{1};
    end
end


%% distribute the MetaMorph info
if isfield(TIF, 'MM_stack') && isfield(IMG, 'info') && ~isempty(IMG.info)
    MM = parseMetamorphInfo(IMG.info, TIF.MM_stackCnt);
    for i = 1:numel(stack)
        stack(i).MM = MM(i);
    end
end

%% duplicate the LSM info
if exist('LSM_info', 'var')
    for i = 1:numel(stack)
        stack(i).lsm = LSM_info;
    end
end


%% return

if ~ exist('stack', 'var')
    stack = [];
end

%clean-up
fclose(TIF.file);
if ~isempty( hWaitbar )
    delete( hWaitbar );
end


end
function plane = read_plane(offset, width, height, plane_nb)

global TIF;

%return an empty array if the sample format has zero bits
if ( TIF.BitsPerSample(plane_nb) == 0 )
    plane=[];
    return;
end

%fprintf('reading plane %i size %i %i\n', plane_nb, width, height);

%determine the type needed to store the pixel values:
switch( TIF.SampleFormat )
    case 1
        classname = sprintf('uint%i', TIF.BitsPerSample(plane_nb));
    case 2
        classname = sprintf('int%i', TIF.BitsPerSample(plane_nb));
    case 3
        if ( TIF.BitsPerSample(plane_nb) == 32 )
            classname = 'single';
        else
            classname = 'double';
        end
    otherwise
        error('unsuported TIFF sample format %i', TIF.SampleFormat);
end

% Preallocate a matrix to hold the sample data:
try
    plane = zeros(width, height, classname);
catch
    %compatibility with older matlab versions:
    eval(['plane = ', classname, '(zeros(width, height));']);
end

% Read the strips and concatenate them:
line = 1;
while ( TIF.StripCnt <= TIF.StripNumber )

    strip = read_strip(offset, width, plane_nb, TIF.StripCnt, classname);
    TIF.StripCnt = TIF.StripCnt + 1;

    % copy the strip onto the data
    plane(:, line:(line+size(strip,2)-1)) = strip;

    line = line + size(strip,2);
    if ( line > height )
        break;
    end

end

% Extract valid part of data if needed
if ~all(size(plane) == [width height]),
    plane = plane(1:width, 1:height);
    warning('tiffread2:Crop','Cropping data: found more bytes than needed');
end

% transpose the image (otherwise display is rotated in matlab)
plane = plane';

end
function strip = read_strip(offset, width, plane_nb, stripCnt, classname)

global TIF;

%fprintf('reading strip at position %i\n',TIF.StripOffsets(stripCnt) + offset);
StripLength = TIF.StripByteCounts(stripCnt) ./ TIF.BytesPerSample(plane_nb);

%fprintf( 'reading strip %i\n', stripCnt);
status = fseek(TIF.file, TIF.StripOffsets(stripCnt) + offset, 'bof');
if status == -1
    error('invalid file offset (error on fseek)');
end

bytes = fread( TIF.file, StripLength, classname, TIF.BOS );

if any( length(bytes) ~= StripLength )
    error('End of file reached unexpectedly.');
end

strip = reshape(bytes, width, StripLength / width);

end
function [nbBytes, matlabType] = convertType(tiffType)
switch (tiffType)
    case 1
        nbBytes=1;
        matlabType='uint8';
    case 2
        nbBytes=1;
        matlabType='uchar';
    case 3
        nbBytes=2;
        matlabType='uint16';
    case 4
        nbBytes=4;
        matlabType='uint32';
    case 5
        nbBytes=8;
        matlabType='uint32';
    case 7
        nbBytes=1;
        matlabType='uchar';
    case 11
        nbBytes=4;
        matlabType='float32';
    case 12
        nbBytes=8;
        matlabType='float64';
    otherwise
        error('tiff type %i not supported', tiffType)
end
end
function  entry = readIFDentry()

global TIF;
entry.tiffType = fread(TIF.file, 1, 'uint16', TIF.BOS);
entry.cnt      = fread(TIF.file, 1, 'uint32', TIF.BOS);
%disp(['tiffType =', num2str(entry.tiffType),', cnt = ',num2str(entry.cnt)]);

[ entry.nbBytes, entry.matlabType ] = convertType(entry.tiffType);

if entry.nbBytes * entry.cnt > 4
    %next field contains an offset:
    offset = fread(TIF.file, 1, 'uint32', TIF.BOS);
    %disp(strcat('offset = ', num2str(offset)));
    status = fseek(TIF.file, offset, -1);
    if status == -1
        error('invalid file offset (error on fseek)');
    end

end


if TIF.entry_tag == 33629   % metamorph 'rationals'
    entry.val = fread(TIF.file, 6*entry.cnt, entry.matlabType, TIF.BOS);
elseif TIF.entry_tag == 34412  %TIF_CZ_LSMINFO
    entry.val = readLSMinfo;
else
    if entry.tiffType == 5
        entry.val = fread(TIF.file, 2*entry.cnt, entry.matlabType, TIF.BOS);
    else
        entry.val = fread(TIF.file, entry.cnt, entry.matlabType, TIF.BOS);
    end
end

if ( entry.tiffType == 2 );
    entry.val = char(entry.val');
end

end
function [MMstack, MMwavelength, MMprivate2] = splitMetamorph(imgCnt)

global TIF;

MMstack = [];
MMwavelength = [];
MMprivate2 = [];

if TIF.MM_stackCnt == 1
    return;
end

left  = imgCnt - 1;

if isfield( TIF, 'MM_stack' )
    S = length(TIF.MM_stack) / TIF.MM_stackCnt;
    MMstack = TIF.MM_stack(S*left+1:S*left+S);
end

if isfield( TIF, 'MM_wavelength' )
    S = length(TIF.MM_wavelength) / TIF.MM_stackCnt;
    MMwavelength = TIF.MM_wavelength(S*left+1:S*left+S);
end

if isfield( TIF, 'MM_private2' )
    S = length(TIF.MM_private2) / TIF.MM_stackCnt;
    MMprivate2 = TIF.MM_private2(S*left+1:S*left+S);
end

end
function mm = parseMetamorphInfo(info, cnt)

info   = regexprep(info, '\r\n|\o0', '\n');
parse  = textscan(info, '%s %s', 'Delimiter', ':');
tokens = parse{1};
values = parse{2};

first = char(tokens(1,1));

k = 0;
mm = struct('Exposure', zeros(cnt,1));
for i=1:size(tokens,1)
    tok = char(tokens(i,1));
    val = char(values(i,1));
    %fprintf( '"%s" : "%s"\n', tok, val);
    if strcmp(tok, first)
        k = k + 1;
    end
    if strcmp(tok, 'Exposure')
        [v, c, e, pos] = sscanf(val, '%i');
        unit = val(pos:length(val));
        %return the exposure in milli-seconds
        switch( unit )
            case 'ms'
                mm(k).Exposure = v;
            case 's'
                mm(k).Exposure = v * 1000;
            otherwise
                warning('tiffread2:Unit', ['Exposure unit "',unit,'" not recognized']);
                mm(k).Exposure = v;
        end
    else
        switch tok
            case 'Binning'
                % Binning: 1 x 1 -> [1 1]
                mm(k).Binning = sscanf(val, '%d x %d')';
            case 'Region'
                mm(k).Region = sscanf(val, '%d x %d, offset at (%d, %d)')';
            otherwise
                field  = regexprep(tok, ' ', '');
                if strcmp(val, 'Off')
                    eval(['mm(k).',field,'=0;']);
                elseif strcmp(val, 'On')
                    eval(['mm(k).',field,'=1;']);
                elseif isstrprop(val,'digit')
                    eval(['mm(k).',field,'=str2num(val)'';']);
                else
                    eval(['mm(k).',field,'=val;']);
                end
        end
    end
end

end
function R = readLSMinfo()

% Read part of the LSM info table version 2
% this provides only very partial information, since the offset indicate that
% additional data is stored in the file
global TIF;

R.MagicNumber            = sprintf('0x%09X',fread(TIF.file, 1, 'uint32', TIF.BOS));
StructureSize          = fread(TIF.file, 1, 'uint32', TIF.BOS);
R.DimensionX             = fread(TIF.file, 1, 'uint32', TIF.BOS);
R.DimensionY             = fread(TIF.file, 1, 'uint32', TIF.BOS);
R.DimensionZ             = fread(TIF.file, 1, 'uint32', TIF.BOS);
R.DimensionChannels      = fread(TIF.file, 1, 'uint32', TIF.BOS);
R.DimensionTime          = fread(TIF.file, 1, 'uint32', TIF.BOS);
R.IntensityDataType      = fread(TIF.file, 1, 'uint32', TIF.BOS);
R.ThumbnailX             = fread(TIF.file, 1, 'uint32', TIF.BOS);
R.ThumbnailY             = fread(TIF.file, 1, 'uint32', TIF.BOS);
R.VoxelSizeX             = fread(TIF.file, 1, 'float64', TIF.BOS);
R.VoxelSizeY             = fread(TIF.file, 1, 'float64', TIF.BOS);
R.VoxelSizeZ             = fread(TIF.file, 1, 'float64', TIF.BOS);
R.OriginX                = fread(TIF.file, 1, 'float64', TIF.BOS);
R.OriginY                = fread(TIF.file, 1, 'float64', TIF.BOS);
R.OriginZ                = fread(TIF.file, 1, 'float64', TIF.BOS);
R.ScanType               = fread(TIF.file, 1, 'uint16', TIF.BOS);
R.SpectralScan           = fread(TIF.file, 1, 'uint16', TIF.BOS);
R.DataType               = fread(TIF.file, 1, 'uint32', TIF.BOS);
OffsetVectorOverlay    = fread(TIF.file, 1, 'uint32', TIF.BOS);
OffsetInputLut         = fread(TIF.file, 1, 'uint32', TIF.BOS);
OffsetOutputLut        = fread(TIF.file, 1, 'uint32', TIF.BOS);
OffsetChannelColors    = fread(TIF.file, 1, 'uint32', TIF.BOS);
R.TimeInterval           = fread(TIF.file, 1, 'float64', TIF.BOS);
OffsetChannelDataTypes = fread(TIF.file, 1, 'uint32', TIF.BOS);
OffsetScanInformation  = fread(TIF.file, 1, 'uint32', TIF.BOS);
OffsetKsData           = fread(TIF.file, 1, 'uint32', TIF.BOS);
OffsetTimeStamps       = fread(TIF.file, 1, 'uint32', TIF.BOS);
OffsetEventList        = fread(TIF.file, 1, 'uint32', TIF.BOS);
OffsetRoi              = fread(TIF.file, 1, 'uint32', TIF.BOS);
OffsetBleachRoi        = fread(TIF.file, 1, 'uint32', TIF.BOS);
OffsetNextRecording    = fread(TIF.file, 1, 'uint32', TIF.BOS);

% There are more information stored in this table, which is not read here


%read real acquisition times:
if ( OffsetTimeStamps > 0 )
    
    status = fseek(TIF.file, OffsetTimeStamps, -1);
    if status == -1
        error('error on fseek');
    end
    
    StructureSize          = fread(TIF.file, 1, 'int32', TIF.BOS);
    NumberTimeStamps       = fread(TIF.file, 1, 'int32', TIF.BOS);
    for i=1:NumberTimeStamps
        R.TimeStamp(i)       = fread(TIF.file, 1, 'float64', TIF.BOS);
    end
    
    %calculate elapsed time from first acquisition:
    R.TimeOffset = R.TimeStamp - R.TimeStamp(1);
    
end


end
function lsm_new=convert8to16lsm(lsm_old)
[~,nmax]=size(lsm_old);
[~,chal_max]=size(lsm_old(1).data);
lsm_new=lsm_old;
for ni=1:nmax
    lsm_new(ni).bits=16;
    for chal=1:chal_max
        lsm_new(ni).data{1,chal} = im2uint16(lsm_old(ni).data{1,chal});
    end
end
end
function [totmean] = nucvsneigh(xyzintin)

totmean=[];

for i=1:max(xyzintin(:,4))
    [curow,~]=find(xyzintin(:,4)==i);
    curmean=mean(xyzintin(curow,3))/mean(xyzintin(curow,2));
    
    curmat=[i,curmean];
    totmean=cat(1, totmean, curmat);
end;

end

% step 3 sub functions
function [X, Y, b2] = CPD_preprocessing(X, Y, opti)

% CPD_preprocessing. Wei Dou 5/27/12.
% 3D rotation of zebrafish embryo nuclei position data before CPD rigid or affine registration. 
% CPD can only solve small-angle 3D rotions (< 5 degrees).
% this is for approximate alignment the orientation of the test embryo to the reference embryo
% in order to greatly decrease the rotation angles before CPD rotation estimation. 
% plane regression and rotation is used to eliminate the large angle around x and y axes.
% 0-360 z-axis rotation screening is used to approxiamate the rotation angle around z axis. 

p = mfilename('fullpath'); pathstr = fileparts(p);

disp('start x,y rotation preprocessing...'); tic;

for i=1:opti.maxNO
%-------------------Preprocessing: rotation to eliminate the large angle around x and y axes-----------------------
% Plane regression and plots. b = parameter values for Z = b(1) + b(2)*X + b(3)*Y (plane function).
    b1=plane_regression(X); % for X (test) set, b1 is the regression parameter set for test set plane function.
    b2=plane_regression(Y); % as above
 
    if opti.show && i==1       % plotting before preprocessing
       figure(1), plane_plot(X,b1,Y,b2); title('Before preprocessing(xy rotation)'); 
    end

% Translation of the two nuclei data sets (test and reference) based on that the two regression planes pass the origin point (0,0,0). 
          % This is to ensure that we obtain the unit vector (passing the origin point)
          % along the intercecting line of the two traslated regression planes (test and reference set).
    X(:,3) = X(:,3) - b1(1); 
    Y(:,3) = Y(:,3) - b2(1);

% Calculate the unit vector.
    [x, y, z] = unit_vector(b1, b2);

% Calculate the angle of the two regression planes.   b(2)*X + b(3)*Y - Z = -b(1)
    cosA = [b1(2), b1(3),-1]*[b2(2),b2(3),-1]'/((b1(2)^2+b1(3)^2+1)^0.5*(b2(2)^2+b2(3)^2+1)^0.5);
    alpha = acos(cosA);

% Rotation of the test set plane to the reference set plane, eliminating the large angle around x and y axes.
    r = pre_r(x, y, z, 2*pi-alpha);
    Y = Y*r';
    
    disp(['iteration = ' num2str(i) ', angle = ' num2str(alpha)]);
    
    if i==1, b12 = 0; end; b12 = b12 + b1(1);    
    
    if i==opti.maxNO || alpha<opti.limit, break; end;
end

disptime(toc);

X(:,3) = X(:,3) + b12;  b1(1) = b1(1) + b12; % restore traslation in z direction for X set.

if opti.show
   figure(2), plane_plot(X,b1,Y,b2);   
   title('After preprocessing_rotation(xy rotation)');
end

cd(pathstr);
end
function [dataoutput, R, CentPo] = dvplane(datainput, stk, parameters)

% dvplane.   Wei Dou 5/8/13.
% This function calculates the the Dorsal-Ventral Plane of an embryo using 
% 4D nuclei point data: (x, y, z, Psmad_Intensity). The 4D data is then
% rigidly rotated to make the DV plane overlap with x,z plane.
% After the D-V plane has been determined, Psmad Intensity Profiles can be
% extracted for statistical analyses.
% Plane regression to make the embryo regressed plane overlapp with the 
% x-y plane is a priority for this function.
% ---------------
% Rigidly rotated nuclei point data from plane regression is imported as a
% structure datainput.set1,..2,..3,..4,..... Each set includes a specific 
% embryo from a certain developmental stage.
% The rest of the input parameters are:
%     stk: number of individual embryos to be analyzed at a certain stage;
%     bandwidth: band width in z direction;
%     stapo: start z coordinate for the first band;
%     endpo: end z coordinate for the last band;
%     NOmaxPo: for each band, when you estimate average maximum intensity
%              point, the number of the largest intensity points in descending 
%              order used for averaging;
%     plots.__: 1, show plots in the process, =0, do not show plots;
%          .Band1: band plot after z range restriction;
%          .Band2: band plot after intensity narrowing down;
%          .BandCirMax: band plot with regressed circle center and maximum
%                       average intensity point;
%          .LinReg: regressed line in x-y plane using centers and maximums;
%          .DV: final transformed nuclei data with DV plane as the x-z
%               plane plotted. ventral pole set to (0,0,0); 
%     VenOriSetMet: method used to set ventral pole cordinates to (0,0,0);
%                   Method 1: average ventral coordinates; 
%                   Method 2: circle regression.
% Output: transformed nuclei data.
% ---------------
% To find the DV plane, the function separates the 3D(x,y,z) nuclei point
% shell data into several bands, for each band estimates the coordinate 
% with maximum Psmad Intensity. Center coordinates for each individual
% bands are also estimated using circle regression. The combanation of
% these coordinates will be used to estimate the DV plane.

% check inputs and set the default
if nargin<2
    error('Error! Not enough inputs.');
elseif nargin==2
       bandwidth = 100; stapo = -100; endpo = -40;  NOmaxPo = 20; plots = 0;
elseif nargin==3
       if ~isfield(parameters,'dvmethod') || isempty(parameters.dvmethod), parameters.dvmethod = 1; end;
       if ~isfield(parameters,'bandwidth') || isempty(parameters.bandwidth), parameters.bandwidth = 100; end;
       if ~isfield(parameters,'stapo') || isempty(parameters.stapo), parameters.stapo = -100; end;       
       if ~isfield(parameters,'endpo') || isempty(parameters.endpo), parameters.endpo = -40; end;
       if ~isfield(parameters,'NOmaxPo') || isempty(parameters.NOmaxPo), parameters.NOmaxPo = 20; end;
       if ~isfield(parameters,'plots') || isempty(parameters.plots), parameters.plots = []; end;
       if ~isfield(parameters.plots,'Band1') || isempty(parameters.plots.Band1), parameters.plots.Band1 = 0; end; 
       if ~isfield(parameters.plots,'Band2') || isempty(parameters.plots.Band2), parameters.plots.Band2 = 0; end; 
       if ~isfield(parameters.plots,'BandCirMax') || isempty(parameters.plots.BandCirMax), parameters.plots.BandCirMax = 0; end; 
       if ~isfield(parameters.plots,'LinReg') || isempty(parameters.plots.LinReg), parameters.plots.LinReg = 0; end; 
       if ~isfield(parameters.plots,'DV') || isempty(parameters.plots.DV), parameters.plots.DV = 0; end; 
       dvmethod = parameters.dvmethod;
       bandwidth = parameters.bandwidth;
       stapo = parameters.stapo;
       endpo = parameters.endpo;
       NOmaxPo = parameters.NOmaxPo;
       plots = parameters.plots;   
end
if stk<0 || rem(stk,1)~=0, error('Error! stk input must be a postive integer within the range of you embryo number.'); end;

BandNO = size(stapo:bandwidth:endpo,2)-1;
data = datainput;
R = zeros(stk,1);       % Initialization, storing radius of the fitted cirlce of the band along the DV plane moved to the x-z plane
CentPo = zeros(stk,2);  % Initialization, storing center coordinates of the fitted circles along the DV planed moved to the x-z plane
                        % and with the ventral pole (cross point of the fitted circle in the x-z plane withe the x axis) set to (0,0,0)

%finding the dorval ventral plane
tic;
for i=stk:stk
    disp(['Finding DV plane for the ' int2str(i) 'th embryo...']);
    LinRegPo = zeros(BandNO*2, 2); 
    eval(['n1 = size(data.set' int2str(i) ', 1);']);
    for j=1:BandNO
        
    % step1: band selection
        tem1 = zeros(1,5);         % temporary matrix storing nuclei points within a short range along the z axis
        for k=1:n1  
            eval(['datatemp = data.set' int2str(i) '(k,3);']);
            if datatemp > stapo && datatemp < stapo+bandwidth
               eval(['tem1 = cat(1, tem1, data.set' int2str(i) '(k,:));']);    
            end
        end
        tem1 = tem1(2:size(tem1,1), :);
        if plots.Band1
           figure, plot3(tem1(:,1), tem1(:,2), tem1(:,3),'.');
           eval(['title(''Band ' int2str(j) ' nuclei points'');']);            
        end
        stapo = stapo + bandwidth;
        
    % step2: narrow down using I range (ventral most in the z range)
        eval(['Threshold = dvmethod * 0.5 * max(data.set' int2str(i) '(:,5));']); %finding nuclei points with intensity values >= 0.4 max intensity (toward ventral pole)
        n2 = size(tem1, 1);
        tem2 = zeros(1,5);   % temporary matrix storing nuclei points within a short range along the z axis and above a certain I threshold
        for k=1:n2
            if tem1(k,5) > Threshold || tem1(k,5) == Threshold
               tem2 = cat(1, tem2, tem1(k,:));
            end
        end
        tem2 = tem2(2:size(tem2,1), :);
        if plots.Band2
           figure, plot3(tem2(:,1), tem2(:,2), tem2(:,3),'.');
           eval(['title(''Band ' int2str(j) ' nuclei points toward ventral pole'');'])
        end
        
    % step3: estimate maximum intensity points and center points
                    % estimate cirlce center points for each individual band
        [xc, yc, R0] = circfit(tem1(:,1), tem1(:,2));
        if plots.BandCirMax
           figure, plot(tem1(:,1),tem1(:,2), '.', xc, yc, 'r+');
           figure, plot(tem2(:,1),tem2(:,2), '.', AveMaxPo(1), AveMaxPo(2), 'r+');
        end
        LinRegPo(j+BandNO,:) = [xc, yc];
                    % estimate average maximum intensity points.
        if dvmethod==1        % method1: finding local average maximums                 
           [~,IX] = sort(tem2(:,5), 'descend');    
           MaxPo = zeros(NOmaxPo, 5); 
           for k=1:NOmaxPo
               MaxPo(k,:) = tem2(IX(k),:);
           end
           AveMaxPo = mean(MaxPo,1);
           LinRegPo(j,:) = AveMaxPo(1:2);
        elseif dvmethod==2    % method2: polynomial fitting and peak finding
               tem1(:,1) = tem1(:,1) -xc; tem1(:,2) = tem1(:,2) -yc;
               eval(['data.set' int2str(i) '(:,1) = data.set' int2str(i) '(:,1)-xc;']);
               eval(['data.set' int2str(i) '(:,2) = data.set' int2str(i) '(:,2)-yc;']);
               xc = 0; yc = 0; LinRegPo(j+BandNO,:) = [0, 0]; 
               tem1(:,4) = real(asin(tem1(:,2) ./ sqrt((tem1(:,1)-xc).^2 + (tem1(:,2)-yc).^2)));
               for k=1:size(tem1,1)
                   if tem1(k,1)>xc
                      tem1(k,4) = sign(tem1(k,4))*pi - tem1(k,4);
                   end
               end
               p = polyfit(tem1(:,4),tem1(:,5),4); % x: tem1(:,4), degrees, y: tem1(:,5), intensities
               inten_hat = p(1)*tem1(:,4).^4 + p(2)*tem1(:,4).^3 + p(3)*tem1(:,4).^2 + p(4)*tem1(:,4) +p(5);
               figure, plot(tem1(:,4),tem1(:,5),'bx',tem1(:,4),inten_hat,'r.');
               rts = roots([4,3,2,1] .* p(1:4));   % first derivative equals 0.
               rts_snd = 12*p(1) * rts.^2 + 6*p(2) * rts + 2*p(3); 
               if j==1, tempol = zeros(BandNO,1); end;
               for k=1:3
                   if rts_snd(k)<0
                      LinRegPo(j,:) = [xc - R0*cos(rts(k)), R0*sin(rts(k))];
                      tempol(j) = rts(k);
                   end
               end
        end
    end
    if dvmethod==2
       Average_Angle_Position = mean(tempol) 
       standard_error = std(tempol); 
       LinRegPo
    end
    
    % step4: line regression and DV plane positioning passing the line and vertical to x-z plane
    eval(['data.set' int2str(i) '(:,1) = data.set' int2str(i) '(:,1)-mean(LinRegPo(1:BandNO,1));']);
    eval(['data.set' int2str(i) '(:,2) = data.set' int2str(i) '(:,2)-mean(LinRegPo(1:BandNO,2));']);     
    LinRegPo(:,1) = LinRegPo(:,1) - mean(LinRegPo(1:BandNO,1));
    LinRegPo(:,2) = LinRegPo(:,2) - mean(LinRegPo(1:BandNO,2));     
    p=real(polyfit(LinRegPo(:,1),LinRegPo(:,2),1));   % y=p(1)x +p(2) is the estimated DV plane
    xx=ceil(min(LinRegPo(:,1))*0.1)*10-50:20:ceil(max(LinRegPo(:,1))*0.1)*10+50;   
%     if plots.LinReg
%        figure,plot(LinRegPo(:,1),LinRegPo(:,2),'x',xx,polyval(p,xx),'r'); 
%     end            

    % step5: rotation and translation to make the DV plane overlap with x-z
           % plane and ventral pole coordinate set to (0,0,0).
    eval(['data.set' int2str(i) '(:,2) = data.set' int2str(i) '(:,2) - p(2);']);
    
    % figure,scatter3(data.set2(:,1), data.set2(:,2), data.set2(:,3), 10, data.set2(:,5), 'filled');
    
    LinRegPo(:,2) = LinRegPo(:,2) - p(2);
    % LinRegPo
    if plots.LinReg
       figure,plot(LinRegPo(:,1),LinRegPo(:,2),'x',xx,polyval([p(1) 0],xx),'r'); 
    end      
         % translation of the nuclei data set along y axis to make the DV
         % plane passing the origin(0,0,0).
    if mean(LinRegPo(BandNO+1:BandNO*2,2))>0      % clockwise rotation along z axis              
       if p(1)>0 || p(1)==0
          ang = 2*pi - atan(p(1));
       elseif p(1)<0
          ang = pi + atan(abs(p(1)));
       end 
    elseif mean(LinRegPo(BandNO+1:BandNO*2,2))<0  % counterclockwise rotation along z axis 
       if p(1)>0 || p(1)==0
          ang = pi - atan(p(1));
       elseif p(1)<0
          ang = atan(abs(p(1)));
       end              
    end
    r = pre_r(0,0,1,ang);
    eval(['data.set' int2str(i) '(:,1:3) = data.set' int2str(i) '(:,1:3) * r'';']); 
    
    if plots.DV
       eval(['data_for_plot = [data.set' int2str(i) '(:,1:3) data.set' int2str(i) '(:,5)];']);
       figure, plane_plot(data_for_plot, 0);    
    end        
end
    disptime(toc);
    eval(['dataoutput = data.set' int2str(i) ';']);  % set output return data
end
function [stkout] = removeYSL(stkin)
%removes all points blow the line connecting the 2 imputted points
%   Detailed explanation goes here

%b=(x1*z2-z1*x2)/(-x2-x1)


nucdisplay3d(stkin, 25, 1, 5);

camorbit(0,90);

datacursormode on

f = warndlg('close this box after you have selected point 1', 'Instructions');
drawnow     % Necessary to print the message
waitfor(f);

dcm_obj = datacursormode(gcf);
info_struct = getCursorInfo(dcm_obj);  % !! use ginput to replace getCursorInfo(dcm_obj)
xyz1=info_struct.Position;

x1=xyz1(1,1);
z1=xyz1(1,3);

f = warndlg('close this box after you have selected point 2', 'Instructions');
drawnow     % Necessary to print the message
waitfor(f);


dcm_obj = datacursormode(gcf);
info_struct = getCursorInfo(dcm_obj);
xyz2=info_struct.Position;

x2=xyz2(1,1);
z2=xyz2(1,3);


%[x1, z1]=ginput(1);
%[x2, z2]=ginput(1);
close(gcf);


m=(z2-z1)/(x2-x1);
b=-m*x1+z1;


[a,b]=find(stkin(:,3)<stkin(:,1)*m+b);

stkout=stkin;
stkout(a,:)=[];

%close all
end
function b = plane_regression(inputdata)

% plane regression for zebrafish nuclei position data. Wei Dou  05/20/2012.
% This is to do regression (estimating b). 
% input:
%       inputdata(:,1) = x coordinate value
%       inputdata(:,2) = y coordinate value
%       inputdata(:,3) = z coordinate value
% output:
%       b = parameter values for Z = b(1) + b(2)*X + b(3)*Y (plane function).

  x = inputdata(:,1);
  y = inputdata(:,2);
  z = inputdata(:,3);
  
% regression  
  [m, d] = size(inputdata);
  if d~=3 
     error('Error! Only for 3D data. Check data dimention');
  end

  X = [ones(m,1) x y]; 
  b = regress(z,X);
end
function plane_plot(indata1, b1, indata2, b2)

% plane_plot. Wei Dou 5/27/12.
% This is to plot the scatter points and corresponding regression plane.
% input:
%       indata(1/2)(:,1) = x coordinate value
%       indata(1/2)(:,2) = y coordinate value
%       indata(1/2)(:,3) = z coordinate value
  if nargin==2
     d = size(indata1, 2);
     if d~=3 
        error('Error! Only for 3D data. Check data dimention');
     end
     
     plotting(indata1, b1, nargin);
  end
  
  if nargin==4
     d1 = size(indata1, 2);    
     d2 = size(indata2, 2);
     if d1~=3 && d2~=3 
        error('Error! Only for 3D data. Check data dimention');
     end
     
     hold on;
     plotting(indata1, b1, nargin);
     plotting(indata2, b2, nargin-2);
     hold off;
  end
end
function plotting(indata, b, n)
  x = indata(:,1);
  y = indata(:,2);
  z = indata(:,3);

  xfit = min(x):(max(x)-min(x))/10:max(x);  
  yfit = min(y):(max(x)-min(x))/10:max(y);
  
  [XFIT,YFIT]= meshgrid (xfit,yfit); % creat mesh data
  ZFIT = b(1) + b(2) * XFIT + b(3) * YFIT;
  if n==2, plot3(x,y,z,'bo'); end;
  if n==4, plot3(x,y,z,'r.'); end;
  mesh(XFIT,YFIT,ZFIT); % mesh plot
end
function [x, y, z] = unit_vector(b1, b2)

% unit_vector. Wei Dou  05/8/2013.
% This is to calculate the unit vector that passes (0,0,0) and is along the
% intercecting line of the two regression planes using the reference and the test nuclei data set. 
% Based on the unit vector, rotation can be used to eliminate the large angle around x and y axes.

% syms x0 y0 z0;
% [x0,y0,z0]=solve('z0=b1(2)*x0+b1(3)*y0','z0=b2(2)*x0+b2(3)*y0','x0^2+y0^2+z0^2=1');
% x0=vpa(x0,4);
% y0=vpa(y0,4);

x = -(b1(3) - b2(3))*(1/(b1(2)^2 - 2*b1(3)*b2(3) - 2*b1(2)*b2(2) + b1(3)^2 + b2(2)^2 + ...
    b2(3)^2 + b1(2)^2*b2(3)^2 + b1(3)^2*b2(2)^2 - 2*b1(2)*b1(3)*b2(2)*b2(3)))^(1/2);

y = (b1(2) - b2(2))*(1/(b1(2)^2 - 2*b1(3)*b2(3) - 2*b1(2)*b2(2) + b1(3)^2 + b2(2)^2 + ...
    b2(3)^2 + b1(2)^2*b2(3)^2 + b1(3)^2*b2(2)^2 - 2*b1(2)*b1(3)*b2(2)*b2(3)))^(1/2);

z = (b1(2)*b2(3) - b1(3)*b2(2))*(1/(b1(2)^2 - 2*b1(3)*b2(3) - 2*b1(2)*b2(2) + b1(3)^2 + ...
    b2(2)^2 + b2(3)^2 + b1(2)^2*b2(3)^2 + b1(3)^2*b2(2)^2 - 2*b1(2)*b1(3)*b2(2)*b2(3)))^(1/2);
end
function r = pre_r(x,y,z, alpha)

% Preprocessing_Rotation (Pre_R). Wei Dou 5/8/13.
% This is to rotate the test set (plane) to the reference set (plane). 
% Rotation is used to eliminate the large angle around x and y axes.

ca = cos(alpha);
sa = sin(alpha);
r = [ca+(1-ca)*x^2, (1-ca)*x*y-z*sa, (1-ca)*x*z+y*sa;
     (1-ca)*x*y+z*sa, ca+(1-ca)*y^2, (1-ca)*y*z-x*sa;
     (1-ca)*x*z-y*sa, (1-ca)*y*z+x*sa, ca+(1-ca)*z^2];
end
function [xc,yc,R,a] = circfit(x,y)

% CIRCFIT Fits a circle in x,y plane.   Wei Dou 05/8/13
%
% [XC, YC, R, A] = CIRCFIT(X,Y)
% Result is center point (yc,xc) and radius R.A is an 
% optional output describing the circle's equation:
%
% x^2+y^2+a(1)*x+a(2)*y+a(3)=0

n=length(x); xx=x.*x; yy=y.*y; xy=x.*y;
A=[sum(x) sum(y) n;sum(xy) sum(yy)...
sum(y);sum(xx) sum(xy) sum(x)];
B=[-sum(xx+yy) ; -sum(xx.*y+yy.*y) ; -sum(xx.*x+xy.*y)];
a=A\B;
xc = -.5*a(1);
yc = -.5*a(2);
R = sqrt((a(1)^2+a(2)^2)/4-a(3));

end
function nucdisplay3d(xyzin, sphsize, zoff,intcol)

%this function displays a matrix of xyz coordinates and intensities in 3D.
%input is a n x m array such that [x1, y1, z1, intensity1, inensity2...; x2, y2, z2, intensity1, intensity 2,... ;...]

%zoff=zpixellength/x/ypixellength          
%xyzin(:,3)=abs(xyzin(:,3)-138);
%[nucrow,~]=find(xyzin(:,2)>610);
%xyzin(nucrow,:)=[];
%intcol= row of inensities to be used


%[xsph,ysph,zsph]=sphere;
%xsph=xsph*sphsize;
%ysph=ysph*sphsize;
%zsph=zsph*sphsize;

%datatype can be selected.  for now it is defaulted to 1 or 8-bit raw
%dattype=input('data type ("3" for input max, "2" for log, "1" for 8-bit raw or "0" for custom): ');
dattype=1;

if dattype==0
    
    calcmean=mean(xyzin(:,intcol));
    disp(['calculated mean = ' num2str(calcmean)])

    manmean=input('Is this mean acceptable? (1=yes ; 2=no, I would like to imput a value manually) ');
    %manmean=0;
    
    if manmean==2
        calcmean=input('Input Mean: ');
    end;
    contmax=2*calcmean;
end;

%intitle=input('please input title: ','s');
intitle='intensity';

if dattype==1
%in this setup, 0 is the inherent lower limit coressponding to deep blue,
%256 is the inherent upper limit corresponding to red.  this is because a
%matrix of 128 rows is made, and all numbers are divided by 256 then
%multiplied by 127 and 1 is added.
    %contmax=100;
    contmax=256;
end;
    
if dattype==2

    xyzin(:,intcol)=log2(xyzin(:,intcol));
    contmax=8;
end;
    


if dattype==3
%in this setup, 0 is the inherent lower limit coressponding to deep blue,
%150 is the inherent upper limit corresponding to red.  all int values above 150 are set to 150.  this is because a
%matrix of 128 rows is made, and all numbers are divided by 256 then
%multiplied by 127 and 1 is added.
contmax=input('Input Max: ');
    %contmax=150;
    %[rows,~]=find(xyzin(:,intcol)>contmax);
    %xyzin(rows,intcol)=contmax;
    
end;



figure('units','normalized','outerposition',[0.1 0.1 0.8 0.8])

%contmax=max(xyzin(:,intcol));
map=hsv(128);
%contmax=2.5;
hold on
lighting none


xyzin(:,3)=round(xyzin(:,3).*zoff);
%for i=1000:2000
for i=1:size(xyzin,1)
%    if xyzin(i,4)<150 && xyzin(i,4)>50
     
    xnuc=xyzin(i,1);
    ynuc=xyzin(i,2);
    znuc=xyzin(i,3);
    cont=xyzin(i,intcol);
    colormap('hsv')
    if cont>contmax
        cont=contmax;
    end;
    
    %surf(xsph+xnuc,ysph+ynuc,zsph+znuc, ones(21), 'facecolor', map(ceil(cont/contmax*127)+1,:), 'facelighting', 'none', 'linestyle', 'none', 'edgecolor', 'flat', 'EdgeLighting', 'none', 'backfacelighting', 'unlit') 
    plot3(xnuc,ynuc,znuc, '.', 'MarkerSize', sphsize, 'Color', map(ceil(cont./contmax.*127)+1,:)) 
    
    %surf(xsph+xnuc,ysph+ynuc,zsph+znuc, ones(21), 'facecolor', map(ceil(cont/contmax*127)+1,:), 'linestyle', 'none', 'edgecolor', 'flat') 
    
  %  end;
end;


%
%colormap('summer')
%[xsph,ysph,zsph]=sphere;
%xsph=xsph*10;
%ysph=ysph*10;
%zsph=zsph*10;
%surf(xsph+481,ysph+491,zsph+36, 75, 'facecolor', 'interp', 'facelighting', 'phong', 'linestyle', 'none', 'edgecolor', 'flat', 'EdgeLighting', 'gouraud', 'backfacelighting', 'reverselit') 


%axis ([0,1024,0,1024,0,round(137*zoff)])
%colordef black %sets backround to black
colordef white
daspect([1,1,1])
camlight('right');
title(intitle)
if dattype==1
    colorbar
    caxis([0,256]);
    %('YTickLabel',{'0','25.6','51.2','76.8','102.4', '128','153.6','179.2', '204.8', '230.5', '256'})
end;
if dattype==0
    colorbar
    caxis([0,2*calcmean]);
    %('YTickLabel',{'0','25.6','51.2','76.8','102.4', '128','153.6','179.2', '204.8', '230.5', '256'})
end;

if dattype==2
    colorbar('YTickLabel',{'0','2','4','8','16','32', '64', '128', '256'})
    caxis([0,log2(256)])
end;

if dattype==3
    colorbar
    caxis([0,contmax]);
    %('YTickLabel',{'0','25.6','51.2','76.8','102.4', '128','153.6','179.2', '204.8', '230.5', '256'})
end;

end

% step 4 sub functions
function [Transform, C]=cpd_register(X, Y, opt)

%CPD_REGISTER Rigid, affine, non-rigid point set registration. 
% The main CPD registration function that sets all the options,
% normalizes the data, runs the rigid/non-rigid registration, and returns
% the transformation parameters, registered poin-set, and the
% correspondences.
%
%   Input
%   ------------------ 
%   X, Y       real, double, full 2-D matrices of point-set locations. We want to
%              align Y onto X. [N,D]=size(X), where N number of points in X,
%              and D is the dimension of point-sets. Similarly [M,D]=size(Y). 
%   
%   opt        a structure of options with the following optional fields:
%
%       .method=['rigid','affine','nonrigid','nonrigid_lowrank'] (default
%               rigid) Registration method. Nonrigid_lowrank uses low rank
%               matrix approximation (use for the large data problems).
%       .corresp=[0 or 1] (default 0) estimate the correspondence vector at
%               the end of the registration.
%       .normalize =[0 or 1] (default 1) - normalize both point-sets to zero mean and unit
%               variance before registration, and denormalize after.
%       .max_it (default 150) Maximum number of iterations.
%       .tol (default 1e-5) Tolerance stopping criterion.
%       .viz=[0 or 1] (default 1) Visualize every every iteration.
%       .outliers=[0...1] (default 0.1) The weight of noise and outliers
%       .fgt=[0,1 or 2] Default 0 - do not use. 1 - Use a Fast Gauss transform (FGT) to speed up some matrix-vector product.
%                       2 - Use FGT and fine tune (at the end) using truncated kernel approximations.
%
%       Rigid registration options
%       .rot=[0 or 1] (default 1) 1 - estimate strictly rotation. 0 - also allow for reflections.
%       .scale=[0 or 1] (default 1) 1- estimate scaling. 0 - fixed scaling. 
%
%       Non-rigid registration options
%       .beta [>0] (default 2) Gaussian smoothing filter size. Forces rigidity.
%       .lambda [>0] (default 3) Regularization weight. 
%
%   Output
%   ------------------ 
%   Transform      structure of the estimated transformation parameters:
%
%           .Y     registered Y point-set
%           .iter  total number of iterations
%
%                  Rigid/affine cases only:     
%           .R     Rotation/affine matrix.
%           .t     Translation vector.
%           .s     Scaling constant.
%           
%                  Non-rigid cases only:
%           .W     Non-rigid coefficient
%           .beta  Gaussian width
%           .t, .s translation and scaling
%           
%    
%   C       Correspondance vector, such that Y corresponds to X(C,:)
%
%           
%
%   Examples
%   --------
%
%   See many detailed examples in the 'examples' folder.

% Copyright (C) 2008-2009 Andriy Myronenko (myron@csee.ogi.edu)
% also see http://www.bme.ogi.edu/~myron/matlab/cpd/
%
%     This file is part of the Coherent Point Drift (CPD) package.
%
%     The source code is provided under the terms of the GNU General Public License as published by
%     the Free Software Foundation version 2 of the License.
% 
%     CPD package is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with CPD package; if not, write to the Free Software
%     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA


[M,D]=size(Y); [N, D2]=size(X);
% Check the input options and set the defaults
if nargin<2, error('cpd_rigid_register.m error! Not enough input parameters.'); end;
if nargin<3, opt.method='rigid'; end;
if ~isfield(opt,'method') || isempty(opt.method), opt.method = 'rigid'; end;
if ~isfield(opt,'normalize') || isempty(opt.normalize), opt.normalize = 1; end;
if ~isfield(opt,'max_it') || isempty(opt.max_it), opt.max_it = 150; end;
if ~isfield(opt,'tol') || isempty(opt.tol), opt.tol = 1e-5; end;
if ~isfield(opt,'viz') || isempty(opt.viz), opt.viz = 1; end;
if ~isfield(opt,'corresp') || isempty(opt.corresp), opt.corresp = 0; end;
if ~isfield(opt,'outliers') || isempty(opt.outliers), opt.outliers = 0.1; end;
if ~isfield(opt,'fgt') || isempty(opt.fgt), opt.fgt = 0; end;
if ~isfield(opt,'sigma2') || isempty(opt.sigma2), opt.sigma2 = 0; end;

% strictly rigid params
if ~isfield(opt,'rot') || isempty(opt.rot), opt.rot = 1; end;
if ~isfield(opt,'scale') || isempty(opt.scale), opt.scale = 1; end;
% strictly non-rigid params
if ~isfield(opt,'beta') || isempty(opt.beta), opt.beta = 2; end;
if ~isfield(opt,'lambda') || isempty(opt.lambda), opt.lambda = 3; end;
% lowrank app param
if ~isfield(opt,'numeig') || isempty(opt.numeig), opt.numeig = round(sqrt(M)); end;
if ~isfield(opt,'eigfgt') || isempty(opt.eigfgt), opt.eigfgt = 1; end;


% checking for the possible errors
if D~=D2, error('The dimension of point-sets is not the same.'); end;
if (D>M)||(D>N), disp('The dimensionality is larger than the number of points. Possibly the wrong orientation of X and Y.'); end;
if (M>1e+5)||(N>1e+5) && (opt.fgt==0), disp('The data sets are large. Use opt.fgt=1 to speed up the process.'); end;
if (M>1e+5)||(N>1e+5) && strcmp(lower(opt.method),'nonrigid'), disp('The data sets are large. Use opt.method=''nonrigid_lowrank'' to speed up the non-rigid registration'); end;
if (D<=1) || (D>3), opt.viz=0; end;
if (opt.normalize==1)&&(opt.scale==0),opt.scale=1; end;

% check if mex functions are compiled yet
if ~exist('cpd_P','file')
    disp('Looks like you have not compiled CPD mex files yet (needs to be done once)');
    disp('Running cpd_make.m for you ...'); tic;
    cpd_make;
end

% Convert to double type, save Y
X=double(X);  
Y=double(Y); Yorig=Y; 

% default mean and scaling
normal.xd=0; normal.yd=0;
normal.xscale=1; normal.yscale=1;

% Normalize to zero mean and unit variance
if opt.normalize, [X,Y,normal]=cpd_normalize(X,Y); end;

disp(['%%%%% Starting CPD-' upper(opt.method) ' registration. %%%' ]); tic;

%%%% Choose the method and start CPD point-set registration
switch lower(opt.method),
    case 'rigid'
        [C, R, t, s, sigma2, iter, T]=cpd_rigid(X,Y, opt.rot, opt.scale, opt.max_it, opt.tol, opt.viz, opt.outliers, opt.fgt, opt.corresp, opt.sigma2);
       case 'affine'
        [C, R, t, sigma2, iter, T]=cpd_affine(X,Y, opt.max_it, opt.tol, opt.viz, opt.outliers, opt.fgt, opt.corresp, opt.sigma2); s=1;
    case 'nonrigid'
        [C, W, sigma2, iter, T] =cpd_GRBF(X, Y, opt.beta, opt.lambda, opt.max_it, opt.tol, opt.viz, opt.outliers, opt.fgt, opt.corresp, opt.sigma2);    
    case 'nonrigid_lowrank'
        [C, W, sigma2, iter, T] =cpd_GRBF_lowrank(X, Y, opt.beta, opt.lambda, opt.max_it, opt.tol, opt.viz, opt.outliers, opt.fgt, opt.numeig, opt.eigfgt, opt.corresp, opt.sigma2);
    otherwise
        error('The opt.method value is invalid. Supported methods are: rigid, affine, nonrigid, nonrigid_lowrank');
end
%%%% 
disptime(toc);

Transform.iter=iter;
Transform.method=opt.method;
Transform.Y=T;
Transform.normal=normal;

% Denormalize transformation parameters
switch lower(opt.method)
    case {'rigid','affine'}
        Transform.R=R; Transform.t=t;Transform.s=s;
        if opt.normalize, % denormalize parameters and registered point set, if it was prenormalized
            Transform.s=Transform.s*(normal.xscale/normal.yscale);
            Transform.t=normal.xscale*Transform.t+normal.xd'-Transform.s*(Transform.R*normal.yd');
            Transform.Y=T*normal.xscale+repmat(normal.xd,M,1);
            
            if strcmp(lower(opt.method),'affine')
                Transform.R=Transform.s*Transform.R; 
                Transform.s=1;
            end
            
        end;
    case {'nonrigid','nonrigid_lowrank'}
            Transform.beta=opt.beta;
            Transform.W=W;
            Transform.Yorig=Yorig;
            Transform.s=1;
            Transform.t=zeros(D,1);
        if opt.normalize,
             Transform.Y=T*normal.xscale+repmat(normal.xd,M,1);
        end 

end
end
function  [X, Y, normal] =cpd_normalize(x,y)

%CPD_NORMALIZE Normalizes reference and template point sets to have zero
%mean and unit variance.
%   G=CPD_NORMALIZE(x,y) Normalizes x and y to have zero mean and unit
%   variance.
%
%   Input
%   ------------------ 
%   x, y       real, full 2-D matrices. Rows represent samples. Columns
%              represent features. x - reference point set. y - template
%              point set.
%
%   Output
%   ------------------ 
%   X, Y      normalized reference and template point sets. 
%
%   normal     structure that can be used to rescale and shift the point
%              sets back to its original scaling and position (use cpd_denormalize.m)
%
%   Examples
%   --------
%       x= [1 2; 3 4; 5 6;];
%       y=x;
%       [X, Y, normal]=cpd_normalize(x,y);
%
%       x2=cpd_denormalize(X, normal);
%       norm(x-x2)
%
%   See also CPD_DENORMALIZE, CPD_REGISTER

% Copyright (C) 2006 Andriy Myronenko (myron@csee.ogi.edu)
%
%     This file is part of the Coherent Point Drift (CPD) package.
%
%     The source code is provided under the terms of the GNU General Public License as published by
%     the Free Software Foundation version 2 of the License.
% 
%     CPD package is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with CPD package; if not, write to the Free Software
%     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

if nargin<2, error('cpd_normalize error! Not enough input parameters.'); end;

n=size(x,1);
m=size(y,1);

normal.xd=mean(x);
normal.yd=mean(y);

x=x-repmat(normal.xd,n,1);
y=y-repmat(normal.yd,m,1);

normal.xscale=sqrt(sum(sum(x.^2,2))/n);
normal.yscale=sqrt(sum(sum(y.^2,2))/m);

X=x/normal.xscale;
Y=y/normal.yscale;
end
function [C, B, t, sigma2, iter, T]=cpd_affine(X,Y, max_it, tol, viz, outliers, fgt, corresp, sigma2)
%CPD_AFFINE The affine CPD point-set registration. It is recommended to use
%   and umbrella function rcpd_register with an option opt.method='affine'
%   instead of direct use of the current funciton.
%
%
%   Input
%   ------------------
%   X, Y       real, double, full 2-D matrices of point-set locations. We want to
%              align Y onto X. [N,D]=size(X), where N number of points in X,
%              and D is the dimension of point-sets. Similarly [M,D]=size(Y).
%
%   max_it          maximum number of iterations, try 150
%   tol             tolerance criterium, try 1e-5
%   viz=[0 or 1]    Visualize every iteration         
%   outliers=[0..1] The weight of noise and outliers, try 0.1
%   fgt=[0 or 1]    (default 0) Use a Fast Gauss transform (FGT). (use only for the large data problems)
%   corresp=[0 or 1](default 0) estimate the correspondence vector.
%
%
%
%
%   Output
%   ------------------
%   C      Correspondance vector, such that Y corresponds to X(C,:).
%   B      Affine matrix.
%   t      Translation vector.
%   sigma2 Final sigma^2
%   iter   Final number or iterations
%   T      Registered Y point set
%
%
%   Examples
%   --------
%   It is recommended to use an umbrella function cpd_register with an
%   option opt.method='affine' instead of direct use of the current
%   funciton.
%
%   See also CPD_REGISTER

% Copyright (C) 2008 Andriy Myronenko (myron@csee.ogi.edu)
%
%     This file is part of the Coherent Point Drift (CPD) package.
%
%     The source code is provided under the terms of the GNU General Public License as published by
%     the Free Software Foundation version 2 of the License.
%
%     CPD package is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with CPD package; if not, write to the Free Software
%     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

[N, D]=size(X);[M, D]=size(Y);

% Initialize sigma and Y
if ~exist('sigma2','var') || isempty(sigma2) || (sigma2==0), 
    sigma2=(M*trace(X'*X)+N*trace(Y'*Y)-2*sum(X)*sum(Y)')/(M*N*D);
end
sigma2_init=sigma2;

T=Y;

% Optimization
iter=0; ntol=tol+10; L=1;
while (iter<max_it) && (ntol > tol) && (sigma2 > 10*eps)

    L_old=L;

    % Check wheather we want to use the Fast Gauss Transform
    if (fgt==0)  % no FGT
        [P1,Pt1, PX, L]=cpd_P(X,T, sigma2 ,outliers); st='';
    else         % FGT
        [P1, Pt1, PX, L, sigma2, st]=cpd_Pfast(X, T, sigma2, outliers, sigma2_init, fgt);
    end
    
    ntol=abs((L-L_old)/L);
    disp([' CPD Affine ' st ' : dL= ' num2str(ntol) ', iter= ' num2str(iter) ' sigma2= ' num2str(sigma2)]);
  
    % Precompute 
    Np=sum(P1);
    mu_x=X'*Pt1/Np;
    mu_y=Y'*P1/Np;


    % Solve for parameters
    B1=PX'*Y-Np*(mu_x*mu_y');
    B2=(Y.*repmat(P1,1,D))'*Y-Np*(mu_y*mu_y');
    B=B1/B2; % B= B1 * inv(B2);
    
    
    t=mu_x-B*mu_y;
    
    sigma2save=sigma2;
    sigma2=abs(sum(sum(X.^2.*repmat(Pt1,1,D)))- Np*(mu_x'*mu_x) -trace(B1*B'))/(Np*D); 
    % abs here to prevent roundoff errors that leads to negative sigma^2 in
    % rear cases
    
    % Update centroids positioins
    T=Y*B'+repmat(t',[M 1]);

    iter=iter+1;

    if viz, cpd_plot_iter(X, T); end;
    %saveas(1, ['regdem' int2str(iter) '.tif'])  %run to visualizr each
    %iteration save
end

% Find the correspondence, such that Y(C) corresponds to X
if corresp, C=cpd_Pcorrespondence(X,T,sigma2save,outliers); else C=0; end;
end
function [C, R, t, s, sigma2, iter, T]=cpd_rigid(X,Y, rot, scale, max_it, tol, viz, outliers, fgt, corresp, sigma2)

%CPD_RIGID The rigid CPD point-set registration. It is recommended to use
%   and umbrella function rcpd_register with an option opt.method='rigid'
%   instead of direct use of the current funciton.
%
%
%   Input
%   ------------------
%   X, Y       real, double, full 2-D matrices of point-set locations. We want to
%              align Y onto X. [N,D]=size(X), where N number of points in X,
%              and D is the dimension of point-sets. Similarly [M,D]=size(Y).
%
%   rot=[0 or 1]    (default 1) 1- strict rotation, 0- allow reflections.
%   scale=[0 or 1]  (default 1) 1- estimate scaling, 0- don't estimate scaling.    
%   max_it          maximum number of iterations, try 150
%   tol             tolerance criterium, try 1e-5
%   viz=[0 or 1]    Visualize every iteration         
%   outliers=[0..1] The weight of noise and outliers, try 0.1
%   fgt=[0 or 1]    (default 0) Use a Fast Gauss transform (FGT). (use only for the large data problems)
%   corresp=[0 or 1](default 0) estimate the correspondence vector.
%
%
%
%
%   Output
%   ------------------
%   C      Correspondance vector, such that Y corresponds to X(C,:).
%   R      Rotation matrix.
%   t      Translation vector.
%   s      Scaling constant.
%   sigma2 Final sigma^2
%   iter   Final number or iterations
%   T      Registered Y point set
%
%
%   Examples
%   --------
%   It is recommended to use an umbrella function cpd_register with an
%   option opt.method='rigid' instead of direct use of the current
%   funciton.
%
%   See also CPD_REGISTER

% Copyright (C) 2008 Andriy Myronenko (myron@csee.ogi.edu)
%
%     This file is part of the Coherent Point Drift (CPD) package.
%
%     The source code is provided under the terms of the GNU General Public License as published by
%     the Free Software Foundation version 2 of the License.
%
%     CPD package is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with CPD package; if not, write to the Free Software
%     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

[N, D]=size(X);[M, D]=size(Y);
if viz, figure; end;

% Initialization
if ~exist('sigma2','var') || isempty(sigma2) || (sigma2==0), 
    sigma2=(M*trace(X'*X)+N*trace(Y'*Y)-2*sum(X)*sum(Y)')/(M*N*D);
end
sigma2_init=sigma2;

T=Y; s=1; R=eye(D);

% Optimization
iter=0; ntol=tol+10; L=0;
while (iter<max_it) && (ntol > tol) && (sigma2 > 10*eps)

    L_old=L;
    % Check wheather we want to use the Fast Gauss Transform
    if (fgt==0)  % no FGT
        [P1,Pt1, PX, L]=cpd_P(X,T, sigma2 ,outliers); st='';
    else         % FGT
        [P1, Pt1, PX, L, sigma2, st]=cpd_Pfast(X, T, sigma2, outliers, sigma2_init, fgt);
    end

    ntol=abs((L-L_old)/L);
    disp([' CPD Rigid ' st ' : dL= ' num2str(ntol) ', iter= ' num2str(iter) ' sigma2= ' num2str(sigma2)]);


    % Precompute
    Np=sum(Pt1);
    mu_x=X'*Pt1/Np;
    mu_y=Y'*P1/Np;

    % Solve for Rotation, scaling, translation and sigma^2
    A=PX'*Y-Np*(mu_x*mu_y'); % A= X'P'*Y-X'P'1*1'P'Y/Np;
    [U,S,V]=svd(A); C=eye(D);
    if rot, C(end,end)=det(U*V'); end % check if we need strictly rotation (no reflections)
    R=U*C*V';

    sigma2save=sigma2;
    if scale  % check if estimating scaling as well, otherwise s=1
        s=trace(S*C)/(sum(sum(Y.^2.*repmat(P1,1,D))) - Np*(mu_y'*mu_y));
        sigma2=abs(sum(sum(X.^2.*repmat(Pt1,1,D))) - Np*(mu_x'*mu_x) -s*trace(S*C))/(Np*D);
    else
        sigma2=abs((sum(sum(X.^2.*repmat(Pt1,1,D))) - Np*(mu_x'*mu_x)+sum(sum(Y.^2.*repmat(P1,1,D))) - Np*(mu_y'*mu_y) -2*trace(S*C))/(Np*D));
    end

    t=mu_x-s*R*mu_y;

    % Update the GMM centroids
    T=s*Y*R'+repmat(t',[M 1]);

    iter=iter+1;

    if viz, cpd_plot_iter(X, T); end; % show current iteration if viz=1
    
end

% Find the correspondence, such that Y corresponds to X(C,:)
if corresp, C=cpd_Pcorrespondence(X,T,sigma2save,outliers); else C=0; end;
end
function   Transform =cpd_denormalize(Transform, normal, way)

%CPD_DENORMALIZE Denormalizes template point set to its original scaling.
%   y=CPD_DENORMALIZE(Y, normal) Denormalizes points in 
%   normalized point set Y to be scaled and shifted
%   back in the reference point set coordinate system.
%
%   Input
%   ------------------ 
%   Y          Normalized point set.
%
%   Output
%   ------------------ 
%   y          denormalized point set back in the reference point set system. 
%
%   normal     structure of scale and shift parameters
%
%   Examples
%   --------
%       x= [1 2; 3 4; 5 6;];
%       y=x;
%       [X, Y0, normal]=cpd_normalize(x,y);
%
%       x2=cpd_denormalize(X, normal);
%       norm(x-x2)
%
%   See also CPD_NORMALIZE, CPD_TRANSFORM, CPD_REGISTER

% Copyright (C) 2006 Andriy Myronenko (myron@csee.ogi.edu)
%
%     This file is part of the Coherent Point Drift (CPD) package.
%
%     The source code is provided under the terms of the GNU General Public License as published by
%     the Free Software Foundation version 2 of the License.
% 
%     CPD package is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with CPD package; if not, write to the Free Software
%     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

switch lower(Transform.method)
    case {'rigid','affine'}
        Transform.s=Transform.s*(normal.xscale/normal.yscale);
        Transform.t=normal.xscale*Transform.t+normal.xd'-Transform.s*(Transform.R*normal.yd');
    case 'nonrigid'
        Transform.s=normal.xscale/normal.yscale;
        Transform.t=normal.xd'-Transform.s*normal.yd';
        Transform.W=Transform.W*normal.xscale;   
        Transform.beta=normal.yscale*Transform.beta;       
end
end
function G=cpd_G(x,y,beta)

%CPD_G Construct Gaussian affinity matrix
%   G=CPD_G(x,y,beta) returns Gaussian affinity matrix between x and y data
%   sets. If x=y returns Gaussian Gramm matrix.
%
%   Input
%   ------------------ 
%   x, y       real, full 2-D matrices. Rows represent samples. Columns
%               represent features.
%   
%   beta      std of the G.
%
%   Output
%   ------------------ 
%   G           Gaussian affinity matrix 
%
%   Examples
%   --------
%       x= [1 2; 3 4; 5 6;];
%       beta=2;
%       G=cpd_G(x,x,beta);
%
%   See also CPD_REGISTER.

% Copyright (C) 2006 Andriy Myronenko (myron@csee.ogi.edu)
%
%     This file is part of the Coherent Point Drift (CPD) package.
%
%     The source code is provided under the terms of the GNU General Public License as published by
%     the Free Software Foundation version 2 of the License.
% 
%     CPD package is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with CPD package; if not, write to the Free Software
%     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

if nargin<3, error('cpd_G.m error! Not enough input parameters.'); end;

k=-2*beta^2;
[n, d]=size(x); [m, d]=size(y);

G=repmat(x,[1 1 m])-permute(repmat(y,[1 1 n]),[3 2 1]);
G=squeeze(sum(G.^2,2));
G=G/k;
G=exp(G);
end
function [P1, Pt1, PX, L, sigma2, st]=cpd_Pfast(X,T,sigma2, outliers, sigma2_init, fgt)

switch fgt,
    case 1
        if sigma2<0.05, sigma2=0.05; end;
        [P1, Pt1, PX, L]=cpd_P_FGT(X, T, sigma2, outliers, sigma2_init); st='(FGT)';

    case 2
        if (sigma2 > 0.015*sigma2_init) % FGT sqrt(2/(N+M)
            [P1, Pt1, PX, L]=cpd_P_FGT(X, T, sigma2, outliers, sigma2_init); st='(FGT)';
        else
            % quite FGT, switch to the truncated kernel approximation
            [P1,Pt1, PX, L]=cpd_Pappmex(X,T, sigma2 ,outliers,1e-3);  st='(Truncated)';
        end
end
end
function [P1, Pt1, PX, L]=cpd_P_FGT(X, Y, sigma2, outliers, sigma2_init)

[N,D]=size(X);[M,D]=size(Y);
hsigma=sqrt(2*sigma2);
if outliers==0
   outliers=10*eps; 
end


% FGT parameters
e          = 9;      % Ratio of far field (default e = 10)
K          = round(min([N M 50+sigma2_init/sigma2])); % Number of centers (default K = sqrt(Nx))
p          = 6;      % Order of truncation (default p = 8)


%[e K p]

% computer Pt1 and denomP
[xc , A_k] = fgt_model(Y' , ones(1,M), hsigma, e,K,p);
Kt1 = fgt_predict(X' , xc , A_k , hsigma,e);

ndi=outliers/(1-outliers)*M/N*(2*pi*sigma2)^(0.5*D);
denomP=(Kt1+ndi);
Pt1=1-ndi./denomP;Pt1=Pt1';

% compute P1
[xc , A_k] = fgt_model(X' , 1./denomP, hsigma, e,K,p);
P1 = fgt_predict(Y' , xc , A_k , hsigma,e); P1=P1';

% compute PX
for i=1:D
 [xc , A_k] = fgt_model(X' , X(:,i)'./denomP, hsigma, e,K,p);
 PX(i,:) = fgt_predict(Y' , xc , A_k , hsigma,e); 
end
PX=PX';


L=-sum(log(denomP))+D*N*log(sigma2)/2;
end
function cpd_plot_iter(X, Y, C)

%   CPD_PLOT(X, Y, C); plots 2 data sets. Works only for 2D and 3D data sets.
%
%   Input
%   ------------------ 
%   X           Reference point set matrix NxD;
%   Y           Current postions of GMM centroids;
%   C           (optional) The correspondence vector, such that Y corresponds to X(C,:) 
%
%   See also CPD_REGISTER.

% Copyright (C) 2007 Andriy Myronenko (myron@csee.ogi.edu)
%
%     This file is part of the Coherent Point Drift (CPD) package.
%
%     The source code is provided under the terms of the GNU General Public License as published by
%     the Free Software Foundation version 2 of the License.
% 
%     CPD package is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with CPD package; if not, write to the Free Software
%     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

if nargin<2, error('cpd_plot.m error! Not enough input parameters.'); end;
[m, d]=size(Y);

if d>3, error('cpd_plot.m error! Supported dimension for visualizations are only 2D and 3D.'); end;
if d<2, error('cpd_plot.m error! Supported dimension for visualizations are only 2D and 3D.'); end;

% for 2D case
if d==2,
   plot(X(:,1), X(:,2),'r*', Y(:,1), Y(:,2),'bo'); %axis off; axis([-1.5 2 -1.5 2]);
else
% for 3D case
   plot3(X(:,1),X(:,2),X(:,3),'r.',Y(:,1),Y(:,2),Y(:,3),'bo'); % title('X data (red). Y GMM centroids (blue)');set(gca,'CameraPosition',[15 -50 8]);
end

% plot correspondences
if nargin>2,
    hold on;
    if d==2,
        for i=1:m,
            plot([X(C(i),1) Y(i,1)],[X(C(i),2) Y(i,2)]);
        end
    else
        for i=1:m,
            plot3([X(C(i),1) Y(i,1)],[X(C(i),2) Y(i,2)],[X(C(i),3) Y(i,3)]);
        end
    end
    hold off;
end

drawnow;
end
function R=cpd_R(a,b,g)

if nargin==1
    R=rot(a);
end

if nargin==3

    R1=eye(3);
    R2=eye(3);
    R3=eye(3);

    R1(1:2,1:2)=rot(a);
    R2([1 3],[1 3])=rot(b);
    R3(2:3,2:3)=rot(g);

    R=R1*R2*R3;

end
end
function R=rot(a)

ca=cos(a);
sa=sin(a);

R=[ca -sa;
    sa ca];
end
function T=cpd_transform(Z, Transform)

switch lower(Transform.method)
    case {'rigid','affine'}
        T=Transform.s*(Z*Transform.R')+repmat(Transform.t',[size(Z,1) 1]);
    case {'nonrigid'}
        
        % because of normalization during the registration
        % these steps are necessary for non-rigid tranaformation
        Transform.beta=Transform.beta*Transform.normal.yscale;
        Transform.W=Transform.normal.xscale*Transform.W;
        Transform.shift=Transform.normal.xd-Transform.normal.xscale/Transform.normal.yscale*Transform.normal.yd;
        Transform.s=Transform.normal.xscale/Transform.normal.yscale;

        G=cpd_G(Z, Transform.Yorig,Transform.beta);
        T=Z*Transform.s+G*Transform.W+repmat(Transform.shift,size(Z,1),1);
        % T=Transform.s*Z+repmat(Transform.t',[size(Z,1) 1])+cpd_G(Z, Transform.Yorig,Transform.beta)*Transform.W;
    otherwise
        error('CPD: This transformation is not supported.')
end   
end
function disptime(t)

% Function for convinient display of time from 'toc'
% use disptime(toc)
%
% Andriy Myronenko
% Feb 10, 2006

if t<60
    s=t;
    m=0;h=0;
end

if (t>=60) && (t<3600)
    m=floor(t/60);
    s=t-m*60;
    h=0;
end

if t>=3600
    h=floor(t/3600);
    m=floor((t-3600*h)/60);
    s=t-h*3600-m*60;
end

disp(['Time =' num2str(h) ' hours ' num2str(m) ' minutes ' num2str(s) ' seconds ']);
end

% step 5 sub functions
function [data, sides3, nodes]=icsosoproj(p,stkname, stknum, facets, colmin, colmax)
%try isocaps, isosurface, reducepatch, patch

%stknum=1:6;
%stkname='bmp27overall';




%%  chd het homo timeseries




%---------------------------- load data -----------------------------------
for i=stknum
    load([stkname int2str(i) '_after_CPD.mat']);
    eval(['d' int2str(i) '=dataSTK' int2str(i) 'T;']);    
end

%-------------------- inner outer surface deletion ------------------------
% set options
opt.plot = p.avre_plot; 
opt.numper = p.avre_numper;

for i=stknum
    eval(['d = d' int2str(i) ';']);
    [idx_rem] = inoutsurf(d, opt);
    d = d(idx_rem, :);
    eval(['d' int2str(i) ' = d;']);

    clear d;
    saveas(gcf, [stkname int2str(i) '_after_surface_deletion'],'png');

end

data=[];
for i=stknum  %%%%%%%%centers each embryo on (0,0,0)
    eval(['datacur = d' int2str(i) ';']);

    [xc, yc, zc, R] = spherefit1(datacur(:,1),datacur(:,2),datacur(:,3));
    datacur(:,1) = datacur(:,1) - xc;    
    datacur(:,2) = datacur(:,2) - yc;
    datacur(:,3) = datacur(:,3) - zc;
    %datacur(:,4) = 1:size(datacur,1);  % 4th column encoded as index
    
    data=cat(1,data,datacur);             %puts all nuclei in one dataset
end

[~,~,~,R] = spherefit1(data(:,1),data(:,2),data(:,3));  %find average radius


%%%%%% makes phi and theta in spherical coordinates rows 6 and 7
data(:,6)=atand(data(:,2)./data(:,1));
data(:,7)=atand(((data(:,1).^2+data(:,2).^2).^.5)./data(:,3));
[negxposy]=find(data(:,1)<0 & data(:,2)>0);
[negxnegy]=find(data(:,1)<0 & data(:,2)<0);
data(negxposy,6)=data(negxposy,6)+180;
data(negxnegy,6)=data(negxnegy,6)-180;
%%%%%%%%%%%%%%%%%%%%
  

[sides3, node_xyz] = icosgenerate(facets);
nodes=node_xyz'*R;

nodes(:,4)=atand(nodes(:,2)./nodes(:,1));
nodes(:,5)=atand(((nodes(:,1).^2+nodes(:,2).^2).^.5)./nodes(:,3));
[negxposy]=find(nodes(:,1)<0 & nodes(:,2)>0);
[negxnegy]=find(nodes(:,1)<0 & nodes(:,2)<0);
nodes(negxposy,4)=nodes(negxposy,4)+180;
nodes(negxnegy,4)=nodes(negxnegy,4)-180;

for i=1:numel(data(:,1))
    phicur=data(i,6);
    thetacur=data(i,7);
      
    curdists=distance(thetacur, phicur, nodes(:,5),nodes(:,4));
    [distval,distindex]=sort(curdists);
    
    data(i,8)=distindex(1);
    data(i,9)=distindex(2);
    data(i,10)=distindex(3);
    
    data(i,11)=distval(1);
    data(i,12)=distval(2);
    data(i,13)=distval(3);
end
    
for i=1:numel(data(:,1))
    data(i,8:10)=sort(data(i,8:10));
end



trisurf(sides3,nodes(:,1),nodes(:,2),nodes(:,3))
colormap(hsv)
caxis([colmin colmax])
axis equal

%legend([['min ' num2str(colmin)], ['max ' num2str(colmax)]], ) 

end
function [xc,yc,zc,R,a] = spherefit1(x,y,z)

% sphere surface fit in the x, y, z space for nuclei cloud data. Wei Dou 5/8/13
% [xc, yc, ac, R, a] = spherefit1(x,y,z)
% Result is center point (yc,xc,zc) and radius R.A is an 
% optional output describing the circle's equation:
%
% x^2+y^2+z^2+a(1)*x+a(2)*y+a(3)*z +a(4) = 0

n = length(x); 
xx=x.*x; 
yy=y.*y;
zz=z.*z;
xy=x.*y;
xz=x.*z;
yz=y.*z;

A = [sum(xx) sum(xy) sum(xz) -sum(x); ...
     sum(xy) sum(yy) sum(yz) -sum(y); ...
     sum(xz) sum(yz) sum(zz) -sum(z); ...
     -sum(x) -sum(y) -sum(z) n];
B = [sum(x.*(xx+yy+zz)); sum(y.*(xx+yy+zz)); sum(z.*(xx+yy+zz)); -sum(xx+yy+zz)];
a = A\B;
xc = a(1)/2;
yc = a(2)/2;
zc = a(3)/2;
R = sqrt((a(1)^2 + a(2)^2 + a(3)^2)/4-a(4));
end
function [sides3, node_xyz] = icosgenerate(facets)

%input the number of facets you want, recommended is 7.  The icosohedral
%will have 20 * facets * facets number of facets.  
%
%side3 is a list of the vertices of all unique trangular facets. the vertice xyz coordinates are in 'node_xyz'.   

node_xyz = sphere_icos2_points ( facets, 20 );


combos=[];

for i= 1:numel(node_xyz(1,:))
%for i=1
    xcur=node_xyz(1,i);
    ycur=node_xyz(2,i);
    zcur=node_xyz(3,i);
    
    for ii= 1:numel(node_xyz(1,:))
        %h=((xcur-node_xyz(1,:)).^2+(ycur-node_xyz(2,:)).^2+(zcur-node_xyz(3,:).^2)).^.5;
        h(ii)=pdist([xcur,ycur,zcur;node_xyz(1,ii),node_xyz(2,ii),node_xyz(3,ii)]) ;      
    end
    
    
    [p,r]=sort(h);
    
    allcurcombs=combntns(r(1:7),3);
    kk=find(allcurcombs(:,1) == i | allcurcombs(:,2) == i | allcurcombs(:,3) == i);
    curcombsout=allcurcombs(kk,:);
    
    combos = cat(1,combos,curcombsout);

              %combos=indicies of all triabges made by each point with its
              %5 nearest nieghbors
       
end
combosu=unique(combos, 'rows');
for i=1:numel(combosu(:,1))
    combosu2(i,:)=sort(combosu(i,:));
end
combosu=unique(combosu2, 'rows');

for i=1:numel(combosu(:,1))
    x1cur=node_xyz(1,combosu(i,1));
    y1cur=node_xyz(2,combosu(i,1));
    z1cur=node_xyz(3,combosu(i,1));
    
    x2cur=node_xyz(1,combosu(i,2));
    y2cur=node_xyz(2,combosu(i,2));
    z2cur=node_xyz(3,combosu(i,2));
    
    x3cur=node_xyz(1,combosu(i,3));
    y3cur=node_xyz(2,combosu(i,3));
    z3cur=node_xyz(3,combosu(i,3));
    
    curdist=pdist([x1cur, y1cur, z1cur;x2cur,y2cur,z2cur;x3cur,y3cur, z3cur]);
    
    halfper=(curdist(1)+curdist(2)+curdist(3))/2;
    areacur=(halfper*(halfper-curdist(1))*(halfper-curdist(2))*(halfper-curdist(3)))^.5;
    
    sideqs=abs((curdist(1)-curdist(2)))+abs((curdist(1)-curdist(3)));
    
    combosu(i,4)=curdist(1);
    combosu(i,5)=curdist(2);
    combosu(i,6)=curdist(3);
   combosu(i,7)=sideqs;
   combosu(i,8)=areacur;

end
mode(combosu(:,4))
%vv=find(combosu(:,4) == p(2) & combosu(:,5) == p(2) & combosu(:,6) == p(2));
%vv=find(combosu(:,7) < .06);
%sides=combosu(vv,:);


combosu=sortrows(combosu,7);
vertices=facets*facets*20;
sides=combosu(1:vertices,:);

sides3=sides(:,[1:3]);


end

% Step 6 sub functions
function icosograph(sides3, nodes)

%icosdisplay(sides3, nodes, 4, 0, 160)
%title('P-Smad Intensity')

%icosdisplay(sides3, nodes, 6, 0, 1)
%title('Coefficient of Variance')

icosdisplay(sides3, nodes, 7, 0, 30)
title('Number of Nuclei')

icosdisplay(sides3, nodes, 12, 0, 140)
title('P-Smad Intensity')

%icosdisplay(sides3, nodes, 25, 0, 30)
%title('Coefficient of Variance')

%icosdisplay(sides3, nodes, 15, 0, max(sides3(:,15)))
%title('Number of Nuclei')

end
function [sign]=TTestV1(data1, data2, symb, col1, col2,perc, bandwth, stepsz,displ)
linesz=8;

[profile1, databand1, R1, allout1]=sigmaXV5S(data1, symb, col1, perc, bandwth, stepsz,displ,linesz,2);
[profile2, databand2, R1, allout2]=sigmaXV5S(data2, symb, col2, perc, bandwth, stepsz,displ,linesz-1,2);

means1=allout1{1,3};
means2=allout2{1,3};
nums=mean(allout1{1,1},2);
for i=1:numel(nums(:,1))
    sign(i)=ttest2(means1(i,:),means2(i,:),.05);
end


meanmean1=nanmean(means1,2);
meanmean2=nanmean(means2,2);

figure(40)
hold on
for i=1:numel(nums(:,1))
    if isnan(sign(i))==0
        if sign(i)==0     
            plot(nums(i,1), meanmean1(i,1), 'o', 'Color', [0,0,0], 'Markersize', 25,'MarkerFaceColor',[1,1,1],'LineWidth', 3)
        end
        if sign(i)==1
            plot(nums(i,1), meanmean1(i,1), 'o', 'Color', [0,0,0], 'Markersize', 25,'MarkerFaceColor',[.2,.2,.2],'LineWidth', 3)
        end
    end
end

end
function [profile, databand, R, allout]=sigmaXV5S(data, symb, col, perc, bandwth, stepsz,displ,linesz, disptyp)

%disptyp=2;

%----------------------- 1D VLD profile extraction ------------------------
pp=0;
for i=unique(data(:,4))'
    pp=pp+1;
    dcur=data(:,4)==i;
    
        % estimate eta at the margin
    percent=perc;
    eta = eta_est(data(dcur,1:3), percent);
    
  
    [profile{i}, databand{i}, R(pp)] = profile_extraction_1D_JZ(data(dcur,:), eta,bandwth,stepsz,displ);    
%    profiletop = profile_extraction_vert_VLD(d, bandwidth);


 
end
R=nanmean(R);
%{
%% fits a line to each curve using a smoothing spline
    xall=-175:.1:185;

for i=unique(data(:,4))'
    datacur=databand{i};
    datacur(:,13)=datacur(:,13)*180/pi;
    fitobject{i}=fit(datacur(:,13),datacur(:,5), 'smoothingspline',  'SmoothingParam', .000001);    
%% extracts the int values of the profile every .1 degrees from -180 to 180    
    fitint{i} = feval(fitobject{i},xall);
end
%}
z=0;

for i=unique(data(:,4))'
z=z+1;
data=databand{i};

data(:,13)=data(:,13).*180/pi;
    
  j=0;  
for i=-180:stepsz:(180-stepsz)

    cur=data(:,13)>=i & data(:,13)<=i+stepsz  | data(:,13)<=-i & data(:,13)>=-i-stepsz ;
  
    %if numel(data(cur,18))>0
            j=j+1;
            
        curRME=(sum(data(cur,17).^2).*1/numel(data(cur,17)))^.5;
        %curmeansig=nanmedian( abs(abs(data(cur,20)).^-1.*data(cur,17)) )*180/pi;
        
        %curmeansig=nanmean(abs(data(cur,18))).^-1.*curRME*180/pi;
        curRME=((curRME./nanmean(data(cur,16)))^2-.1^2)^.5*nanmean(data(cur,16));
        curmeansig=nanmean(abs(data(cur,18))).^-1.*curRME*180/pi;
        
        
        curmeanslp=nanmedian(abs(data(cur,18))).*pi/180;
        curmeanint=nanmean(data(cur,5));
        %curmeanCOV=nanmedian(data(cur,17))./nanmean(data(cur,16));
        %curmeanCOV=(sum((data(cur,17))./nanmean(data(cur,16)).^2)./numel(data(cur,16))).^.5;
    
        
        curmeanCOV=curRME./nanmean(data(cur,16));
        curalln(j,z)=(i+round(stepsz/2));
        curallsig(j,z)=curmeansig./180;
        curallslp(j,z)=curmeanslp;
        curallint(j,z)=curmeanint;
        curallCOV(j,z)=curmeanCOV;
   % end

end

if disptyp==3
    figure(20)
    hold on
    plot(curalln(:,z),curallsig(:,z),':', 'Color', col, 'LineWidth', 2, 'Markersize', 9)    

    figure(30)
    hold on
    plot(curalln(:,z),curallslp(:,z),':', 'Color', col, 'LineWidth', 2, 'Markersize', 9)    

    figure(40)
    hold on
    plot(curalln(:,z),curallint(:,z),':', 'Color', col, 'LineWidth', 2, 'Markersize', 9)    

    figure(50)
    hold on
    plot(curalln(:,z),curallCOV(:,z),':', 'Color', col, 'LineWidth', 2, 'Markersize', 9)    

end

end
if disptyp==1
    figure(20)
    hold on
    plot(nanmean(curalln,2),nanmean(curallsig,2),symb, 'Color', col, 'LineWidth', 3.5, 'Markersize', 13)
    axis([-180,180,0,50])
    figure(30)
    hold on
    plot(nanmean(curalln,2),nanmean(curallslp,2),symb, 'Color', col, 'LineWidth', 3.5, 'Markersize', 13)
    axis([-180,180,0,1.5])

    figure(40)
    hold on
    plot(nanmean(curalln,2),nanmean(curallint,2),symb, 'Color', col, 'LineWidth', 3.5, 'Markersize', 13)
    axis([-180,180,0,120])
    grid on
    
    figure(50)
    hold on
    plot(nanmean(curalln,2),nanmean(abs(curallCOV),2),symb, 'Color', col, 'LineWidth', linesz, 'Markersize', 7, 'MarkerFaceColor', col)
    set(gca,'FontSize',32)
    axis([-180,180,0,.5])
end

if disptyp==2
    figure(20)
    hold on
    %errorbar(nanmean(curalln,2),nanmean(curallsig,2),nanstd(curallsig,0,2),symb, 'Marker', 'o', 'Color', col, 'LineWidth', linesz, 'Markersize', 7, 'MarkerFaceColor', col)
    plot(nanmean(curalln,2),nanmean(curallsig,2),symb, 'Marker', 'o', 'Color', col, 'LineWidth', linesz, 'Markersize', 7, 'MarkerFaceColor', col)
   
    set(gca,'FontSize',32)
    axis([-180,180,0,.2])
    grid on
    figure(30)
    hold on
    %errorbar(nanmean(curalln,2),nanmean(curallslp,2),nanstd(curallslp,0,2),symb, 'Marker', 'o', 'Color', col, 'LineWidth', linesz, 'Markersize', 7, 'MarkerFaceColor', col)
    plot(nanmean(curalln,2),nanmean(curallslp,2),symb, 'Marker', 'o', 'Color', col, 'LineWidth', linesz, 'Markersize', 7, 'MarkerFaceColor', col)
    grid on
    set(gca,'FontSize',32)
    axis([-180,180,0,1.5])

    figure(43)
    hold on
    errorbar(nanmean(curalln,2),nanmean(curallint,2)-8.8,nanstd(curallint,0,2),symb, 'Marker', 'o', 'Color', col+.1, 'LineWidth', linesz, 'Markersize', 7, 'MarkerFaceColor', col)
    plot(nanmean(curalln,2),nanmean(curallint,2)-8.8,symb, 'Marker', 'o', 'Color', col, 'LineWidth', linesz+1, 'Markersize', 5, 'MarkerFaceColor', col)
    grid on
    set(gca,'FontSize',32)
    axis([-180,180,0,125])
    
    figure(50)
    hold on
    %errorbar(nanmean(curalln,2),nanmean(abs(curallCOV),2),nanstd(abs(curallCOV),0,2),symb, 'Marker', 'o', 'Color', col, 'LineWidth', linesz, 'Markersize', 7, 'MarkerFaceColor', col)
    %plot(nanmean(curalln,2),nanmean(abs(curallCOV),2),symb, 'Marker', 'o', 'Color', col, 'LineWidth', linesz+1, 'Markersize', 7, 'MarkerFaceColor', col)
    plot(nanmean(curalln,2),nanmean(abs(curallCOV),2),symb, 'Color', col, 'LineWidth', linesz+1, 'Markersize', 7, 'MarkerFaceColor', col)

    grid on
    set(gca,'FontSize',32)
    axis([-180,180,0,.5])
end


allout{1}=curalln;
allout{2}=curallslp;
allout{3}=curallint;
allout{4}=curallCOV;
end
function icosdisplay(sides3, nodes, col, colmin, colmax)
%% display function for 'icosoproj' outputs
%'side3' is a matrix, each row is a face, columns 1-3 are vertices, column
%4 is psmad mean, column 5 is standard deviation, column 6 is coefficient
%of variance, column 7 is  number of nuclei
%'nodes' is the vertice xyz data refered to by sides3(1:3,:)
%'col' is the column to be displayed, 4 for mean, 5 std, 6 COV, 7 # of
%nuclei
%'colmin' is minimum value on colorscale
%'colmax' is max value on colorscale
%
%note: facets with less than 30% of the mean nuclei per facet are not
%displayed


figure
hold on

%% sets the lower bound for number of nuclei per facet
zs=sides3(:,15)==0;
sides3(zs,:)=NaN;
zlocs=nanmean(sides3(:,11));
lowerbound=nanmean(sides3(:,7))*.1;
%std(sides3(:,7))

%% prints each facet individually, as long as it is not NaN and above 30% of the mean in # of nuclei
for i=1:numel(sides3(:,1))
     if sides3(i,7) > lowerbound || sides3(i,11)>zlocs

   % if isnan(sides3(i,col)) == 0
        trisurf(sides3(i,1:3),nodes(:,1),nodes(:,2),nodes(:,3), sides3(i,col), 'EdgeColor', 'none')
        %trisurf(sides3(i,1:3),nodes(:,1),nodes(:,2),nodes(:,3), 1, 'EdgeColor', 'none')
    %end
    end
end
hold on
colormap(hsv)
axis([-300 300 -300 300 -100 300])
caxis([colmin colmax])
axis equal



end
function eta = eta_est(data, percent)

% Function Name: eta_est  (Version 1.0)
% Author: Wei Dou
% Date: 8/25/2013
%
% Functionality:
%    This function reads in 3D nuclei cloud data after plane regression &
% adjustment, dv plane finding & rotation, and YSL deletion. An eta angle 
% value characterizing the degree of the cloud cap away from (either less 
% or more than) a hemispherical cap is calculated and returned. 
% 
% Inputs:
%     data - 3D (x,y,z) nuclei cloud data 
%     percent - percentage of the A/P range (z distance from the nucleus
%               point with the largest z coordinate to that with the
%               smallest z coordinate) used to estimate the posterior margin 
%               z coordinate of the cloud cap for calculation of eta, 
%               default = 0.05
% Output:
%     eta - the angle of the cloud cap away from a hemispherical cap. If
% it is exactly hemispherical, eta = 0. If less, eta ~ (0 to 90). If more,
% eta ~ (0 to -90).

% check inputs and set defaults
if nargin<1, error('Error! No input arguments.'); end
if nargin==1, percent = 0.05; end 

% fit spherical surface to the cloud data
[~, ~, zc, R] = spherefit1(data(:,1),data(:,2),data(:,3));

% calculate the z coordinate of the posterior margin
max_z = max(data(:,3));
min_z = min(data(:,3));
zrange =  max_z - min_z; 
z_margin = min_z + zrange * percent;

% calculate eta
eta = asin((z_margin - zc)/R)/pi*180;

end
function [profile, data_band, R] = profile_extraction_1D_JZ(data, eta, bandwidth, binsize, plotornot, col)

% Function Name: profile_extraction_1D_VLD
% Authour: Wei Dou 
% Update date: 9/8/2013
%
% Functionality:
%    This function takes 4D nuclei point hemisphere data (x,y,z,Intensity)
% from zebrafish embryo as the input, estimate a 1D P-Smad intensity profile 
% for a band (-180 to 180 degrees) from a specific eta. The data set input
% should have been adjusted fro D/V plane, CPD registered, and had inner and 
% outer surface nuclei deleted.
% 
% Inputs:
%       data - 5D (x,y,z, H3 intensity,P-smad intensity) nuclei cloud data 
%       degree - 0:degree:360 to define # of space elements, default = 5
%       eta - degree away from an exact hemisphere for band position in the
%             z axis. if not given, eta is estimated as the posterior margin 
%       bandwidth - micron length in the z direction to determine a band for 
%                   VLD profile extraction, default = 40 
%       binsize - size (angle degree) for each record postion for mean
%                 intensity calculation, default = 10, (then 180:10:180)
%       plotornot - (0 or 1), 1 means to plot. Plot and highlight the band
%                 of data used for profile extraction. default = 0
% Output:
%       profile - profile matrix with each row as [degree position, mean, sem]
%       data_band - the data band selected for 1D profile extraction

% check inputs and set defaults
if nargin<1, error('Error! No input arguments.'); end
if nargin==1, eta = eta_est(data); bandwidth = 40; binsize = 10; plotornot = 1;col = [1,0,0]; end 
if nargin==2, bandwidth = 40; binsize = 10; plotornot = 1;col = [1,0,0]; end
if nargin==3, binsize = 10; plotornot = 1;col = [1,0,0]; end
if nargin==4, plotornot = 0; col = [1,0,0]; end
if nargin==5, col = [1,0,0]; end

if rem(180,binsize)
   error('Error! Input binsize(angle degree) must be exactly divided by 180'); 
end

% fit mean sphere surface of all points and translate the data set accordingly
[xc, yc, zc, R] = spherefit1(data(:,1),data(:,2),data(:,3));
data(:,1) = data(:,1) - xc;    
data(:,2) = data(:,2) - yc;
data(:,3) = data(:,3) - zc;
data(:,4) = 1:size(data,1);  % 4th column encoded as index

% lower margin position(z coordinate) for the band to be chosen for eta defined
MagnPos = R * sin(eta/180*pi);  

% select the data band for 1D profile extraction
datarecord = data;
data = data((data(:,3) >= MagnPos) & (data(:,3) <= MagnPos + bandwidth), :);
% plot data_band
if plotornot
   figure
   plot3(datarecord(:,1),datarecord(:,2),datarecord(:,3),'.', 'MarkerEdgeColor', [0,0,0], 'MarkerSize', 10); 
   hold on;
   plot3(data(:,1),data(:,2),data(:,3),'.', 'MarkerEdgeColor', col, 'MarkerSize', 10);    
   hold on;
end

% obtain output angle postion vector
pos = [(-180+binsize/2):binsize:(180-binsize/2)]';

% initialize output mean intensity vectors
Minten1 = []; % for 0 to 180
Minten2 = []; % for 0 to -180

% initialize output std intensity vectors
Sinten1 = []; % for 0 to 180
Sinten2 = []; % for 0 to -180

% start generating profile
for alpha=binsize:binsize:180
    
    % select nuclei points in each space slice element rotating along the z axis 
    kf1 = tan((180-alpha)/180*pi);
    kb1 = tan((180-alpha+binsize)/180*pi);
    kf2 = tan(alpha/180*pi);
    kb2 = tan((alpha-binsize)/180*pi);
    xvec = data(:,1);
    yvec = data(:,2);    

    % for 0 to 180
    if kb1==0
       bool_row1 = xvec<yvec/kf1 & yvec>=0;
    elseif kf1==0
       bool_row1 = xvec>=yvec/kb1 & yvec>0; 
    else
       bool_row1 = xvec>=yvec/kb1 & xvec<yvec/kf1;
    end
    Minten1 = [Minten1 mean(data(bool_row1, 5))];
    Sinten1 = [Sinten1 median(abs(data(bool_row1, 17)))];

    % for 0 to -180
    if kb2==0
       bool_row2 = xvec<yvec/kf2 & yvec<0;
    elseif kf1==0
       bool_row2 = xvec>=yvec/kb2 & yvec<0; 
    else
       bool_row2 = xvec>=yvec/kb2 & xvec<yvec/kf2;
    end
    Minten2 = [Minten2 mean(data(bool_row2, 5))];
    Sinten2 = [Sinten2 median(abs(data(bool_row2, 17)))];
end

% reverse Minten2 and Sinten2
n = size(Minten2,2);
Minten20 = zeros(1,n);
Sinten20 = zeros(1,n);

for i=1:n
    Minten20(i) = Minten2(n-i+1);
    Sinten20(i) = Sinten2(n-i+1);
end
Minten = [Minten20 Minten1]';
Sinten = [Sinten20 Sinten1]';

% get profile matrix and return
profile = [pos Minten Sinten];
profile = cat(1, profile, [profile(size(profile,1),1)+binsize profile(1,2:3)]);

% plot(profile(:,1), profile(:,2)); 

% get data band
data_band = data;

end
