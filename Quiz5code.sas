libname epi5143 '\\Mac\Home\Desktop\EPI5143 work folder\data';
proc contents data=epi5143.nhrabstracts;
run;
proc sort data=epi5143.nhrabstracts out=adm nodupkey;
by hraEncWID;
run;
*creating spine dataset;
data dataA;
set epi5143.nhrabstracts;
year=year(datepart(hraAdmDtm));
if year<2003 then delete;
if year>2004 then delete;
run;
data diabetes;
set epi5143.nhrdiagnosis;
DM=0;
if hdgcd in:('250' 'E11' 'E10') then DM=1;
run;
*flat filing diabetes dataset;
proc sort data=diabetes;
by hdgHraEncWID;
run;
proc freq data=diabetes order=freq;
table hdgHraEncWID;
run;
data dataB;
set diabetes;
by hdgHraEncWID;
array dDM{24} DM1-DM24;
retain DM1-DM24 counter;
if first.hdgHraEncWID=1 then do x=1 to 24;
	dDM{x}=.;
	counter=1;
	end;
dDM{counter}=DM;
counter=counter+1;
if last.hdgHraEncWID=1 then do;
	keep hdgHraEncWID DM1-DM24;
	output;
	end;
*merging datasets;
proc sort data=dataB (rename=hdgHraEncWID=hraEncWID);
by hraEncWID;
run;
data dataAB;
merge dataA (in=a)
	dataB(in=b);
by hraEncWID;
if a=1 then output;
run;
*creating single indicator variable;
data final;
set dataAB;
if (DM1 or DM2 or DM3 or DM4 or DM5 or DM6 or DM7 or DM8 or DM9 or DM10 or DM11 or DM12 or DM13 or DM14 or DM15 or DM16 or DM17 or DM18 or DM19 or DM20 or DM21 or DM22 or DM23 or DM24)=1 then DM=1;
	else DM=0;
run;
*frequency table;
proc freq data=final;
table DM;
run;

*DM Freq Percent CumFreq CumPerc
0   2147 96.28   2147    96.28 
1   83   3.72    2230    100.00 
;



