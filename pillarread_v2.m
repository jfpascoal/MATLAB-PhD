function [varargout]=pillarread_v2(varargin)
%PILLAREAD_V2
% PILLARREAD_V2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Declare globals
% -- Handles for GUI panels
global input_pan imset_pan area_pan export_pan preview_pan

% -- Handles for push buttons
global inBrowse_but import_but reset_but prevPillar_but prevNext_but ...
    prevPrev_but prevFirst_but prevLast_but radApply_but export_but ...
    runDetect_but crop_but bkgrdInfo_but subtBkgrd_but posSet_but ...
    detCh1Prev_but detCh2Prev_but detCh3Prev_but

% -- Handles for edit boxes and text boxes
global inDir_ed infoCol_tx infoRow_tx infoChn_tx rad_ed infoBox ...
    imgInfo_tx maskPosition_tx ch1Thresh_ed ch1Mult_ed ch2Thresh_ed ...
    ch2Mult_ed ch3Thresh_ed ch3Mult_ed imgNoBox_tx multLbl_tx threshLbl_tx


% -- Handles for slider bars, checkboxes, imellipse, axes and guifig
global guifig prevPillar_ax intens_sl bright_sl objDetect_ckb elli ...
    bckgrdCh1_ckb bckgrdCh2_ckb bckgrdCh3_ckb quantCh1_ckb quantCh2_ckb ...
    quantCh3_ckb bkgroundSubt_ckb

% -- Variables
global dirin imgNList currImg currImgNo imgLibrary nImgs chipInfo ...
    chnList colList rowList imgID imgFlag nFlags flagNo intensFact ...
    brightFact imgMask elliSz elliPosX elliPosY posRef posMtx posRefMtx ...
    npillars chnlNo nChnls chnlNoDet nChnlsDet cropImgSz

% -- Switch variables
global flagOff posDef backgroundSub

% -- Output variables
global imgTotF imgAvgF imgStdF cropImgs imgMontage bkgrdInfo pkInfo ...
    totBkground relBkground cropImgsBkSub imgTotBS imgAvgBS imgStdBS

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize GUI
% -- Function to build GUI
    function genGUI(~,~)
     guifig=figure('Visible','off',...
            'Name','PillarReader',...
            'NumberTitle','off',...
            'Resize','off',...
            'Color',[0.941,0.941,0.941],...
            'Position',[510,80,703,720],...
            'WindowStyle','normal');
        
        % -- Build GUI components
        input_pan=uipanel('Parent',guifig,... % -- Input panel
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'Title','Import image set',...
            'Units','characters',...
            'Position',[1.2,48.615,138.8,5.846]);...
            uicontrol('Parent',input_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',11,...
            'HorizontalAlignment','center',...
            'String','Input folder:',...
            'Units','characters',...
            'Position',[2,2.923,15.6,1.385]);...
            inDir_ed=uicontrol('Parent',input_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',10,...
            'HorizontalAlignment','left',...
            'String','',...
            'Units','characters',...
            'Position',[18.4,2.615,116.8,1.692]);...
            inBrowse_but=uicontrol('Parent',input_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','Browse',...
            'Units','characters',...
            'Position',[95.2,0.615,18.2,1.769]);...
            import_but=uicontrol('Parent',input_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','Import',...
            'Units','characters',...
            'Position',[114.6,0.615,18.2,1.769]);...
            reset_but=uicontrol('Parent',input_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','Reset',...
            'Units','characters',...
            'Position',[19.2,0.615,18.2,1.769]);
        imset_pan=uipanel('Parent',guifig,... % -- Image set panel
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'Title','Image library info',...
            'Units','characters',...
            'Position',[1.2,38.385,28.8,10.231]);...
            uicontrol('Parent',imset_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'HorizontalAlignment','center',...
            'String','No pillars:',...
            'Units','characters',...
            'Position',[1.8,7.077,13,1.385]);...
            uicontrol('Parent',imset_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'HorizontalAlignment','center',...
            'String','No chanels:',...
            'Units','characters',...
            'Position',[1.8,5.385,15.2,1.385]);...
            uicontrol('Parent',imset_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'HorizontalAlignment','center',...
            'String','x',...
            'Units','characters',...
            'Position',[20.6,7.077,1.6,1.385]);...
            infoCol_tx=uicontrol('Parent',imset_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','',...
            'Units','characters',...
            'Position',[15.8,7.077,4.4,1.385]);...
            infoRow_tx=uicontrol('Parent',imset_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','',...
            'Units','characters',...
            'Position',[22.4,7.077,4.4,1.385]);...
            infoChn_tx=uicontrol('Parent',imset_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','',...
            'Units','characters',...
            'Position',[18.6,5.385,5.4,1.385]);...
            prevPillar_but=uicontrol('Parent',imset_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','Preview image',...
            'Units','characters',...
            'Position',[3.4,2.7,21.2,2]);...
            prevFirst_but=uicontrol('Parent',imset_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','|<',...
            'Units','characters',...
            'Position',[1.6,0.6,5.8,1.846]);...
            prevPrev_but=uicontrol('Parent',imset_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','<',...
            'Units','characters',...
            'Position',[7.6,0.6,5.8,1.846]);...
            prevNext_but=uicontrol('Parent',imset_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','>',...
            'Units','characters',...
            'Position',[14.4,0.6,5.8,1.846]);...
            prevLast_but=uicontrol('Parent',imset_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','>|',...
            'Units','characters',...
            'Position',[20.6,0.6,5.8,1.846]);
        area_pan=uipanel('Parent',guifig,... % -- Quantification panel
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'Title','Area selection',...
            'Units','characters',...
            'Position',[1.2,29.846,28.8,8.385]);...
            uicontrol('Parent',area_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'HorizontalAlignment','center',...
            'String','Selection radius:',...
            'Units','characters',...
            'Position',[3.8,5.308,20.2,1.385]);...
            rad_ed=uicontrol('Parent',area_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',10,...
            'HorizontalAlignment','center',...
            'String','',...
            'Units','characters',...
            'Position',[2.2,3.154,9.4,1.769]);...
            radApply_but=uicontrol('Parent',area_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','Apply',...
            'Units','characters',...
            'Position',[13.6,3,12,2.077]);...
            crop_but=uicontrol('Parent',area_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','Crop',...
            'Units','characters',...
            'Position',[5 0.692,17.6,2]);
        export_pan=uipanel('Parent',guifig,... % -- Export panel
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'Title','Analyze and export',...
            'Units','characters',...
            'Position',[1.2,2.308,28.8,27.154]);...
            threshLbl_tx=uicontrol('Parent',export_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'HorizontalAlignment','center',...
            'String','Thresh',...
            'Units','characters',...
            'Position',[15.8,12.692,7,1.077]);...
            multLbl_tx=uicontrol('Parent',export_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'HorizontalAlignment','center',...
            'String','Mult',...
            'Units','characters',...
            'Position',[9.8,12.615,5.8,1.154]);...
            bkgroundSubt_ckb=uicontrol('Parent',export_pan,...
            'Style','checkbox',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'String','Background subt.',...
            'Units','characters',...
            'Position',[1.8,23.462,24.6,2.077]);...
            bckgrdCh1_ckb=uicontrol('Parent',export_pan,...
            'Style','checkbox',...
            'FontName','Arial',...
            'FontSize',8,...
            'String','Ch1',...
            'Units','characters',...
            'Position',[1.2,21.615,8,1.769]);...
            bckgrdCh2_ckb=uicontrol('Parent',export_pan,...
            'Style','checkbox',...
            'FontName','Arial',...
            'FontSize',8,...
            'String','Ch2',...
            'Units','characters',...
            'Position',[10.4,21.615,8,1.769]);...
            bckgrdCh3_ckb=uicontrol('Parent',export_pan,...
            'Style','checkbox',...
            'FontName','Arial',...
            'FontSize',8,...
            'String','Ch3',...
            'Units','characters',...
            'Position',[19.6,21.615,8,1.769]);...
            subtBkgrd_but=uicontrol('Parent',export_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','Subtract',...
            'Units','characters',...
            'Position',[5.6,19.308,17.6,2]);... 
            bkgrdInfo_but=uicontrol('Parent',export_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','Background info',...
            'Units','characters',...
            'Position',[2.4,17,24.2,2]);...
            objDetect_ckb=uicontrol('Parent',export_pan,...
            'Style','checkbox',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'String','Object detection',...
            'Units','characters',...
            'Position',[2.2,14,24,2.077]);...       
            quantCh1_ckb=uicontrol('Parent',export_pan,...
            'Style','checkbox',...
            'FontName','Arial',...
            'FontSize',8,...
            'String','Ch1',...
            'Units','characters',...
            'Position',[2,10.615,8,1.769]);...
            quantCh2_ckb=uicontrol('Parent',export_pan,...
            'Style','checkbox',...
            'FontName','Arial',...
            'FontSize',8,...
            'String','Ch2',...
            'Units','characters',...
            'Position',[2,8.538,8,1.769]);...
            quantCh3_ckb=uicontrol('Parent',export_pan,...
            'Style','checkbox',...
            'FontName','Arial',...
            'FontSize',8,...
            'String','Ch3',...
            'Units','characters',...
            'Position',[2,6.462,8,1.769]);...
            ch1Mult_ed=uicontrol('Parent',export_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',8,...
            'HorizontalAlignment','center',...
            'Units','characters',...
            'Position',[10.4,10.692,5,1.692]);...
            ch1Thresh_ed=uicontrol('Parent',export_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',8,...
            'HorizontalAlignment','center',...
            'Units','characters',...
            'Position',[16.8,10.692,5,1.692]);...
            detCh1Prev_but=uicontrol('Parent',export_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'HorizontalAlignment','center',...
            'String','*',...
            'Units','characters',...
            'Position',[23.4,10.692,3,1.692]);...
            ch2Mult_ed=uicontrol('Parent',export_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',8,...
            'HorizontalAlignment','center',...
            'Units','characters',...
            'Position',[10.4,8.615,5,1.692]);...
            ch2Thresh_ed=uicontrol('Parent',export_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',8,...
            'HorizontalAlignment','center',...
            'Units','characters',...
            'Position',[16.8,8.615,5,1.692]);...
            detCh2Prev_but=uicontrol('Parent',export_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'HorizontalAlignment','center',...
            'String','*',...
            'Units','characters',...
            'Position',[23.4,8.615,3,1.692]);...
            ch3Mult_ed=uicontrol('Parent',export_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',8,...
            'HorizontalAlignment','center',...
            'Units','characters',...
            'Position',[10.4,6.538,5,1.692]);...
            ch3Thresh_ed=uicontrol('Parent',export_pan,...
            'Style','edit',...
            'BackgroundColor',[1,1,1],...
            'FontName','Arial',...
            'FontSize',8,...
            'HorizontalAlignment','center',...
            'Units','characters',...
            'Position',[16.8,6.538,5,1.692]);...
            detCh3Prev_but=uicontrol('Parent',export_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'HorizontalAlignment','center',...
            'String','*',...
            'Units','characters',...
            'Position',[23.4,6.538,3,1.692]);...
            runDetect_but=uicontrol('Parent',export_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','Run detection',...
            'Units','characters',...
            'Position',[4,3.846,20.6,2]);...
            export_but=uicontrol('Parent',export_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','Export',...
            'Units','characters',...
            'Position',[6.6,0.769,15,2]);
        preview_pan=uipanel('Parent',guifig,... % -- Pillar preview panel
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'Title','Pillar preview',...
            'Units','characters',...
            'Position',[31.2,2.231,108.8,46.308]);...
            uicontrol('Parent',preview_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',9,...
            'HorizontalAlignment','center',...
            'String','Intensity:',...
            'Units','characters',...
            'Position',[6.6,3,10,1.154]);...
            uicontrol('Parent',preview_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',9,...
            'HorizontalAlignment','center',...
            'String','Brightness:',...
            'Units','characters',...
            'Position',[3.6,1.077,13.2,1.154]);...
            prevPillar_ax=axes('Parent',preview_pan,...
            'SelectionHighlight','off',...
            'Units','pixels',...
            'Position',[16,69,512,512],...
            'XTick',[],...
            'XTickLabel','',...
            'YTick',[],...
            'YTickLabel','',...
            'Color',[0,0,0]);...
            posSet_but=uicontrol('Parent',preview_pan,...
            'Style','pushbutton',...
            'FontName','MS Sans Serif',...
            'FontSize',8,...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'String','SET pos',...
            'Units','characters',...
            'Position',[91.6,24,11.6,1.769]);
            intens_sl=uicontrol('Parent',preview_pan,...
            'Style','slider',...
            'SliderStep',[0.01,0.1],...
            'Units','characters',...
            'Position',[19,2.846,84.8,1.308]);...
            bright_sl=uicontrol('Parent',preview_pan,...
            'Style','slider',...
            'SliderStep',[0.01,0.1],...
            'Units','characters',...
            'Position',[19,1,84.8,1.308]);...
            imgInfo_tx=uicontrol('Parent',preview_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'FontWeight','bold',...
            'BackgroundColor',[0,0,0],...
            'ForegroundColor',[0.7,0.7,0.7],...
            'HorizontalAlignment','right',...
            'Units','characters',...
            'Position',[35,5.4,70,1.6]);...
            maskPosition_tx=uicontrol('Parent',preview_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',11,...
            'FontWeight','bold',...
            'BackgroundColor',[0,0,0],...
            'ForegroundColor',[0.7,0.7,0.7],...
            'HorizontalAlignment','left',...
            'Units','characters',...
            'Position',[4,42.6,25,1.6]);...
            imgNoBox_tx=uicontrol('Parent',preview_pan,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',11,...
            'FontWeight','bold',...
            'BackgroundColor',[0,0,0],...
            'ForegroundColor',[0.7,0.7,0.7],...
            'HorizontalAlignment','left',...
            'Units','characters',...
            'Position',[83,42.6,21.5,1.6]);
        infoBox=uicontrol('Parent',guifig,...
            'Style','text',...
            'FontName','MS Sans Serif',...
            'FontSize',10,...
            'HorizontalAlignment','right',...
            'String','InfoBox!',...
            'Units','characters',...
            'Position',[32,0.615,106.2,1.615]);
    end

% -- Function to preset/reset variables
    function resetVars(~,~)
        % Variables
        varargout={};
        imgNList={};
        currImg=uint16(zeros(512,512));
        currImgNo=1;
        imgLibrary={};
        chipInfo=[0,0,0];
        chnList=[];
        rowList=[];
        colList=[];
        nImgs=[];
        imgID=[];
        imgFlag={};
        nFlags=[];
        flagNo=1;
        flagOff=0;
        intensFact=1;
        brightFact=0;
        imgMask=[];
        elliSz=340;
        elliPosX=256-elliSz/2;
        elliPosY=elliPosX;
        elli=[];
        imgTotF={};
        imgAvgF={};
        imgStdF={};
        cropImgSz=[];
        cropImgs={};
        cropImgsBkSub={};
        imgTotF={};
        imgAvgF={};
        imgStdF={};
        imgTotBS={};
        imgAvgBS={};
        imgStdBS={};
        imgMontage={};
        posDef=1;
        posRef=cell(8,1);
        posRefMtx=cell(8,1);
        bkgrdInfo={};
        pkInfo={};
        backgroundSub=false;
        
        % GUI controls
        % -- Input panel
        set(inBrowse_but,'Enable','on')
        set(import_but,'Enable','on')
        
        % -- Image set info panel
        set(infoChn_tx,'String',num2str(chipInfo(1))),...
            set(infoRow_tx,'String',num2str(chipInfo(2))),...
            set(infoCol_tx,'String',num2str(chipInfo(3)))
        set(prevPillar_but,'Enable','off')
        set(prevNext_but,'Enable','off')
        set(prevPrev_but,'Enable','off')
        set(prevFirst_but,'Enable','off')
        set(prevLast_but,'Enable','off')
        
        % -- Area selection panel
        set(rad_ed,'String',num2str(elliSz/2))
        set(rad_ed,'Enable','off',...
            'String',num2str(elliSz/2))        
        set(radApply_but,'Enable','off')
        set(crop_but,'Enable','off')
        
        % -- Analyze and export panel
        set(bkgroundSubt_ckb,'Enable','off')
        set(bckgrdCh1_ckb,'Enable','off')
        set(bckgrdCh2_ckb,'Enable','off')
        set(bckgrdCh3_ckb,'Enable','off')
        set(subtBkgrd_but,'Enable','off')
        set(bkgrdInfo_but,'Enable','off')
        set(objDetect_ckb,'Enable','off')
        set(multLbl_tx,'Enable','off')
        set(threshLbl_tx,'Enable','off')
        set(quantCh1_ckb,'Enable','off')
        set(ch1Mult_ed,'Enable','off')
        set(ch1Thresh_ed,'Enable','off')
        set(detCh1Prev_but,'Enable','off')
        set(quantCh2_ckb,'Enable','off')
        set(ch2Mult_ed,'Enable','off')
        set(ch2Thresh_ed,'Enable','off')
        set(detCh2Prev_but,'Enable','off')
        set(quantCh3_ckb,'Enable','off')
        set(ch3Mult_ed,'Enable','off')
        set(ch3Thresh_ed,'Enable','off')
        set(detCh3Prev_but,'Enable','off')
        set(runDetect_but,'Enable','off')
        set(export_but,'Enable','off')
        
        % -- Pillar preview panel
        set(imgInfo_tx,'Visible','off')
        set(maskPosition_tx,'Visible','off',...
            'String',['[',num2str(elliPosX+elliSz/2),' ',...
            num2str(elliPosY+elliSz/2),' ',num2str(elliSz),']'])
        set(imgNoBox_tx,'Visible','off')
        set(posSet_but,'Enable','off',...
            'Visible','off')
        set(intens_sl,'Value',intensFact,...
            'Enable','off')
        set(bright_sl,'Value',brightFact,...
            'Enable','off')
        imshow(currImg,'Parent',prevPillar_ax)
        
        setInfoBox('Ready to go!',[0,1,0])
    end

% -- Check for input arguments and set dirin
if nargin==0
    dirin=cd;
else
    dirin=varargin{1};
end

% -- Check validity of input arguments
if nargin>0
    if ~ischar(varargin{1})
        disp('ERROR')
        disp('Input argument must be string')
        dirin=cd;
    elseif ~exist(varargin{1},'dir')
        disp('ERROR')
        disp('Input argument is not a valid directory')
        dirin=cd;
    end
end

% -- Build GUI, preset variables and turn visible
genGUI, resetVars
set(guifig,'Visible','on')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% UIcontrol functions
% -- UIcontrols' callback handles
set(inBrowse_but,'Callback',@inBrowse_Callback)
set(import_but,'Callback',@import_Callback)
set(reset_but,'Callback',@resetVars)
set(prevPillar_but,'Callback',@prevPillar_Callback)
set(prevFirst_but,'Callback',@prevFirst_Callback)
set(prevPrev_but,'Callback',@prevPrev_Callback)
set(prevNext_but,'Callback',@prevNext_Callback)
set(prevLast_but,'Callback',@prevLast_Callback)
set(radApply_but,'Callback',@radApply_Callback)
set(crop_but,'Callback',@crop_Callback)
set(bkgroundSubt_ckb,'Callback',@bkgroundSubt_Callback)
set(subtBkgrd_but,'Callback',@subtBkgrd_Callback)
set(bkgrdInfo_but,'Callback',@bkgrdInfo_Callback)
set(objDetect_ckb,'Callback',@objDetect_Callback)
set(quantCh1_ckb,'Callback',@quantCh1_Callback)
set(quantCh2_ckb,'Callback',@quantCh2_Callback)
set(quantCh3_ckb,'Callback',@quantCh3_Callback)
set(detCh1Prev_but,'Callback',@detCh1Prev_Callback)
set(detCh2Prev_but,'Callback',@detCh2Prev_Callback)
set(detCh3Prev_but,'Callback',@detCh3Prev_Callback)
set(runDetect_but,'Callback',@runDetect_Callback)
set(export_but,'Callback',@export_Callback)
set(posSet_but,'Callback',@posSet_Callback)
set(intens_sl,'Callback',@intens_Callback)
set(bright_sl,'Callback',@bright_Callback)


% -- UIcontrol (and imellipse drag) callback functions
    function inBrowse_Callback(~,~)
        % Callback for hitting the "Browse" button.
        n_dirin=uigetdir(dirin,'Choose folder...');
        if n_dirin==0
            return
        end
        dirin=n_dirin;
        set(inDir_ed,'String',dirin)
        clear n_dirin
    end

    function import_Callback(~,~)
        % Callback for hitting the "Import image library" pushbutton.
        
        dirin=get(inDir_ed,'String');
        % Check that dirin is valid
        if ~exist(dirin,'dir')
            setInfoBox('Input directory is not valid!',[1,0,0])
            n_dirin=uigetdir(cd,'Choose folder...');
            if n_dirin==0
                set(inDir_ed,'String',cd)
                return
            else
                dirin=n_dirin;
                set(inDir_ed,'String',dirin)
            end
        end
        
        tiffFinder=dirLoad; % Local function to load folder
        if tiffFinder==0 % checkpoint for the existence of tiff files
            return
        else
            set(infoChn_tx,'String',num2str(chipInfo(1)))
            set(infoRow_tx,'String',num2str(chipInfo(2)))
            set(infoCol_tx,'String',num2str(chipInfo(3)))
            pause(0.001)
            buildLib % Local function to build image library
            set(prevPillar_but,'Enable','on')
        end
        soundAlarm
    end

    function prevPillar_Callback(~,~)
        % Callback for hitting the "preview images" pushbutton. This
        % callback first runs a flagging protocol, to check for good "hits"
        % (images with cells) and creates a filter (imgFlag) so that only
        % those images are displayed. In case no images are flagged, it
        % turns the switch flagOff on and displays all the images in the
        % library.
        % Secondly, it triggers a protocol to set the mask position matrix
        % by asking for 12 chip edge positions. After all 12 positions are
        % set, it calculates the matrix and lets the user browse through
        % the (flagged) images.
        
        % Pre-analyze images and flag for preview, according to maxima and
        % standard deviations.
        setInfoBox('Analizing image library and setting flags',[0,0,0])
        
        imgFlag=cell(chipInfo(1),1); % Pre-allocate cells.
        for i=1:chipInfo(1) % Pre-allocate logical matrices.
            imgFlag{i}=false(chipInfo(2),chipInfo(3));
        end
        for i=1:chipInfo(1)
            imgFlag{i}=cellfun(@flagger,imgLibrary{i}); %local function
        end
        flagV=false(nImgs,1);
        for i=1:nImgs
            flagV(i)=imgFlag{imgID(i,1)}(imgID(i,2),imgID(i,3));
        end
        imgFlag=find(flagV); % replace nested cells with index vector
        [nFlags,~]=size(imgFlag);
        if nFlags==0 % checkpoint
            setInfoBox(['No images were flagged for preview... ',...
                'Displaying all'],[0,0,0])
            flagOff=1; % switch
            currImgNo=1;
        else
            flagOff=0;
            flagNo=1;
            currImgNo=imgFlag(flagNo);
        end
        intensFact=1;
        brightFact=0;
        if exist(fullfile(dirin,'positionMtx.mat'),'file')
            posMtx=importdata(fullfile(dirin,'positionMtx.mat'));
            posDef=13;
            set(prevPrev_but,'Enable','off')
            set(prevFirst_but,'Enable','off')
            set(prevNext_but,'Enable','on')
            set(prevLast_but,'Enable','on')
            set(crop_but,'Enable','on')
            setInfoBox(['Position matrix loaded. ',...
                'Previewig flagged images...'],[0,0,0])
        else
            posMtx=[];
            posDef=1;% counter
            setInfoBox('Set reference positions...',[0,0,0])
        end
        set(rad_ed,'Enable','on')
        set(radApply_but,'Enable','on')
        set(intens_sl,'Enable','on',...
            'Value',0.01)
        set(bright_sl,'Enable','on',...
            'Value',0.5)
        set(imgInfo_tx,'Visible','on')
        set(maskPosition_tx,'Visible','on')
        set(imgNoBox_tx,'Visible','on')
        dispImg % local function
        soundAlarm
    end

    function prevFirst_Callback(~,~)
        % Callback for hitting the "preview first image" pushbutton. The
        % flagOff switch allows to preview only the flagged images (case 0)
        % or the whole image library (case 2), in case no image was
        % flagged.
        switch flagOff
            case 0
                flagNo=1;
                currImgNo=imgFlag(flagNo);
            case 1
                currImgNo=1;
        end
        set(prevFirst_but,'Enable','off')
        set(prevPrev_but,'Enable','off')
        set(prevNext_but,'Enable','on')
        set(prevLast_but,'Enable','on')
        dispImg
    end

    function prevPrev_Callback(~,~)
        % Callback for hitting the "preview previous image" pushbutton. The
        % flagOff switch allows to preview only the flagged images (case 0)
        % or the whole image library (case 2), in case no image was
        % flagged.
        switch flagOff
            case 0
                flagNo=flagNo-1;
                currImgNo=imgFlag(flagNo);
                if flagNo==1
                    set(prevPrev_but,'Enable','off')
                    set(prevFirst_but,'Enable','off')
                elseif flagNo~=nFlags
                    set(prevNext_but,'Enable','on')
                    set(prevLast_but,'Enable','on')
                end
            case 1
                currImgNo=currImgNo-1;
                if currImgNo==1
                    set(prevPrev_but,'Enable','off')
                    set(prevFirst_but,'Enable','off')
                elseif currImgNo~=nImgs
                    set(prevNext_but,'Enable','on')
                    set(prevLast_but,'Enable','on')
                end
        end
        dispImg
    end

    function prevNext_Callback(~,~)
        % Callback for hitting the "preview next image" pushbutton. The
        % flagOff switch allows to preview only the flagged images (case 0)
        % or the whole image library (case 2), in case no image was
        % flagged.
        switch flagOff
            case 0
                flagNo=flagNo+1;
                currImgNo=imgFlag(flagNo);
                if flagNo==nFlags
                    set(prevNext_but,'Enable','off')
                    set(prevLast_but,'Enable','off')
                elseif flagNo>1
                    set(prevPrev_but,'Enable','on')
                    set(prevFirst_but,'Enable','on')
                end
            case 1
                currImgNo=currImgNo+1;
                if currImgNo>1
                    set(prevPrev_but,'Enable','on')
                    set(prevFirst_but,'Enable','on')
                elseif currImgNo==nImgs
                    set(prevNext_but,'Enable','off')
                    set(prevLast_but,'Enable','off')
                end
        end
        dispImg
    end

    function prevLast_Callback(~,~)
        % Callback for hitting the "preview last image" pushbutton. The
        % flagOff switch allows to preview only the flagged images (case 0)
        % or the whole image library (case 2), in case no image was
        % flagged.
        switch flagOff
            case 0
                flagNo=nFlags;
                currImgNo=imgFlag(flagNo);
            case 1
                currImgNo=nImgs;
        end
        set(prevFirst_but,'Enable','on')
        set(prevPrev_but,'Enable','on')
        set(prevNext_but,'Enable','off')
        set(prevLast_but,'Enable','off')
        dispImg
    end

    function radApply_Callback(~,~)
        % Callback for hitting the radius Apply pushbutton. The position of
        % the mask is adjusted, so that the center position isn't changed
        % along with the size.
        elliPosX=elliPosX-...
            (str2double(get(rad_ed,'String'))*2-elliSz)/2; % adjust posX
        elliPosY=elliPosY-...
            (str2double(get(rad_ed,'String'))*2-elliSz)/2; % adjust posY
        elliSz=str2double(get(rad_ed,'String'))*2; % radius to diameter
        set(maskPosition_tx,'String',... % update mask info box
            ['[',num2str(elliPosX+elliSz/2),' ',...
            num2str(elliPosY+elliSz/2),' ',num2str(elliSz),']'])
        dispImg
    end

    function crop_Callback(~,~)
        % Disable pushbuttons and other uicontrols during processing
        set(crop_but,'Enable','off')
        set(radApply_but,'Enable','off')
        set(prevPillar_but,'Enable','off')
        set(prevFirst_but,'Enable','off')
        set(prevPrev_but,'Enable','off')
        set(prevNext_but,'Enable','off')
        set(prevLast_but,'Enable','off')
        set(inBrowse_but,'Enable','off')
        set(import_but,'Enable','off')
        set(reset_but,'Enable','off')
        set(intens_sl,'Enable','off')
        set(bright_sl,'Enable','off')
        set(maskPosition_tx,'Visible','off')
        delete(elli)
        
        % Pre-allocate output variables
        cropImgSz=elliSz+1;
        cropImgs=cell(chipInfo(1),1);
        for i=1:chipInfo(1)
            cropImgs{i}=cell(chipInfo(2),chipInfo(3));
            for j=1:chipInfo(2)
                for k=1:chipInfo(3)
                    cropImgs{i}{j,k}=zeros(cropImgSz);
                end
            end
        end
        
        % Crop images
        elliRad=elliSz/2;
        for i=1:chipInfo(1)
            setInfoBox(['Cropping images... Set ',num2str(i),' of ',...
                num2str(chipInfo(1))],[0,0,0])
            for j=1:chipInfo(2)
                for k=1:chipInfo(3)
                    currImg=imgLibrary{i}{j,k};
                    posX=posMtx{j,k}(1)+elliRad;
                    posY=posMtx{j,k}(2)+elliRad;
                    [x,y]=meshgrid(-(posX-1):(512-posX),...
                        -(posY-1):(512-posY));
                    imgMask=(x.^2+y.^2)<=(elliRad)^2;
                    cropImgs{i}{j,k}=edgeObj(posX,posY,elliRad); % local
                end
            end
        end           
        
        % Set mask for cropped images
        [x,y]=meshgrid(-elliSz/2:elliSz/2,-elliSz/2:elliSz/2);
        imgMask=(x.^2+y.^2)<=(elliSz/2)^2;
                    
        set(reset_but,'Enable','on')
        set(prevPillar_but,'Enable','on')
        set(bkgroundSubt_ckb,'Enable','on')
        set(objDetect_ckb,'Enable','on')
        set(export_but,'Enable','on')
        setInfoBox(['Analysis completed! ',...
            'Run other algorithms or Export...'],[0,1,0]);
        soundAlarm
    end

    function bkgroundSubt_Callback(~,~)
        % Callback for checking/unchecking the "Background Subtraction"
        % checkbox. The activation of the "SD" and "%SD" edit boxes will be
        % chaged accordingly.
        switch get(bkgroundSubt_ckb,'Value')
            case 0
                switch chipInfo(1)
                    case 1
                        set(bckgrdCh1_ckb,'Enable','off')
                    case 2
                        set(bckgrdCh1_ckb,'Enable','off')
                        set(bckgrdCh2_ckb,'Enable','off')
                    case 3
                        set(bckgrdCh1_ckb,'Enable','off')
                        set(bckgrdCh2_ckb,'Enable','off')
                        set(bckgrdCh3_ckb,'Enable','off')
                end
            case 1
                switch chipInfo(1)
                    case 1
                        set(bckgrdCh1_ckb,'Enable','on')
                    case 2
                        set(bckgrdCh1_ckb,'Enable','on')
                        set(bckgrdCh2_ckb,'Enable','on')
                    case 3
                        set(bckgrdCh1_ckb,'Enable','on')
                        set(bckgrdCh2_ckb,'Enable','on')
                        set(bckgrdCh3_ckb,'Enable','on')
                end
                set(subtBkgrd_but,'Enable','on')
        end
    end

    function subtBkgrd_Callback(~,~)
        % Callback for hitting the "Subtract background" pushbutton.
        
        backgroundSub=true; %set backgroundSub ON for image display
        % Check which chanels are checked to be processed
        chnlNo=[];
        nChnls=[];
        if get(bckgrdCh1_ckb,'Value')==1
            chnlNo=1;
        end
        if get(bckgrdCh2_ckb,'Value')==1
            chnlNo=[chnlNo,2];
        end
        if get(bckgrdCh3_ckb,'Value')==1
            chnlNo=[chnlNo,3];
        end
        if isempty(chnlNo)
            setInfoBox('Select the chanels for background subtraction',...
                [1,0,0])
            return
        end
        [~,nChnls]=size(chnlNo);
                
        % Pre-allocate output variables
        [totBkground,relBkground]=deal(cell(1,chipInfo(1)));         
        cropImgsBkSub=cell(1,chipInfo(1));
        for i=1:nChnls
            [totBkground{chnlNo(i)},relBkground{chnlNo(i)}]=...
                deal(zeros(chipInfo(2),chipInfo(3)));
            cropImgsBkSub{chnlNo(i)}=cell(chipInfo(2),chipInfo(3));
            for j=1:chipInfo(2) % pre-allocate each image
                for k=1:chipInfo(3)
                cropImgsBkSub{chnlNo(i)}{j,k}=zeros(cropImgSz);
                end
            end
        end
        
        % Call background subtraction function
        n=0;
        for i=1:nChnls
            for j=1:chipInfo(2)
                for k=1:chipInfo(3)
                    currImg=cropImgs{chnlNo(i)}{j,k};
                    n=n+1;
                    set(imgInfo_tx,'String',['Chnl ',num2str(i),...
                        ', Row ',num2str(j),', Col ',num2str(k)])
                    setInfoBox(['Computing and subtracting the ',...
                        'background... Image ',num2str(n),' of ',...
                        num2str(nChnls*chipInfo(2)*chipInfo(3))],[0,0,0])
                    [cropImgsBkSub{chnlNo(i)}{j,k},...
                        totBkground{chnlNo(i)}(j,k),...
                        relBkground{chnlNo(i)}(j,k)]=...
                        bkgrdSubt(currImg);%local function
                end
            end
        end
        
        setInfoBox('Subtraction done. Run object detection or export...',...
            [0,1,0]);
        soundAlarm
        set(subtBkgrd_but,'Enable','off')
        set(bkgrdInfo_but,'Enable','on')
        assignin('base','cropImgs',cropImgs)
        assignin('base','totBkground',totBkground)
        assignin('base','relBkground',relBkground)
    end

    function bkgrdInfo_Callback(~,~)
        for i=1:nChnls
            x=1:chipInfo(3);
            y=1:chipInfo(2);
            figure('Name',['Chanel ',num2str(chnlNo(i)),...
                ' - total background fluorescence']),...
                mesh(x,y,totBkground{chnlNo(i)})
            figure('Name',['Chanel ',num2str(chnlNo(i)),...
                ' - relative background fluorescence']),...
                mesh(x,y,relBkground{chnlNo(i)})
        end
    end

    function objDetect_Callback(~,~)
        % Callback for checking/unchecking the "Object detection" checkbox.
        % The activation of the "treshold" and "limit" edit boxes will be
        % chaged accordingly.
        switch get(objDetect_ckb,'Value')
            case 0
                set(threshLbl_tx,'Enable','off')
                set(multLbl_tx,'Enable','off')
                switch chipInfo(1)
                    case 1
                        set(quantCh1_ckb,'Enable','off')
                        set(ch1Thresh_ed,'Enable','off')
                        set(ch1Mult_ed,'Enable','off')
                        set(detCh1Prev_but,'Enable','off')
                    case 2
                        set(quantCh1_ckb,'Enable','off')
                        set(ch1Thresh_ed,'Enable','off')
                        set(ch1Mult_ed,'Enable','off')
                        set(detCh1Prev_but,'Enable','off')
                        set(quantCh2_ckb,'Enable','off')
                        set(ch2Thresh_ed,'Enable','off')
                        set(ch2Mult_ed,'Enable','off')
                        set(detCh2Prev_but,'Enable','off')
                    case 3
                        set(quantCh1_ckb,'Enable','off')
                        set(ch1Thresh_ed,'Enable','off')
                        set(ch1Mult_ed,'Enable','off')
                        set(detCh1Prev_but,'Enable','off')
                        set(quantCh2_ckb,'Enable','off')
                        set(ch2Thresh_ed,'Enable','off')
                        set(ch2Mult_ed,'Enable','off')
                        set(detCh2Prev_but,'Enable','off')
                        set(quantCh3_ckb,'Enable','off')
                        set(ch3Thresh_ed,'Enable','off')
                        set(ch3Mult_ed,'Enable','off')
                        set(detCh3Prev_but,'Enable','off')
                end
            case 1
                set(runDetect_but,'Enable','on')
                set(threshLbl_tx,'Enable','on')
                set(multLbl_tx,'Enable','on')
                switch chipInfo(1)
                    case 1
                        set(quantCh1_ckb,'Enable','on')
                        if get(quantCh1_ckb,'Value')==1
                            set(ch1Thresh_ed,'Enable','on')
                            set(ch1Mult_ed,'Enable','on')
                            set(detCh1Prev_but,'Enable','on')
                        end
                    case 2
                        set(quantCh1_ckb,'Enable','on')
                        if get(quantCh1_ckb,'Value')==1
                            set(ch1Thresh_ed,'Enable','on')
                            set(ch1Mult_ed,'Enable','on')
                            set(detCh1Prev_but,'Enable','on')
                        end
                        set(quantCh2_ckb,'Enable','on')
                        if get(quantCh2_ckb,'Value')==1
                            set(ch2Thresh_ed,'Enable','on')
                            set(ch2Mult_ed,'Enable','on')
                            set(detCh2Prev_but,'Enable','on')
                        end
                    case 3
                        set(quantCh1_ckb,'Enable','on')
                        if get(quantCh1_ckb,'Value')==1
                            set(ch1Thresh_ed,'Enable','on')
                            set(ch1Mult_ed,'Enable','on')
                            set(detCh1Prev_but,'Enable','on')
                        end
                        set(quantCh2_ckb,'Enable','on')
                        if get(quantCh2_ckb,'Value')==1
                            set(ch2Thresh_ed,'Enable','on')
                            set(ch2Mult_ed,'Enable','on')
                            set(detCh2Prev_but,'Enable','on')
                        end
                        set(quantCh3_ckb,'Enable','on')
                        if get(quantCh3_ckb,'Value')==1
                            set(ch3Thresh_ed,'Enable','on')
                            set(ch3Mult_ed,'Enable','on')
                            set(detCh3Prev_but,'Enable','on')
                        end
                end
        end
    end

    function quantCh1_Callback(~,~)
      % Callback for checking/unchecking the "Object detection - chanel 1" 
      % checkbox. The SD and %SD edit boxes will be enabled accordingly.
        switch get(quantCh1_ckb,'Value')
            case 0
                set(ch1Thresh_ed,'Enable','off')
                set(ch1Mult_ed,'Enable','off')
                set(detCh1Prev_but,'Enable','off')
            case 1
                set(ch1Thresh_ed,'Enable','on')
                set(ch1Mult_ed,'Enable','on')
                set(detCh1Prev_but,'Enable','on')
        end  
    end

    function quantCh2_Callback(~,~)
        % Callback for checking/unchecking the "Object detection - chanel 2"
        % checkbox. The SD and %SD edit boxes will be enabled accordingly.
        switch get(quantCh2_ckb,'Value')
            case 0
                set(ch2Thresh_ed,'Enable','off')
                set(ch2Mult_ed,'Enable','off')
                set(detCh2Prev_but,'Enable','off')
            case 1
                set(ch2Thresh_ed,'Enable','on')
                set(ch2Mult_ed,'Enable','on')
                set(detCh2Prev_but,'Enable','on')
        end
    end

    function quantCh3_Callback(~,~)
        % Callback for checking/unchecking the "Object detection - chanel 3"
        % checkbox. The SD and %SD edit boxes will be enabled accordingly.
        switch get(quantCh3_ckb,'Value')
            case 0
                set(ch3Thresh_ed,'Enable','off')
                set(ch3Mult_ed,'Enable','off')
                set(detCh3Prev_but,'Enable','off')
            case 1
                set(ch3Thresh_ed,'Enable','on')
                set(ch3Mult_ed,'Enable','on')
                set(detCh3Prev_but,'Enable','on')
        end
    end

    function detCh1Prev_Callback(~,~)
        pixlcomp(1)
    end

    function detCh2Prev_Callback(~,~)
        pixlcomp(2)
    end

    function detCh3Prev_Callback(~,~)
        pixlcomp(3)
    end

    function runDetect_Callback(~,~)
       % Callback for hitting the "Run detection" pushbutton.
       
       % Check which chanels are to be quantified       
       chnlNoDet=[];
        if get(quantCh1_ckb,'Value')==1
            chnlNoDet=1;
        end
        if get(quantCh2_ckb,'Value')==1
            chnlNoDet=[chnlNoDet,2];
        end
        if get(quantCh3_ckb,'Value')==1
            chnlNoDet=[chnlNoDet,3];
        end
        nChnlsDet=numel(chnlNoDet);
        
        % Check that the input parameters are valid
        if get(quantCh1_ckb,'Value')==1
            if isnan(str2double(get(ch1Thresh_ed,'String'))) || ...
                    isnan(str2double(get(ch1Mult_ed,'String')))
                setInfoBox('Input parameters are not valid...',[1,0,0])
                return
            elseif str2double(get(ch1Thresh_ed,'String'))<1 || ...
                    str2double(get(ch1Mult_ed,'String'))<0
                setInfoBox('Input parameters are not valid...',[1,0,0])
                return
            end
        end
        if get(quantCh2_ckb,'Value')==1
            if isnan(str2double(get(ch2Thresh_ed,'String'))) || ...
                    isnan(str2double(get(ch2Mult_ed,'String')))
                setInfoBox('Input parameters are not valid...',[1,0,0])
                return
            elseif str2double(get(ch2Thresh_ed,'String'))<1 || ...
                    str2double(get(ch2Mult_ed,'String'))<0
                setInfoBox('Input parameters are not valid...',[1,0,0])
                return
            end
        end
        if get(quantCh3_ckb,'Value')==1
            if isnan(str2double(get(ch3Thresh_ed,'String'))) || ...
                    isnan(str2double(get(ch3Mult_ed,'String')))
                setInfoBox('Input parameters are not valid...',[1,0,0])
                return
            elseif str2double(get(ch3Thresh_ed,'String'))<1 || ...
                    str2double(get(ch3Mult_ed,'String'))<0
                setInfoBox('Input parameters are not valid...',[1,0,0])
                return
            end
        end
        
        % Quantify
        pkInfo=cell(1,chipInfo(1)); %pre-allocate
        for i=1:nChnlsDet
            setInfoBox(['Quantifying peaks in set ',...
                num2str(i),' of ',num2str(nChnlsDet),'...'],[0,0,0])
            %pre-allocate
            pkInfo{chnlNoDet(i)}=zeros(chipInfo(2),chipInfo(3));
            %set the right image library
            if isempty(cropImgsBkSub)
                currLib=cropImgs{chnlNoDet(i)};
            else
                if isempty(intersect(chnlNo,chnlNoDet(i)))
                    currLib=cropImgs{chnlNoDet(i)};
                else
                    currLib=cropImgsBkSub{chnlNoDet(i)};
                end
            end
            %set thresh and lim
            switch chnlNoDet(i)
                case 1
                    thresh=str2double(get(ch1Thresh_ed,'String'));
                    lim=str2double(get(ch1Mult_ed,'String'));
                case 2
                    thresh=str2double(get(ch2Thresh_ed,'String'));
                    lim=str2double(get(ch2Mult_ed,'String'));
                case 3
                    thresh=str2double(get(ch3Thresh_ed,'String'));
                    lim=str2double(get(ch3Mult_ed,'String'));
            end
            %run algorithm
            for j=1:chipInfo(2)
                for k=1:chipInfo(3)
                    currImg=currLib{j,k};
                    pkInfo{chnlNoDet(i)}(j,k)=...
                        pkcount(currImg,thresh,lim); %local function
                end
            end
        end
        setInfoBox('Done counting peaks. Ready to export...',[0,0,0])
        soundAlarm
    end

    function export_Callback(~,~)
        clear imgLibrary % free memory
        
        % pre-allocate output variables
        [imgTotF,imgAvgF,imgStdF]=deal(cell(chipInfo(1),1));
        for i=1:chipInfo(1)
            [imgTotF{i},imgAvgF{i},imgStdF{i}]=...
                deal(zeros(chipInfo(2),chipInfo(3)));
        end
        
        if ~isempty(cropImgsBkSub)
            [imgTotBS,imgAvgBS,imgStdBS]=deal(cell(nChnls,1));
            for i=1:nChnls
                [imgTotBS{chnlNo(i)},imgAvgBS{chnlNo(i)},...
                    imgStdBS{chnlNo(i)}]=...
                    deal(zeros(chipInfo(2),chipInfo(3)));
            end
        end
        
        % Analyze image library
        setInfoBox('Analyzing image library...' ,[0,0,0])
        for i=1:chipInfo(1)
            for j=1:chipInfo(2)
                for k=1:chipInfo(3)
                    currImg=cropImgs{i}{j,k};
                    imgTotF{i}(j,k)=sum(currImg(imgMask));
                    imgAvgF{i}(j,k)=mean(currImg(imgMask));
                    imgStdF{i}(j,k)=std(double(currImg(imgMask)));
                    
                end
            end
        end
        
        if ~isempty(cropImgsBkSub)
            for i=1:nChnls
                for j=1:chipInfo(2)
                    for k=1:chipInfo(3)
                        currImg=cropImgsBkSub{chnlNo(i)}{j,k};
                        imgTotBS{i}(j,k)=sum(currImg(imgMask));
                        imgAvgBS{i}(j,k)=mean(currImg(imgMask));
                        imgStdBS{i}(j,k)=std(double(currImg(imgMask)));
                    end
                end
            end
        end
        
        
        %Build montages
        montageBuilder
        
        % Write image montages
        setInfoBox('Writing montage image...',[0,0,0])
        pause(0.001)
        if ~exist(fullfile(dirin,'Montages'),'dir')
            mkdir(dirin,'Montages')
        end
        for i=1:chipInfo(1)
            imgMontage{i}=uint16(imgMontage{i}*16);
            imwrite(imgMontage{i},...
                fullfile(dirin,'Montages',...
                strcat('chl',num2str(i),'montage_nnew.tiff')),...
                'Compression','none')
        end
        
        % Write library of cropped images
                
        if ~exist(fullfile(dirin,'croppedImgs'),'dir')
            mkdir(dirin,'croppedImgs')
        end
        
        for i=1:chipInfo(1)
            setInfoBox(['Writing cropped images. Set',...
                num2str(i),' of ',num2str(chipInfo(1)),'...'],[0,0,0])
            for j=1:chipInfo(2)
                for k=1:chipInfo(3)
                    imwrite(uint16(cropImgs{i}{j,k}),...
                        fullfile(dirin,'croppedImgs',...
                        ['chnl_',num2str(i),'_row_',num2str(j),...
                        '_col_',num2str(k),'.tiff']),...
                        'Compression','none')
                end
            end
        end
        
        % Write library of background subtracted images
        if ~isempty(cropImgsBkSub)
            if ~exist(fullfile(dirin,'croppedImgs','subBackground'),'dir')
                mkdir(fullfile(dirin,'croppedImgs'),'subBackground')
            end
            
            for i=1:nChnls
                setInfoBox(['Writing background subtracted images. Set',...
                    num2str(chnlNo(i)),' of ',num2str(chipInfo(1)),'...'],...
                    [0,0,0])
                for j=1:chipInfo(2)
                    for k=1:chipInfo(3)
                        imwrite(uint16(cropImgsBkSub{chnlNo(i)}{j,k}),...
                            fullfile(dirin,'croppedImgs',...
                            'subBackground',...
                            ['chnl_',num2str(chnlNo(i)),...
                            '_row_',num2str(j),'_col_',num2str(k),...
                            '.tiff']),...
                            'Compression','none')
                    end
                end
            end
        end
        
        % Write data to excel
        % To avoid issues with OneDrive, first export the data to a folder
        % in the current directory (\temp) and then move the output file 
        % to dirin.
        
        % Check if temp folder exists and create it if it doesn't
        dirtemp=fullfile(cd,'temp');
        if ~exist(dirtemp,'dir')
            mkdir(cd,'temp')
        end
        
        sheetlabel={'TotFluor','AvgFluor','Std_Fluor','';...
            'TotFluorBS','AvgFluorBS','StdFluorBS','TotBG'};
        infoOut={imgTotF,imgAvgF,imgStdF,{};...
            imgTotBS,imgAvgBS,imgStdBS,totBkground};
        setInfoBox('Writing output excel files...',[0,0,0])
        
        % Write info of unmodified cropped images 
        for i=1:chipInfo(1)
            for j=1:3
                try
                    xlswrite(fullfile(dirtemp,'outdata_nnew.xlsx'),...
                        infoOut{1,j}{i},...
                        strcat('chl',num2str(i),sheetlabel{1,j}))
                catch
                    disp(['Couldn''t write excel sheet no. ',...
                        num2str(j+(i-1)*3)])
                    currData=infoOut{1,j}{i}; %#ok<NASGU>
                    save(fullfile(dirtemp,['outdata_n_','chl',num2str(i),...
                        sheetlabel{1,j},'.txt']),'currData',...
                        '-ascii','-double','-tabs')
                end
            end
        end
        
        % Write info of background subtracted images
        if ~isempty(cropImgsBkSub)
            for i=1:nChnls
                for j=1:4
                    xlswrite(fullfile(dirtemp,'outdata_bkSub.xlsx'),...
                        infoOut{2,j}{chnlNo(i)},...
                        strcat('chl',num2str(chnlNo(i)),sheetlabel{2,j}))
                end
            end
        end
        
        % Write info of peak detection/cell quantification
        if ~isempty(pkInfo)
            for i=1:nChnlsDet
                xlswrite(fullfile(dirtemp,'outdata_cellCount.xlsx'),...
                    pkInfo{chnlNoDet(i)},...
                    strcat('chl',num2str(chnlNoDet(i))))
            end
        end
        
        % Move output file(s) to dirin folder.
        movefile(fullfile(dirtemp,'outdata*'),dirin)
        
        % Exit
        varargout={};
        setInfoBox('Done!',[0,1,0])
        soundAlarm
        uiresume
    end

    function intens_Callback(~,~)
        % Callback for dragging the intensity slider.
        intensFact=get(intens_sl,'Value')*100;
        dispImg
    end

    function bright_Callback(~,~)
        % Callback for dragging the brightness slider.
        brightFact=(get(bright_sl,'Value')-0.5)*60000;
        dispImg
    end

    function posSet_Callback(~,~)
        % Callback for hitting the SET position pushbutton. Sets the
        % mask reference positions and calculates the position matrix.
        % Each coordenate (X and Y) will be dependent on both the column 
        % number and the row number. So, it is necessary to calculate the
        % four different slopes: X along rows, X along columns, Y along
        % rows and Y along columns. 
        
        % Set the reference position [posDef] of 8
        posRef{posDef}=[elliPosX,elliPosY];
        % Check if all the 8 reference are set and calculate the slopes.
        if posDef==12 
            % Pre-allocate the slopes.
            horX=zeros(1,4);
            horY=zeros(1,4);
            verX=zeros(1,4);
            verY=zeros(1,4);
            posHor=[1 4 5 6 7 8 9 12];
            posVer=[1 9 2 10 3 11 4 12];
            % For each slope, 4 "samples" are calculated and then averaged.
            for i=1:4
                horX(i)=(posRef{posHor(i*2)}(1)-posRef{posHor(i*2-1)}(1))/11;
                horY(i)=(posRef{posHor(i*2)}(2)-posRef{posHor(i*2-1)}(2))/11;
                verX(i)=(posRef{posVer(i*2)}(1)-posRef{posVer(i*2-1)}(1))/35;
                verY(i)=(posRef{posVer(i*2)}(2)-posRef{posVer(i*2-1)}(2))/35;
            end
            horX=mean(horX);
            horY=mean(horY);
            verX=mean(verX);
            verY=mean(verY);
            % The coordinates of the pillar {1,1} are set as the "b" in 
            % "mx+b", or the intersection points.
            if chipInfo(3)==12 % if 12 columns, b will be the 1st ref
                bX=posRef{1}(1);
                bY=posRef{1}(2);
            elseif chipInfo(3)==14 %if 14 columns, b will be 1st ref - slope
                bX=posRef{1}(1)-horX;
                bY=posRef{1}(2)-horY;
            end
            % Set the position matrix.
            posMtx=cell(chipInfo(2),chipInfo(3));
            for j=1:chipInfo(3)
                for i=1:chipInfo(2)
                    posMtx{i,j}=[round(bX+(j-1)*horX+(i-1)*verX),...
                        round(bY+(j-1)*horY+(i-1)*verY)];
                end
            end
            %save the position matrix
            save(fullfile(dirin,'positionMtx.mat'),'posMtx')
            % Inactivate the button.
            set(posSet_but,'Enable','off',...
                'Visible','off')
            set(prevPrev_but,'Enable','off')
            set(prevFirst_but,'Enable','off')
            set(prevNext_but,'Enable','on')
            set(prevLast_but,'Enable','on')
            set(crop_but,'Enable','on')
            setInfoBox('Position matrix set. Previewing images...',[0,0,0])
        end
        posDef=posDef+1;
        dispImg % local function
    end
            
    function elliDrag_Callback(elliPos,~)
        % Callback function for dragging/resizing the mask ellipse
        % elliPos is given as [posX posY diamX diamY] - because the aspect 
        % ratio is fixed, indices 3 and 4 will always be equal.  
        
        elliSz=elliPos(3); % get diameter 
        elliPosX=elliPos(1); % get posX
        elliPosY=elliPos(2); % get posY
        
        % Display position/size in the mask info box - the position given
        % refers to the center of the mask, rather than the top left angle;
        % the size refers to the diameter.
        set(maskPosition_tx,'String',... 
            ['[',num2str(elliPosX+elliSz/2),' ',...
            num2str(elliPosY+elliSz/2),' ',num2str(elliSz),']'])
        set(rad_ed,'String',num2str(elliSz/2)) % set the edit box with the 
                                               % radius, rather than the 
                                               % diameter.
        dispImg
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Local functions (operational)
% -- Set InfoBox
    function setInfoBox(infoTxt,infoColor)
        set(infoBox,'String',infoTxt,'ForegroundColor',infoColor)
        pause(0.001)
    end

% -- Sound alarm
    function soundAlarm(~,~)
        [audsmpl,audfreq]=audioread('C:\Windows\Media\chord.wav');
        sound(audsmpl,audfreq)
    end

% -- Load folder and check numbers of pillars and chanels 
    function tiffFinder=dirLoad(~,~)
        % Load folder
        setInfoBox('Analyzing folder...',[0,0,0])
        inDir=dir(dirin);
        [dirSize,~]=size(inDir);
        imgNList=cell(dirSize,1);
        k=1;
        for i=1:dirSize
            if inDir(i,1).isdir==0
                if strcmp(inDir(i,1).name(end-4:end),'.tiff')==1
                    imgNList{k}=inDir(i,1).name;
                    k=k+1;
                end
            end
        end
        if k==1
            setInfoBox('*.tiff files not found...',[1,0,0])
            tiffFinder=0;
            return
        else tiffFinder=1;
        end
        imgNList=imgNList(1:k-1);
        nImgs=k-1;
        
        % Check numbers of columns, rows and chanels and save identifiers
        colList=cell(nImgs,1);
        rowList=cell(nImgs,1);
        chnList=cell(nImgs,1);
        for i=1:nImgs
            chnList{i}=imgNList{i}(end-5);
            colList{i}=imgNList{i}(end-8:end-7);
            rowList{i}=imgNList{i}(end-14:end-13);
        end
        [chipInfo(1),~]=size(unique(chnList));
        [chipInfo(2),~]=size(unique(rowList));
        [chipInfo(3),~]=size(unique(colList));
        npillars=chipInfo(2)*chipInfo(3);

        setInfoBox('Finished loading folder!',[0,1,0])
    end

% -- Build image library
    function buildLib(~,~)
        setInfoBox('Building library...',[0,0,0])
        % Get chanels, rows and columns identifiers
        imgID=zeros(nImgs,3);
        for i=1:nImgs % get identifiers out of filename
            imgID(i,1)=str2double(chnList{i});
            imgID(i,2)=str2double(rowList{i}(regexp(rowList{i},'\d')));
            imgID(i,3)=str2double(colList{i});
        end
        % sort row and col identifiers and replace them by their indices.
        rowID=sort(unique(imgID(:,2)));
        colID=sort(unique(imgID(:,3)));
        for i=1:nImgs  
            imgID(i,2)=find(rowID==imgID(i,2));
            imgID(i,3)=find(colID==imgID(i,3));
        end
        
        % Pre-alocate image library (nested cells - two levels).
        % First level for each chanel; second level for each image (pixel 
        % matrix), in the same layout as the chip (row x column).
        imgLibrary=cell(chipInfo(1),1); % Pre-alocate first level cell.
        for i=1:chipInfo(1) % Pre-alocate second level cells.
            imgLibrary{i}=cell(chipInfo(2),chipInfo(3));
        end
        % Build library
        for i=1:nImgs
            imgLibrary{imgID(i,1)}{imgID(i,2),imgID(i,3)} = ...
                imread(fullfile(dirin,imgNList{i}));
        end
        % Set the reference mask positions matrix
        if chipInfo(3)==14
            posRefMtx={[1,2];...
                [1,6];...
                [1,9];...
                [1,13];...
                [13,2];...
                [13,13];...
                [24,2];...
                [24,13];...
                [36,2];...
                [36,6];...
                [36,9];...
                [36,13]};
        elseif chipInfo(3)==12
            posRefMtx={[1,1];...
                [1,5];...
                [1,8];...
                [1,12];...
                [13,1];...
                [13,12];...
                [24,1];...
                [24,12];...
                [36,1];...
                [36,5];...
                [36,8];...
                [36,12]};
        else
            posDef=13;
        end
        setInfoBox('Finished building image library!',[0,1,0])
    end

% -- Display image
    function dispImg(~,~)
        switch backgroundSub
            case false
                if posDef<13
                    currImg=imgLibrary{1}{posRefMtx{posDef}(1),...
                        posRefMtx{posDef}(2)};
                    currImg=currImg*10*intensFact+brightFact;
                    imshow(currImg,'Parent',prevPillar_ax)
                    set(imgInfo_tx,'String',['Set reference ',...
                        num2str(posDef),' of 12'],...
                        'ForegroundColor',[1,0,0])
                    set(posSet_but,'Enable','on',...
                        'Visible','on')
                    elliBuilder % Local function
                else
                    currImg=imgLibrary{imgID(currImgNo,1)}...
                        {imgID(currImgNo,2),imgID(currImgNo,3)};
                    currImg=currImg*10*intensFact+brightFact;
                    imshow(currImg,'Parent',prevPillar_ax)
                    set(imgInfo_tx,'String',imgNList(currImgNo))
                    if flagOff==0
                        set(imgNoBox_tx,'String',...
                            ['Img ',num2str(flagNo),' of ',num2str(nFlags)])
                    else
                        set(imgNoBox_tx,'String',...
                            ['Img ',num2str(currImgNo),' of ',num2str(nImgs)])
                    end
                    elliBuilder %Local function
                end
            case true
                imshow(currImg,'Parent',prevPillar_ax)
                pause(0.001)
        end
    end

% -- Image sample flagger
    function flagg=flagger(mtx)
        flagg=(max(max(mtx))>300 && std(std(double(mtx)))>15);
    end

% -- Build imellipse for mask
    function elliBuilder(~,~)
        if posDef==13
            elliPosX=posMtx{imgID(currImgNo,2),imgID(currImgNo,3)}(1);
            elliPosY=posMtx{imgID(currImgNo,2),imgID(currImgNo,3)}(2);
        end
        elli=imellipse(prevPillar_ax,[elliPosX,elliPosY,elliSz,elliSz]);
        set(maskPosition_tx,'String',... % update mask info box
            ['[',num2str(elliPosX+elliSz/2),' ',...
            num2str(elliPosY+elliSz/2),' ',num2str(elliSz),']'])
        setFixedAspectRatioMode(elli,1)
        addNewPositionCallback(elli,@elliDrag_Callback);
    end

% -- Image cropping
    function cropImg=edgeObj(posX,posY,elliRad)
         cropImg=currImg;
         cropImg(~imgMask)=0; %apply mask
         
         % crop around mask
         cropImg=cropImg(posY-elliRad:posY+elliRad,...
             posX-elliRad:posX+elliRad);
    end

% -- Image background subtraction
    function [newimg,totBkgrd,relBkgrd]=bkgrdSubt(img)
        % BKGRDSUBT detects the optimal threshold for background
        % subtraction of the input image. It first calculates the exponent
        % (pixel^x) that generates an image with maximum standard
        % deviation. Then, it writes an histogram of pixel values
        % (1000 bins), calculates its derivate, converts negative values to
        % positive and smooths it (span of 25 bins). The background values
        % will be concentrated on the left end of the histogram. By
        % smoothing it, it is possible to have a fair perception of the
        % background threshold and convert it to zero. To account for the
        % background in the areas with cells, the mean background value is
        % subtracted in those areas.
      
        img=double(img);
        pixlTotal=sum(sum(img)); % total fluorescence before subtraction
        [imgSize,~]=size(img);
        
        x=(1.5:0.25:5);
        fStd=zeros(size(x));
        for i=1:numel(x)
            expImg=double(uint16(img.^x(i)));
            fStd(i)=std(expImg(expImg~=0));
        end
        
        % Check if the pillar is a blank
        if isempty(findpeaks(fStd)) || max(max(uint16(img.^2.4)))<65355
            background=img;
            cells=zeros(imgSize);
            if max(max(uint16(img.^2.4)))==65535
                maxX=2;
            else
                maxX=1;
            end
            currImg=uint16(img.^maxX); dispImg
        else
            x=(1.5:0.02:2.3);
            fStd=zeros(size(x));
            for i=1:numel(x)
                expImg=double(uint16(img.^x(i)));
                fStd(i)=std(expImg(expImg~=0));
            end
            
            [~,pkind]=findpeaks(fStd);
            if ~isempty(findpeaks(fStd))
                % images with higher background generate a peak at a good
                % threshold
                maxX=x(pkind(1));
            else
                % images with lower background only generate a later peak,
                % when the background is too bright. To set the optimal
                % exponent, the program calculates the gradient (derivate -
                % "speed") and second gradient (second derivate -
                % "acceleration") and sets the exponent as the point where
                % the "speed" stabilizes, after the first peak. This point
                % is found in the "acceleration" as the peak close to 0,
                % after the acceleration minimum ("desacceleration").
                %
                % "Speed" (always positive):
                %          -
                %         / \
                %        /   \
                %       /     -   <- slight speed stabilization
                %      /        \
                %-----/          \------
                %
                % "Acceleration":
                %
                %+%     -      _ acceleration peak (negative, close to 0)
                %+%    / \    |
                %+%   /   \   V
                %0%--/     \     /------
                %-%  min -> \/\_/
                %-%
                %
                dfStd=smoother(gradient(fStd),3); %calculate derivate
                ddfStd=smoother(gradient(dfStd),3);%calculate second derivate
                [dpks,dfpk]=findpeaks(dfStd); %findpeaks in derivate
                if isempty(dpks)
                    %if there are no peaks in the derivate, look for the
                    %peaks in the second derivate.
                    [dpks,dfpk]=findpeaks(ddfStd);
                    if isempty(dpks)
                        dfpk=find(ddfStd==max(ddfStd),1);
                        dpks=ddfStd(dfpk);
                    end
                end
                
                invddfStd=ddfStd.*(-1); %invert the second derivate to find
                %the minima
                [~,iddfpk]=findpeaks(invddfStd); %find the minima in the
                %second derivate
                
                maxdpk=dfpk(dpks==max(dpks)); %find the max peak in derivate
                iddfpk=iddfpk(iddfpk>maxdpk); %select only the minima that
                %come after the max peak in
                %the derivate
                
                %if there is no minima at this point, select the first
                %derivate max, instead of the maximum max.
                if isempty(iddfpk)
                    [~,iddfpk]=findpeaks(invddfStd);
                    maxdpk=dfpk(1);
                    iddfpk=iddfpk(iddfpk>maxdpk);
                end
                
                %if there is still no minima at this point, select the
                %first peak in the second derivate
                if isempty(iddfpk)
                    [~,dfpk]=findpeaks(ddfStd);
                    [~,iddfpk]=findpeaks(invddfStd);
                    if ~isempty(dfpk)
                        maxdpk=dfpk(1);
                        iddfpk=iddfpk(iddfpk>maxdpk);
                    end
                    % if there is no peak in the second derivate, select
                    % all the minima in the second derivate.
                end
                
                n=invddfStd(iddfpk); %check the values of the selected
                %minima
                
                if numel(n)>1
                    %if there's more than one minimum and the second
                    %minimum is lower than the first and not too far from
                    %it in the x axis, set the second minimum as the
                    %min peak. Else, set the first minimum as the min peak.
                    if n(2)>n(1) && x(iddfpk(2))-x(iddfpk(1))<0.2
                        minpk=iddfpk(2);
                    else
                        minpk=iddfpk(1);
                    end
                elseif numel(n)==1
                    %if there's only one minimum, set it as the min peak.
                    minpk=iddfpk(1);
                else
                    % if there's still no minimum peak, set the lowest
                    % point of the second derivate, after the derivate max
                    % peak, as the min peak.
                    minpk=find(ddfStd==min(ddfStd(maxdpk:end)));
                    minpk=min(minpk(minpk>=maxdpk));
                end
                
                % find the closest point to 0 after the minimum
                ddfStdN=ddfStd(x>=x(minpk)); %select data after the minimum
                ddfStdN=sqrt(ddfStdN.^2)*(-1); %invert data again
                if numel(ddfStdN)<3
                    maxX=x(minpk);
                else
                    [~,pk0]=findpeaks(ddfStdN);
                    if isempty(pk0)
                        %if there's no peak, choose closest point to 0.
                        maxInd=find(ddfStdN==max(ddfStdN),1);
                        maxX=x(minpk-1+maxInd);
                    else
                        maxX=x(minpk-1+pk0(1));
                    end
                end
            end
        end
        
        if maxX>1   
            tempimg=double(uint16(img.^maxX));
            % Compute threshold in exponentiated image
            minthresh=double(multithresh(tempimg(tempimg>0)));
            minthresh=minthresh^(1/maxX);
            minthresh=round(minthresh);
            
            % Generate binary mask using computed threshold
            maskim=imquantize(img, minthresh);
            
            % Because IMQUANTIZE generates an array of 1s and 2s:
            maskim=maskim-1;
            
            % Apply filters:
            maskim=bwareaopen(maskim,5);
            maskim=bwmorph(bwmorph(maskim,'spur'),'spur');
            maskim=bwmorph(imthinbreak(maskim),'spur');
            maskim=bwareaopen(maskim,5);
            
            % Apply mask to image:
            background=img;
            cells=img;
            background(maskim)=0;
            cells(~maskim)=0;
        end
        
        % Remove baseline average background from positive areas (cells)
        newimg=zeros(imgSize);
        avgbkground=mean(mean(background(background>0)));
        totBkgrd=0; %for total background subtraction calculation
        
        % Remove 90% of average background from positive areas:
        for i=1:numel(img)
            if cells(i)>0
                newimg(i)=img(i)-avgbkground*0.9;
                totBkgrd=totBkgrd+avgbkground*0.9;
            elseif background(i)>0
                totBkgrd=totBkgrd+img(i);
                newimg(i)=0;
            end
        end
        newimg=uint16(newimg);
        currImg=uint16(double(newimg).^maxX); dispImg
        relBkgrd=totBkgrd/pixlTotal;
    end

% -- Pixel "bridge" breaker
    function newimg=imthinbreak(img)
        % IMTHINBREAK detects the patterns 0 1 0 and 0;1;0 in the mask
        % (i.e. single, spur or bridge pixels) and sets them to 0. The
        % algorithm runs twice to clear singlets or spurs that the first
        % pass may create.
        
        patX=[0 1 0];
        patY=[0;1;0];
        
        newimg=img;
        %for i=1:2
        BX=normxcorr2(patX,newimg);
        BY=normxcorr2(patY,newimg);
        BX(BX~=1)=0;
        BY(BY~=1)=0;
        
        % the normxcorr2 function creates a "padding"
        BX=logical(BX(:,2:end-1));
        BY=logical(BY(2:end-1,:));
        
        newimg(BX|BY)=0;
        %end
    end

% -- Pixel value compilation and histogram display
    function pixlcomp(i)
        if isempty(cropImgsBkSub)
            currLib=cropImgs{i};
        else
            if isempty(intersect(chnlNo(i),i))
                currLib=cropImgs{i};
            else
                currLib=cropImgsBkSub{i};
            end
        end
        pixlValLib=zeros(1+nnz(imgMask)*chipInfo(2)*chipInfo(3),1);
        pixlValLib(1)=65535;
        n=0;
        for j=1:chipInfo(2)
            for k=1:chipInfo(3)
                currImg=double(uint16(currLib{j,k}*16));
                
                pixlValLib(2+n*nnz(imgMask):1+(n+1)*nnz(imgMask))=...
                    currImg(imgMask);
                n=n+1;
            end
        end
        pixlValLib(pixlValLib==0)=[];
        pixlValLib=[0;pixlValLib];
        figure('Name',...
            ['Chanel ',num2str(i),' pixel value distribution']),...
            hist(pixlValLib,130)
    end

% -- Peak/cell counter
    function peaknum=pkcount(img,thresh,lim)
        img=uint16(img*16);
        binimg=double(img);
        binimg(binimg<thresh)=0;
        binimg(binimg>0)=1;
        binimg=bwareaopen(bwmorph(binimg,'hbreak'),lim,4);
        if nnz(binimg)==0
            peaknum=0;
            return
        end
        img(binimg==0)=0;
        [y,x]=size(img);
        bwimg=zeros(y,x);
        
        for i=2:1:y-1
            for j=2:1:x-1
                if img(i,j)>thresh+thresh*0.4;
                    if img(i,j)>=img(i-1,j-1) && ...
                            img(i,j)>=img(i-1,j) && ...
                            img(i,j)>=img(i-1,j+1) && ...
                            img(i,j)>=img(i,j-1) && ...
                            img(i,j)>=img(i,j+1) && ...
                            img(i,j)>=img(i+1,j-1) && ...
                            img(i,j)>=img(i+1,j) && ...
                            img(i,j)>=img(i+1,j+1)
                        bwimg(i,j)=1;
                        % retroactive check
                        bwimg(i-1,j-1)=0;
                        bwimg(i-1,j)=0;
                        bwimg(i-1,j+1)=0;
                        bwimg(i,j-1)=0;
                        if i>2 && i<y-1 && j>2 && j<x-1
                            if      img(i,j)<img(i-2,j-1) || ...
                                    img(i,j)<img(i-2,j) || ...
                                    img(i,j)<img(i-2,j+1) || ...
                                    img(i,j)<img(i-1,j-2) || ...
                                    img(i,j)<img(i-1,j+2) || ...
                                    img(i,j)<img(i,j-2) || ...
                                    img(i,j)<img(i,j+2) || ...
                                    img(i,j)<img(i+1,j-2) || ...
                                    img(i,j)<img(i+1,j+2) || ...
                                    img(i,j)<img(i+2,j-1) || ...
                                    img(i,j)<img(i+2,j) || ...
                                    img(i,j)<img(i+2,j+1)
                                bwimg(i,j)=0;
                            end
                            % retroactive check
                            if img(i,j)>=img(i-2,j-1)
                                bwimg(i-2,j-1)=0;
                            end
                            if img(i,j)>=img(i-2,j)
                                bwimg(i-2,j)=0;
                            end
                            if img(i,j)>=img(i-2,j+1)
                                bwimg(i-2,j+1)=0;
                            end
                            if img(i,j)>=img(i-1,j-2)
                                bwimg(i-1,j-2)=0;
                            end
                            if img(i,j)>=img(i-1,j+2)
                                bwimg(i-1,j+2)=0;
                            end
                            if img(i,j)>=img(i,j-2)
                                bwimg(i,j-2)=0;
                            end
                        end
                    end
                end
            end
        end
        peaknum=nnz(bwimg);
    end

% -- Image montage function
    function montageBuilder(~,~)
        imgMontage=cell(chipInfo(1),1);
        for i=1:chipInfo(1)
            imgMontage{i}=cell(chipInfo(2),1);
        end
        for i=1:chipInfo(1)
            setInfoBox(['Building image montage. Set ',num2str(i),...
                ' of ',num2str(chipInfo(1))],[0,0,0])
            if isempty(intersect(chnlNo(i),i))
                currLib=cropImgs{i};
            else
                currLib=cropImgsBkSub{i};
            end
            for j=1:chipInfo(2)
                for k=1:chipInfo(3)
                    if k==1
                        imgMontage{i}{j}=currLib{j,k};
                    else
                        imgMontage{i}{j}=[imgMontage{i}{j},...
                            currLib{j,k}];
                    end
                end
                if j>1
                    imgMontage{i}{1}=[imgMontage{i}{1};imgMontage{i}{j}];
                end
            end
            imgMontage{i}=imgMontage{i}{1};
        end
    end

uiwait
% if exist('guifig','var') && ishandle(guifig)
%     delete(guifig);
% end
end
