[![Star](https://img.shields.io/github/stars/fanwangecon/PrjLabEquiBFW?style=social)](https://github.com/FanWangEcon/PrjLabEquiBFW/stargazers) [![Fork](https://img.shields.io/github/forks/fanwangecon/PrjLabEquiBFW?style=social)](https://github.com/FanWangEcon/PrjLabEquiBFW/network/members) [![Star](https://img.shields.io/github/watchers/fanwangecon/PrjLabEquiBFW?style=social)](https://github.com/FanWangEcon/PrjLabEquiBFW/watchers) [![DOI](https://zenodo.org/badge/457847683.svg)](https://zenodo.org/badge/latestdoi/457847683)

This is a work-in-progress Matlab package consisting of functions that solve the equilibrium gender labor force participation and wage model in [Bhalotra](https://www.iza.org/person/2905/sonia-r-bhalotra), [Fernández](https://sites.google.com/view/manuelfernandezsierra) and [Wang](https://fanwangecon.github.io/) (2022). Tested with [Matlab](https://www.mathworks.com/products/matlab.html) 2021b.

All functions are parts of a matlab toolbox that can be installed:

> Download and install the Matlab toolbox: [PrjLabEquiBFW.mltbx](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW.mltbx)

The Code Companion can also be accessed via the bookdown site and PDF linked below:

> [**bookdown site**](https://fanwangecon.github.io/PrjLabEquiBFW/bookdown/), [**bookdown pdf**](https://fanwangecon.github.io/PrjLabEquiBFW/bookdown/BFW-Equilibrium-Gender-LFP-and-Wage-Code-Companion.pdf), [**MathWorks File Exchange**](https://www.mathworks.com/matlabcentral/fileexchange/107025-prjlabequibfw)

This bookdown file is a collection of mlx based vignettes for functions that are available from [PrjLabEquiBFW](https://github.com/FanWangEcon/PrjLabEquiBFW). Each Vignette file contains various examples for invoking each function.

The package relies on [MEconTools](https://fanwangecon.github.io/MEconTools/), which needs to be installed first. The package does not include allocation functions, only simulation code to generate the value of each stimulus check increments for households.

The site is built using [Bookdown](https://bookdown.org/).

Please contact [FanWangEcon](https://fanwangecon.github.io/) for issues or problems.

[![](https://img.shields.io/github/last-commit/fanwangecon/PrjLabEquiBFW)](https://github.com/FanWangEcon/PrjLabEquiBFW/commits/main) [![](https://img.shields.io/github/commit-activity/m/fanwangecon/PrjLabEquiBFW)](https://github.com/FanWangEcon/PrjLabEquiBFW/graphs/commit-activity) [![](https://img.shields.io/github/issues/fanwangecon/PrjLabEquiBFW)](https://github.com/FanWangEcon/PrjLabEquiBFW/issues) [![](https://img.shields.io/github/issues-pr/fanwangecon/PrjLabEquiBFW)](https://github.com/FanWangEcon/PrjLabEquiBFW/pulls)

# Installation

In addition to downloading and installing [PrjLabEquiBFW.mltbx](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW.mltbx), can also:

```
# Clone Package from Git Bash
cd "C:/Downloads"
git clone https://github.com/fanwangecon/PrjLabEquiBFW.git
```

Install the Package from inside Matlab:

```
# Install Matlab Toolbox PrjLabEquiBFW
toolboxFile = 'C:/Downloads/PrjLabEquiBFW/PrjLabEquiBFW.mltbx';
# toolboxFile = 'C:/Users/fan/PrjLabEquiBFW/PrjLabEquiBFW.mltbx';
agreeToLicense = true;
installedToolbox = matlab.addons.toolbox.installToolbox(toolboxFile, agreeToLicense)
```

# 1  Introduction

1. [The Labor Demand and Supply Problem](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/intro/htmlpdfm/bfwx_intro.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/intro/bfwx_intro.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/intro/htmlpdfm/bfwx_intro.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/intro/htmlpdfm/bfwx_intro.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/intro/htmlpdfm/bfwx_intro.html)
	+ The Labor Demand and Supply Problem

# 2  Core Functions

1. [CES Demand Core Functions](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_demand.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/func/bfwx_mp_func_demand.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_demand.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_demand.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_demand.html)
	+ This function generates a container map with key CES demand-side equation for a particular sub-nest.
	+ **PrjLabEquiBFW**: *[bfw_mp_func_demand()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/func/bfw_mp_func_demand.m)*
2. [Multinomial Logit Core Functions](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_supply.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/func/bfwx_mp_func_supply.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_supply.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_supply.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_supply.html)
	+ This function generates a container map with key multinomial logit supply-side equations.
	+ **PrjLabEquiBFW**: *[bfw_mp_func_supply()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/func/bfw_mp_func_supply.m)*
3. [Equilibrium Core Functions](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_equi.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/func/bfwx_mp_func_equi.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_equi.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_equi.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_equi.html)
	+ This function generates a container map with key equilibrium equations.
	+ **PrjLabEquiBFW**: *[bfw_mp_func_equi()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/func/bfw_mp_func_equi.m)*

# 3  Parameters

1. [bfwx_mp_path](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/params/htmlpdfm/bfwx_mp_path.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/params/bfwx_mp_path.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/params/htmlpdfm/bfwx_mp_path.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/params/htmlpdfm/bfwx_mp_path.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/params/htmlpdfm/bfwx_mp_path.html)
	+ bfw_mp_path
	+ **PrjLabEquiBFW**: *[bfw_mp_path()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/paramsdata/bfw_mp_path.m)*
2. [bfwx_mp_control](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/params/htmlpdfm/bfwx_mp_control.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/params/bfwx_mp_control.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/params/htmlpdfm/bfwx_mp_control.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/params/htmlpdfm/bfwx_mp_control.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/params/htmlpdfm/bfwx_mp_control.html)
	+ bfw_mp_control
	+ **PrjLabEquiBFW**: *[bfw_mp_control()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/paramsdata/bfw_mp_control.m)*
3. [bfw_mp_param_esti](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/params/htmlpdfm/bfwx_mp_param_esti.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/params/bfwx_mp_param_esti.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/params/htmlpdfm/bfwx_mp_param_esti.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/params/htmlpdfm/bfwx_mp_param_esti.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/params/htmlpdfm/bfwx_mp_param_esti.html)
	+ bfw_mp_param_esti
	+ **PrjLabEquiBFW**: *[bfw_mp_param_esti()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/paramsdata/bfw_mp_param_esti.m)*

# 4  Data

1. [bfwx_mp_data](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/data/htmlpdfm/bfwx_mp_data.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/data/bfwx_mp_data.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/data/htmlpdfm/bfwx_mp_data.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/data/htmlpdfm/bfwx_mp_data.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/data/htmlpdfm/bfwx_mp_data.html)
	+ bfw_mp_data
	+ **PrjLabEquiBFW**: *[bfw_mp_data()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/paramsdata/bfw_mp_data.m)*

# 5  Demand

1. [Solve Nested CES Optimal Demand (CRS)](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solvedemand/bfwx_crs_nested_ces.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces.html)
	+ This function solves optimal choices given CES production function under cost minimization.
	+ Works with Constant Elasticity of Substitution problems with constant returns, up to four nest layers, and two inputs in each sub-nest.
	+ Takes as inputs share and elasticity parameters across layers of sub-nests, as well as input unit costs at the bottom-most layer.
	+ Works with Constant Elasticity of Substitution problems with constant returns, up to four nest layers, and two inputs in each sub-nest.
	+ **PrjLabEquiBFW**: *[bfw_crs_nested_ces()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/solvedemand/bfw_crs_nested_ces.m)*
2. [Compute Nested CES MPL Given Demand (CRS)](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces_mpl.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solvedemand/bfwx_crs_nested_ces_mpl.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces_mpl.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces_mpl.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces_mpl.html)
	+ Given labor quantity demanded, using first-order relative optimality conditions, find the marginal product of labor given CES production function.
	+ Takes as inputs share and elasticity parameters across layers of sub-nests, as well as quantity demanded at each bottom-most CES nest layer.
	+ Works with Constant Elasticity of Substitution problems with constant returns, up to four nest layers, and two inputs in each sub-nest.
	+ Allows for uneven branches, so that some branches go up to four layers, but others have less layers, works with BFW (2022) nested labor input problem.
	+ **PrjLabEquiBFW**: *[bfw_crs_nested_ces_mpl()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/solvedemand/bfw_crs_nested_ces_mpl.m)*

# 6  Supply

1. [bfwx_mlogit](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solvesupply/htmlpdfm/bfwx_mlogit.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solvesupply/bfwx_mlogit.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solvesupply/htmlpdfm/bfwx_mlogit.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solvesupply/htmlpdfm/bfwx_mlogit.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solvesupply/htmlpdfm/bfwx_mlogit.html)
	+ bfwx_mlogit
	+ **PrjLabEquiBFW**: *[bfwx_mlogit()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/solvesupply/bfwx_mlogit.m)*

# 7  Equilibrium by Skill Nest Group

1. [bfw_solveequi_kwfw](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solveequiskl/htmlpdfm/bfwx_solveequi_kwfw.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solveequiskl/bfwx_solveequi_kwfw.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solveequiskl/htmlpdfm/bfwx_solveequi_kwfw.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solveequiskl/htmlpdfm/bfwx_solveequi_kwfw.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solveequiskl/htmlpdfm/bfwx_solveequi_kwfw.html)
	+ bfw_solveequi_kwfw
	+ **PrjLabEquiBFW**: *[bfw_solveequi_kwfw()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/solveequiskl/bfw_solveequi_kwfw.m)*
2. [bfw_solveequi_w2q2w](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solveequiskl/htmlpdfm/bfwx_solveequi_w2q2w.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solveequiskl/bfwx_solveequi_w2q2w.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solveequiskl/htmlpdfm/bfwx_solveequi_w2q2w.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solveequiskl/htmlpdfm/bfwx_solveequi_w2q2w.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solveequiskl/htmlpdfm/bfwx_solveequi_w2q2w.html)
	+ bfw_solveequi_w2q2w
	+ **PrjLabEquiBFW**: *[bfw_solveequi_w2q2w()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/solveequiskl/bfw_solveequi_w2q2w.m)*

----
Please contact [![](https://img.shields.io/github/followers/fanwangecon?label=FanWangEcon&style=social)](https://github.com/FanWangEcon) [![](https://img.shields.io/twitter/follow/fanwangecon?label=%20&style=social)](https://twitter.com/fanwangecon) for issues or problems.

[![DOI](https://zenodo.org/badge/457847683.svg)](https://zenodo.org/badge/latestdoi/457847683)

![RepoSize](https://img.shields.io/github/repo-size/fanwangecon/PrjLabEquiBFW)
![CodeSize](https://img.shields.io/github/languages/code-size/fanwangecon/PrjLabEquiBFW)
![Language](https://img.shields.io/github/languages/top/fanwangecon/PrjLabEquiBFW)
![Release](https://img.shields.io/github/downloads/fanwangecon/PrjLabEquiBFW/total)
![License](https://img.shields.io/github/license/fanwangecon/PrjLabEquiBFW)

