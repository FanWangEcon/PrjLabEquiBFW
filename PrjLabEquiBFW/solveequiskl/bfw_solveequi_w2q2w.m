%% BFW_MINPUTS_SOLVEEQUI_P2Q_SRDP Equilibrium Solution
%    Same as BFW_MINPUTS_SOLVEEQUI_P2Q_SRDP, except do not use price
%    inversion to go from demand Q to supply prices, which can generate
%    imaginery numbers.
%

%%
function [varargout]=bfw_solveequi_w2q2w(varargin)
%% Default and Parse
if (~isempty(varargin))

    it_data_year = 1989;
    it_data_year = it_data_year - 1989;
    bl_checkminmax = true;
    bl_skilled = false;
    it_solve_n1n2n3 = 3;

    if (length(varargin)==3)
        [mp_params, mp_data, mp_controls] = varargin{:};
        st_param_group = 'default';
        bl_log_wage = mp_params('bl_log_wage');
        mp_func_demand = bfw_mp_func_demand(bl_verbose_nest);
        mp_func_supply = bfw_mp_func_supply(bl_log_wage, bl_verbose_nest);
        mp_func_equi = bfw_mp_func_equi(bl_verbose_nest);
        mp_func = [mp_func_equi; mp_func_supply; mp_func_demand];

    elseif (length(varargin)==6)
        [mp_params, mp_data, mp_func, mp_controls, ...
            it_data_year, bl_skilled] = varargin{:};

    elseif (length(varargin)==8)
        [mp_params, mp_data, mp_func, mp_controls, ...
            it_solve_n1n2n3, it_data_year, bl_skilled, bl_checkminmax] = varargin{:};

    elseif (length(varargin)> 8)
        error('bfw_solveequi_w2q2w:TooManyOptionalParameters', ...
              'allows at most 8 optional parameters');
    end

else

    clear all;
    close all;
    clc;

    % Get Parameters and data
    % Get Parameters
    bl_log_wage = true;
    bl_verbose_nest = false;
    mp_params = bfw_mp_param_esti(bl_log_wage);
    mp_param_aux = bfw_mp_param_aux(bl_verbose_nest);
    mp_params = [mp_params ; mp_param_aux];
    % Get Data
    mp_data = bfw_mp_data(bl_verbose_nest);
    % Get Functions
    mp_func_demand = bfw_mp_func_demand(bl_verbose_nest);
    mp_func_supply = bfw_mp_func_supply(bl_log_wage, bl_verbose_nest);
    mp_func_equi = bfw_mp_func_equi(bl_verbose_nest);
    mp_func = [mp_func_equi; mp_func_supply; mp_func_demand];
    % Get Controls
    mp_controls = bfw_mp_control();
    mp_controls('bl_bfw_solveequi_w2q2w_display') = true;
    mp_controls('bl_bfw_solveequi_w2q2w_display_verbose') = true;

    it_example_inputs = 1;
    if (it_example_inputs == 1)
        fl_rho_manual = 0.18;
        fl_rho_routine = 0.18;
        fl_rho_analytical = 0.18;

        fl_beta_1_manual = 1 - 0.26;
        fl_beta_1_routine = 1 - 0.30;
        fl_beta_1_analytical = 1 - 0.40;

        fl_Y_manual = 3.4084;
        fl_Y_routine = 2.3402;
        fl_Y_analytical = 1.7552;

        fl_w1o1_init = 2.315707;
        fl_w1o2_init = 3.217799;
        fl_w1o3_init = 4.329016;

        fl_w2o1_init = 1.942;
        fl_w2o2_init = 3.2247;
        fl_w2o3_init = 3.3738;

        it_data_year = 1989;
        bl_skilled = false;

    elseif (it_example_inputs == 2)
        fl_rho_manual = 0.64678;
        fl_rho_routine = 0.64678;
        fl_rho_analytical = 0.64678;

        fl_beta_1_manual = 0.63427;
        fl_beta_1_routine = 0.58738;
        fl_beta_1_analytical = 0.5784;

        fl_Y_manual = 3.2291;
        fl_Y_routine = 2.2223;
        fl_Y_analytical = 1.7487;

        fl_w1o1_init = 2.3157;
        fl_w1o2_init = 3.2178;
        fl_w1o3_init = 4.329;

        fl_w2o1_init = 1.942;
        fl_w2o2_init = 3.2247;
        fl_w2o3_init = 3.3738;

        it_data_year = 1989;

        bl_skilled = false;

    elseif (it_example_inputs == 3)
        fl_rho_manual = 0.34186;
        fl_rho_routine = 0.34186;
        fl_rho_analytical = 0.34186;

        fl_beta_1_manual = 0.63075;
        fl_beta_1_routine = 0.6326;
        fl_beta_1_analytical = 0.53894;

        fl_Y_manual = 5.5703;
        fl_Y_routine = 4.6673;
        fl_Y_analytical = 2.5644;

        fl_w1o1_init = 2.263;
        fl_w1o2_init = 2.5991;
        fl_w1o3_init = 3.6533;

        fl_w2o1_init = 1.7636;
        fl_w2o2_init = 2.4062;
        fl_w2o3_init = 2.8429;

        it_data_year = 2010;

        bl_skilled = false;

    elseif (it_example_inputs == 4)
        fl_rho_manual = 0.75002424;
        fl_rho_routine = 0.244249613;
        fl_rho_analytical = 0.244249613;

        fl_beta_1_manual = 0.703785173;
        fl_beta_1_routine = 0.687107264;
        fl_beta_1_analytical = 0.706254232;

        fl_Y_manual = 0.124479951;
        fl_Y_routine = 0.39857586;
        fl_Y_analytical = 1.388880655;

        fl_w1o1_init = 5.758649;
        fl_w1o2_init = 6.221019;
        fl_w1o3_init = 7.977073;

        fl_w2o1_init = 2.376239;
        fl_w2o2_init = 4.863073;
        fl_w2o3_init = 5.881686;

        it_data_year = 1996;

        bl_skilled = true;
    end

    mp_params('fl_rho_manual') = fl_rho_manual;
    mp_params('fl_rho_routine') = fl_rho_routine;
    mp_params('fl_rho_analytical') = fl_rho_analytical;

    mp_params('fl_beta_1_manual') = fl_beta_1_manual;
    mp_params('fl_beta_1_routine') = fl_beta_1_routine;
    mp_params('fl_beta_1_analytical') = fl_beta_1_analytical;

    mp_params('fl_Y_manual') = fl_Y_manual;
    mp_params('fl_Y_routine') = fl_Y_routine;
    mp_params('fl_Y_analytical') = fl_Y_analytical;

    mp_data('fl_w1o1_init') = fl_w1o1_init;
    mp_data('fl_w1o2_init') = fl_w1o2_init;
    mp_data('fl_w1o3_init') = fl_w1o3_init;

    mp_data('fl_w2o1_init') = fl_w2o1_init;
    mp_data('fl_w2o2_init') = fl_w2o2_init;
    mp_data('fl_w2o3_init') = fl_w2o3_init;

    it_data_year = it_data_year - 1989;
    bl_checkminmax = true;
    it_solve_n1n2n3 = 3;
end

%% Parse Parameters
% Parse Model Parameters
params_group = values(mp_params, {'bl_log_wage'});
[bl_log_wage] = params_group{:};
% Parse Model Parameters
params_group = values(mp_params, {'fl_rho_manual', 'fl_rho_routine', 'fl_rho_analytical', 'fl_Z'});
[fl_rho_manual, fl_rho_routine, fl_rho_analytical, fl_Z] = params_group{:};
% Inner output
params_group = values(mp_params, {'fl_Y_manual', 'fl_Y_routine', 'fl_Y_analytical'});
[fl_Y_manual, fl_Y_routine, fl_Y_analytical] = params_group{:};
% Parse Model Parameters, 2 is female, 1 is male
params_group = values(mp_params, {'fl_beta_1_manual', 'fl_beta_1_routine', 'fl_beta_1_analytical'});
[fl_beta_1_manual, fl_beta_1_routine, fl_beta_1_analytical] = params_group{:};
fl_beta_2_manual = 1 - fl_beta_1_manual;
fl_beta_2_routine = 1 - fl_beta_1_routine;
fl_beta_2_analytical = 1 - fl_beta_1_analytical;
% Parse Algorithm Control Parameters
params_group = values(mp_params, {'fl_max_occ_shares_sum', ...
    'fl_p2_min', 'fl_p2_max', 'fl_p1_min', 'fl_p1_max'});
[fl_max_occ_shares_sum, ...
    fl_p2_min, fl_p2_max, fl_p1_min, fl_p1_max] = params_group{:};

% Parse Function Inputs
params_group = values(mp_func, {'fc_log_pmdpo_occ'});
[fc_log_pmdpo_occ] = params_group{:};
params_group = values(mp_func, {'fc_w1dw2', 'fc_d1', 'fc_d2', ...
    'fc_lagrange_x1', 'fc_lagrange_x2', 'fc_p1_foc', 'fc_p2_foc'});
[fc_w1dw2, fc_d1, fc_d2, fc_lagrange_x1, fc_lagrange_x2, fc_p1_foc, fc_p2_foc] = params_group{:};

% Parse Data Parameters
params_group = values(mp_data, {'ar_cate2gensklocc_category', 'ar_cate2gensklocc_sex', ...
    'ar_cate2gensklocc_skill', 'ar_cate2gensklocc_occupation'});
[ar_cate2gensklocc_category, ar_cate2gensklocc_sex, ...
    ar_cate2gensklocc_skill, ar_cate2gensklocc_occupation] = params_group{:};
params_group = values(mp_data, {'ar_grp2catekey_group', 'ar_grp2catekey_category'});
[ar_grp2catekey_group, ar_grp2catekey_category] = params_group{:};
params_group = values(mp_data, {'ar_potwrklei_year', 'ar_potwrklei_group', ...
    'ar_potwrklei_potwrker', ...
    'ar_potwrklei_shrmarid', 'ar_potwrklei_shrufive', ...
    'ar_potwrklei_applianc', 'ar_potwrklei_jobscrys'});
[ar_potwrklei_year, ar_potwrklei_group, ...
    ar_potwrklei_potwrker, ...
    ar_potwrklei_shrmarid, ar_potwrklei_shrufive, ...
    ar_potwrklei_applianc, ar_potwrklei_jobscrys] = params_group{:};

params_group = values(mp_data, {'fl_w2o1_init', 'fl_w2o2_init', 'fl_w2o3_init'});
[fl_w2o1_init, fl_w2o2_init, fl_w2o3_init] = params_group{:};
params_group = values(mp_data, {'fl_w1o1_init', 'fl_w1o2_init', 'fl_w1o3_init'});
[fl_w1o1_init, fl_w1o2_init, fl_w1o3_init] = params_group{:};

params_group = values(mp_data, {'date_esti_offset'});
[date_esti_offset] = params_group{:};

% Control parameters
params_group = values(mp_controls, {'bl_bfw_solveequi_w2q2w_display', ...
    'bl_bfw_solveequi_w2q2w_display_verbose'});
[bl_bfw_solveequi_w2q2w_display, bl_bfw_solveequi_w2q2w_display_verbose] = params_group{:};

%% Get Supply Functions
% Skilled or unskilled, each with six keys, these occupational categories are
% such that: it is female than male as rows, and the three ocupational categories
% are manual, routine and analytical as three columns.
if (bl_skilled)
    mt_st_gen_occ_categories = [...
        "C111", "C112", "C113";...
        "C011", "C012", "C013"];
    ar_st_gen_leis_categories = [...
        "C014"; "C114"];
else
    mt_st_gen_occ_categories = [...
        "C101", "C102", "C103"; ...
        "C001", "C002", "C003"];
    ar_st_gen_leis_categories = [...
        "C004"; "C104"];
end

% Do not compare MP_FL_LABOR_OCCPRBTY_EXT and MP_FL_LABOR_SUPPLIED_EXT and MP_FL_LOG_PMDPO_OCC to what is
% generated below. It is based on wages from data file but not necessarily what is specified
% on top.
[mp_fl_labor_occprbty_ext, mp_fl_labor_supplied_ext, ~, mp_fc_labor_supplied_3v0f, ~, ~, ...
    mp_fl_potwrker, mp_fl_log_pmdpo_occ, mp_fl_log_pmdpo_occ_wage_zero] = ...
    bfw_mlogit(mp_params, mp_data, mp_func, mp_controls, ...
    mt_st_gen_occ_categories, it_data_year);
% to cell for easier access
mt_fl_potwrker = NaN(size(mt_st_gen_occ_categories));
mt_cl_fc_labor_supplied_3v0f = cell(size(mt_st_gen_occ_categories));
for it_gender=[1,2]
    ar_st_gen_occ_categories=mt_st_gen_occ_categories(it_gender,:);
    for it_category_key_gender=1:length(ar_st_gen_occ_categories)
        % Key
        st_category_key=ar_st_gen_occ_categories(it_category_key_gender);
        % Supply function
        fc_labor_supplied_3v0f = mp_fc_labor_supplied_3v0f(st_category_key);
        mt_cl_fc_labor_supplied_3v0f{it_gender, it_category_key_gender} = fc_labor_supplied_3v0f;
        % Potential worker
        mt_fl_potwrker(it_gender, it_category_key_gender) = mp_fl_potwrker(st_category_key);
    end
end

% Supply parameters
params_group = values(mp_params, {'psi1'});
[psi1] = params_group{:};
if (bl_skilled)
    params_group_arpsi0 = values(mp_params, {'arpsi0_f_s', 'arpsi0_k_s'});
    params_group_arpie = values(mp_params, {'arpie_f_s', 'arpie_k_s'});
else
    params_group_arpsi0 = values(mp_params, {'arpsi0_f_u', 'arpsi0_k_u'});
    params_group_arpie = values(mp_params, {'arpie_f_u', 'arpie_k_u'});
end
[arpsi0_f, arpsi0_k] = params_group_arpsi0{:};
[arpie_f, arpie_k] = params_group_arpie{:};

%% Store existing wages to map
% skill
if (bl_skilled)
    ar_bl_skill = (ar_cate2gensklocc_skill == "skilled");
else
    ar_bl_skill = (ar_cate2gensklocc_skill == "unskilled");
end
% occupation
ar_bl_manual = (ar_cate2gensklocc_occupation == 'Manual');
ar_bl_routine = (ar_cate2gensklocc_occupation == 'Routine');
ar_bl_analytical = (ar_cate2gensklocc_occupation == 'Analytical');
% gender
ar_bl_female = (ar_cate2gensklocc_sex == "Female");
ar_bl_male = (ar_cate2gensklocc_sex == "Male");
% joint
ar_bl_m_f = (ar_bl_manual.*ar_bl_female.*ar_bl_skill == 1);
ar_bl_r_f = (ar_bl_routine.*ar_bl_female.*ar_bl_skill == 1);
ar_bl_a_f = (ar_bl_analytical.*ar_bl_female.*ar_bl_skill == 1);
ar_bl_m_m = (ar_bl_manual.*ar_bl_male.*ar_bl_skill == 1);
ar_bl_r_m = (ar_bl_routine.*ar_bl_male.*ar_bl_skill == 1);
ar_bl_a_m = (ar_bl_analytical.*ar_bl_male.*ar_bl_skill == 1);

% Variables to be re-used
ar_st_occ_group=["Manual", "Routine", "Analytical"];
it_st_occ_group_len = length(ar_st_occ_group);
% given the sequence of strings in AR_ST_OCC_GROUP, store AR_BLs in matrixes
% each column is a different occupation
mt_bl_f = [ar_bl_m_f, ar_bl_r_f, ar_bl_a_f];
mt_bl_m = [ar_bl_m_m, ar_bl_r_m, ar_bl_a_m];
ar_beta_1 = [fl_beta_1_manual, fl_beta_1_routine, fl_beta_1_analytical];
ar_rho = [fl_rho_manual, fl_rho_routine, fl_rho_analytical];
ar_y = [fl_Y_manual, fl_Y_routine, fl_Y_analytical];

%% STORE
% male row 1, female row 2
% manual col 1, routine col 2, analytical col 3
% Containers to store current iteration demand and supply
mp_fl_labor_supplied = containers.Map('KeyType','char', 'ValueType','any');
mp_fl_labor_demanded = containers.Map('KeyType','char', 'ValueType','any');
mp_fl_prob_occ = containers.Map('KeyType','char', 'ValueType','any');
mt_fl_labor_supplied = [NaN, NaN, NaN;NaN, NaN, NaN];
mt_fl_labor_demanded = [NaN, NaN, NaN;NaN, NaN, NaN];
mt_fl_prob_occ = [NaN, NaN, NaN;NaN, NaN, NaN];
% new wages updated
mp_wages = containers.Map('KeyType','char', 'ValueType','any');
mp_wages_updated = containers.Map('KeyType','char', 'ValueType','any');
mp_wages_relative_updated = containers.Map('KeyType','char', 'ValueType','any');
mt_wages = [NaN, NaN, NaN;NaN, NaN, NaN];
mt_wages_updated = [NaN, NaN, NaN;NaN, NaN, NaN];
ar_wages_relative_updated = [NaN, NaN, NaN];

% Equilibrium wage iteration structure
% Algorithm Structure:
% 1. W
% 2. S(W)
% 3. rW(S(W))
% 4. D(rW(S(W)))
% 5. D(rW(S(W)))
% 6. femaleW(D(rW(S(W))))
% 7. maleW(femaleW(D(rW(S(W)))), rW(S(W)))

fl_speed_shifter_mse_tol = 1e-1;
it_speed_shifteriter_max = 2;
fl_start_speed = 1.0;
fl_speed_reduce_divider = 1;
it_speed_shifter_ctr = 0;
bl_speed_down = true;
while (bl_speed_down)
    it_speed_shifter_ctr = it_speed_shifter_ctr + 1;

    % Iteratively solve
    % 1. Plug in wages, solves for supply quantities
    % 2. Given supply quantities, generate MPL and wage
    % 3. Repeat
    % [fl_w2o1_cur, fl_w2o2_cur, fl_w2o3_cur] = deal(fl_w2o1_init, fl_w2o2_init, fl_w2o3_init);
    % [fl_w1o1_cur, fl_w1o2_cur, fl_w1o3_cur] = deal(fl_w1o1_init, fl_w1o2_init, fl_w1o3_init);
    mt_wages = [fl_w1o1_init, fl_w1o2_init, fl_w1o3_init; ...
        fl_w2o1_init, fl_w2o2_init, fl_w2o3_init];

    % Wage iteration convergence criteria
    Z = 1;
    fl_equi_wage_gap_tol = 1e-8;
    it_equi_wage_gap_iter_max = 50;
    bl_continue = true;
    it_equi_wage_ctr = 0;
    while (bl_continue)
        it_equi_wage_ctr = it_equi_wage_ctr + 1;

        % A. SUPPLY LEVEL: Given wages, solve for supplies
        for it_gender=[1,2]
            for it_occ_group_gender=1:it_st_occ_group_len

                % Get function
                fc_labor_supplied_3v0f = mt_cl_fc_labor_supplied_3v0f{it_gender, it_occ_group_gender};
                % Run function and assign
                mt_fl_labor_supplied(it_gender, it_occ_group_gender) = fc_labor_supplied_3v0f(...
                    mt_wages(it_gender, 1), mt_wages(it_gender, 2), mt_wages(it_gender, 3));

            end
        end

        % Prior Steps B+C.
        for it_occ_group = 1:it_st_occ_group_len

            % B. RELATIVE PRICE: Given relative supplies generate relative price from demand equations
            % Load wages and quantities
            x1_q_supply = mt_fl_labor_supplied(1, it_occ_group);
            x2_q_supply = mt_fl_labor_supplied(2, it_occ_group);
            % Y
            Y = ar_y(it_occ_group);
            % Rho and share
            rho = ar_rho(it_occ_group);
            beta_1 = ar_beta_1(it_occ_group);
            beta_2 = 1 - beta_1;
            fl_w1dw2 = fc_w1dw2(x1_q_supply, x2_q_supply, rho, beta_1, beta_2);
            % Assign
            ar_wages_relative_updated(it_occ_group) = fl_w1dw2;

            % C. RELATIVE PRICE: Given relative supplies generate relative price from demand equations
            % Only relative wages matter for demand solution
            p1 = fl_w1dw2;
            p2 = 1;
            beta_2 = 1 - beta_1;

            % Solutions to the demand side problem: d1, d2 and lagrangian
            fl_d1 = fc_d1(p1, p2, Y, Z, rho, beta_1, beta_2);
            fl_d2 = fc_d2(p1, p2, Y, Z, rho, beta_1, beta_2);
            % Store labor demand given relative wages
            mt_fl_labor_demanded(1, it_occ_group) = fl_d1;
            mt_fl_labor_demanded(2, it_occ_group) = fl_d2;

            % Demand Shares
            fl_potwrker_1 = mt_fl_potwrker(1, it_occ_group);
            fl_potwrker_2 = mt_fl_potwrker(2, it_occ_group);
            % Gender (and skill) specific probabilities for participation
            mt_fl_prob_occ(1, it_occ_group) = fl_d1/fl_potwrker_1;
            mt_fl_prob_occ(2, it_occ_group) = fl_d2/fl_potwrker_2;

        end

        %% Labor quantity check
        for it_gen = [1,2]
            ar_fl_prob_occ = mt_fl_prob_occ(it_gen, :);
            fl_occ_shr_sum = sum(ar_fl_prob_occ);
            if (fl_occ_shr_sum > fl_max_occ_shares_sum)
                mt_fl_prob_occ(it_gen, :) = (ar_fl_prob_occ./fl_occ_shr_sum)*fl_max_occ_shares_sum;
            end
        end

        ar_fl_labor_demanded_lei_prob = 1- sum(mt_fl_prob_occ, 2);
        mt_fl_labor_demanded_log_relalei_prob = log(mt_fl_prob_occ./ar_fl_labor_demanded_lei_prob);

        ar_log_rela_all_but_wage = NaN(1,size(mt_fl_prob_occ,2));

        % D1. PRICE LEVEL: solve for femaleW(D(rW(S(W))))
        % see: https://fanwangecon.github.io/R4Econ/regnonlin/logit/htmlpdfr/fs_logit_aggregate_share_to_price.html
        % fwd: female wage given demand
        % 3 by 3 RHS matrix
        mt_rhs_fwd_input = NaN([3, 3]);
        % Probability shares of each of the three categories
        ar_prob_occ = NaN([3, 1]);
        % Obtain FL_A_OCC values (COL values), identical each time
        ar_a_occ = NaN([3,1]);
        for it_occ_group_c = 1:it_st_occ_group_len
            % Get col key
            st_occ_group_col = ar_st_occ_group(it_occ_group_c);
            if (strcmp(st_occ_group_col, "Manual"))
                ar_bl_occ_f = ar_bl_m_f;
            elseif (strcmp(st_occ_group_col, "Routine"))
                ar_bl_occ_f = ar_bl_r_f;
            elseif (strcmp(st_occ_group_col, "Analytical"))
                ar_bl_occ_f = ar_bl_a_f;
            end
            st_cate_f_col = ar_cate2gensklocc_category(ar_bl_occ_f);
            % Non-wage component of category-specific value
            if (bl_log_wage)
                % log(wage)*coefficient, log(1) = 0, gets rid of wage term
                wage = 1;
            else
                % wage*coefficient, wage=0 eliminates term
                wage = 0;
            end
            st_group_key = ar_grp2catekey_group(ar_grp2catekey_category==st_cate_f_col);
            ar_it_yr_group_idx = (ar_potwrklei_year==(it_data_year+date_esti_offset)).*(ar_potwrklei_group==st_group_key);
            psi0 = arpsi0_f(it_occ_group_c);
            fl_omega_s2 = fc_log_pmdpo_occ(psi0, psi1, wage, ...
                arpie_f(1), arpie_f(2), arpie_f(3), arpie_f(4), arpie_f(5), arpie_f(6), ...
                it_data_year, ...
                    ar_potwrklei_shrufive(ar_it_yr_group_idx==1), ...
                    ar_potwrklei_shrmarid(ar_it_yr_group_idx==1), ...
                    ar_potwrklei_applianc(ar_it_yr_group_idx==1), ...
                    ar_potwrklei_jobscrys(ar_it_yr_group_idx==1));
            fl_a_occ = exp(fl_omega_s2);
            ar_a_occ(it_occ_group_c) = fl_a_occ;
            ar_log_rela_all_but_wage(it_occ_group_c) = ...
                exp((mt_fl_labor_demanded_log_relalei_prob(2, it_occ_group_c) - fl_omega_s2)/psi1);
        end

        ar_wages_f = ar_log_rela_all_but_wage;

        % Fill in matrix values
        bl_skip_old = true;
        if (~bl_skip_old)
            it_occ_ctr = 0;
            for it_occ_group_r = 1:it_st_occ_group_len

                % Get probability share
                fl_potwrker_2 = mt_fl_potwrker(2, it_occ_group_r);
                fl_p_last_iter_occ = mt_fl_labor_supplied(2, it_occ_group_r)/fl_potwrker_2;
                fl_p_new_iter_occ = mt_fl_prob_occ(2, it_occ_group_r);
                fl_ratio_new = fl_start_speed/(fl_speed_reduce_divider+(it_speed_shifter_ctr-1));
                fl_p_occ = fl_p_new_iter_occ*fl_ratio_new + fl_p_last_iter_occ*(1-fl_ratio_new);
                fl_p_occ = fl_p_new_iter_occ;
                ar_prob_occ(it_occ_group_r) = fl_p_occ;

                % Column loop
                for it_occ_group_c = 1:length(ar_st_occ_group)

                    % Obtain LF_A_OCC pre-stored.
                    fl_a_occ = ar_a_occ(it_occ_group_c);

                    % Diagonal or not
                    if (it_occ_group_r == it_occ_group_c)
                        fl_rhs_val = fl_a_occ * (1 - fl_p_occ);
                    else
                        fl_rhs_val = -1 * fl_a_occ * fl_p_occ;
                    end

                    % Fill value
                    mt_rhs_fwd_input(it_occ_group_r, it_occ_group_c) = fl_rhs_val;

                end
            end

            % Given W to Q RHS matrix, linearly solve/estimate for function of three wages
            fc_ols_lin = @(y, x) (x'*x)^(-1)*(x'*y);
            ar_q2w_f_coef = fc_ols_lin(ar_prob_occ, mt_rhs_fwd_input);
            % women wages that would support the demand quantities
            if (bl_log_wage)
                ar_wages_f = exp(log(ar_q2w_f_coef)/psi1);
            else
                ar_wages_f = log(ar_q2w_f_coef)/psi1;
            end
        end

        % D2. PRICE LEVEL: Solve for best fitting wage level Solve for best
        % fitting WAGE1 above given Log(L1(M)/L1(O)) = a1 + b1 * WAGE2 * RELA,
        % Log(L2(M)/L2(O)) = a2 + b2 * WAGE2, where L1(M) and L2(M)
        % are from demand level optimal choices/predictions, L2(O) is the
        % residual number of workers. Think of these as in effect OMEGA1 =
        % RHO1 * WAGE2, and OMEGA2 = RHO2(RELA) * WAGE2. We know OMEGA1 and
        % RHO1 and OMEGA2 and RHO2, trying to best the best fitting WAGE2.
        % Clearly, (OMEGA1/RHO1) = WAGE2 + eps1, (OMEGA2/RHO2) = WAGE2 +
        % eps2, clearly, the eps minimizing choice is ((OMEGA1/RHO1) +
        % (OMEGA2/RHO2)) * 0.5 = BESTWAGE2, now we have the scaling needed.
        for it_occ_group = 1:it_st_occ_group_len

            % Related wages based on relaQuantity(wages)
            fl_w1dw2 = ar_wages_relative_updated(it_occ_group);

            % Wage updates
            % Female wage computed from the linear fit above
            fl_wage_2_f_update = ar_wages_f(it_occ_group);
            % Given earlier relative ratio, male wage given female wage
            fl_wage_1_k_update = fl_wage_2_f_update*fl_w1dw2;
            % Updates
            mt_wages_updated(1, it_occ_group) = fl_wage_1_k_update;
            mt_wages_updated(2, it_occ_group) = fl_wage_2_f_update;

        end

        % D. Existing and new wages comparison
        fl_total_wage_change_mse = 0;
        fl_mse_excess_demand = 0;
        for it_gender=[1,2]
            for it_occ_group_gender=1:it_st_occ_group_len

                % input wages same way for all occupations
                fl_wage = mt_wages(it_gender, it_occ_group_gender);
                fl_wage_update = mt_wages_updated(it_gender, it_occ_group_gender);
                % update wages
                mt_wages(it_gender, it_occ_group_gender) = fl_wage_update;
                % MSE
                fl_total_wage_change_mse = fl_total_wage_change_mse + (fl_wage-fl_wage_update)^2;

                % Demand and supply gap
                fl_supply = mt_fl_labor_supplied(it_gender, it_occ_group_gender);
                fl_demand = mt_fl_labor_demanded(it_gender, it_occ_group_gender);
                fl_mse_excess_demand = fl_mse_excess_demand + (fl_demand-fl_supply)^2;

            end
        end

        % E. Iteration forward condition
        if (isnan(fl_mse_excess_demand) || imag(fl_mse_excess_demand) ~= 0)
            bl_continue = false;
            it_equi_wage_flag = -99;
        elseif (fl_mse_excess_demand < fl_equi_wage_gap_tol)
            bl_continue = false;
            it_equi_wage_flag = 1;
        elseif (it_equi_wage_ctr >= it_equi_wage_gap_iter_max)
            bl_continue = false;
            it_equi_wage_flag = 2;
        end

        % Print
        if (bl_bfw_solveequi_w2q2w_display_verbose)
            if (~bl_continue || rem(it_equi_wage_ctr, 10) == 0 || it_equi_wage_ctr <= 2)
                st_print = strjoin(...
                    ["ITER:", ...
                    ['it_speed_shifter_ctr=' num2str(it_speed_shifter_ctr)], ...
                    ['it_equi_wage_ctr=' num2str(it_equi_wage_ctr)], ...
                    ['bl_continue=' num2str(bl_continue)], ...
                    ['fl_ds_gap_mse=' num2str(fl_mse_excess_demand)], ...
                    ['fl_total_wage_change_mse=' num2str(fl_total_wage_change_mse)], ...
                    ], ";");
                disp(st_print);
                disp(mt_wages);
                disp(mt_fl_labor_supplied);
                disp(mt_fl_labor_demanded);
            end
        end

    end

    % E. Iteration forward condition
    if (isnan(fl_mse_excess_demand) || ...
            imag(fl_mse_excess_demand) ~= 0 || ...
            fl_mse_excess_demand > fl_speed_shifter_mse_tol )
        if (it_speed_shifter_ctr >= it_speed_shifteriter_max)
            bl_speed_down = false;
        else
            bl_speed_down = true;
        end
    else
        bl_speed_down = false;
    end

end

%% Key results
for it_gender=[1,2]
    ar_st_gen_occ_categories=mt_st_gen_occ_categories(it_gender,:);
    for it_category_key_gender=1:length(ar_st_gen_occ_categories)
        % Key
        st_category_key=ar_st_gen_occ_categories(it_category_key_gender);
        % Supply function
        mp_wages(st_category_key) = mt_wages(it_gender, it_category_key_gender);
        mp_fl_labor_supplied(st_category_key) = mt_fl_labor_supplied(it_gender, it_category_key_gender);
        mp_fl_labor_demanded(st_category_key) = mt_fl_labor_demanded(it_gender, it_category_key_gender);
        mp_fl_prob_occ(st_category_key) = mt_fl_prob_occ(it_gender, it_category_key_gender);
    end
end

%% Display
if (bl_bfw_solveequi_w2q2w_display)
    ff_container_map_display(mp_wages);
    ff_container_map_display(mp_fl_labor_supplied);
    ff_container_map_display(mp_fl_labor_demanded);
end

%% Return
varargout = cell(nargout,0);
for it_k = 1:nargout
    if (it_k==1)
        % ob_out_cur = ar_w1_iter_endo;
        ob_out_cur = NaN;
    elseif (it_k==2)
        % ob_out_cur = ar_w2_iter_hat;
        ob_out_cur = NaN;
    elseif (it_k==3)
        % ob_out_cur = ar_w2_iter_gap;
        ob_out_cur = NaN;
    elseif (it_k==4)
        ob_out_cur = mt_wages;
    elseif (it_k==5)
        ob_out_cur = mt_fl_labor_demanded;
    elseif (it_k==6)
        ob_out_cur = mt_fl_labor_supplied;
    elseif (it_k==7)
        mt_fl_labor_occprbty = mt_fl_prob_occ;
        ob_out_cur = mt_fl_labor_occprbty;
    elseif (it_k==8)
        ob_out_cur = fl_mse_excess_demand;
    elseif (it_k==9)
        ob_out_cur = mt_st_gen_occ_categories;
    elseif (it_k==10)
        ob_out_cur = mp_wages;
    elseif (it_k==11)
        ob_out_cur = mp_fl_labor_supplied;
    elseif (it_k==12)
        ob_out_cur = mp_fl_labor_demanded;
    elseif (it_k==13)
        ob_out_cur = mp_fl_prob_occ;
    end
    varargout{it_k} = ob_out_cur;
end

end
