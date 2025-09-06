## LatinAmerican Health Studies (LHS)
#### Author: AQ
#### Date: 14may25

## Project: LHS0001

### Aim: Identify determinants of under-five mortality using discrete-time survival analysis with complex survey data.

### Workflow Overview

#### Job 01: Dataset Preparation

- Derive the working dataset from the DHS 2015 child recode data.

- Store in wide format for further processing.

#### Job 02: Multiple Imputation

- Apply PROC MI to the LHS000101 dataset for handling missing data.

#### Job 03: Log-Format Dataset

- Reshape dataset into long format (person-years) for discrete-time survival analysis.

#### Job 04: Modeling

- Implement cloglog binomial model using SAS.

- Generate model results and structured reports.

#### Job 05: Descriptive Analysis

- Produce descriptive statistics tables for study variables.


### Supporting Resources

#### Job 90: Formats

Define and maintain SAS formats for project variables.

#### Job 91: SAS Macros

Develop reusable SAS macros to streamline the analysis workflow.


---
END