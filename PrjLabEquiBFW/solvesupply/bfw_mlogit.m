%% BFW_SUPPLY_LEVELS_BF18 Quantity Supplied and probability given Wages
%    Given wages, what is the quantity of labor supplied? Provide outputs
%    for a particular demand category. This generates supply side equation
%    functions, with wage unknown, for each of the 12 possible supply
%    equations. There are 12 because there are high and low, male and
%    female four types of workers, and each can supply three types of
%    workers to meet demand side needs. These functions can be also used
%    for graphing purposes.
%
%    These functions are specific to education group, to gender as well as
%    to occupation type, 2 x 2 x 3 = 12. Can provide a 2D matrix of wages,
%    where columns 1 uses the category code from Dataset1_aux with C001,
%    thorugh C113. And can find given these codes, the corresponding
%    education group, gender group and occupation type's equation.
%    Depending on how many wages are specified, the corresponding number of
%    quantity supply will be provided.
%
%    In addition what what is just stated, need to also generate outcomes
%    for the appropriate years.
%
%    * MT_ST_GEN_OCC_CATEGORIES matrix of gender-skill-occupation category
%    where each row is a different equilibrium outcome,
%    * IT_DATA_YEAR integer calendar year that the input wages correspond
%    to, needed because potential labor quantity and share of below 5 and
%    share married are calendar year specific. This is the year value where
%    0 is equal to 1989.
%    * MP_WAGES map containing wages as values and C001, C002 to C113 type
%    keys as keys for different gender-education-occupation category wages.
%    Would provide six wages for male and female lower educated for
%    example, for the three occupational categories. These are six wages
%    that are needed and that are relevant for equilibrium consideration
%    for the lower educated labor equilibrium.
%
%    [MP_FL_LABOR_OCCPRBTY, MP_FL_LABOR_SUPPLIED, MP_FC_LABOR_OCCPRBTY,
%    MP_FC_LABOR_SUPPLIED] = BFW_SUPPLY_LEVELS_BF18(MP_PARAMS, MP_DATA,
%    MP_FUNC, MP_CONTROLS, MT_ST_GEN_OCC_CATEGORIES, IT_DATA_YEAR,
%    MP_WAGES) For a particular year, given wages across occupation
%    categories and a matrix of occupation categories, generate quantity
%    supplied as well as probability of supplying for several types of
%    workers. Also output functions of wages for quantity supplied and
%    probability of supplying. All outputs usse the category keys , C101,
%    is for female unskilled manual worker for example.
%
%

%%
function [varargout]=bfw_mlogit(varargin)

%% Default and Parse
if (~isempty(varargin))

    [bl_verbose, bl_graph] = deal(false, false);
    ar_it_prob_or_quant = [1,2];

    bl_log_wage = true;
    bl_verbose_nest = false;

    if (length(varargin)==4)
        [mp_params, mp_data, mp_controls, ...
            mt_st_gen_occ_categories, it_data_year] = varargin{:};
        mp_func = bfw_mp_func_supply(bl_log_wage, bl_verbose_nest);
    elseif (length(varargin)==5)
        [mp_params, mp_data, mp_controls, ...
            mt_st_gen_occ_categories, it_data_year] = varargin{:};
        mp_func = bfw_mp_func_supply(bl_log_wage, bl_verbose_nest);
    elseif (length(varargin)==6)
        [mp_params, mp_data, mp_func, mp_controls, ...
            mt_st_gen_occ_categories, it_data_year] = varargin{:};
    elseif (length(varargin)==7)
        [mp_params, mp_data, mp_func, mp_controls, ...
            mt_st_gen_occ_categories, it_data_year, mp_wages] = varargin{:};
    elseif (length(varargin)==10)
        [mp_params, mp_data, mp_func, mp_controls, ...
            mt_st_gen_occ_categories, it_data_year, mp_wages, ...
            bl_verbose, bl_graph, ...
            ar_it_prob_or_quant] = varargin{:};
    elseif (length(varargin)> 11)
        error('bfw_mlogit:TooManyOptionalParameters', ...
              'allows at most 11 optional parameters');
    end

    if (length(varargin)<=6)
        mp_wages = containers.Map('KeyType', 'char', 'ValueType', 'any');
        for st_gen_occ=mt_st_gen_occ_categories(:)'
            mp_wages(st_gen_occ) = NaN;
        end
    end

else
    clear all;
    close all;
    clc;

    % 1. Print and Graph options
    bl_verbose = true;
    bl_graph = true;
    ar_it_prob_or_quant = [1,2];

    % 2. Get Parameters and data
    bl_log_wage = true;
    bl_verbose_nest = false;
    % Get Parameters
    mp_params = bfw_mp_param_esti(bl_log_wage);
    mp_param_aux = bfw_mp_param_aux(bl_verbose_nest);
    mp_params = [mp_params ; mp_param_aux];
    % Get Data
    mp_data = bfw_mp_data(bl_verbose_nest);
    % Get Functions
    mp_func = bfw_mp_func_supply(bl_log_wage, bl_verbose_nest);
    % Get Controls
    mp_controls = bfw_mp_control();

    % 3. Which categories to obtain data from, there are 12 possible
    % For non-college equilibrium, six wages, three female, three males
    % gen_occ = gender occupation
    bl_skilled = true;
    if (bl_skilled)
        mt_st_gen_occ_categories = [...
            "C011", "C012", "C013"; ...
            "C111", "C112", "C113"];
    else
        mt_st_gen_occ_categories = [...
            "C001", "C002", "C003"; ...
            "C101", "C102", "C103"];
    end

    % 4. Data from which year, only integer year value allowed
    it_data_year = 0;

    % 5. Array of wages, at most, since there are six nests, there are 12
    % prices possible. And there are 12 quantity supplies possible, coming
    % from four tyeps of workers, each supply 3 + home categories.
    params_group = values(mp_data, {'date_esti_offset'});
    [date_esti_offset] = params_group{:};
    mp_wages = containers.Map('KeyType', 'char', 'ValueType', 'any');
    % Obtain some equilibrium wage data as testing inputs
    mp_path = bfw_mp_path();
    spt_codem_data = mp_path('spt_codem_data');
%     tb_data_pq = readtable(fullfile(spt_codem_data, 'Dataset1.csv'));
    tb_data_pq = mp_data('tb_data_pq');
    tb_data_pq = tb_data_pq(:, ["year", "category", "numberWorkers", "meanWage"]);
    ar_st_gen_occ_categories = mt_st_gen_occ_categories(:)';
    for st_gen_occ=ar_st_gen_occ_categories
        tb_gen_occ_over_years = tb_data_pq(strcmp(tb_data_pq.category, st_gen_occ),:);
        fl_wage_one_year = tb_gen_occ_over_years(tb_gen_occ_over_years.year == (it_data_year + date_esti_offset), :);
        mp_wages(st_gen_occ) = fl_wage_one_year{1, "meanWage"};
    end

    % Print Wages
    ff_container_map_display(mp_wages);
end

%% Parse Parameters
% Parse Function inputs
params_group = values(mp_func, {'fc_prob_denom', 'fc_ar_prob_wrk', 'fc_prob_lei', 'fc_supply'});
[fc_prob_denom, fc_ar_prob_wrk, fc_prob_lei, fc_supply] = params_group{:};
params_group = values(mp_func, {'fc_log_pmdpo_occ'});
[fc_log_pmdpo_occ] = params_group{:};

% Parse Data Inputs
params_group = values(mp_data, {'ar_potwrklei_year', 'ar_potwrklei_group', ...
    'ar_potwrklei_potwrker', ...
    'ar_potwrklei_shrmarid', 'ar_potwrklei_shrufive', ...
    'ar_potwrklei_applianc', 'ar_potwrklei_jobscrys'});
[ar_potwrklei_year, ar_potwrklei_group, ...
    ar_potwrklei_potwrker, ...
    ar_potwrklei_shrmarid, ar_potwrklei_shrufive, ...
    ar_potwrklei_applianc, ar_potwrklei_jobscrys] = params_group{:};
params_group = values(mp_data, {'ar_grp2catekey_group', 'ar_grp2catekey_category'});
[ar_grp2catekey_group, ar_grp2catekey_category] = params_group{:};
params_group = values(mp_data, {'ar_cate2gensklocc_category', 'ar_cate2gensklocc_sex', ...
    'ar_cate2gensklocc_skill', 'ar_cate2gensklocc_occupation'});
[ar_cate2gensklocc_category, ar_cate2gensklocc_sex, ...
    ar_cate2gensklocc_skill, ar_cate2gensklocc_occupation] = params_group{:};

params_group = values(mp_data, {'date_esti_offset'});
[date_esti_offset] = params_group{:};

% Parameters
params_group = values(mp_params, {'bl_log_wage'});
[bl_log_wage] = params_group{:};
params_group = values(mp_params, {'psi1'});
[psi1] = params_group{:};
params_group = values(mp_params, {'arpsi0_f_u', 'arpsi0_f_s', 'arpsi0_k_u', 'arpsi0_k_s'});
[arpsi0_f_u, arpsi0_f_s, arpsi0_k_u, arpsi0_k_s] = params_group{:};
params_group = values(mp_params, {'arpie_f_u', 'arpie_f_s', 'arpie_k_u', 'arpie_k_s'});
[arpie_f_u, arpie_f_s, arpie_k_u, arpie_k_s] = params_group{:};

params_group = values(mp_params, {'fl_p_rescalar', 'fl_q_rescalar'});
[fl_p_rescalar, fl_q_rescalar] = params_group{:};

%% Match Category code to Group code
% see: Dataset2_aux vs Dataset1_aux

% Keep track of supply functions of wage, and quantity supplied
% fc = function, Supply curves as function of wages
% 1v2f = 1 variable, 2 fixed, variable is the numerator category wage
mp_fc_labor_occprbty_1v2f = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_fc_labor_supplied_1v2f = containers.Map('KeyType', 'char', 'ValueType', 'any');
% 3v0f = 3 variables, 1 fixed, all three prices are parameters
mp_fc_labor_occprbty_3v0f = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_fc_labor_supplied_3v0f = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_fl_labor_supplied_3v0f = containers.Map('KeyType', 'char', 'ValueType', 'any');
% fl = float, numerical values of quantity supplied
mp_fl_labor_occprbty = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_fl_labor_supplied = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_fl_potwrker = containers.Map('KeyType', 'char', 'ValueType', 'any');
% Store value differences
mp_fl_log_pmdpo_occ = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_fl_log_pmdpo_occ_wage_zero = containers.Map('KeyType', 'char', 'ValueType', 'any');

% collect min and max wages
fl_min_wage = 1e-2;
fl_max_wage = -inf;

% Loop over supplier types (edu-gender groups)
for it_supplier_group=1:size(mt_st_gen_occ_categories,1)

    ar_st_gen_occ_categories = mt_st_gen_occ_categories(it_supplier_group, :);
    arpsi0 = NaN(1, 3);
    arwage = NaN(1, 3); % obs. wages for each occupation

    % it_solve_iter=1, get parameters/data over manual/routine/analytical
    % end of it_solve_iter=1, multinomial logit probabilities given m/r/a
    % it_solve_iter=1, generate functions and quantity supplied
    for it_solve_iter=1:1:2
        for st_category_key = ar_st_gen_occ_categories

            % A. Get category-key and wages
            fl_wage = mp_wages(st_category_key);
            fl_wage = fl_wage/fl_p_rescalar;
            % fl_min_wage = min(fl_wage, fl_min_wage);
            fl_max_wage = max(fl_wage, fl_max_wage);

            % B. Get group-key
            st_group_key = ar_grp2catekey_group(ar_grp2catekey_category==st_category_key);

            % C. Get potential worker, share with kids < 5 and share married at
            % this year, for this gender-education group.
            ar_it_yr_group_idx = (ar_potwrklei_year==(it_data_year+date_esti_offset)).*(ar_potwrklei_group==st_group_key);
            fl_potwrklei_potwrker = ar_potwrklei_potwrker(ar_it_yr_group_idx==1);
            fl_potwrklei_potwrker = fl_potwrklei_potwrker/fl_q_rescalar;
            fl_potwrklei_shrufive = ar_potwrklei_shrufive(ar_it_yr_group_idx==1);
            fl_potwrklei_shrmarid = ar_potwrklei_shrmarid(ar_it_yr_group_idx==1);
            fl_potwrklei_applianc = ar_potwrklei_applianc(ar_it_yr_group_idx==1);
            fl_potwrklei_jobscrys = ar_potwrklei_jobscrys(ar_it_yr_group_idx==1);

            % D. Sex, Skill and Occupations
            st_sex = ar_cate2gensklocc_sex(ar_cate2gensklocc_category==st_category_key);
            st_skill = ar_cate2gensklocc_skill(ar_cate2gensklocc_category==st_category_key);
            st_occupation = ar_cate2gensklocc_occupation(ar_cate2gensklocc_category==st_category_key);

            % E. Get parameters
            if (strcmp(st_sex, 'Female') && (strcmp(st_skill, 'unskilled')))
                arpsi0_base = arpsi0_f_u;
                arpie = arpie_f_u;
            elseif (strcmp(st_sex, 'Female') && (strcmp(st_skill, 'skilled')))
                arpsi0_base = arpsi0_f_s;
                arpie = arpie_f_s;
            elseif (strcmp(st_sex, 'Male') && (strcmp(st_skill, 'unskilled')))
                arpsi0_base = arpsi0_k_u;
                arpie = arpie_k_u;
            elseif (strcmp(st_sex, 'Male') && (strcmp(st_skill, 'skilled')))
                arpsi0_base = arpsi0_k_s;
                arpie = arpie_k_s;
            end

            % F. Cccupation-gender-skill specific supply Qs and functions
            if (strcmp(st_occupation, 'Manual'))
                fl_psi0_manual = arpsi0_base(1);
                arpsi0(1) = fl_psi0_manual;
                arwage(1) = fl_wage;
                % fl_prob_denom generated in it_solve_iter == 1
                if (it_solve_iter == 2)
                    fl_labor_occprbty = ar_prob_wrk(1);
                    fl_labor_supplied = ar_quant_supply(1);
                    fc_labor_occprbty_3v0f = @(w1, w2, w3) fc_ar_prob_wrk(fl_psi0_manual, psi1, w1, fc_prob_denom_wage(w1, w2, w3));
                    fc_labor_supplied_3v0f = @(w1, w2, w3) fc_supply(fl_potwrklei_potwrker, fc_labor_occprbty_3v0f(w1, w2, w3));
                    fc_labor_occprbty_1v2f = @(wage) fc_ar_prob_wrk(fl_psi0_manual, psi1, wage, fc_prob_denom_wage(wage, fl_w2, fl_w3));
                    fc_labor_supplied_1v2f = @(wage) fc_supply(fl_potwrklei_potwrker, fc_labor_occprbty_1v2f(wage));

                    fl_log_pmdpo_occ = ar_log_pmdpo_occ(1);
                    fl_log_pmdpo_occ_wage_zero = ar_log_pmdpo_occ_wage_zero(1);
                end
            elseif (strcmp(st_occupation, 'Routine'))
                fl_psi0_routine = arpsi0_base(2);
                arpsi0(2) = fl_psi0_routine;
                arwage(2) = fl_wage;
                % fl_prob_denom generated in it_solve_iter == 1
                if (it_solve_iter == 2)
                    fl_labor_occprbty = ar_prob_wrk(2);
                    fl_labor_supplied = ar_quant_supply(2);
                    fc_labor_occprbty_3v0f = @(w1, w2, w3) fc_ar_prob_wrk(fl_psi0_routine, psi1, w2, fc_prob_denom_wage(w1, w2, w3));
                    fc_labor_supplied_3v0f = @(w1, w2, w3) fc_supply(fl_potwrklei_potwrker, fc_labor_occprbty_3v0f(w1, w2, w3));
                    fc_labor_occprbty_1v2f = @(wage) fc_ar_prob_wrk(fl_psi0_routine, psi1, wage, fc_prob_denom_wage(fl_w1, wage, fl_w3));
                    fc_labor_supplied_1v2f = @(wage) fc_supply(fl_potwrklei_potwrker, fc_labor_occprbty_1v2f(wage));

                    fl_log_pmdpo_occ = ar_log_pmdpo_occ(2);
                    fl_log_pmdpo_occ_wage_zero = ar_log_pmdpo_occ_wage_zero(2);
                end
            elseif (strcmp(st_occupation, 'Analytical'))
                fl_psi0_analytical = arpsi0_base(3);
                arpsi0(3) = fl_psi0_analytical;
                arwage(3) = fl_wage;
                % fl_prob_denom generated in it_solve_iter == 1
                if (it_solve_iter == 2)
                    fl_labor_occprbty = ar_prob_wrk(3);
                    fl_labor_supplied = ar_quant_supply(3);
                    fc_labor_occprbty_3v0f = @(w1, w2, w3) fc_ar_prob_wrk(fl_psi0_analytical, psi1, w3, fc_prob_denom_wage(w1, w2, w3));
                    fc_labor_supplied_3v0f = @(w1, w2, w3) fc_supply(fl_potwrklei_potwrker, fc_labor_occprbty_3v0f(w1, w2, w3));
                    fc_labor_occprbty_1v2f = @(wage) fc_ar_prob_wrk(fl_psi0_analytical, psi1, wage, fc_prob_denom_wage(fl_w1, fl_w2, wage));
                    fc_labor_supplied_1v2f = @(wage) fc_supply(fl_potwrklei_potwrker, fc_labor_occprbty_1v2f(wage));

                    fl_log_pmdpo_occ = ar_log_pmdpo_occ(3);
                    fl_log_pmdpo_occ_wage_zero = ar_log_pmdpo_occ_wage_zero(3);
                end
            end

            % G. Display
            if (it_solve_iter== 1 && bl_verbose)
                st_display = strjoin(...
                    ["BFW_SUPPLY_LEVELS_BF18", ...
                    ['it_supplier_group=' num2str(it_supplier_group)], ...
                    ['SNW_MP_CONTROL=' string(st_category_key)], ...
                    ['time=' string(st_group_key)] ...
                    ['fl_wage=' num2str(fl_wage)] ...
                    ], ";");
                disp(st_display);
                st_display = strjoin(...
                    ["Supply data", ...
                    ['potwrker=' num2str(fl_potwrklei_potwrker)], ...
                    ['shrmarid=' num2str(fl_potwrklei_shrmarid)], ...
                    ['shrufive=' num2str(fl_potwrklei_shrufive)], ...
                    ['applianc=' num2str(fl_potwrklei_applianc)], ...
                    ['jobscrys=' num2str(fl_potwrklei_jobscrys)], ...
                    ], ";");
                disp(st_display);
            end

            % H. Collected quantity supplied (when it_solve_iter=2)
            if (it_solve_iter== 2)
                mp_fl_labor_occprbty(st_category_key) = fl_labor_occprbty;
                mp_fl_labor_supplied(st_category_key) = fl_labor_supplied;
                mp_fc_labor_occprbty_3v0f(st_category_key) = fc_labor_occprbty_3v0f;
                mp_fc_labor_supplied_3v0f(st_category_key) = fc_labor_supplied_3v0f;
                mp_fc_labor_occprbty_1v2f(st_category_key) = fc_labor_occprbty_1v2f;
                mp_fc_labor_supplied_1v2f(st_category_key) = fc_labor_supplied_1v2f;

                mp_fl_log_pmdpo_occ(st_category_key) = fl_log_pmdpo_occ;
                mp_fl_log_pmdpo_occ_wage_zero(st_category_key) = fl_log_pmdpo_occ_wage_zero;

                mp_fl_potwrker(st_category_key) = fl_potwrklei_potwrker;
                % Additional statistics
                if (bl_verbose)
                    mp_fl_labor_supplied_3v0f(st_category_key) = fc_labor_supplied_3v0f(fl_w1, fl_w2, fl_w3);
                end
            end
        end

        % I. Generate Probability Denominator
        if (it_solve_iter == 1)

            % Data inputs
            [mtwage, t] = deal(arwage, it_data_year);
            [prbchd, prbmar, prbapp, prbjsy] = ...
                deal(fl_potwrklei_shrufive, fl_potwrklei_shrmarid, fl_potwrklei_applianc, fl_potwrklei_jobscrys);
            [fl_w1, fl_w2, fl_w3] = deal(arwage(1), arwage(2), arwage(3));
            [pie1, pie2, pie3, pie4, pie5, pie6] = deal(arpie(1), arpie(2), arpie(3), arpie(4), arpie(5), arpie(6));

            % Demonitor equations
            fl_prob_denom = fc_prob_denom(arpsi0, psi1, arpie, fl_w1, fl_w2, fl_w3, t, prbchd, prbmar, prbapp, prbjsy);
            fc_prob_denom_wage = @(w1, w2, w3) fc_prob_denom(arpsi0, psi1, arpie, w1, w2, w3, t, prbchd, prbmar, prbapp, prbjsy);

            % Probabilities
            ar_prob_wrk = fc_ar_prob_wrk(arpsi0, psi1, mtwage, fl_prob_denom);
            fl_prob_lei = fc_prob_lei(arpie, t, prbchd, prbmar, prbapp, prbjsy, fl_prob_denom);

            % Difference in value occ vs base.
            ar_log_pmdpo_occ = fc_log_pmdpo_occ(arpsi0', psi1, arwage', ...
                pie1, pie2, pie3, pie4, pie5, pie6, t, ...
                prbchd, prbmar, prbapp, prbjsy);
            ar_log_pmdpo_occ_wage_zero = fc_log_pmdpo_occ(arpsi0', psi1, 0, ...
                pie1, pie2, pie3, pie4, pie5, pie6, t, ...
                prbchd, prbmar, prbapp, prbjsy);

            % check: should have, 1 - sum(ar_prob_wrk) - fl_prob_lei = 0
            % Demand quantiSties
            ar_quant_supply = fc_supply(fl_potwrklei_potwrker, ar_prob_wrk);
        end
    end
end

%% Print collected results
if (bl_verbose)
    ff_container_map_display(mp_fl_labor_occprbty);
    ff_container_map_display(mp_fl_labor_supplied);
    ff_container_map_display(mp_fl_labor_supplied_3v0f);

    ff_container_map_display(mp_fc_labor_occprbty_3v0f);
    ff_container_map_display(mp_fc_labor_supplied_3v0f);
    ff_container_map_display(mp_fc_labor_occprbty_1v2f);
    ff_container_map_display(mp_fc_labor_supplied_1v2f);
end

%% Visualize Graph Supply Curves
if (bl_graph)

    for it_prob_or_quant = ar_it_prob_or_quant

        if (it_prob_or_quant == 1)
            mp_fc_labor = mp_fc_labor_occprbty_1v2f;
            st_y_title = 'Probability of workers supplied';
        else
            mp_fc_labor = mp_fc_labor_supplied_1v2f;
            st_y_title = 'Quantity of workers supplied';
        end
        % Wage grid
        fl_wage_margin = (fl_max_wage - fl_min_wage)/10;
        fl_wage_grid_min = max(0, fl_min_wage-fl_wage_margin);
        fl_wage_grid_max = fl_max_wage+fl_wage_margin;
        st_grid_type = 'grid_log10space';
        ar_wage_grid = ff_saveborr_grid(fl_wage_grid_min, fl_wage_grid_max, 15, st_grid_type);

        % evaluate along wage grid
        param_map_keys = keys(mp_fc_labor);
        param_map_vals = values(mp_fc_labor);
        ar_row_grid = strings([1, length(mp_fc_labor)]);
        mt_value = NaN([length(mp_fc_labor), length(ar_wage_grid)]);
        for i = 1:length(mp_fc_labor)
            st_key = param_map_keys{i};
            fc_labor = param_map_vals{i};
            ar_row_grid(i) = st_key;
            mt_value(i, :) = fc_labor(ar_wage_grid)';
        end

        % Generate the two time series
        rng(456);
        ar_col_grid = ar_wage_grid;
        mp_support_graph = containers.Map('KeyType', 'char', 'ValueType', 'any');
        mp_support_graph('cl_st_graph_title') = {...
            ['Supply curves for edu-gender-occupation categories'], ...
            ['year=' num2str(it_data_year)]};
        mp_support_graph('cl_st_ytitle') = st_y_title;
        mp_support_graph('cl_st_xtitle') = {'Wages'};
        mp_support_graph('bl_graph_logy') = false; % do not log
        ff_graph_grid(mt_value, ar_row_grid, ar_col_grid, mp_support_graph);
    end
end


%% F. Return
varargout = cell(nargout,0);
for it_k = 1:nargout

    if (it_k==1)
        ob_out_cur = mp_fl_labor_occprbty;
    elseif (it_k==2)
        ob_out_cur = mp_fl_labor_supplied;
    elseif (it_k==3)
        ob_out_cur = mp_fc_labor_occprbty_3v0f;
    elseif (it_k==4)
        ob_out_cur = mp_fc_labor_supplied_3v0f;
    elseif (it_k==5)
        ob_out_cur = mp_fc_labor_occprbty_1v2f;
    elseif (it_k==6)
        ob_out_cur = mp_fc_labor_supplied_1v2f;
    elseif (it_k==7)
        ob_out_cur = mp_fl_potwrker;
    elseif (it_k==8)
        ob_out_cur = mp_fl_log_pmdpo_occ;
    elseif (it_k==9)
        ob_out_cur = mp_fl_log_pmdpo_occ_wage_zero;
    end
    varargout{it_k} = ob_out_cur;

end

end
