
/*making a small change to see reflect in github*/

/*survival analysis example*/

/*http://www.ats.ucla.edu/stat/sas/seminars/sas_survival/default.htm*/

libname kels 'C:\Users\Kelbla\Documents\Analytics\healthinsurance\astellas';

/*lenfol: length of followup, terminated either by death or censoring. The outcome in this study.*/
/*fstat: the censoring variable, loss to followup=0, death=1*/
/*age: age at hospitalization*/
/*bmi: body mass index*/
/*hr: initial heart rate*/
/*gender: males=0, females=1*/

proc univariate data = kels.whas500(where=(fstat=1));
var lenfol;
histogram lenfol / kernel;
run;


title 'survival analysis';
proc univariate data = kels.whas500(where=(fstat=1));
var lenfol;
cdfplot lenfol;
run;


 

proc lifetest data=kels.whas500(where=(fstat=1)) plots=survival(atrisk);
time lenfol*fstat(0);
run; 

ods output ProductLimitEstimates = ple;
proc lifetest data=kels.whas500(where=(fstat=1))  nelson outs=outwhas500;
time lenfol*fstat(0);
run;

proc sgplot data = ple;
series x = lenfol y = CumHaz;
run;

proc corr data = kels.whas500 plots(maxpoints=none)=matrix(histogram);
var lenfol gender age bmi hr;
run;


/*kaplan meire*/


proc lifetest data=kels.whas500 atrisk outs=outwhas500;
time lenfol*fstat(0);
run;



/*cox*/

proc phreg data = kels.whas500 plots=survival;
class gender;
model lenfol*fstat(0) = gender age bmi hr;
run;
