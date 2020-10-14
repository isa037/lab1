clear all
fID=fopen("resultsc.txt");
f_sampling = 10000;
xc=fscanf(fID,"%d");

thd(xc,f_sampling,15)

fclose(fID);