function varargout = statanalysis(varargin)
% STATANALYSIS MATLAB code for statanalysis.fig
%      STATANALYSIS, by itself, creates a new STATANALYSIS or raises the existing
%      singleton*.
%
%      H = STATANALYSIS returns the handle to a new STATANALYSIS or the handle to
%      the existing singleton*.
%
%      STATANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STATANALYSIS.M with the given input arguments.
%
%      STATANALYSIS('Property','Value',...) creates a new STATANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before statanalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to statanalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help statanalysis

% Last Modified by GUIDE v2.5 07-Aug-2014 18:55:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @statanalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @statanalysis_OutputFcn, ...
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

% --- Executes just before statanalysis is made visible.
function statanalysis_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to statanalysis (see VARARGIN)

% Choose default command line output for statanalysis
handles.output = hObject;

% Update handles structure
soundx=0:0.1:100;
soundy=sin(soundx.^2);
handles.errsound=[soundy,5500];

handles.filepath=0;
handles.fulldata=0;
handles.bandapp=0;
handles.spanrun=0;
set(handles.bandnum_ed,'String',1)
handles.bandwd=1;
handles.stat=zeros(8,1);
handles.kernname='';
handles.krnmin=0;
set(handles.klimmin_ed,'String',0)
handles.krnmax=500;
set(handles.klimmax_ed,'String',500)
handles.krnstep=0.1;
set(handles.klimstep_ed,'String',0.1)
set(handles.stat_tbl,'Data',handles.stat)
handles.perc_events=0.75;
handles.plotchk=0;
handles.areachk=0;
guidata(hObject, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = statanalysis_OutputFcn(~, ~, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function import_ed_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function bandnum_ed_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function klimmin_ed_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function klimmax_ed_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function klimstep_ed_CreateFcn(hObject, ~, ~) %#ok<*DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function spannum_ed_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function graphsel_ppm_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------        Callbacks        --------------------------

% --- Executes on button press in browseBut.
function browseBut_Callback(hObject, ~, handles)

dirin=get(handles.import_ed,'String');
dirout=uigetfile(dirin,'Choose directory...');
set(handles.import_ed,'String',dirout)
handles.filepath=get(handles.import_ed,'String');
guidata(hObject,handles)
end

function import_ed_Callback(hObject, ~, handles) %#ok<*DEFNU,*DEFNU>

handles.filepath=get(hObject,'String');
guidata(hObject,handles)
end

% --- Executes on button press in import_but.
function import_but_Callback(hObject, ~, handles)

% Check if input path variable has been created 
if handles.filepath==0
    handles.filepath=get(handles.import_ed,'String');
end

% Check if path is correct
checkpath=exist(handles.filepath,'file');
if checkpath==0 % if path doesn't exist
    sound(handles.errsound)
    set(handles.status_tx,'String','ERR',...
        'BackgroundColor',[1,0,0])
    guidata(hObject,handles)
    pause(0.01)
    disp('Wrong file path! File doesn''t exist in the specified folder.')
    disp('Please input correct file path to proceed.')

elseif checkpath==2 %if input is a correct file path
    set(handles.status_tx,'String','OK',...
        'BackgroundColor',[0,1,0])
    guidata(hObject,handles)
    pause(0.01)
    load(handles.filepath)
    handles.fulldata=fulldata;

elseif checkpath==7 % if input is a folder
    handles.filepath=fullfile(handles.filepath,'fulldata.mat'); % Assume file name as 'fulldata.mat'
    if exist(handles.filepath,'file')~=2 % if fullfile doesn't exist
        sound(handles.errsound)
        set(handles.status_tx,'String','ERR',...
            'BackgroundColor',[1,0,0])
        guidata(hObject,handles)
        pause(0.01)
        disp('Wrong folder path! File fulldata.mat doesn''t exist in the specified folder.')
        disp('Please input the complete file path to proceed.')
    else %retrieve fulldata
        set(handles.status_tx,'String','OK',...
            'BackgroundColor',[0,1,0])
        guidata(hObject,handles)
        pause(0.01)
        load(handles.filepath)
        handles.fulldata=fulldata;
    end
    
elseif checkpath==1 %if input is a variable in the workspace
    set(handles.status_tx,'String','OK',...
        'BackgroundColor',[0,1,0])
    guidata(hObject,handles)
    pause(0.01)
    handles.fulldata=handles.filepath;

else %all other cases
    sound(handles.errsound)
    set(handles.status_tx,'String','ERR',...
        'BackgroundColor',[1,0,0])
    guidata(hObject,handles)
    pause(0.01)
    disp('Wrong file type! Unable to load specified file.')
    disp('Please input a valid *.mat file path.')
end
disp(checkpath)

% Calculate data to display in stats table
% stat: Number of points;     (1)
%       Average;              (2)
%       Std deviation;        (3)
%       Median;               (4)
%       Maximum;              (5)
%       Minimum;              (6)
%       1st quartile;         (7)
%       3rd quartile;         (8)

if handles.fulldata~=0
    handles.fulldata=sort(handles.fulldata);
    [handles.stat(1),~]=size(handles.fulldata);
    handles.stat(2)=mean(handles.fulldata);
    handles.stat(3)=std(handles.fulldata);
    handles.stat(4)=median(handles.fulldata);
    handles.stat(5)=max(handles.fulldata);
    handles.stat(6)=min(handles.fulldata);
    quartils=round([handles.stat(1)/4,handles.stat(1)*3/4]);
    handles.stat(7)=handles.fulldata(quartils(1));
    handles.stat(8)=handles.fulldata(quartils(2));
    set(handles.stat_tbl,'Data',handles.stat)
end
guidata(hObject,handles)
end

% --- Executes on button press in reset_but.
function reset_but_Callback(hObject, ~, handles)

%Add rest after code is complete
handles.fulldata=0;
handles.bandapp=0;
handles.spanrun=0;
handles.krnmin=0;
set(handles.klimmin_ed,'String',0)
handles.krnmax=500;
set(handles.klimmax_ed,'String',500)
handles.krnstep=0.1;
set(handles.klimstep_ed,'String',0.1)
set(handles.bandnum_ed,'String',1)
handles.bandwd=1;
handles.stat=zeros(9,1);
set(handles.stat_tbl,'Data',handles.stat)
handles.perc_events=0.75;
set(handles.spannum_ed,'String',0.75)
cla reset
handles.plotchk=0;
handles.areachk=0;
guidata(hObject,handles)
end

% --- Executes on button press in bandsilv_but.
function bandsilv_but_Callback(hObject, ~, handles)

handles.bandwd=(4*handles.stat(3)^5/3/handles.stat(1))^(1/5);
set(handles.bandnum_ed,'String',handles.bandwd)
guidata(hObject,handles)
end

% --- Executes when editing bandnum_ed
function bandnum_ed_Callback(hObject, ~, handles)

handles.bandwd=str2double(get(hObject,'String'));
guidata(hObject,handles)
end

% --- Executes when editing klimmin_ed
function klimmin_ed_Callback(hObject, ~, handles)

handles.krnmin=str2double(get(hObject,'String'));
checklim=(handles.krnmax-handles.krnmin)/handles.krnstep;
if ceil(checklim)~=floor(checklim)
    set(handles.status_tx,'String','ERR',...
        'BackgroundColor',[1,0,0])
    guidata(hObject,handles)
else
    set(handles.status_tx,'String','OK',...
        'BackgroundColor',[0,1,0])
    guidata(hObject,handles)
end
guidata(hObject,handles)
end

% --- Executes when editing klimmax_ed
function klimmax_ed_Callback(hObject, ~, handles)

handles.krnmax=str2double(get(hObject,'String'));
checklim=(handles.krnmax-handles.krnmin)/handles.krnstep;
if ceil(checklim)~=floor(checklim)
    set(handles.status_tx,'String','ERR',...
        'BackgroundColor',[1,0,0])
    guidata(hObject,handles)
else
    set(handles.status_tx,'String','OK',...
        'BackgroundColor',[0,1,0])
    guidata(hObject,handles)
end
guidata(hObject,handles)
end

% --- Executes when editing klimstep_ed
function klimstep_ed_Callback(hObject, ~, handles)

handles.krnstep=str2double(get(hObject,'String'));
checklim=(handles.krnmax-handles.krnmin)/handles.krnstep;
if ceil(checklim)~=floor(checklim)
    set(handles.status_tx,'String','ERR',...
        'BackgroundColor',[1,0,0])
    guidata(hObject,handles)
else
    set(handles.status_tx,'String','OK',...
        'BackgroundColor',[0,1,0])
    guidata(hObject,handles)
end
guidata(hObject,handles)
end

% --- Executes on button press in bandapp_but.
function bandapp_but_Callback(hObject, ~, handles)

if handles.fulldata==0
    sound(handles.errsound)
    set(handles.status_tx,'String','ERR',...
        'BackgroundColor',[1,0,0])
    guidata(hObject,handles)
    disp('Data file not imported yet!')
    disp('Please import the data file before running the density estimation!')

elseif handles.fulldata~=0
    set(handles.status_tx,'String','OK',...
            'BackgroundColor',[0,1,0])
    guidata(hObject,handles)
    pause(0.01)
    
    if handles.plotchk~=0
        delete(handles.dataplot)
    end
    if handles.areachk~=0
        delete(handles.areaplot)
        handles.areachk=0;
    end

    handles.bandapp=1;

    checklim=(handles.krnmax-handles.krnmin)/handles.krnstep;
    if ceil(checklim)~=floor(checklim)
        sound(handles.errsound)
        set(handles.status_tx,'String','ERR',...
            'BackgroundColor',[1,0,0])
        guidata(hObject,handles)
        disp('Limits are not valid!')
        disp('''(Minimum + Maximum) / Step'' must be an integer')

    else
        [row,~]=size(handles.fulldata);
        handles.x=(handles.krnmin:handles.krnstep:handles.krnmax);
        [~,x_size]=size(handles.x);
        dabax=zeros(row,x_size);
        for i=1:row
            for j=1:x_size
                dabax(i,j)=(handles.x(j)-handles.fulldata(i))/handles.bandwd;
            end
        end
        dens_table=zeros(row,x_size);

        % Gaussian kernel
        if get(handles.kgauss_rad,'Value')==1
            handles.kernname='Gaussian';
            for i=1:row
                for j=1:x_size
                    dens_table(i,j)=1/sqrt(2*pi)*exp(-1/2*dabax(i,j)^2);
                end
            end

        % Uniform kernel     
        elseif get(handles.kunif_rad,'Value')==1
            handles.kernname='Uniform';
            for i=1:row
                for j=1:x_size
                    if abs(dabax(i,j))<=1
                        dens_table(i,j)=1/2;
                    end
                end
            end

        % Triangular kernel
        elseif get(handles.ktriang_rad,'Value')==1
            handles.kernname='Triangular';
            for i=1:row
                for j=1:x_size
                    if abs(dabax(i,j))<=1
                        dens_table(i,j)=1-abs(dabax(i,j));
                    end
                end
            end

        % Epanechnikov kernel
        elseif get(handles.kepane_rad,'Value')==1
            handles.kernname='Epanechnikov';
            for i=1:row
                for j=1:x_size
                    if abs(dabax(i,j))<=1
                        dens_table(i,j)=3/4*(1-(dabax(i,j))^2);
                    end
                end
            end

        % Biweight kernel
        elseif get(handles.kbiwei_rad,'Value')==1
            handles.kernname='Biweight';
            for i=1:row
                for j=1:x_size
                    if abs(dabax(i,j))<=1
                        dens_table(i,j)=15/16*(1-(dabax(i,j))^2)^2;
                    end
                end
            end

        % Triweight kernel
        elseif get(handles.ktriwei_rad,'Value')==1
            handles.kernname='Triweight';
            for i=1:row
                for j=1:x_size
                    if abs(dabax(i,j))<=1
                        dens_table(i,j)=35/32*(1-(dabax(i,j))^2)^3;
                    end
                end
            end

        % Tricube kernel
        elseif get(handles.ktricub_rad,'Value')==1
            handles.kernname='Tricube';
            for i=1:row
                for j=1:x_size
                    if abs(dabax(i,j))<=1
                        dens_table(i,j)=70/81*(1-abs(dabax(i,j))^3)^3;
                    end
                end
            end

        % Cosine kernel
        elseif get(handles.kcosin_rad,'Value')==1
            handles.kernname='Cosine';
            for i=1:row
                for j=1:x_size
                    if abs(dabax(i,j))<=1
                        dens_table(i,j)=pi/4*cos(pi/2*dabax(i,j));
                    end
                end
            end
        end
        handles.data=sum(dens_table)/(row*handles.bandwd);
        handles.dataplot=plot(handles.x,handles.data,'k');
        handles.plotchk=1;
    end
end
guidata(hObject,handles)
end

% --- Executes when editing klimmax_ed
function spannum_ed_Callback(hObject, ~, handles)

handles.perc_events=str2double(get(hObject,'String'));
guidata(hObject,handles)
end

% --- Executes on button press in spanrun_but.
function spanrun_but_Callback(hObject, ~, handles)

if handles.bandapp==0
    sound(handles.errsound)
    set(handles.status_tx,'String','ERR',...
        'BackgroundColor',[1,0,0])
    pause(0.01)
    guidata(hObject,handles)
    disp('Density estimation not done yet!')
    disp('Please run the density estimation before running the span detection!')

elseif handles.bandapp==1   
    set(handles.status_tx,'String','...',...
            'BackgroundColor',[1,1,0])
    guidata(hObject,handles)
    pause(0.01)

    handles.spanrun=1;

    [~,numevents]=size(handles.data);
    totfact=1/handles.krnstep;

    k=numevents;
    i=10;
    while k>1
        k=numevents/i;
        numorder=log10(i);
        i=i*10;
    end
    dims=zeros(1,numorder-1);
    for i=1:numorder-1
        dims(i)=10^i;
    end
    dims=[sort(dims,'descend'),1];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    looptable=zeros(numevents-1,1);
    for i=1:numevents-1
        loopstop=0;
        dimtable=zeros(numorder,1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        for k=1:numorder
            inloopnum=1;
            rec_events=0;
            loopdim=dims(k);
            if k==1
                pointfinder=0;
            else pointfinder=sum(dimtable);
            end
            while rec_events<handles.perc_events*totfact
                if pointfinder+loopdim*inloopnum<=numevents
                    if pointfinder+loopdim*inloopnum>i
                        rec_events=sum(handles.data(i:(pointfinder+loopdim*inloopnum)));
                    end
                    if inloopnum<=10
                        inloopnum=inloopnum+1;
                    else
                        loopstop=1;
                        break
                    end
                else loopstop=1;
                    break
                end
            end
            if loopstop==1
                break
            end
            if loopdim>1
                dimtable(k)=loopdim*(inloopnum-2);
            else dimtable(k)=loopdim*(inloopnum-1);
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if loopstop==0
            looptable(i)=sum(dimtable)-i;
        elseif loopstop==1
            looptable(i:numevents-1)=nan;
            break
        end
    end

    [~,minval]=min(looptable);
    handles.span=[minval,minval+min(looptable)];
    handles.lowfrac=looptable(1);

    % Detecting higher fraction
    rec_events=0;
    k=1;
    while rec_events<handles.perc_events*totfact
        rec_events=sum(handles.data(numevents-k:numevents));
        k=k+1;
    end
    handles.highfrac=(numevents-k-2);
    handles.numevents=numevents;

    % Setting output
    set(handles.spanminval_tx,'String',handles.span(1)/totfact)
    set(handles.spanmaxval_tx,'String',handles.span(2)/totfact)
    set(handles.minspan_tx,'String',(handles.span(2)-handles.span(1))/totfact)
    set(handles.lowfrac_tx,'String',handles.lowfrac/totfact)
    set(handles.highfrac_tx,'String',handles.highfrac/totfact)

    % Setting status text
    set(handles.status_tx,'String','OK',...
            'BackgroundColor',[0,1,0])
    guidata(hObject,handles)
    pause(0.01)

    % Plot according to selection
    if handles.areachk~=0
        delete(handles.areaplot)
    end

    if get(handles.disparea_ckb,'Value')==1
        if get(handles.graphsel_ppm,'Value')==1
           span=handles.span;
        elseif get(handles.graphsel_ppm,'Value')==2
            span=[1,handles.lowfrac];
        elseif get(handles.graphsel_ppm,'Value')==3
            span=[handles.highfrac,handles.numevents];
        end

        handles.ardata=zeros(1,(span(2)-span(1)+1));

        for i=1:(span(2)-span(1)+1)
            handles.ardata(:,i)=handles.data(:,i-1+span(1));
        end
        handles.arx=handles.x(span(1)):handles.krnstep:handles.x(span(2));

        hold on
        handles.areaplot=area(handles.arx,handles.ardata,...
            'FaceColor',[0.8,0.8,0.8],...
            'EdgeColor',[0.8,0.8,0.8]);
        handles.dataplot=plot(handles.x,handles.data,'k');
        hold off
        handles.plotchk=1;
        handles.areachk=1;
    end
end
guidata(hObject,handles)
end


% --- Executes on button press in disparea_ckb.
function disparea_ckb_Callback(hObject, ~, handles)

if handles.areachk~=0
    delete(handles.areaplot)
end

if handles.spanrun==1;
    if get(hObject,'Value')==1
        if get(handles.graphsel_ppm,'Value')==1
           span=handles.span;
        elseif get(handles.graphsel_ppm,'Value')==2
            span=[1,handles.lowfrac];
        elseif get(handles.graphsel_ppm,'Value')==3
            span=[handles.highfrac,handles.numevents];
        end
    
        handles.ardata=zeros(1,(span(2)-span(1)+1));
    
        for i=1:(span(2)-span(1)+1)
            handles.ardata(:,i)=handles.data(:,i-1+span(1));
        end
        handles.arx=handles.x(span(1)):handles.krnstep:handles.x(span(2));
    
        hold on
        handles.areaplot=area(handles.arx,handles.ardata,...
            'FaceColor',[0.8,0.8,0.8],...
            'EdgeColor',[0.8,0.8,0.8]);
        handles.dataplot=plot(handles.x,handles.data,'k');
        hold off
        handles.areachk=1;
        handles.plotchk=1;
    elseif get(hObject,'Value')==0
        handles.dataplot=plot(handles.x,handles.data,'k');
        handles.plotchk=1;
        handles.areachk=0;
    end
end    
guidata(hObject,handles)
end


% --- Executes on selection change in graphsel_ppm.
function graphsel_ppm_Callback(hObject, ~, handles)

if handles.areachk~=0
    delete(handles.areaplot)
end

if handles.spanrun==1;
    if get(hObject,'Value')==1
        span=handles.span;
    elseif get(hObject,'Value')==2
        span=[1,handles.lowfrac];
    elseif get(hObject,'Value')==3
        span=[handles.highfrac,handles.numevents];
    end
    if get(handles.disparea_ckb,'Value')==1
        handles.ardata=zeros(1,(span(2)-span(1)+1));
    
        for i=1:(span(2)-span(1)+1)
            handles.ardata(:,i)=handles.data(:,i-1+span(1));
        end
        handles.arx=handles.x(span(1)):handles.krnstep:handles.x(span(2));

        hold on
        handles.areaplot=area(handles.arx,handles.ardata,...
            'FaceColor',[0.8,0.8,0.8],...
            'EdgeColor',[0.8,0.8,0.8]);
        handles.dataplot=plot(handles.x,handles.data,'k');
        hold off
        handles.areachk=1;
        handles.plotchk=1;
    end
end
guidata(hObject,handles)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------- Exporting --------------------------------%

%%%%%%%%%%%%%%%%%%%%%%%% Check button callbacks %%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in expstat_ckb.
function expstat_ckb_Callback(~, ~, ~)
% No action
end

% --- Executes on button press in expdensparam_ckb.
function expdensparam_ckb_Callback(~, ~, ~)
% No action
end

% --- Executes on button press in expdensplot_ckb.
function expdensplot_ckb_Callback(~, ~, ~)
% No action
end

% --- Executes on button press in expdiamplot_ckb.
function expdiamplot_ckb_Callback(~, ~, ~)
% No action
end

% --- Executes on button press in expdens_ckb.
function expdens_ckb_Callback(hObject, ~, handles)

if get(hObject,'Value')==0
    set(handles.expdensdata_ckb,'Visible','Off',...
        'Value',0)
    set(handles.expdensparam_ckb,'Visible','Off',...
        'Value',0)
    set(handles.expdensplot_ckb,'Visible','Off',...
        'Value',0)
elseif get(hObject,'Value')==1
    set(handles.expdensdata_ckb,'Visible','On',...
        'Value',0)
    set(handles.expdensparam_ckb,'Visible','On',...
        'Enable','off',...
        'Value',0)
    set(handles.expdensplot_ckb,'Visible','On',...
        'Value',0)
end
guidata(hObject,handles)
end

% --- Executes on button press in expdensdata_ckb.
function expdensdata_ckb_Callback(hObject, ~, handles)

if get(hObject,'Value')==0
    set(handles.expdensparam_ckb,...
        'Enable','off',...
        'Value',0)
else set (handles.expdensparam_ckb,...
        'Enable','on')
end
guidata(hObject,handles)
end

% --- Executes on button press in expdiam_ckb.
function expdiam_ckb_Callback(hObject, ~, handles)

if get(hObject,'Value')==0
    set(handles.expdiamplot_ckb,'Visible','Off',...
        'Value',0)
elseif get(hObject,'Value')==1
    set(handles.expdiamplot_ckb,'Visible','On',...
        'Value',1)
end
guidata(hObject,handles)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Export button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in export_but.
function export_but_Callback(hObject, ~, handles)

% Set date/time prefix
currdate=datestr(now,'ddmmmyy-HHMM_');

% Eliminate '\fulldata.mat' (or other file) from handles.filepath
folderpath=handles.filepath;
lastslash=find(ismember(handles.filepath,'\'),1,'last');
folderpath(lastslash:end)=[];

% Export statistics
if get(handles.expstat_ckb,'Value')==1
    statparams={'Number of points';'Average';'Std deviation';'Median';...
        'Maximum';'Minimum';'1st quartile';'3rd quartile'};
    statdataset=dataset({statparams,'Property'},{handles.stat,'Value'});
    export(statdataset,'File',fullfile(folderpath,[currdate,'statistics.txt']))
end

% Export density estimation data and/or parameters
if get(handles.expdens_ckb,'Value')==1
    
    if get(handles.expdensdata_ckb,'Value')==1
        
        % Set local temporary variables for exportation
        x=handles.x; %#ok<NASGU>
        data=handles.data; %#ok<NASGU>
        bandwidth=handles.bandwd; %#ok<NASGU>
        kernel=handles.kernname; %#ok<NASGU>
        xrange=[handles.krnmin,handles.krnmax,handles.krnstep]; %#ok<NASGU>
        filekde=fullfile(folderpath,[currdate,'kdens']);
        
        if get(handles.expdensparam_ckb,'Value')==1
            save(filekde,...
                'x','data','bandwidth','kernel','xrange')
        else save(filekde,...
                'x','data')
        end
        clear x data bandwidth kernel xrange
    end
    
    % Export plot
    if get(handles.expdensplot_ckb,'Value')==1
        
    end
end
    
guidata(hObject,handles)

end

