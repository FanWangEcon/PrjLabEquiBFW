# Objective

Solving constant return to scale nested CES problem, in iterative backward
structure. The solution is actually used in
*PrjFLFPMexicoBFW/caliestidemand/bfw_qpdata_esti_invoke_mlvl.m* when solving
*htl* up to down. But the solution there is nested inside other problems.

There are several core functions:

1. sub-nest solution: given parameters, provide optimal choices
2. n-nest solution: there are N nests, assume there are 2 inputs in each nest, each nest has 2 + 1 parameters, elasticity and share as well as well as the output parameter, but the inner output parameter is endogenous except for the outter-most nest. So the input structure is if there are 2 nests, there should be (1+2)*2 + 1 = 7 parameters. If there are 3 nests, there should be (1 +**** 2 + 4)*2 + 1 = 15 parameters.

## Nest structure

So in our problem here, at level 3, there are 6 nests across skill x occupation categories. At level 2, there are 3 nests across occupations. At level 1, one nest over one occupation group. At level 0, another occupation group level nesting.

Looking downward, we really have four layers, and 11 different nests.

1. [T1] + [T2]
2. [T11] + [T12] ; [T21] + [T22]
3. [T111] + [T112] ; [T121] + [T122]; [T211] + [T212] ; [T221] + [T222]
4. [T2111] + [T2112] ; [T2121] + [T2122] ; [T2211] + [T2212] ; [T2221] + [T2222]

- T1: Analytical
- T2: Routine + Manual

- T11: Skilled analytical
- T12: Unskilled analytical

- T111: Skilled analytical male
- T112: Skilled analytical female
- T121: Unskilled analytical male
- T122: Unskilled analytical female

- T21: Routine
- T22: Manual

- T211: Skilled Routine
- T212: Unskilled Routine
- T221: Skilled Manual
- T222: Unskilled Manual

There are, associated with each nest a share parameter and a rho/elasticity parameter. To be extremely clear, store the elasticity and rho parameters in multi-dimensional matrixes, where there are only valid values in valid cells. For the current structure, two multi-dimensional matrixes, each with 3 dimension, each dimension with two positions, for the 4th layer here. So for a nested problem with N layers, two cell array with dimension N, one with rho, one with elasticity values. The N layers: layer 1 is 1 by 1, layer 2 is 1 by 2, layer 3 is 2 by 2; layer 4 is 2 by 2 by 2. And fill in cells that are valid. Not just the lowest level, but higher level can be directly price facing as well. In the example here,  [T111] + [T112] ; [T121] + [T122] are price facing, [T2111] + [T2112] ; [T2121] + [T2122] ; [T2211] + [T2212] ; [T2221] + [T2222] are also price facing.

## Function Inputs

The function requires three types of inputs:

1. Aggregate highest tier output requirement: the Y/Z ratio, *MN_YZ_CHOICES*
2. Elasticity and share parameters stored in the above specified matrix structure, *MN_RHO*, *MN_SHARE*
3. Observed Wages, *MN_PRICE*

### YZ Cell Array MN_YZ_CHOICES

We only observe one aggregate yz at the highest tier, but we will be generating YZ (choices). Create a N layer cell array that is identical to the dimension of the rho and elasticity cell arrays.

### Wage Cell Array MN_PRICE

The observed wages input structure, use the same matrix dimensions mentioned above, but it needs to be one layer deeper, because there are two wages for each nest, create a Cell with N layers (elements): layer 1 is 1 by 2; layer 2 is 2 by 2; layer 3 is 2 by 2 by 2; layer 4 is 2 by 2 by 2 by 2. All matrixes are initialized fully with NaN, and fill initially with which elements are observed.

In our example, we will have 12 wages at levels 3 and 4:

3. [T111] + [T112] ; [T121] + [T122];
4. [T2111] + [T2112] ; [T2121] + [T2122] ; [T2211] + [T2212] ; [T2221] + [T2222]

## Intermediary Outputs

### Aggregate Wages MN_PRICE

Generate intermediary wages using Equation A.8, starting at the N-1 layer, and going upwards, filling in whenever there is NaN, using below layer (NOT same layer) rho and elasticity values and lower layer wages as well, if lower layer wages exist.

Output is that the wage cell array will be fully filled up.

### Optimal Choices (and Inner Outputs) MN_YZ_CHOICES

Fill up **MN_YZ_CHOICES** matrix. At the same layer, given **MN_PRICE** and **MN_YZ_CHOICES** at the same layer, generate the **MN_YZ_CHOICES** for the layer just below.

## Final output: Optimal Choices

Lowest layer **MN_YZ_CHOICES** are the optimal choices.

## Additional Outputs

+ Is the aggregate output requirement satisfied?
+ Can cost be improved by choosing alternatives?
+ Is optimality achieved?
