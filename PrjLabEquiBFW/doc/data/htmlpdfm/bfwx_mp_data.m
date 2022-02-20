%% bfw_mp_data
% This is the example vignette for function: bfw_mp_data from the <https://fanwangecon.github.io/PrjLabEquiBFW/ 
% *PrjLabEquiBFW Package*>*.* 
%% Get All Data

bl_verbose = false;
mp_data = bfw_mp_data(bl_verbose);
%% Dataset 1

disp(mp_data('tb_data_pq'));
%% Dataset 1 Aux

disp(mp_data('tb_category2sexskillocc_key'));
%% Dataset 2

disp(mp_data('tb_supply_potwrklei'));
%% Dataset 2 Aux

disp(mp_data('tb_group2category_key'));
%%