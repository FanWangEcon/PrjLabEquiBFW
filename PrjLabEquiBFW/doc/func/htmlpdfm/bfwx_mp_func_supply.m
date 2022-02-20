%% Multinomial Logit Core Functions
% This is the example vignette for function: <https://github.com/FanWangEcon/PrjLabEquiBFW/tree/main/PrjLabEquiBFW/func/bfw_mp_func_supply.m 
% *bfw_mp_func_supply*> from the <https://fanwangecon.github.io/PrjLabEquiBFW/ 
% *PrjLabEquiBFW Package*>*.* This function generates a container map with key 
% multinomial logit supply-side equations. 
%% Test BL_LOG_WAGE is false
% Default test

bl_log_wage = false;
bl_verbose = true;
mp_func_supply = bfw_mp_func_supply(bl_log_wage, bl_verbose);
%% Test BL_LOG_WAGE is false
% Default test

bl_log_wage = true;
mp_func_supply = bfw_mp_func_supply(bl_log_wage, bl_verbose);