/* Zoe Zirlin Case Study 1*/
/*I certify that the SAS code given is my original and exclusive work*/

FILENAME CSV '/home/u42893137/ZZ/BeerPhenols.csv' TERMSTR=CRLF; /*1A: Include the data 
step or Proc Import code used to get your data into a SAS data set.*/

PROC IMPORT DATAFILE=CSV
		    OUT=beerdata
		    DBMS=CSV
		    REPLACE;
RUN;

PROC PRINT DATA=beerdata;
RUN;


proc sgscatter data=beerdata; /*1B*/
matrix _numeric_/ diagonal= (kernel histogram);
run;


proc corr data=beerdata; /*1B*/
run; /*This is where we see that Phenol = DScavAct 
has the highest correlation and lowest p-value, 
meaning they are the most correalted and the most statistically significant*/

proc reg data=beerdata;
	model phenol = DScavAct;
run; /*2A-2C: We can see that the p value is statistically signifiacnt at <.001.
the rsquared value is 69%, meaning that 69% of the variability in Total phenolic content 
can be explained by DPPH radical scavenging activity
The linear model could be better, as the simple regression shows a megaphone effect,
meaning that as the datapoints get larger, they become more variable, which shows
non-constant variance. Also, the quantile quantile plot shows one major outlier 
and the points do not hug the line towards the ends.*/

/*2D*/
proc transreg data=beerdata;
	model BoxCox(phenol) = identity(DScavAct);
run;

Data beerdataboxcox;
	set beerdata;
	LogPhenol = log(phenol);
	SqrtPhenol = sqrt(phenol);
	InvPhenol = 1/phenol;
	SR = phenol**(.5);
	SPhenol = phenol**2;
run;

proc reg data=beerdataboxcox;
	Model SR = DScavAct;
run;


/*2E*/ /*Calculate a 95% CI for the slope */
proc reg data=beerdata;
	model phenol = DScavAct/clb;
run;

/*2F Step 1*/
proc surveyselect   data=beerdata out=boot
					seed=54321 samprate=1
					method=urs outhits reps=1000;
run;

proc print data=boot (obs=100);
run;

/*2F Step 2*/
proc reg data=boot outest=betas noprint;
	model phenol = DScavAct;
	by replicate;
run;

proc print data=betas (obs=100);
run;


/*2F Step 3*/
proc univariate data=betas;
	var DScavAct;
	histogram DScavAct;
	output out=bootCI pctlpts=2.5 97.5
					  pctlpre= Conf_Limit_;
run;

proc print data=bootCI;
run;

/*2E for comparison*/
proc reg data=beerdata;
	model phenol = DScavAct/clb;
run;

/*2G*/
proc glm data=beerdata plots=diagnostics;
class DScavAct;
model phenol = DScavAct/ss3;
run;
/*Because the P-Value is statistically significant at 0.0001, we can assume that this
linear model is effective.*/


/*2H*/

data beerdatatemp;
input  
	 Phenol
	 Melanoidin
	 DScavAct
	 AScavAct
	 ORAC
	 ReducePower
	 MetalChelate;
datalines;
. . .9 . . . .
;
run;

data beertemp1;
set beerdataboxcox beerdatatemp;
run;


proc reg data=beertemp1;
	model phenol = DScavAct/cli clm;
run;



/*3A*/
proc reg data=beerdata;
	model phenol = Beer	 Melanoidin 	DScavAct	AScavAct	ORAC	ReducePower	MetalChelate/vif; /*produces VIF's for each predictor*/
run;   /*VIF numbers are not over 5 for any variables with the response variable Phenol*/

/*3B*/
proc reg data=beerdata;
model phenol = Beer	 Melanoidin 	DScavAct	AScavAct	ORAC	ReducePower	MetalChelate/selection=Backward;
run; /*variables DScavAct, ReducePower and MetalChelate are statistically significant at the .05 sig. level*/

/*3C*/
proc reg data=beerdata;
	model phenol = DScavAct ReducePower MetalChelate;
run; /*RSquared value is 0.8111, meaning that 81% of the variability in variable phenol can be explained by variables DScavAct, ReducePower and MetalChelate*/

/*3D*/
/*Although the Quantile Quantile plot is normal, there is non-constant variation in the residual plot, as the datapoints become more variable the higher they get, creating a megaphone effect*/



/*3E*/


proc reg data=beerdata;
	model phenol =	 Melanoidin 	DScavAct	AScavAct	ORAC	ReducePower 	MetalChelate; 
run;

proc reg data=beerdata;
	model phenol = 	Melanoidin 	DScavAct	AScavAct	ORAC	ReducePower 	MetalChelate; 
	test Melanoidin=0, AScavAct=0, ORAC=0; /*Test for Ho: b = 0*/
run;


/*3F*/
/*There is indeed one outlier in the data. The one point may be impacting the data*/


data beerdataoutlier;
	set beerdata;
	if beer= '34' then delete;
run;

proc print data=beerdataoutlier;
run;

proc reg data=beerdataoutlier;
	model phenol = DScavAct ReducePower MetalChelate;
run;

proc reg data=beerdata;
	model phenol = DScavAct ReducePower MetalChelate;
run;

/*END*/

