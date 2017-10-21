function varargout=statanalysis_v2(varargin)

% Declare globals
% -- GUI components
% > -- Figure, dynamic text boxes, table, pop-up menu and axes
global guifig status_tx stat_tbl plot_ax minspan_tx spanminval_tx ...
    spanmaxval_tx lowfrac_tx highfrac_tx graphsel_ppm

% > -- Push buttons
global browsebut import_but reset_but bandsilv_but bandapp_but ...
    spanrun_but

% > -- Radio buttons
global kgauss_rad kunif_rad ktriang_rad kepane_rad kbiwei_rad ...
    ktriei_rad ktricube_rad kcosin_rad

% > -- Edit boxes
global  import_ed klimmin_ed klimmax_ed klimstep_ed  bandnum_ed ...
    spannum_ed

% > -- Check boxes
global disparea_ckb
    
% -- Variables
global filepath  

% -------------------------------------------------------------------------
% Check if input variable exists and declare 'filepath'
filepath='C:\Users\Jorge\Documents\PhD\Tese\SCBL\Aggregates to read\';
if nargin==1
    if ischar(varargin{1})==1
        filepath=varargin{1};
    end
end

% Create GUI
guifig=figure('Visible','off',...
    'Name','StatAnalysis',...
    'NumberTitle','off',...
    'Resize','off',...
    'Units','characters',...
    'Color',[0.941,0.941,0.941],...
    'Position',[20,4,213,55],...
    'WindowStyle','modal');

% Build components
%   -- Panels and axes
importPan=uipanel('Title','Import data',...
    'Units','Characters',...
    'Position',[0.4,50.385,211.2,3.846],...
    'FontName','MS Sans Serif',...
    'FontSize',10,...
    'FontWeight','Bold');

statPan=uipanel('Title','Data statistical analysis',...
    'Units','Characters',...
    'Position',[0.4,34.231,58.6,16.154],...
    'FontName','MS Sans Serif',...
    'FontSize',10,...
    'FontWeight','Bold');

kdePan=uipanel('Title','Kernel density estimation',...
    'Units','Characters',...
    'Position',[59.6,34.231,65.8,16.154],...
    'FontName','MS Sans Serif',...
    'FontSize',10,...
    'FontWeight','Bold');

dmsPan=uipanel('Title','Diameter minimum span analysis',...
    'Units','Characters',...
    'Position',[126,34.231,52,16.154],...
    'FontName','MS Sans Serif',...
    'FontSize',10,...
    'FontWeight','Bold');

exportPan=uipanel('Title','Export',...
    'Units','Characters',...
    'Position',[178.6,34.231,33.2,16.154],...
    'FontName','MS Sans Serif',...
    'FontSize',10,...
    'FontWeight','Bold');

plot_ax=axes('Color',[1,1,1],...
    'Units','characters',...
    'Position',[12.5,3,197.5,30],...
    'XLim',[0,500],...
    'XTick',[0,50,100,150,200,250,300,350,400,450,500],...
    'YLim',[0,0.03],...
    'YTick',[0,0.005,0.01,0.015,0.02,0.025,0.03]);...
    xlabel(plot_ax,'Diameter (\mum)','FontWeight','bold'),...
    ylabel(plot_ax,'Density','FontWeight','bold')
    
% -- importPan controls
uicontrol('Parent',importPan,...
    'Style','text',...
    'String','File path:',...
    'Units','Characters',...
    'Position',[1.8,0.769,10.4,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9,...
    'FontWeight','Normal')

import_ed=uicontrol('Parent',importPan,...
    'Style','edit',...
    'String',filepath,...
    'Units','Characters',...
    'Position',[13.4,0.538,136,1.692],...
    'FontName','Arial',...
    'FontSize',10,...
    'HorizontalAlignment','left',...
    'BackgroundColor',[1,1,1]);

browsebut=uicontrol('Parent',importPan,...
    'Style','pushbutton',...
    'String','Browse',...
    'Units','Characters',...
    'Position',[150.2,0.385,13.8,2],...
    'FontName','Arial',...
    'FontSize',9,...
    'FontWeight','bold');

import_but=uicontrol('Parent',importPan,...
    'Style','pushbutton',...
    'String','Import data',...
    'Units','Characters',...
    'Position',[165,0.385,16.6,2],...
    'FontName','Arial',...
    'FontSize',9,...
    'FontWeight','bold');

status_tx=uicontrol('Parent',importPan,...
    'Style','text',...
    'String','OK',...
    'Units','Characters',...
    'BackgroundColor',[0.0,1.0,0.0],...
    'Position',[185.6,0.769,7.6,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9,...
    'FontWeight','bold');

reset_but=uicontrol('Parent',importPan,...
    'Style','pushbutton',...
    'String','Reset',...
    'Units','Characters',...
    'Position',[197.8,0.385,10.4,2],...
    'FontName','Arial',...
    'FontSize',9,...
    'FontWeight','bold');

% -- statPan controls
stat_tbl=uitable('Parent',statPan,...
    'Units','Characters',...
    'Position',[1.4,1.154,55,12.769],...
    'Data',zeros(8,1),...
    'ColumnName',[],...
    'ColumnWidth',{53},...
    'RowName',{'Number of datapoints','Average','Std deviation',...
    'Median','Maximum','Minimum','1st quartile','3rd quartile'},...
    'FontName','Arial',...
    'FontSize',9);

% -- kdePan controls
kernsel_pan=uibuttongroup('Parent',kdePan,...
    'Units','Characters',...
    'Position',[1,6.923,42,7.846],...
    'Title','Kernel selection',...
    'FontName','MS Sans Serif',...
    'FontSize',9);...
    kgauss_rad=uicontrol('Parent',kernsel_pan,...
    'Style','radiobutton',...
    'String','Gaussian',...
    'Units','Characters',...
    'Position',[1.6,4.846,21,1.769],...
    'FontName','MS Sans Serif',...
    'FontSize',9);...
    kunif_rad=uicontrol('Parent',kernsel_pan,...
    'Style','radiobutton',...
    'String','Uniform',...
    'Units','Characters',...
    'Position',[1.6,3.308,22,1.769],...
    'FontName','MS Sans Serif',...
    'FontSize',9);...
    ktriang_rad=uicontrol('Parent',kernsel_pan,...
    'Style','radiobutton',...
    'String','Triangular',...
    'Units','Characters',...
    'Position',[1.6,1.769,20.8,1.769],...
    'FontName','MS Sans Serif',...
    'FontSize',9);...
    kepane_rad=uicontrol('Parent',kernsel_pan,...
    'Style','radiobutton',...
    'String','Epanechnikov',...
    'Units','Characters',...
    'Position',[1.6,0.231,21.6,1.769],...
    'FontName','MS Sans Serif',...
    'FontSize',9);...
    kbiwei_rad=uicontrol('Parent',kernsel_pan,...
    'Style','radiobutton',...
    'String','Biweight',...
    'Units','Characters',...
    'Position',[25,4.846,15.2,1.769],...
    'FontName','MS Sans Serif',...
    'FontSize',9);...
    ktriei_rad=uicontrol('Parent',kernsel_pan,...
    'Style','radiobutton',...
    'String','Triweight',...
    'Units','Characters',...
    'Position',[25,3.308,15.6,1.769],...
    'FontName','MS Sans Serif',...
    'FontSize',9);...
    ktricube_rad=uicontrol('Parent',kernsel_pan,...
    'Style','radiobutton',...
    'String','Tricube',...
    'Units','Characters',...
    'Position',[25,1.769,14.2,1.769],...
    'FontName','MS Sans Serif',...
    'FontSize',9);...
    kcosin_rad=uicontrol('Parent',kernsel_pan,...
    'Style','radiobutton',...
    'String','Cosine',...
    'Units','Characters',...
    'Position',[25,0.231,14.4,1.769],...
    'FontName','MS Sans Serif',...
    'FontSize',9);
kernband_pan=uipanel('Parent',kdePan,...
    'Units','Characters',...
    'Position',[1.2,0.462,42,6.385],...
    'Title','Bandwidth selection',...
    'FontName','MS Sans Serif',...
    'FontSize',9);...
    bandsilv_but=uicontrol('Parent',kernband_pan,...
    'Style','pushbutton',...
    'String','Silverman''s approx. (gaussian)',...
    'Units','Characters',...
    'Position',[2,3.231,37.4,1.692],...
    'FontName','MS Sans Serif',...
    'FontSize',9);...
    bandnum_ed=uicontrol('Parent',kernband_pan,...
    'Style','edit',...
    'String','1',...
    'Units','Characters',...
    'Position',[4.4,0.923,13.8,1.692],...
    'FontName','Arial',...
    'FontSize',11,...
    'BackgroundColor',[1,1,1]);...
    bandapp_but=uicontrol('Parent',kernband_pan,...
    'Style','pushbutton',...
    'String','Apply',...
    'Units','Characters',...
    'Position',[20.8,0.538,17.4,2.385],...
    'FontName','Arial',...
    'FontSize',9,...
    'FontWeight','bold');
kernlim_pan=uipanel('Parent',kdePan,...
    'Units','Characters',...
    'Position',[43.6,0.462,20.6,14.308],...
    'Title','Range',...
    'FontName','MS Sans Serif',...
    'FontSize',9);...
    uicontrol('Parent',kernlim_pan,...
    'Style','text',...
    'String','Minimum',...
    'Units','Characters',...
    'Position',[4.6,11.231,10.6,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9),...
    uicontrol('Parent',kernlim_pan,...
    'Style','text',...
    'String','Maximum',...
    'Units','Characters',...
    'Position',[4.4,7.154,11,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9),...
    uicontrol('Parent',kernlim_pan,...
    'Style','text',...
    'String','Step (rec: 0.1)',...
    'Units','Characters',...
    'Position',[2,3.077,15.8,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9),...
    klimmin_ed=uicontrol('Parent',kernlim_pan,...
    'Style','edit',...
    'String','0',...
    'Units','Characters',...
    'Position',[2,9.538,16,1.692],...
    'FontName','Arial',...
    'FontSize',11,...
    'BackgroundColor',[1,1,1]);...
    klimmax_ed=uicontrol('Parent',kernlim_pan,...
    'Style','edit',...
    'String','500',...
    'Units','Characters',...
    'Position',[2,5.462,16,1.692],...
    'FontName','Arial',...
    'FontSize',11,...
    'BackgroundColor',[1,1,1]);...
    klimstep_ed=uicontrol('Parent',kernlim_pan,...
    'Style','edit',...
    'String','0.1',...
    'Units','Characters',...
    'Position',[2,1.385,16,1.692],...
    'FontName','Arial',...
    'FontSize',11,...
    'BackgroundColor',[1,1,1]);

% -- dmsPan controls
uicontrol('Parent',dmsPan,...
    'Style','text',...
    'String','Detect area (<1):',...
    'Units','Characters',...
    'Position',[1,12.692,19.6,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9)
spannum_ed=uicontrol('Parent',dmsPan,...
    'Style','edit',...
    'String','0.75',...
    'Units','Characters',...
    'Position',[21.2,12.462,10.8,1.692],...
    'FontName','Arial',...
    'FontSize',11,...
    'BackgroundColor',[1,1,1]);
spanrun_but=uicontrol('Parent',dmsPan,...
    'Style','pushbutton',...
    'String','Run',...
    'Units','Characters',...
    'Position',[33.4,12.385,13.6,1.769],...
    'FontName','Arial',...
    'FontSize',9,...
    'FontWeight','bold');
spanres_pan=uipanel('Parent',dmsPan,...
    'Title','Analysis',...
    'Units','Characters',...
    'Position',[1.2,0.462,48,11.846],...
    'FontName','MS Sans Serif',...
    'FontSize',9);...
    uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','Minimum span',...
    'Units','Characters',...
    'Position',[1.2,9,18,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9,...
    'FontWeight','bold'),...
    uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','Range:',...
    'Units','Characters',...
    'Position',[12.8,7.385,8.4,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9),...
    uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','Lower fraction up to:',...
    'Units','Characters',...
    'Position',[1.2,5.385,24.2,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9,...
    'FontWeight','bold'),...
    uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','Higher fraction down to:',...
    'Units','Characters',...
    'Position',[1.2,3.231,28.2,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9,...
    'FontWeight','bold'),...
    uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','/mum',...
    'Units','Characters',...
    'Position',[28.6,9.077,3.6,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9),...
    uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','/mum',...
    'Units','Characters',...
    'Position',[42.6,7.462,3.6,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9),...
    uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','/mum',...
    'Units','Characters',...
    'Position',[34.8,5.385,3.6,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9),...
    uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','/mum',...
    'Units','Characters',...
    'Position',[39,3.154,3.6,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9),...
    uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','to',...
    'Units','Characters',...
    'Position',[31.4,7.462,2,1.231],...
    'FontName','MS Sans Serif',...
    'FontSize',9),...
    minspan_tx=uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','0',...
    'Units','Characters',...
    'Position',[20.4,9.077,7.2,1.154],...
    'FontName','Arial',...
    'FontSize',10);...
    spanminval_tx=uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','0',...
    'Units','Characters',...
    'Position',[23,7.308,7.2,1.154],...
    'FontName','Arial',...
    'FontSize',10);...
    spanmaxval_tx=uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','0',...
    'Units','Characters',...
    'Position',[34.4,7.308,7.2,1.154],...
    'FontName','Arial',...
    'FontSize',10);...
    lowfrac_tx=uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','0',...
    'Units','Characters',...
    'Position',[26.6,5.385,7.2,1.154],...
    'FontName','Arial',...
    'FontSize',10);...
    highfrac_tx=uicontrol('Parent',spanres_pan,...
    'Style','text',...
    'String','0',...
    'Units','Characters',...
    'Position',[30.8,3.154,7.2,1.154],...
    'FontName','Arial',...
    'FontSize',10);...
    graphsel_ppm=uicontrol('Parent',spanres_pan,...
    'Style','popupmenu',...
    'String',['Min span';'Low fraction';'High fraction'],...
    'Units','Characters',...
    'Position',[1.4,0.692,23.6,1.769],...
    'FontName','Arial',...
    'FontSize',10,...
    'BackgroundColor',[1,1,1]);...
    disparea_ckb=uicontrol('Parent',spanres_pan,...
    'Style','checkbox',...
    'String','Display area',...
    'Units','Characters',...
    'Position',[26.6,0.615,19.8,1.923],...
    'FontName','MS Sans Serif',...
    'FontSize',9,...
    'Value',0);

% -- exportPan controls
expstat_ckb=uicontrol('Parent',exportPan,...
    'Style','checkbox',...
    'String','Statistics',...
    'Units','Characters',...
    'Position',[2.8,12.538,17,2.077],...
    'FontName','MS Sans Serif',...
    'FontSize',10,...
    'Value',1);
expdens_ckb=uicontrol('Parent',exportPan,...
    'Style','checkbox',...
    'String','Density estimation',...
    'Units','Characters',...
    'Position',[2.8,10.769,27.8,2.077],...
    'FontName','MS Sans Serif',...
    'FontSize',10,...
    'Value',1);
expdensdata_ckb=uicontrol('Parent',exportPan,...
    'Style','checkbox',...
    'String','Plot data',...
    'Units','Characters',...
    'Position',[7.2,9.038,14,1.769],...
    'FontName','MS Sans Serif',...
    'FontSize',8,...
    'Value',1);
    

% Initialize GUI
set(guifig,'Visible','On')



% Set callback handles


% Set output arguments

uiwait 
varargout={};

end