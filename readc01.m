function data=readc01(inFile,shape)
loci.common.DebugTools.enableLogging('INFO');
r=loci.formats.ChannelFiller();
r=loci.formats.ChannelSeparator(r);

r.setId(inFile)

plane=r.openBytes(0);

I=loci.common.DataTools.makeDataArray(plane,2,0,1);

data=reshape(typecast(I,'uint16'),shape);
clear r
clear plane
clear I

end