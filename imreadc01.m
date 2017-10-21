function data=imreadc01(inFile,shape,r)
% loci.common.DebugTools.enableLogging('INFO');
% imrd=loci.formats.ChannelFiller();
% imrd=loci.formats.ChannelSeparator(imrd);

r.setId(inFile)

plane=r.openBytes(0);

I=loci.common.DataTools.makeDataArray(plane,2,0,1);

data=reshape(typecast(I,'uint16'),shape);

end
