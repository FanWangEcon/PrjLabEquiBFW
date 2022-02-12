# (APPENDIX) Appendix {-}

# Index and Code Links

## Introduction links

1. [The Labor Demand and Supply Problem](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/intro/htmlpdfm/bfwx_intro.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/intro/bfwx_intro.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/intro/htmlpdfm/bfwx_intro.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/intro/htmlpdfm/bfwx_intro.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/intro/htmlpdfm/bfwx_intro.html)
	+ The Labor Demand and Supply Problem

## Core Functions links

1. [CES Demand Core Functions](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_demand.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/func/bfwx_mp_func_demand.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_demand.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_demand.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/func/htmlpdfm/bfwx_mp_func_demand.html)
	+ This function generates a container map with key CES demand-side equation for a particular sub-nest.
	+ **PrjLabEquiBFW**: *[bfw_mp_func_demand()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/func/bfw_mp_func_demand.m)*

## Demand links

1. [Solving Nested CES Demand Problems (CRS)](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces.html): [**mlx**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solvedemand/bfwx_crs_nested_ces.mlx) \| [**m**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces.m) \| [**pdf**](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/master/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces.pdf) \| [**html**](https://fanwangecon.github.io/PrjLabEquiBFW/PrjLabEquiBFW/doc/solvedemand/htmlpdfm/bfwx_crs_nested_ces.html)
	+ This function solves optimal choices in Constant Elasticity of Substitution problems with constant returns and two inputs in each sub-nest.
	+ Takes as inputs share and elasticity parameters across layers of sub-nests, as well as input unit costs at the bottom-most layer.
	+ Works for CES problems with up to four nest layers, and allows for uneven branches, so that some branches go up to four layers, but others have less layers.
	+ Works with BFW (2022) nested labor input problem.
	+ **PrjLabEquiBFW**: *[bfw_mp_func_demand()](https://github.com/FanWangEcon/PrjLabEquiBFW/blob/main/PrjLabEquiBFW/solvedemand/bfw_mp_func_demand.m)*
