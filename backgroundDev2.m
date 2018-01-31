% increase x of fStd to 2.5 or 2.6 and change last part of tresh detection
% for multithresh
clear all
close all

imgpath='C:\Users\Jorge\Desktop\chnl_3_row_8_col_2.tiff';

img=imread(imgpath);
figure, imshow(img.*16)

img=double(img); %convert image to double


pixlTotal=sum(sum(img)); % total fluorescence before subtraction
[imgSize,~]=size(img);

x=(1.5:0.25:5);
fStd=zeros(size(x));
for i=1:numel(x)
    expImg=double(uint16(img.^x(i)));
    fStd(i)=std(expImg(expImg~=0));
end

% Check if the pillar is a blank
if isempty(findpeaks(fStd)) || max(max(uint16(img.^2.5)))<65355
    background=img;
    cells=zeros(imgSize);
    if max(max(uint16(img.^2.5)))==65535
        maxX=2;
    else
        maxX=1;
    end
else
    x=(1.5:0.02:2.6);
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
    
    %     % new code
    %     tempimg=double(uint16(img.^maxX));
    %     %figure, imshow(uint16(tempimg));
    %
    %     % calculate density estimation
    %     % convert tempimg values >0 and <30001 to vector and sort
    %     fulldata=sort(reshape(tempimg(tempimg>0 & tempimg< 30001),[],1));
    %     dataMax=max(fulldata);
    %     uniqueData=unique(fulldata);
    %     dataSize=numel(uniqueData);
    %
    %     % set x
    %     prex=1:2^12-1;
    %     x=unique(double(uint16(prex.^maxX)));
    %     x=x(1:find(x==dataMax));
    %     xSize=numel(x);
    %
    %
    %     % density estimation
    %     dX=zeros(xSize); % pre-allocate
    %     for j=1:xSize
    %         for i=1:j
    %             dX(i,j)=x(j)-x(i);
    %         end
    %     end
    %     dX=sort(unique(dX(dX<=10)));
    %     dXSize=numel(dX);
    %
    %     kernTable=zeros(xSize,1); % pre-allocate
    %
    %     for i=1:dXSize
    %         kernTable(i)=(1/sqrt(2^pi)*exp(-1/2*dX(i)^2))/numel(fulldata);
    %     end
    %
    %
    %
    %     freqTable=zeros(1,xSize); % pre-allocate
    %     for i=1:dataSize
    %         freqTable(i)=numel(fulldata(fulldata==x(i)));
    %     end
    %
    %     densEst=zeros(size(x)); % pre-allocate output
    %
    %     for j=1:xSize
    %         xSum=0;
    %         zerocheck=0;
    %         for i=1:xSize
    %             difXData=abs(x(i)-x(j));
    %             if difXData<=10
    %                 xSum=xSum+freqTable(i)*kernTable(dX==difXData);
    %                 if difXData==0
    %                     zerocheck=1;
    %                 end
    %             elseif zerocheck==1
    %                 break
    %             end
    %         end
    %         densEst(j)=xSum;
    %     end
    %
    %     %figure, plot(x,densEst)
    %
    %     % differentiate distribution
    %     dFD=zeros(xSize,1); % pre-allocate
    %     dFD(1)=0;
    %     for i=2:xSize
    %         dFD(i)=(densEst(i)-densEst(i-1))/(x(i)-x(i-1));
    %     end
    %
    %     smdFD=smoother(smoother(dFD,5),3);
    %     %figure, plot(x,smdFD)
    %
    %     % find areas with small variations, i.e. dFD close to 0, after the max.
    %     flatFinder=smdFD<2e-7 & smdFD>-2e-7;
    %     flatInd=find(flatFinder);
    %     smdFDMax=find(smdFD==max(smdFD)); % find index of maximum
    %     % Trim flatInd from values under smdFDMax
    %     flatInd=flatInd(find(flatInd>smdFDMax):end);
    %
    %     if ~isempty(flatInd) % when the peak is at the end
    %         for i=1:numel(flatInd)
    %             if flatInd(i)<=max(flatInd)-9
    %                 indCheck=flatInd(i);
    %                 if sum(flatFinder(indCheck:indCheck+9))/10>=0.9
    %                     minthresh=x(indCheck);
    %                     break
    %                 end
    %             else % if couldn't find a 10-span area, look for a 5-span.
    %                 for j=1:numel(flatInd)
    %                     if flatInd(j)<=max(flatInd)-4
    %                         indCheck=flatInd(j);
    %                         if sum(flatFinder(indCheck:indCheck+4))...
    %                                 /5>=0.8
    %                             minthresh=x(indCheck);
    %                             break
    %                         end
    %                     else
    %                         minthresh=65355;
    %                     end
    %                 end
    %             end
    %         end
    
    tempimg=double(uint16(img.^maxX));
    minthresh=double(multithresh(tempimg(tempimg>0)));
    minthresh=minthresh^(1/maxX);
    minthresh=round(minthresh);
    
end

img=uint16(img);
maskim=imquantize(img, minthresh);
maskim=maskim-1;
figure, imshow(maskim, [])

%maskim=logical(maskim);
maskim=bwareaopen(maskim,5);
maskim=bwmorph(bwmorph(maskim,'spur'),'spur');
%maskim=bwmorph(imthinbreak(maskim),'spur');
maskim=bwareaopen(maskim,5);
figure, imshow(maskim, [])

%     img=uint16(img);
%     minthresh1=minthresh^(1/maxX);
%     minthresh2=double(multithresh(img(img>0)));
%     maximg=uint16(double(img).^maxX);
%     minthresh3=double(multithresh(maximg(maximg>0)));
%     minthresh3=minthresh3^(1/maxX);
%     minthresh1=round(minthresh1);
%     minthresh3=round(minthresh3);
%     disp([minthresh1,minthresh2,minthresh3])
%     imask1=imquantize(img,minthresh1);
%     imask3=imquantize(img,minthresh3);
%     figure,imshow(maximg)
%     figure,imshow(imask1,[])
%     figure,imshow(imask3,[])