function varargout=c01convert_v1(varargin)
%DIBCONVERT_V1 UI to convert Cellomics *.DIB images to other formats.
%  C01CONVERT_V1(DIRIN) triggers the UI and presets DIRIN as input folder,
%  to look for *.DIB files.
%
%  C01CONVERT_V1(DIRIN,DIROUT) triggers the UI and presets DIRIN as input
%  folder and DIROUT as output folder.
%
%  DIRIN and DIROUT must be strings containing valid directory paths with 
%  read permission. DIROUT must have writing permission.
%
%  [INFLIST,OUTFLIST]=C01CONVERT_V1(DIRIN) provides cell arrays of strings
%  containing the source files' names - INFLIST - and output files' paths -
%  OUTFLIST.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Declare globals
% -- Edit boxes
global inFolder_ed pixrngSample_ed outPrefix_ed outChnl1_ed outChnl2_ed ...
    outChnl3_ed outConvFact_ed outFolder_ed
% -- Text boxes
global nWells_txt nColumns_txt nRows_txt nChanels_txt pixrngMin_txt ...
    pixrngMax_txt pixrngAvg_txt infoBox_txt
% -- Push buttons
global inBrowse_but inOK_but pixrngRun_but outBrowse_but outConvert_but ...
    resetUI_but
% -- GUI, popup-menu and checkbox
global guifig outFormat_pop out8comp_chk
% -- Variables
global dirin dirout plateInfo pixrngInfo platePrefix chanelID convFact ...
    pixrngSample fileList fileFinder nImgs imPrefix pixsize currImgDir

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize GUI
% -- Function to build GUI
    function genGUI(~,~)
        guifig=figure('Visible','off',...
            'Name','C01 Converter',...
            'NumberTitle','off',...
            'Resize','off',...
            'Color',[0.941,0.941,0.941],...
            'Position',[520,200,566,519],...
            'WindowStyle','modal');
        
        % Build GUI components
        input_pan=uipanel('Parent',guifig,... % -- Input panel
            'FontName','MS Sans Serif',...
            'FontSize',9,...
            'Title','Input',...
            'Units','characters',...
            'Position',[0.8,23.385,111,16.231]);...
            uicontrol('Parent',input_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',11,...
            'HorizontalAlignment','left',...
            'String','Input folder:',...
            'Units','characters',...
            'Position',[3,12.692,15.6,1.615]);...
            inFolder_ed=uicontrol('Parent',input_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',10,...
            'HorizontalAlignment','left',...
            'Units','characters',...
            'Position',[20.6,12.538,87.4,2]);...
            inBrowse_but=uicontrol('Parent',input_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'String','Browse',...
            'Units','characters',...
            'Position',[64.2,9.923,20.2,2.308]);...
            inOK_but=uicontrol('Parent',input_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'String','OK',...
            'Units','characters',...
            'Position',[85.6,9.923,20.2,2.308]);...
            info_pan=uipanel('Parent',input_pan,... % -- Information panel
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'Title','Info',...
            'Units','characters',...
            'Position',[3.8,0.846,38.6,10.923]);...
            uicontrol('Parent',info_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'HorizontalAlignment','left',...
            'String','No. wells',...
            'Units','characters',...
            'Position',[3.2,7.846,15,1.231]);...
            uicontrol('Parent',info_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'HorizontalAlignment','left',...
            'String','Columns',...
            'Units','characters',...
            'Position',[3.2,5.692,15,1.231]);...
            uicontrol('Parent',info_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'HorizontalAlignment','left',...
            'String','Rows',...
            'Units','characters',...
            'Position',[3.2,3.538,15,1.231]);...
            uicontrol('Parent',info_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'HorizontalAlignment','left',...
            'String','No. chanels',...
            'Units','characters',...
            'Position',[3.2,1.385,15,1.231]);...
            nWells_txt=uicontrol('Parent',info_pan,...
            'BackgroundColor',[1,1,1],...
            'Style','text',...
            'FontName','Arial',...
            'FontSize',10,...
            'Units','characters',...
            'Position',[20.8,7.846,14,1.231]);...
            nColumns_txt=uicontrol('Parent',info_pan,...
            'BackgroundColor',[1,1,1],...
            'Style','text',...
            'FontName','Arial',...
            'FontSize',10,...
            'Units','characters',...
            'Position',[20.8,5.692,14,1.231]);...
            nRows_txt=uicontrol('Parent',info_pan,...
            'BackgroundColor',[1,1,1],...
            'Style','text',...
            'FontName','Arial',...
            'FontSize',10,...
            'Units','characters',...
            'Position',[20.8,3.538,14,1.231]);...
            nChanels_txt=uicontrol('Parent',info_pan,...
            'BackgroundColor',[1,1,1],...
            'Style','text',...
            'FontName','Arial',...
            'FontSize',10,...
            'Units','characters',...
            'Position',[20.8,1.385,14,1.231]);...
            pixrng_pan=uipanel('Parent',input_pan,... % -- Pixel range panel
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'Title','Pixel range',...
            'Units','characters',...
            'Position',[44.2,0.846,61.2,8.846]);...
            uicontrol('Parent',pixrng_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',9,...
            'FontWeight','bold',...
            'String','Analyze pixel range',...
            'Units','characters',...
            'Position',[2.2,5.615,23,1.538]);...
            uicontrol('Parent',pixrng_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'String','Sample',...
            'Units','characters',...
            'Position',[2.2,4.077,10.8,1.538]);...
            pixrngSample_ed=uicontrol('Parent',pixrng_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',9,...
            'Units','characters',...
            'Position',[13.8,4.231,10.2,1.462]);...
            pixrngRun_but=uicontrol('Parent',pixrng_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',9,...
            'FontWeight','bold',...
            'String','Run',...
            'Units','characters',...
            'Position',[4,1.077,19.4,2.769],...
            'Enable','off');...
            uicontrol('Parent',pixrng_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',9,...
            'HorizontalAlignment','right',...
            'String','Minimum',...
            'Units','characters',...
            'Position',[29.5,6.077,13,1.077]);...
            uicontrol('Parent',pixrng_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',9,...
            'HorizontalAlignment','right',...
            'String','Maximum',...
            'Units','characters',...
            'Position',[29.5,3.769,13,1.077]);...
            uicontrol('Parent',pixrng_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',9,...
            'HorizontalAlignment','right',...
            'String','Average',...
            'Units','characters',...
            'Position',[29.5,1.462,13,1.077]);...
            pixrngMin_txt=uicontrol('Parent',pixrng_pan,...
            'BackgroundColor',[1,1,1],...
            'Style','text',...
            'FontName','Arial',...
            'FontSize',9,...
            'Units','characters',...
            'Position',[44.8,6.077,12,1.077]);...
            pixrngMax_txt=uicontrol('Parent',pixrng_pan,...
            'BackgroundColor',[1,1,1],...
            'Style','text',...
            'FontName','Arial',...
            'FontSize',9,...
            'Units','characters',...
            'Position',[44.8,3.769,12,1.077]);...
            pixrngAvg_txt=uicontrol('Parent',pixrng_pan,...
            'BackgroundColor',[1,1,1],...
            'Style','text',...
            'FontName','Arial',...
            'FontSize',9,...
            'Units','characters',...
            'Position',[44.8,1.462,12,1.077]);
        output_pan=uipanel('Parent',guifig,... % -- Output panel
            'FontName','MS Sans Serif',...
            'FontSize',9,...
            'Title','Output',...
            'Units','characters',...
            'Position',[0.8,2.154,111,21]);...
            uicontrol('Parent',output_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',11,...
            'HorizontalAlignment','left',...
            'String','Prefix:',...
            'Units','characters',...
            'Position',[3.2,16.385,11.6,1.615]);...
            uicontrol('Parent',output_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',11,...
            'HorizontalAlignment','left',...
            'String','Chanel ID:',...
            'Units','characters',...
            'Position',[3.2,12.308,20.6,1.615]);...
            uicontrol('Parent',output_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',11,...
            'HorizontalAlignment','left',...
            'String','12 to 16-bit factor:',...
            'Units','characters',...
            'Position',[3.2,9.231,24.4,1.615]);...
            uicontrol('Parent',output_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',11,...
            'HorizontalAlignment','left',...
            'String','Output format:',...
            'Units','characters',...
            'Position',[58.6,9.231,20.6,1.615]);...
            uicontrol('Parent',output_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',11,...
            'HorizontalAlignment','left',...
            'String','Output folder:',...
            'Units','characters',...
            'Position',[3.2,4.231,18.4,1.615]);...
            uicontrol('Parent',output_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'String','Chanel 1',...
            'Units','characters',...
            'Position',[27.8,14.154,17.2,1.154]);...
            uicontrol('Parent',output_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'String','Chanel 2',...
            'Units','characters',...
            'Position',[54.8,14.154,17.2,1.154]);...
            uicontrol('Parent',output_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'String','Chanel 3',...
            'Units','characters',...
            'Position',[82,14.154,17.2,1.154]);...
            outPrefix_ed=uicontrol('Parent',output_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',10,...
            'HorizontalAlignment','left',...
            'Units','characters',...
            'Position',[13.8,16.231,94.2,2]);...
            outChnl1_ed=uicontrol('Parent',output_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',11,...
            'Units','characters',...
            'Position',[24.6,12.077,23.8,1.923]);...
            outChnl2_ed=uicontrol('Parent',output_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',11,...
            'Units','characters',...
            'Position',[51.6,12.077,23.8,1.923]);...
            outChnl3_ed=uicontrol('Parent',output_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',11,...
            'Units','characters',...
            'Position',[78.8,12.077,23.8,1.923]);...
            outConvFact_ed=uicontrol('Parent',output_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',11,...
            'Units','characters',...
            'Position',[29.2,9.077,18.8,1.923]);...
            outFolder_ed=uicontrol('Parent',output_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',10,...
            'HorizontalAlignment','left',...
            'Units','characters',...
            'Position',[23.4,4.077,84.6,2]);...
            outFormat_pop=uicontrol('Parent',output_pan,...
            'Style','popupmenu',...
            'BackgroundColor',[1,1,1],...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'HorizontalAlignment','left',...
            'String','TIFF (multi)|TIFF (single)|PNG|JPG',...
            'Units','characters',...
            'Position',[80,9.154,22.2,1.846]);...
            out8comp_chk=uicontrol('Parent',output_pan,...
            'Style','checkbox',...
            'FontName','MS Sans Serif',...
            'FontSize',11,...
            'HorizontalAlignment','left',...
            'String','8-bit compression',...
            'Units','characters',...
            'Position',[58.6,7,30,1.769]);...
            outBrowse_but=uicontrol('Parent',output_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'String','Browse',...
            'Units','characters',...
            'Position',[64.2,1.385,20.2,2.308],...
            'Enable','off');...
            outConvert_but=uicontrol('Parent',output_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'String','Convert',...
            'Units','characters',...
            'Position',[85.6,1.385,20.2,2.308],...
            'Enable','off');
        resetUI_but=uicontrol('Parent',guifig,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'String','Reset GUI',...
            'Units','characters',...
            'Position',[2,0.35,20.2,1.769]);
        infoBox_txt=uicontrol('Parent',guifig,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontAngle','italic',...
            'FontWeight','bold',...
            'HorizontalAlignment','right',...
            'String','Input folder path...',...
            'Units','characters',...
            'Position',[23.4,0.5,86.8,1.538]);
    end

% -- Function to preset/reset variables
    function resetVars(~,~)
        % --- Set variables
        fileList={};
        nImgs=[];
        imPrefix='';
        plateInfo={'','','',''};
        pixrngInfo={'','',''};
        chanelID={'blue','green','red'};
        pixrngSample=200;
        convFact=16;
        pixsize=[512,512];
        varargout={};
        currImgDir='';
        
        % --- Set UIcontrols
        set(inFolder_ed,'String',dirin)
        set(outFolder_ed,'String',dirout,...
            'Enable','off')
        set(nWells_txt,'String',plateInfo(1),...
            'Enable','off')
        set(nColumns_txt,'String',plateInfo(2),...
            'Enable','off')
        set(nRows_txt,'String',plateInfo(3),...
            'Enable','off')
        set(nChanels_txt,'String',plateInfo(4),...
            'Enable','off')
        set(pixrngSample_ed,'String',num2str(pixrngSample),...
            'Enable','off')
        set(pixrngMin_txt,'String',pixrngInfo(1),...
            'Enable','off')
        set(pixrngMax_txt,'String',pixrngInfo(2),...
            'Enable','off')
        set(pixrngAvg_txt,'String',pixrngInfo(3),...
            'Enable','off')
        platePrefix='Write plate identifier';
        set(outPrefix_ed,'String',platePrefix,...
            'Enable','off')
        set(outChnl1_ed,'String',chanelID(1),...
            'Enable','off')
        set(outChnl2_ed,'String',chanelID(2),...
            'Enable','off')
        set(outChnl3_ed,'String',chanelID(3),...
            'Enable','off')
        set(outConvFact_ed,'String',num2str(convFact),...
            'Enable','off')
        set(outFormat_pop,'Value',1,...
            'Enable','off')
        set(out8comp_chk,'Value',0,...
            'Enable','off')
    end

% -- Check for input variables and set dirin/dirout
if nargin==0
    dirin=cd;
    dirout=dirin;
elseif nargin==1
    dirin=varargin{1};
    dirout=dirin;
elseif nargin==2
    dirin=varargin{1};
    dirout=varargin{2};
elseif nargin>2
    error('Too many input varibales!')
end

% -- Check validity of input arguments
if ~ischar(dirin) || ~ischar(dirout)
    error('Input arguments must be strings')
elseif ~exist(dirin,'dir')
    error('Input directory is not valid')
elseif ~exist(dirout,'dir')
    error('Output directory is not valid')
else
    [~,dirinAttrib]=fileattrib(dirin);
    [~,diroutAttrib]=fileattrib(dirout);
    if dirinAttrib.UserRead==0
        error('Input directory doesn''t have reading permission')
    elseif diroutAttrib.UserRead==0
        error('Output directory doesn''t have reading permission')
    elseif diroutAttrib.UserWrite==0
        error('Output directory doesn''t have writing permission')
    end
end
    
% -- Build GUI, preset variables and turn visible; turn Bioformats logging
% ON.
genGUI, resetVars
set(guifig,'Visible','on')
loci.common.DebugTools.enableLogging('INFO');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% UIcontrol functions
% -- Set UIcontrols' callback handles
set(inBrowse_but,'Callback',@inBrowse_Callback)
set(inOK_but,'Callback',@inOK_Callback)
set(pixrngRun_but,'Callback',@pixrngRun_Callback)
set(outBrowse_but,'Callback',@outBrowse_Callback)
set(outConvert_but,'Callback',@outConvert_Callback)
set(outFormat_pop,'Callback',@outFormat_Callback)
set(resetUI_but,'Callback',@resetVars)

% -- UIcontrol callback functions
    function inBrowse_Callback(~,~)
        n_dirin=uigetdir(dirin,'Choose folder...');
        if n_dirin==0
            return
        end
        dirin=n_dirin;
        set(inFolder_ed,'String',dirin)
        setInfoBox('Ready to roll!...',[0,0,0])
        clear n_dirin
    end

    function inOK_Callback(~,~)
        ed_dirin=get(inFolder_ed,'String');
        % Check if dirin is a valid directory 
        if ~exist(ed_dirin,'dir')
            setInfoBox('Error: Invalid folder path. Directory does not exit',...
                [1,0,0])
            return
        else
            dirin=ed_dirin;
            clear ed_dirin
        end
        fileFinder=0;
        dirLoad %local function
        if fileFinder==1
            set(nWells_txt,'String',plateInfo(1),...
                'Enable','on')
            set(nColumns_txt,'String',plateInfo(2),...
                'Enable','on')
            set(nRows_txt,'String',plateInfo(3),...
                'Enable','on')
            set(nChanels_txt,'String',plateInfo(4),...
                'Enable','on')
            set(pixrngRun_but,'Enable','on')
            set(pixrngSample_ed,'Enable','on')
            imPrefix=dirin(end-22:end);
            set(outPrefix_ed,'String',imPrefix,...
                'Enable','on')
            if ~str2double(plateInfo{4})>2
                set(outChnl3_ed,'String','',...
                    'Visible','off')
                if ~str2double(plateInfo{4})>1
                    set(outChnl2_ed,'String','',...
                        'Visible','off')
                end
            end
            set(outFolder_ed,'String',dirin,...
                'Enable','on')
            set(outConvFact_ed,'Enable','on')
            set(outFormat_pop,'Enable','on')
            set(out8comp_chk,'Enable','on')
            set(outBrowse_but,'Enable','on')
            set(outConvert_but,'Enable','on')
        else
            setInfoBox('*.C01 files not found...',[1,0,0])
            return
        end
    end
        
    function pixrngRun_Callback(~,~)
        pixrngSample=str2double(get(pixrngSample_ed,'String'));
        if ~pixrngSample>0
            setInfoBox('Sample size must be positive integer!',[1,0,0])
            return
        elseif pixrngSample>nImgs
            setInfoBox('Sample size can''t excede total number of images!', ...
                [1,0,0])
            return
        else
            imgSampler; %local function
        end
        set(pixrngMin_txt,'String',pixrngInfo(1),...
            'Enable','on')
        set(pixrngMax_txt,'String',pixrngInfo(2),...
            'Enable','on')
        set(pixrngAvg_txt,'String',pixrngInfo(3),...
            'Enable','on')
    end

    function outFormat_Callback(hObject,~)
        if get(hObject,'Value')==1
            set(outChnl1_ed,'Enable','off')
            set(outChnl2_ed,'Enable','off')
            set(outChnl3_ed,'Enable','off')
        else
            set(outChnl1_ed,'Enable','on')
            set(outChnl2_ed,'Enable','on')
            set(outChnl3_ed,'Enable','on')
        end
    end

    function outBrowse_Callback(~,~)
        dirout=get(outFolder_ed,'String');
        n_dirout=uigetdir(dirout,'Choose folder...');
        if n_dirout==0            
            return
        end
        [~,dirAttrib]=fileattrib(n_dirout);
        if dirAttrib.UserWrite==0
            setInfoBox('Selected folder doesn''t allow writing',[1,0,0])
            return
        else
            dirout=n_dirout;
            set(outFolder_ed,'String',dirout)
            setInfoBox('Ready to convert...',[0,0,0])
        end
        clear n_dirout dirAttrib
    end

    function outConvert_Callback(~,~)
       n_dirout=get(outFolder_ed,'String');
       [~,dirAttrib]=fileattrib(n_dirout);
       if ~exist(n_dirout,'dir') || dirAttrib.UserWrite==0
           setInfoBox('Invalid folder path!',[1,0,0]);
           return
       else
           dirout=n_dirout;
       end
       imPrefix=get(outPrefix_ed,'String');
       convFact=str2double(get(outConvFact_ed,'String'));
       chanelID={get(outChnl1_ed,'String'),...
           get(outChnl2_ed,'String'),...
           get(outChnl3_ed,'String')};
       outFileList=cell(nImgs,1);
       toti=num2str(nImgs); % for progress monitorization
       if ~convFact>0
           setInfoBox('Bit depth conversion factor must be > 0',[1,0,0])
           return
       end
       for i=1:nImgs  % Detect selected format and write the images
           ii=num2str(i); % for progress monitorization
           setInfoBox(['Converting image ',ii,' of ',toti],[0,0,0]),...
               pause(0.0001) % progress monitorization
           currImgDir=fullfile(dirin,fileList{i});
           currImg=imreadc01;
           currImg=currImg*convFact;
           imgName=imgNamer(fileList{i}); % local function
           outPath=fullfile(dirout,imgName);% produce fullfile path
           switch get(outFormat_pop,'Value')
               case 1
                   switch get(out8comp_chk,'Value')
                       case 0
                           imwrite(currImg,strcat(outPath,'.tiff'),...
                               'WriteMode','append',...
                               'Compression','none',...
                               'Description',fileList{i})
                           outFileList{i}=strcat(outPath,'.tiff');
                       case 1
                           currImg=uint8(round(currImg/256));
                           imwrite(currImg,strcat(outPath,'.tiff'),...
                               'WriteMode','append',...
                               'Compression','none',...
                               'Description',fileList{i})
                           outFileList{i}=strcat(outPath,'.tiff');
                   end
               case 2
                   switch get(out8comp_chk,'Value')
                       case 0
                           imwrite(currImg,strcat(outPath,'.tiff'),...
                               'WriteMode','overwrite',...
                               'Compression','none',...
                               'Description',fileList{i})
                           outFileList{i}=strcat(outPath,'.tiff');
                       case 1
                           currImg=uint8(round(currImg/256));
                           imwrite(currImg,strcat(outPath,'.tiff'),...
                               'WriteMode','overwrite',...
                               'Compression','none',...
                               'Description',fileList{i})
                           outFileList{i}=strcat(outPath,'.tiff');
                   end
               case 3
                   switch get(out8comp_chk,'Value')
                       case 0
                           imwrite(currImg,[outPath,'.png'],...
                               'bitdepth',16,...
                               'Description',fileList{i})
                           outFileList{i}=strcat(outPath,'.png');
                       case 1
                           imwrite(currImg,[outPath,'.png'],...
                               'bitdepth',8,...
                               'Description',fileList{i})
                           outFileList{i}=strcat(outPath,'.png');
                   end
               case 4
                   switch get(out8comp_chk,'Value')
                       case 0
                           imwrite(currImg,[outPath,'.jpg'],...
                               'Bitdepth',16,...
                               'Mode','lossless',...
                               'Quality',100,...
                               'Comment',fileList{i})
                           outFileList{i}=strcat(outPath,'.jpg');
                       case 1
                           imwrite(currImg,[outPath,'.jpg'],...
                               'Bitdepth',8,...
                               'Mode','lossless',...
                               'Quality',100,...
                               'Comment',fileList{i})
                           outFileList{i}=strcat(outPath,'.jpg');
                   end
           end
       end
       outFileList=unique(outFileList);
       clear n_dirout dirAttrib toti currImg imgName outPath
       varargout={fileList,outFileList};
       setInfoBox('All done!',[0,1,0])
       % Play sound
       [audsmpl,audfreq]=audioread('C:\Windows\Media\chord.wav');
       sound(audsmpl,audfreq) 
       uiresume
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Local functions (indirect Callbacks)
% -- Set InfoBox
    function setInfoBox(infoTxt,infoColor)
        set(infoBox_txt,'String',infoTxt,'ForegroundColor',infoColor)
    end

% -- Load *.C01 image folder
    function dirLoad(~,~)
        % List directory and check for *.C01 files
        setInfoBox('Analyzing folder...',[1,1,0])
        inDir=dir(dirin);
        [dirSize,~]=size(inDir);
        fileList=cell(dirSize,1);
        k=1;
        for i=1:dirSize
            if inDir(i,1).isdir==0
                if strcmp(inDir(i,1).name(end-3:end),'.C01')==1
                    fileList{k}=inDir(i,1).name;
                    k=k+1;
                end
            end
        end
        if k==1
            setInfoBox('*.C01 files not found...',[1,0,0])
            return
        else fileFinder=1;
        end
        fileList=fileList(1:k-1);
        nImgs=k-1;
        chans=zeros(1,k-1);
        cols=zeros(1,k-1);
        rowz=char(cols);
        
        for i=1:k-1
            chans(i)=str2double(fileList{i}(end-4));
            cols(i)=str2double(fileList{i}(end-10:end-9));
            rowz(:,i)=fileList{i}(end-11);
        end
        
        plateInfo{1}=num2str(nImgs);
        [~,ncols]=size(unique(cols)); ...
            plateInfo{2}=num2str(ncols);
        [~,nrowz]=size(unique(rowz)); ...
            plateInfo{3}=num2str(nrowz);
        [~,nchans]=size(unique(chans)); ...
            plateInfo{4}=num2str(nchans);
        setInfoBox('Plate info detected!',[0,1,0])

        % clear local variables
        clear  inDir k chans cols rowz nchans ncols nrowz
        
    end

% -- Load and analyze image sample
    function imgSampler(~,~)
        setInfoBox('Retrieving and analyzing sample...',[1,1,0]), ...
            pause(0.0001)
        sampleDir=cell(pixrngSample,1); % pre-allocate
        pixMin=zeros(pixrngSample,1);
        pixMax=pixMin;
        pixAvg=pixMin;
        randDirNum=randi(nImgs,pixrngSample); % set random indexes
        %samplelist=cell(nImgs,1);    
        for i=1:pixrngSample
            % retrieve image
            sampleDir{i}=fileList{randDirNum(i)};
            currImgDir=fullfile(dirin,sampleDir{i});
            imgSample=imreadc01; % local
            %samplelist{i}=imgSample;
            % analyze and store pixel stats
            pixMin(i)=min(min(imgSample));
            pixMax(i)=max(max(imgSample));
            pixAvg(i)=mean(mean(imgSample));
        end
        pixrngInfo{1}=min(pixMin);
        pixrngInfo{2}=max(pixMax);
        pixrngInfo{3}=mean(pixAvg);
        setInfoBox('Analysis done!',[0,1,0])
        
        % clear local variables
        clear sampleDir randDirNum imgMin imgMax imgAvg imgSample
    end

% -- Read image file
    function data=imreadc01(~,~)
        % Pre-allocate
        imrd=loci.formats.ChannelFiller();
        imrd=loci.formats.ChannelSeparator(imrd);
        
        % Set file and read
        imrd.setId(currImgDir)
        plane=imrd.openBytes(0);
        I=loci.common.DataTools.makeDataArray(plane,2,0,1);
        data=reshape(typecast(I,'uint16'),pixsize);
        clear imrd
    end

% -- Generate name for exported image
    function convName=imgNamer(imName,~)
        chanelTransl=[0 1 2];
        rowTransl={'_A','_B','_C','_D','_E','_F','_G','_H','_I','_J',...
            '_K','_L','_M','_N','_O','_P','_Q','_R','_S','_T','_U','_V',...
            '_W','_X','_Y','_Z','AA','AB','AC','AD','AE','AF','AG',...
            'AH','AI','AJ','AK','AL'};
        chanNo=logical(ismember(chanelTransl,str2double(imName(end-4))));
        colNo=imName(end-10:end-9);
        rowNo=num2str(find(strcmp(rowTransl,imName(end-12:end-11))));
        if get(outFormat_pop,'Value')==1
            convName=[imPrefix,'_row',rowNo,...
                '_col',colNo];
        else
            convName=strcat(imPrefix,'_row',rowNo,...
                '_col',colNo,...
                '_',chanelID{chanNo});
        end
        if iscell(convName)
            convName=convName{:};
        end
    end

uiwait
end