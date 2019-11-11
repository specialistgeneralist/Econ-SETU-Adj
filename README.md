# SETU 'Overall' Adjustment Procedure for Unit Prizes

_Learning & Teaching Committee, Department of Economics, Monash University_

_11 Nov 2019_

# BACKGROUND

Since 2016, the Department adopted the 'p-score' as a relative, like-with-like, comparison tool for identifying prize-worthy student unit evaluation (SETU: student evaluation of teaching and units) outcomes. The aim of the p-score was to take into account the known systematic sources of variation in SETU such as class-size, campus and UG/PG study type, by calculating the inverse normal p-value (x100) of a given unit, when ranked against similar units in the business school.

Subsequently, in Nov 2019, the LTC took on feedback from the department on the p-score, and sought to refine the procedure for allocating prizes. Key feedback incorporated included:
1. Absolute vs. Relative: the desire for any benchmark for a prize to be an absolute measure, not a relative one; and
2. Continuous vs. Discrete: the desire for the ranking or comparison of unit outcomes to use a more continuous approach to e.g. class size adjustments, avoiding edge-problems with coarse-grained class-size bins.

In addition, more data became available and through discussions with econometricians at EBS, the Directors of Education from the Business School, the Head of Department of Economics, and the Associate Dean, Education, the LTC developed a refined method, using estimation techniques to net out the major systematic sources of variation in the SETU outcome signal.

At their regular meeting of 1 Nov 2019, the LTC discussed the new methodology, modelling outcomes and design approach, and endorsed the following procedure, along with the publication here of the method and de-identified data to support the wider department's understanding of the approach.

# DESIGN

Gather a large, cross- units, and cross- years sample of overall unit scores from the Business School, plus systematic features of these units, and estimate a model to explain the received 'overall median' satisfaction score, such that the likely magnitude of systematic variation can be identified and netted out to form an **setu_overall_adjusted** score.

A standard OLS framework is open to the objection that unit evaluations could be subject to selection at the level of the Chief Examiner. For instance, some argue that 'hight type' CEs might systematically be placed in large, first year classes, due to the strategic importance of these units. As such, estimates of class size effects could be polluted by non-random selection of CEs.

To get around this, we apply a **mixed effects model**, where systematic factors enter with fixed effects (categorial and dummy) variables, and each CE (recovered from the relevant Handbook, here de-identified) is given an effect size on the intercept, which is then estimated in the modelling procedure. In this way, we can estimate the systematic effects, in the presence of type- covariates at the CE level, accounting for any variation due to selection.

In the results, we provide both the ME and OLS models for comparison.

## Prize Criterion

With the ME model in hand, the LTC adopts (for 2019) the following procedure:
1. Estimate the systmatic sources of variation in SETU 'overall' outcomes, and net these out to produce the outcome `setu_overall_adj` in addition to the raw SETU, `setu_overall`.
2. For any unit with 10 or greater responses in the SETU round, and which fulfills either one of the two criteria below, award a Dept. of Economics Unit Prize:
 a. `setu_overall` (raw) greater than, or equal to, **4.50**.
 b. `setu_overall_adj` (adjusted) greater than, or equal to, **4.50**. 

NOTE: The LTC has committed to reviewing this Criterion for 2020, based on experiences from 2019, and will look to tighten the criteria over time in an effort to support aspirations for excellence in teaching.


# METHODS 
## How does de-biasing work?

If SETU 'overall' scores were directly comparable, then there should be no correlation between a large sample of SETU 'overall' scores and any systematic feature of a unit. However, it is easy to reject this assumption with the data. Indeed, this assumption is rejected at the p < 0.001 level for a number of features in a set of over 6,000 units taught at Berwick, Caulfield, Peninsula, or Clayton campusses in the BusEco faculty over 2010 to 2019 inclusive:
* **Class size effect**: 'overall' SETU outcome will fall by 0.12 in the log (base 10) of the class size. For instance, all else being equal, a class of 240 students will, on average, receive an outcome 0.09 points lower than one of 40. If the large class was one of 840 students, then the differential jumps to 0.15 points.
* **Campus effect**: units taught at Clayton, relative to Berwick, Peninsula, or Caulfield, are associated with a 0.06 point lower SETU 'overall' score, all else being equal
* **Undergrad effect**: units taught at the undergraduate level (years 1 to 3), relative to the post-graduate level (years 4 and above), are associated with a 0.23 point lower SETU 'overall' score.

We cannot, on the basis of this analysis alone, identify the source of these systematic effects. However, one could imagine that factors related teacher--student proximity and impact (size of enrolment), and demographics (campuses, post-grad versus undergrad) would be important. Nevertheless, the pattern of systematic effects identified in BusEco SETU 'overall' scores has also been found in other faculties (e.g. Arts) and speaks to a generalised source of SETU 'overall' systematic effect.

Thankfully, de-biasing raw SETU 'overall' scores is not difficult. To do this we undertake two steps:
1. **Step 1**: Estimate a model of SETU 'overall' scores (`setu_overall`) based on unit features (with controls for idiosyncratic Chief Examiner effects); and
2. **Step 2**: Use the sum of estimated coefficients for each systematic effect that applies to a given unit to adjust the raw SETU 'overall' scores and produce the adjusted (apples-to-apples) score (`setu_overall_adj`)

For some units, SETU 'overall' scores are adjusted higher, for others, lower.

Full model estimates on data from 2010 to 2019 are given in the Appendix below. Note, we also apply fixed effects for the year of offering relative to a base year of 2010 (2011, 2012 ..), for Summer semesters, and for paper versus web based administration, in order that adjusted SETU 'overall' scores can be compared across time.

### Model covariates
The full set of model features considered includes:
* `survey_method_web`: 1 if the survey method was ‘web’, 0 otherwise.
* `semester`: a categorical variable for Semester 2 or Summer semester, (Sem 1 excluded class).
* `year`: a linear variable in the calendar year, from 2010 to 2019, found to be highly significant (and positive) suggesting an average improvement in SETU outcomes (of around 0.03 of a point) over this period.
* `class_size_log10`: class size effect, in logs.
* `isclayton`: dummy for Clayton, 0 otherwise
* `ispostgrad`: dummy for postgrad class (4th+), 0 otherwise.
* `low_response`: 1 if < 10 responses, or < 10% of enrolment, 0 otherwise.

### Examples

#### Example 1
Suppose that the unit ECC1000, an undergrad unit taught at Clayton in S1 2019, having ~ 900 students gets a 'raw' SETU of 4.3 (and we assume > 10 responses, and more than 10% of class responded). The fixed-effect contribution for each feature of this unit would be calculated as follows (refer to table below):
* survey method (web): -0.046
* class size (log10(900)x-0.124): -0.365
* semester 2: 0.0
* summer sem: 0.0
* is clayton: -0.061
* is postgrad: 0.0
* year effect (2019 v. 2010) (9x0.03): +0.268
* low response: 0.0

Summary:
* _Total Estimated Systematic Contribution_: -0.204
* _SETU Overall Adjusted_: 4.3 + 0.204 = **4.504**

#### Example 2
Suppose that the unit ECF4450, a postgrad unit taught at Caulfield in S2 2019, having ~ 25 students gets a 'raw' SETU of 4.3 (and we assume > 10 responses, and more than 10% of class responded). The fixed-effect contribution for each feature of this unit would be calculated as follows (refer to table below):
* survey method (web): -0.046
* class size (log10(25)x-0.124): -0.173
* semester 2: +0.0181
* summer sem: 0.0
* is clayton: 0.0
* is postgrad: +0.226
* year effect (2019 v. 2010) (9x0.03): +0.268
* low response: 0.0

Summary:
* _Total Estimated Systematic Contribution_: +0.293
* _SETU Overall Adjusted_: 4.3 - 0.293 = **4.01**


## P-Score and P-Score Faculty

For comparison, we also provide calculations for p-Score and p-Score Faculty.

Armed with the estimated model, we can then easily gather effects for any given unit, producing an adjusted SETU 'overall' (`setu_overall_adj`) score which is now comparable across location, undergrad/postgrad, class size, and even year (e.g. one can compare this 'apples to apples' between 2010 and 2018).

Further, create the `pscore_similar` for the unit by:
* For a given unit, obtain a bag of other units taught in the Business School which were taught in the same year, at the same campus, and are of the same size-cohort.
* Calculate the given unit’s position as an inverse normal scale of 0…100 within the distribution of `setu_overall_adj` for bag of units found in step 1.

Calculation of `pscore_faculty` proceeds as above, except that the bag of units is expanded to include all units taught in the BusEco faculty for the year in question (e.g. all units taught, regadless of campus, or cohort size, undergrad or postgrad in 2018). This comparison is fair becuase we have adjusted the SETU 'overall' scores for systematic bias.


## Models

The two models, ME and OLS (for comparison) are specified as:

ME Model:
```
setu_overall ~ 1 + survey_method + class_size_log10 + sem_ord + isclayton + ispostgrad + year_lin + low_response + (1 | ChiefExaminer)
```
Where `(1 | ChiefExaminer)` estimates the Chief Examiner effects (one per unique CE ID) on the intercept.

OLS Model:
```
setu_overall ~ 1 + survey_method + class_size_log10 + sem_ord + isclayton + ispostgrad + year_lin + low_response
```
(No CE effects)

Both models were estimated with MATLAB using the Statistics Toolbox (see code, `adjust_setu.m`).


## Scenario Outcome

In reaching their decision, the LTC looked at modelling of the 2018 SETU Unit outcomes for Economics. They found that using the greater than or equal to 4.50 criterion on `setu_overall_adj`:
* A total of 18 Prizes would have been awarded (of 65 eligible units, or around the top 27%)
* Of 12 Prizes awarded under previous standard (>= 80 p-score), all 12 would be awarded under the new standard.
* Features of prize winners under the new standard would have been:
    * Class sizes from 12 to 717, average: 174
    * Campuses: 10 Clayton (58%), 5 Caulfield (29%), 2 Peninsula (11%) (compared to all eligible units: 34 Clayton (52%), 25 Caulfield (38%), 6 Peninsula (9%))
    * SETU adjustment sizes from -0.24 to +0.14 (average: -0.01)
* In addition, 6 additional Prizes would be awarded under the new standard, with the lowest p-score of the additional units being 70. So the new standard can be said to be more generous by this approach.
* Under the new standard, 1 unit with a raw SETU < 4.5 would receive a prize due to adjustments.
* Under the new standard, 3 units with raw SETU > 4.5 would not receive a prize due to adjustments, with the range of these misses in raw SETU being 4.51..4.62, but under adjustment the range becomes, 4.29..4.45 . The lowest ranked of these units, after adjustment is 34.
* The middle unit, on adjusted SETU is at around 4.3.

Note: this analysis does not include the addition of 3 units which would have fulfilled the >= 4.50 on `setu_overall` (raw) (but not >= 4.5 `setu_overall_adj`).


# APPENDIX: ESTIMATES



## Linear regression model (robust fit):
```
    setu_overall ~ 1 + survey_method + sem_ord + year_lin + class_size_log10 + isclayton + ispostgrad + low_response

Estimated Coefficients:
                          Estimate        SE         tStat       pValue  
                          _________    _________    _______    __________


    (Intercept)              4.2361     0.029071     145.72             0
    survey_method_Web     -0.064986     0.018601    -3.4936    0.00047968
    sem_ord_Semester 2    0.0099102    0.0096457     1.0274       0.30426
    sem_ord_Summer           0.1142     0.029377     3.8875    0.00010227
    year_lin               0.041071    0.0020445     20.089    3.7866e-87
    class_size_log10       -0.14849     0.011689    -12.704     1.525e-36
    isclayton_1           -0.053335     0.010969    -4.8623    1.1876e-06
    ispostgrad_1            0.18769       0.0103     18.222    2.1153e-72
    low_response_1          0.10681     0.014579     7.3267    2.6424e-13

Number of observations: 6540, Error degrees of freedom: 6531
Root Mean Squared Error: 0.382
R-squared: 0.232,  Adjusted R-Squared 0.231
F-statistic vs. constant model: 247, p-value = 0
```


## Linear mixed-effects model fit by ML

```
Model information:
    Number of observations            6540
    Fixed effects coefficients           9
    Random effects coefficients        652
    Covariance parameters                2

Formula:
    setu_overall ~ 1 + survey_method + class_size_log10 + sem_ord + isclayton + ispostgrad + year_lin + low_response + (1 | ChiefExaminer)

Model fit statistics:
    AIC       BIC       LogLikelihood    Deviance
    8847.1    8921.7    -4412.5          8825.1  

Fixed effects coefficients (95% CIs):
    Name                        Estimate     SE           tStat        pValue
    '(Intercept)'                  4.1667     0.040575     102.69           0
    'survey_method_Web'         -0.046544      0.02332    -1.9959    0.045986
    'class_size_log10'            -0.1237     0.016046    -7.7093   1.454e-14
    'sem_ord_Semester 2'         0.018135     0.012148     1.4929     0.13552
    'sem_ord_Summer'             0.028616     0.037962    0.75381     0.45099
    'isclayton_1'               -0.061056     0.017051    -3.5807  0.00034513
    'ispostgrad_1'                0.22557     0.015086     14.952  9.9634e-50
    'year_lin'                   0.029804    0.0027243      10.94  1.2874e-27
    'low_response_1'            -0.019656      0.01875    -1.0483     0.29453

Random effects covariance parameters (95% CIs):
Group: ChiefExaminer (652 Levels)
    Name1                Name2                Type         Estimate    Lower      Upper  
    '(Intercept)'        '(Intercept)'        'std'        0.19746     0.17923    0.21753

Group: Error
    Name             Estimate    Lower      Upper  
    'Res Std'        0.45476     0.44668    0.46297

```
