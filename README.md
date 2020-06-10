# Beer-Shelf-Life

### Best Model
The R2 for the best model, which includes DScavAct, ReducePower and MetalChelate is 0.8111, meaning that 81% of the variability in variable phenol can be explained by variables DScavAct, ReducePower and MetalChelate. This is a relatively high R Squared value, meaning that we can be confident about choosing these three variables as potential explanations for the level of Phenol in beer. This R Squared value may increase if the outlier in the data is removed. 

### Residuals
The subsequent residual analysis shows that the Quantile Quantile plot is normal, and there is constant variation in the residual plot, as the datapoints are somewhat equally variable. This still includes one outlier point. 

### Conclusion
The nested F-test comparing my full model to a reduced model of interest shows that, when I tested Melanoidin=0, AScavAct=0, ORAC=0, there was a high P-Value of .58. This means that I did indeed choose the correct predictor variables of DScavAct, ReducePower and MetalChelate, because when the other variables in the test group were set to zero, we were unable to reject the null hypothesis because there was no statistical significance. This displays that we were correct in deciding that Melanoidin, AScavAct and ORAC did not have significant effect on our response variable of Phenol.
