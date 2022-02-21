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
