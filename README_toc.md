# 1  Introduction

1. [The Labor Demand and Supply Problem](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/intro/htmlpdfm/bfwx_intro.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/doc/intro/bfwx_intro.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/doc/intro/htmlpdfm/bfwx_intro.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/doc/intro/htmlpdfm/bfwx_intro.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/intro/htmlpdfm/bfwx_intro.html)
	+ The Labor Demand and Supply Problem

# 2  Core Functions

1. [CES Demand Core Functions](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_demand.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/doc/func/bfwx_mp_func_demand.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_demand.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_demand.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_demand.html)
	+ This function generates a container map with key CES demand-side equation for a particular sub-nest.
	+ **PrjLabEquiBFW**: *[bfw_mp_func_demand()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/func/bfw_mp_func_demand.m)*

# 3  Demand

1. [Solve Nested CES Optimal Demand (CRS)](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/doc/solvedemand/bfwx_crs_nested_ces.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces.html)
	+ This function solves optimal choices given CES production function under cost minimization.
	+ Works with Constant Elasticity of Substitution problems with constant returns, up to four nest layers, and two inputs in each sub-nest.
	+ Takes as inputs share and elasticity parameters across layers of sub-nests, as well as input unit costs at the bottom-most layer.
	+ Works with Constant Elasticity of Substitution problems with constant returns, up to four nest layers, and two inputs in each sub-nest.
	+ **PrjLabEquiBFW**: *[bfw_crs_nested_ces()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/solvedemand/bfw_crs_nested_ces.m)*
2. [Compute Nested CES MPL Given Demand (CRS)](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces_mpl.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/doc/solvedemand/bfwx_crs_nested_ces_mpl.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces_mpl.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces_mpl.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces_mpl.html)
	+ Given labor quantity demanded, using first-order relative optimality conditions, find the marginal product of labor given CES production function.
	+ Takes as inputs share and elasticity parameters across layers of sub-nests, as well as quantity demanded at each bottom-most CES nest layer.
	+ Works with Constant Elasticity of Substitution problems with constant returns, up to four nest layers, and two inputs in each sub-nest.
	+ Allows for uneven branches, so that some branches go up to four layers, but others have less layers, works with BFW (2022) nested labor input problem.
	+ **PrjLabEquiBFW**: *[bfw_crs_nested_ces_mpl()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/solvedemand/bfw_crs_nested_ces_mpl.m)*
