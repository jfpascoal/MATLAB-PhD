function outdata=smoother(indata,span)

% Check validity of arguments
if ~isvector(indata) || ~isnumeric(indata)
    error('Input data must be numeric vector.')
end
if ~isscalar(span) || ~span>=3 || ...
        span-floor(span)~=0 || mod(span,2)==0
    error('Span must be a positive odd scalar larger or equal to 3')
end
if ~numel(indata)>span
    error('Size of input data must be larger than span')
end

outdata=zeros(size(indata));
hspan=floor(span/2);


for i=1:hspan
    pointsum=sum(indata(1:i+hspan));
    outdata(i)=pointsum/numel(indata(1:i+hspan));
end
for i=hspan+1:numel(indata)-hspan
    pointsum=sum(indata(i-hspan:i+hspan));
    outdata(i)=pointsum/span;
end
for i=numel(indata)-hspan+1:numel(indata)
    pointsum=sum(indata(i-hspan:end));
    outdata(i)=pointsum/numel(indata(i-hspan:end));
end
    
end

