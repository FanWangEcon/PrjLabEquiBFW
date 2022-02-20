%% BFW_MP_DATA Organizes and Sets Various Model Input Scalar and Array Parameters
%    BFW_MP_DATA sets several main data input values, including prices,
%    outputs and also population subgroup counts.
%
%    MP_PARAMS = BFW_MP_DATA() get default parameters all in the same
%    container map
%
%    MP_PARAMS = BFW_MP_DATA(ST_PARAM_GROUP) generates default parameters
%    for the type ST_PARAM_GROUP. ST_PARAM_GROUP groups include:
%    "default_base", "default_small", etc.
%
%    MP_PARAMS = BFW_MP_DATA(ST_PARAM_GROUP, BL_PRINT_MP_PARAMS) generates
%    default parameters for the type ST_PARAM_GROUP, display parameter map
%    details if BL_PRINT_MP_PARAMS is true.
%
%    MP_PARAMS = BFW_MP_DATA(ST_PARAM_GROUP, BL_PRINT_MP_PARAMS,
%    IT_ROW_N_KEEP, IT_COL_N_KEEP) Control for output matrixes how many
%    rows and columns to print out.
%
%    See also SNWX_MP_PARAM
%

%%
function varargout = bfw_mp_data(varargin)
%% Parse Main Inputs and Set Defaults
if (~isempty(varargin))

    if (length(varargin)==1)
        [bl_verbose] = varargin{:};
    elseif (length(varargin)> 1)
        error('bfw_mp_data:TooManyOptionalParameters', ...
              'allows at most 1 optional parameters');
    end

else

    bl_verbose = true;

end

%% Get Path and Initialize
mp_path = bfw_mp_path();
spt_codem_data = mp_path('spt_codem_data');

mp_data = containers.Map('KeyType','char', 'ValueType','any');

%% A. Data inputs for testing
mp_data_test = containers.Map('KeyType','char', 'ValueType','any');

% Wages for the production function
fl_Y = 1;
fl_G_1 = 1.1;
fl_G_2 = 1.1;
mt_p1 = [0.1, 0.75, 1];
mt_p2 = [0.1, 0.55, 1];
mp_data_test('fl_Y') = fl_Y;
mp_data_test('fl_G_1') = fl_G_1;
mp_data_test('fl_G_2') = fl_G_2;
mp_data_test('mt_p1') = mt_p1;
mp_data_test('mt_p2') = mt_p2;

% Wages
mp_data_test('fl_w1o1_init') = 2.315707;
mp_data_test('fl_w1o2_init') = 3.217799;
mp_data_test('fl_w1o3_init') = 4.329016;

mp_data_test('fl_w2o1_init') = 1.942;
mp_data_test('fl_w2o2_init') = 3.2247;
mp_data_test('fl_w2o3_init') = 3.3738;

mp_data_test('fl_potwrker_1') = 9.9687;
mp_data_test('fl_potwrker_2') = 12.5164;

%% B. Dataset 1
% Worker count and wage data inputs
tb_data_pq = readtable(fullfile(spt_codem_data, 'Dataset1.csv'));
tb_data_pq = tb_data_pq(:, ["year", "category", "numberWorkers", "meanWage"]);
mp_data('tb_data_pq') = tb_data_pq;
ar_datapq_year = tb_data_pq{:,'year'};
ar_datapq_category = tb_data_pq{:,'category'};
ar_datapq_numberWorkers = tb_data_pq{:,'numberWorkers'};
ar_datapq_meanWage = tb_data_pq{:,'meanWage'};
mp_data('ar_datapq_category') = string(ar_datapq_category);
mp_data('ar_datapq_year') = ar_datapq_year;
mp_data('ar_datapq_numberWorkers') = ar_datapq_numberWorkers;
mp_data('ar_datapq_meanWage') = ar_datapq_meanWage;

%% C. Dataset 1 AUX
% File that translates between category and gender and skill, and occupation
tb_category2sexskillocc_key = readtable(fullfile(spt_codem_data, 'Dataset1_aux.csv'));
mp_data('tb_category2sexskillocc_key') = tb_category2sexskillocc_key;
tb_category2sexskillocc_key = tb_category2sexskillocc_key(:, ...
    ["category", "sex", "skill", "occupation", ...
     "categoryhigher", "nesttier", "nestid", "nestidhigher", "group", "inputx1x2"]);
ar_cate2gensklocc_category = tb_category2sexskillocc_key{:,'category'};
ar_cate2gensklocc_sex = tb_category2sexskillocc_key{:, 'sex'};
ar_cate2gensklocc_skill = tb_category2sexskillocc_key{:, 'skill'};
ar_cate2gensklocc_occupation = tb_category2sexskillocc_key{:, 'occupation'};
ar_cate2gensklocc_categoryhigher = tb_category2sexskillocc_key{:, 'categoryhigher'};
ar_cate2gensklocc_nesttier = tb_category2sexskillocc_key{:, 'nesttier'};
ar_cate2gensklocc_nestid = tb_category2sexskillocc_key{:, 'nestid'};
ar_cate2gensklocc_nestidhigher = tb_category2sexskillocc_key{:, 'nestidhigher'};
ar_cate2gensklocc_group = tb_category2sexskillocc_key{:, 'group'};
ar_cate2gensklocc_inputx1x2 = tb_category2sexskillocc_key{:, 'inputx1x2'};

mp_data('ar_cate2gensklocc_category') = string(ar_cate2gensklocc_category);
mp_data('ar_cate2gensklocc_sex') = string(ar_cate2gensklocc_sex);
mp_data('ar_cate2gensklocc_skill') = string(ar_cate2gensklocc_skill);
mp_data('ar_cate2gensklocc_occupation') = string(ar_cate2gensklocc_occupation);
mp_data('ar_cate2gensklocc_categoryhigher') = string(ar_cate2gensklocc_categoryhigher);
mp_data('ar_cate2gensklocc_nesttier') = ar_cate2gensklocc_nesttier;
mp_data('ar_cate2gensklocc_nestid') = string(ar_cate2gensklocc_nestid);
mp_data('ar_cate2gensklocc_nestidhigher') = string(ar_cate2gensklocc_nestidhigher);
mp_data('ar_cate2gensklocc_group') = string(ar_cate2gensklocc_group);
mp_data('ar_cate2gensklocc_inputx1x2') = string(ar_cate2gensklocc_inputx1x2);

%% D. Dataset 2
% DATE_ESTI_OFFSET integer offset value to translate between data file year and
% the date variable used in the estimation equations.
mp_data('date_esti_offset') = 1989;

% Data inputs on quanntity of workers, kids <5 share, married share.
tb_supply_potwrklei = readtable(fullfile(spt_codem_data, 'Dataset2.csv'));
skill = string(tb_supply_potwrklei{:, "skill"});
gender = string(tb_supply_potwrklei{:, "gender"});
tb_supply_potwrklei = removevars(tb_supply_potwrklei, {'skill', 'gender'});
tb_supply_potwrklei = addvars(tb_supply_potwrklei, skill, 'Before', 3);
tb_supply_potwrklei = addvars(tb_supply_potwrklei, gender, 'Before', 3);
mp_data('tb_supply_potwrklei') = tb_supply_potwrklei;
tb_supply_potwrklei = tb_supply_potwrklei(:, ...
    ["year", "group", "numberPotentialWorkers", ...
     "shareMarried", "shareChildrenUnder5", ...
     "WBL", "Appliances", "jobScarceAgree", "jobScarceDisagree", ...
     "numberPotentialWorkersAddBackAddMIgrants", ...
     "CtrPSklmGen89", "CtrGenRelaSkl89MaleLvlAct"]);
ar_potwrklei_year = tb_supply_potwrklei{:,'year'};
ar_potwrklei_group = tb_supply_potwrklei{:, 'group'};
ar_potwrklei_potwrker = tb_supply_potwrklei{:, 'numberPotentialWorkers'};
ar_potwrklei_shrmarid = tb_supply_potwrklei{:, 'shareMarried'};
ar_potwrklei_shrufive = tb_supply_potwrklei{:, 'shareChildrenUnder5'};
ar_potwrklei_womenwbl = tb_supply_potwrklei{:, 'WBL'};
ar_potwrklei_applianc = tb_supply_potwrklei{:, 'Appliances'};
% ar_potwrklei_jobscrys = tb_supply_potwrklei{:, 'jobScarceAgree'};
ar_potwrklei_jobscrys = tb_supply_potwrklei{:, 'WBL'};
ar_potwrklei_jobscrds = tb_supply_potwrklei{:, 'jobScarceDisagree'};
ar_potwrklei_potwkmig = tb_supply_potwrklei{:, 'numberPotentialWorkersAddBackAddMIgrants'};
ar_potwrklei_potwksk1 = tb_supply_potwrklei{:, 'CtrPSklmGen89'};
ar_potwrklei_potwksk2 = tb_supply_potwrklei{:, 'CtrGenRelaSkl89MaleLvlAct'};

mp_data('ar_potwrklei_year') = ar_potwrklei_year;
mp_data('ar_potwrklei_group') = string(ar_potwrklei_group);
mp_data('ar_potwrklei_potwrker') = ar_potwrklei_potwrker;
mp_data('ar_potwrklei_shrmarid') = ar_potwrklei_shrmarid;
mp_data('ar_potwrklei_shrufive') = ar_potwrklei_shrufive;
mp_data('ar_potwrklei_womenwbl') = ar_potwrklei_womenwbl;
mp_data('ar_potwrklei_applianc') = ar_potwrklei_applianc;
mp_data('ar_potwrklei_jobscrys') = ar_potwrklei_jobscrys;
mp_data('ar_potwrklei_potwkmig') = ar_potwrklei_potwkmig;
mp_data('ar_potwrklei_potwksk1') = ar_potwrklei_potwksk1;
mp_data('ar_potwrklei_potwksk2') = ar_potwrklei_potwksk2;

%% E. Dataset 2 Aux
% File that translates between GROUP (gender+edu) and CATEGORY (occ-gen-edu)
tb_group2category_key = readtable(fullfile(spt_codem_data, 'Dataset2_aux.csv'));
tb_group2category_key = tb_group2category_key(:, ...
    ["group", "groupName", "category", "sex", "skill"]);
mp_data('tb_group2category_key') = tb_group2category_key;
ar_grp2catekey_group = tb_group2category_key{:,'group'};
ar_grp2catekey_groupName = tb_group2category_key{:, 'groupName'};
ar_grp2catekey_category = tb_group2category_key{:, 'category'};
ar_grp2catekey_sex = tb_group2category_key{:, 'sex'};
ar_grp2catekey_skill = tb_group2category_key{:, 'skill'};
mp_data('ar_grp2catekey_group') = string(ar_grp2catekey_group);
mp_data('ar_grp2catekey_groupName') = string(ar_grp2catekey_groupName);
mp_data('ar_grp2catekey_category') = string(ar_grp2catekey_category);
mp_data('ar_grp2catekey_sex') = string(ar_grp2catekey_sex);
mp_data('ar_grp2catekey_skill') = string(ar_grp2catekey_skill);

%% F. Put data in table
it_years = length(unique(ar_datapq_year));
% for BFW_QPDATA_ESTI_INVOKE_MLVL
mt_st_variable_names_types = [ ...
    ["year", "double"]; ["category", "string"]; ...
    ["numberWorkers", "double"]; ...
    ["meanWage", "double"]; ...
    ["alphaShare", "double"]; ...
    ["rho", "double"]; ...
    ["wrk_lths", "double"]; ["wrk_htls", "double"]; ...
    ];
% Aggregate q and w for upper nest, all upper-nests
tb_solve_all = table('Size',[0, size(mt_st_variable_names_types,1)],...
    'VariableNames', mt_st_variable_names_types(:,1),...
    'VariableTypes', mt_st_variable_names_types(:,2));
%QPEIMTSA: QPDATA ESTI INVOKE MLVL table solve all
mp_data('QPEIMTSA') = tb_solve_all;

for it_nest_tier=[3,2,1,0]

    % Nest 3, 2, 1 and 0
    if (it_nest_tier == 3)
        ls_it_nestid = [11, 12, 21, 22, 31, 32];
    elseif (it_nest_tier == 2)
        ls_it_nestid = [10, 20, 30];
    elseif (it_nest_tier == 1)
        ls_it_nestid = [2];
    elseif (it_nest_tier == 0)
        ls_it_nestid = [1];
    end

    % Create empty table
    it_higher_nest_row_n = length(ls_it_nestid)*it_years;
    tb_higher_nest_results = table('Size',[it_higher_nest_row_n, size(mt_st_variable_names_types,1)],...
        'VariableNames', mt_st_variable_names_types(:,1),...
        'VariableTypes', mt_st_variable_names_types(:,2));

    % Generate keys, QPEIMTNIDHNR: QPDATA ESTI INVOKE MLVL table nest ID higher nest results
    st_key = ['QPEIMTNIDHNR ' num2str(ls_it_nestid)];
    mp_data(st_key) = tb_higher_nest_results;
end

%% Print
if (bl_verbose)
    ff_container_map_display(mp_data, 5, 5);
end

%% Return
if (nargout==1)
    varargout = cell(nargout,0);
    varargout{1} = mp_data;
end

end
