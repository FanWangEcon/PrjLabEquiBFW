%% BFW_SOLVEEQUI_KWFW Solves Two Inputs Price Taking Problem
%    Solve for equilibrium price by finding the best price combinations
%    from pseudo-analytical iterative procedure. For a particular year,
%    given elasticity and share parameters, and also given inner-outputs
%    values, solve for equilibrium prices and quantities.
%
%    Given the model structure, a low female or male skill worker can
%    choose among three wage occupations (and leisure). On the firm side, a
%    lowest nest firm hires female and male workers. So to solve for
%    equilibrium for the analytical firm, that faces female and male supply
%    of analytical type labor. Doing this for analytical, routine and
%    manual works, we have six supply side equations for female and male
%    unskilled/skilled supplies, and we have six demand side equations.
%    These 12 equations overall form one equilibrium problem, with six
%    equilibrium wages and six equilibrium quantities.
%
%    In solving, checks for wage bounds first, finds lower and upper wage
%    values, conditional on other occupational wages, where solutions are
%    not NAN/INF/IMAG.
%
%    Outputs equilibrium quantities for demand and supply and wages. Under
%    some elasticity and share parameters and inner output values, there
%    are no equilibrium.
%
%    The Algorithm here solves for the six equilibrium wages and six
%    equilibrium quantities, given elasticity, share and inner-output
%    values, by calling a triply nested bisection routine, that relies on a
%    relationship that first provides p2a(p1a, p1b, p1c), p2b(p1a, p1b,
%    p1c) and p2c(p1a, p1b, p1c). And then provides p1a(p2a, p2b, p2c),
%    p1b(p2a, p2b, p2c) and p1c(p2a, p2b, p2c). Note that this CAN NOT be
%    solved as a contraction, the fixed point cannot be "iterated" towards.
%    The phase-diagram does not converge to the fixed-point.
%
%    * IT_DATA_YEAR int where 0 is 1989, and 3 is 1992.
%    * IT_SOLVE_N1N2N3 int can be 1, 2, or 3, if 1 solving for occ1=manual,
%    given exogenous routine and analytical wages; if 2 solving for
%    occ1=manual and occ2=routine, given exogenous analytical wage; if 3,
%    solving for all three wages endogenously;
%
%    [FL_P1_EQUI, FL_P2_EQUI, FL_D1_EQUI, FL_D2_EQUI, FL_S1_EQUI,
%    FL_S2_EQUI] = BFW_SOLVEEQUI_KWFW(MP_PARAMS, MP_DATA,
%    MP_CONTROLS) solves the demand supply for two input ces and two choice
%    logit problem given the number of potential workers for each worker
%    category. MP_PARAMS contains production function and demand indirect
%    utility parameters. MP_DATA contains price and the number of potential
%    workers in each category. MP_CONTROLS includes controlling parameters
%

%%
function [varargout]=bfw_solveequi_kwfw(varargin)

%% Default and Parse
if (~isempty(varargin))

    it_data_year = 1989;
    it_data_year = it_data_year - 1989;
    bl_checkminmax = true;
    bl_skilled = false;
    it_solve_n1n2n3 = 3;

    bl_verbose_nest = false;

    if (length(varargin)==3)

        [mp_params, mp_data, mp_controls] = varargin{:};
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
        error('bfw_solveequi_kwfw:TooManyOptionalParameters', ...
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
    mp_controls('bl_bfw_solveequi_kwfw_display') = true;
    mp_controls('bl_bfw_solveequi_kwfw_display_verbose') = true;

    % it_example_inputs = 1 and 2 work
    % it_example_inputs = 3 demand != supply
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
        fl_potwrker_1 = 9.9687;
        fl_potwrker_2 = 12.5164;
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
        fl_potwrker_1 = 9.9687;
        fl_potwrker_2 = 12.5164;

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
        fl_potwrker_1 = 16.4952;
        fl_potwrker_2 = 19.4271;

        bl_skilled = false;
        % % with it_solve_n1n2n3 = 1; no bisection results for w2o1, all neg
        % fl_w2o2 = 0.7900;
        % fl_w2o3 = 1.1;

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
        fl_potwrker_1 = 16.4952;
        fl_potwrker_2 = 19.4271;

        bl_skilled = true;

    elseif (it_example_inputs == 5)
        % example where using initial prices, and solving for price contraction leads to imagiery number for p1
        % predicted supply is too high given supply side equation parameters.

        fl_rho_manual = 0.38583;
        fl_rho_routine = 0.38583;
        fl_rho_analytical = 0.38583;

        fl_beta_1_manual = 0.88508;
        fl_beta_1_routine = 0.687107264;
        fl_beta_1_analytical = 0.71851;

        fl_Y_manual = 0.081003;
        fl_Y_routine = 0.20317;
        fl_Y_analytical = 1.0791;

        fl_w1o1_init = 5.758649;
        fl_w1o2_init = 6.221019;
        fl_w1o3_init = 7.977073;

        fl_w2o1_init = 4.5245;
        fl_w2o2_init = 5.4146;
        fl_w2o3_init = 8.0437;

        it_data_year = 1996;
        fl_potwrker_1 = 16.4952;
        fl_potwrker_2 = 19.4271;

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

    mp_data('fl_potwrker_1') = fl_potwrker_1;
    mp_data('fl_potwrker_2') = fl_potwrker_2;

    it_data_year = it_data_year - 1989;
    bl_checkminmax = true;
    it_solve_n1n2n3 = 3;
end

%% Parse Parameters

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
params_group = values(mp_params, {'fl_p2_min', 'fl_p2_max', 'fl_p1_min', 'fl_p1_max'});
[fl_p2_min, fl_p2_max, fl_p1_min, fl_p1_max] = params_group{:};

% Parse Function Inputs
params_group = values(mp_func, {'fc_p1_of_p2andSupply', 'fc_p2_of_p1andSupply'});
[fc_p1_of_p2andSupply, fc_p2_of_p1andSupply ] = params_group{:};
params_group = values(mp_func, {'fc_d1', 'fc_d2'});
[fc_d1, fc_d2] = params_group{:};

% Parse Data Parameters
params_group = values(mp_data, {'ar_cate2gensklocc_category', 'ar_cate2gensklocc_sex', ...
    'ar_cate2gensklocc_skill', 'ar_cate2gensklocc_occupation'});
[ar_cate2gensklocc_category, ar_cate2gensklocc_sex, ...
    ar_cate2gensklocc_skill, ar_cate2gensklocc_occupation] = params_group{:};
params_group = values(mp_data, {'fl_w2o1_init', 'fl_w2o2_init', 'fl_w2o3_init'});
[fl_w2o1_init, fl_w2o2_init, fl_w2o3_init] = params_group{:};
params_group = values(mp_data, {'fl_w1o1_init', 'fl_w1o2_init', 'fl_w1o3_init'});
[fl_w1o1_init, fl_w1o2_init, fl_w1o3_init] = params_group{:};
params_group = values(mp_data, {'fl_potwrker_1', 'fl_potwrker_2'});
[fl_potwrker_1, fl_potwrker_2] = params_group{:};

% Control parameters
params_group = values(mp_controls, {'bl_bfw_solveequi_kwfw_display', ...
    'bl_bfw_solveequi_kwfw_display_verbose'});
[bl_bfw_solveequi_kwfw_display, bl_bfw_solveequi_kwfw_display_verbose] = params_group{:};

%% Get Supply Functions
% Skilled or unskilled, each with six keys, these occupational categories are
% such that: it is female than male as rows, and the three ocupational categories
% are manual, routine and analytical as three columns.
if (bl_skilled)
    mt_st_gen_occ_categories = [...
        "C011", "C012", "C013"; ...
        "C111", "C112", "C113"];
else
    mt_st_gen_occ_categories = [...
        "C001", "C002", "C003"; ...
        "C101", "C102", "C103"];
end
[~, ~, ~, mp_fc_labor_supplied_3v0f] = ...
    bfw_mlogit(mp_params, mp_data, mp_func, mp_controls, ...
    mt_st_gen_occ_categories, it_data_year);

%% Inner output level requirements
% as initial inner output levels to make sure there is no NaN values
ar_betarho_minthres_1 = [fl_beta_1_manual, fl_beta_1_routine, fl_beta_2_analytical].^[fl_rho_manual, fl_rho_routine, fl_rho_analytical];
ar_betarho_minthres_2 = [fl_beta_2_manual, fl_beta_2_routine, fl_beta_2_analytical].^[fl_rho_manual, fl_rho_routine, fl_rho_analytical];
ar_pX2pY_minthres_1 = ar_betarho_minthres_1.*fl_potwrker_1;
ar_pX2pY_minthres_2 = ar_betarho_minthres_2.*fl_potwrker_2;
ar_fl_max_ratio_1 = [fl_Y_manual, fl_Y_routine, fl_Y_analytical]./ar_pX2pY_minthres_1;
ar_fl_max_ratio_2 = [fl_Y_manual, fl_Y_routine, fl_Y_analytical]./ar_pX2pY_minthres_2;
% ar_pX2pY_minthres = max(ar_pX2pY_minthres_1, ar_pX2pY_minthres_2);
% [fl_Y_manual, fl_Y_routine, fl_Y_analytical] = deal(ar_pX2pY_minthres(1), ar_pX2pY_minthres(2), ar_pX2pY_minthres(3));
if (bl_bfw_solveequi_kwfw_display)
    st_display = strjoin(...
        ["Completed BFW_SOLVEEQUI_KWFW", ...
        ['fl_potwrker_1=' num2str(fl_potwrker_1)], ...
        ['fl_potwrker_2=' num2str(fl_potwrker_2)], ...
        ['ar_fl_max_ratio_1=' num2str(ar_fl_max_ratio_1)], ...
        ['ar_fl_max_ratio_2=' num2str(ar_fl_max_ratio_2)], ...
        ], ";");
    disp(st_display);
end

%% Obtain Wage Translation Equations from W1 vector to W2 vector and vice-versa.
for it_supplier_group=1:size(mt_st_gen_occ_categories,1)
    for st_category_key = mt_st_gen_occ_categories(it_supplier_group, :)

        % For current category key, gender, skill and occupational category corresponding to it
        st_sex = ar_cate2gensklocc_sex(ar_cate2gensklocc_category==st_category_key);
        st_skill = ar_cate2gensklocc_skill(ar_cate2gensklocc_category==st_category_key);
        st_occupation = ar_cate2gensklocc_occupation(ar_cate2gensklocc_category==st_category_key);

        % Current quantity labor supplied equation
        fc_labor_supplied_3v0f = mp_fc_labor_supplied_3v0f(st_category_key);

        % Default female and male sages
        if (strcmp(st_sex, 'Female'))
            % Female quantity supplied
            [fl_wxo1_init, fl_wxo2_init, fl_wxo3_init] = deal(fl_w2o1_init, fl_w2o2_init, fl_w2o3_init);
        elseif (strcmp(st_sex, 'Male'))
            % Male quantity supplied
            [fl_wxo1_init, fl_wxo2_init, fl_wxo3_init] = deal(fl_w1o1_init, fl_w1o2_init, fl_w1o3_init);
        end

        % w2o1, w2o2, w2o3 are women wages for occuaptions manual, routine and analytical
        % w1o1, w1o2, w1o3 are men wages for occuaptions manual, routine and analytical
        % Generate the six Equilibrium relationship equations (conditional on skill)
        if (strcmp(st_sex, 'Female') && (strcmp(st_occupation, 'Manual')))
            % Manual+MALE wage given Manual+FEMALE
            fc_wxox = @(w2o1, w2o2, w2o3) ...
                fc_p1_of_p2andSupply(w2o1, fc_labor_supplied_3v0f(w2o1, w2o2, w2o3), ...
                fl_Y_manual, 1, fl_rho_manual, fl_beta_1_manual, fl_beta_2_manual);
            fc_w1o1 = fc_wxox;
        elseif (strcmp(st_sex, 'Female') && (strcmp(st_occupation, 'Routine')))
            % Routine+MALE wage given Routine+FEMALE
            fc_wxox = @(w2o1, w2o2, w2o3) ...
                fc_p1_of_p2andSupply(w2o2, fc_labor_supplied_3v0f(w2o1, w2o2, w2o3), ...
                fl_Y_routine, 1, fl_rho_routine, fl_beta_1_routine, fl_beta_2_routine);
            fc_w1o2 = fc_wxox;
        elseif (strcmp(st_sex, 'Female') && (strcmp(st_occupation, 'Analytical')))
            % Manual+MALE wage given Manual+FEMALE
            fc_wxox = @(w2o1, w2o2, w2o3) ...
                fc_p1_of_p2andSupply(w2o3, fc_labor_supplied_3v0f(w2o1, w2o2, w2o3), ...
                fl_Y_analytical, 1, fl_rho_analytical, fl_beta_1_analytical, fl_beta_2_analytical);
            fc_w1o3 = fc_wxox;
        elseif (strcmp(st_sex, 'Male') && (strcmp(st_occupation, 'Manual')))
            % Manual+Female wage given Manual+MALE
            fc_wxox = @(w1o1, w1o2, w1o3) ...
                fc_p2_of_p1andSupply(w1o1, fc_labor_supplied_3v0f(w1o1, w1o2, w1o3), ...
                fl_Y_manual, 1, fl_rho_manual, fl_beta_1_manual, fl_beta_2_manual);
            fc_w2o1 = fc_wxox;
        elseif (strcmp(st_sex, 'Male') && (strcmp(st_occupation, 'Routine')))
            % Routine+FeMALE wage given Routine+MALE
            fc_wxox = @(w1o1, w1o2, w1o3) ...
                fc_p2_of_p1andSupply(w1o2, fc_labor_supplied_3v0f(w1o1, w1o2, w1o3), ...
                fl_Y_routine, 1, fl_rho_routine, fl_beta_1_routine, fl_beta_2_routine);
            fc_w2o2 = fc_wxox;
        elseif (strcmp(st_sex, 'Male') && (strcmp(st_occupation, 'Analytical')))
            % Manual+FeMALE wage given Manual+MALE
            fc_wxox = @(w1o1, w1o2, w1o3) ...
                fc_p2_of_p1andSupply(w1o3, fc_labor_supplied_3v0f(w1o1, w1o2, w1o3), ...
                fl_Y_analytical, 1, fl_rho_analytical, fl_beta_1_analytical, fl_beta_2_analytical);
            fc_w2o3 = fc_wxox;
        end

        % Testing labor supplied functions, generate labor quantities
        if (bl_bfw_solveequi_kwfw_display_verbose)
            % Quantity supplied
            fl_labor_supplied = fc_labor_supplied_3v0f(fl_wxo1_init, fl_wxo2_init, fl_wxo3_init);
            fl_wxox = fc_wxox(fl_wxo1_init, fl_wxo2_init, fl_wxo3_init);
            st_display = strjoin(...
                ["BFW_SOLVEEQUI_KWFW-initial-Q", ...
                ['category_key=' string(st_category_key)], ...
                ['sexrhs=' string(st_sex)], ...
                ['occ=' string(st_occupation)], ...
                ['wxox=' num2str(fl_wxox)], ...
                ['laborsupplied=' num2str(fl_labor_supplied)], ...
                ], ";");
            disp(st_display);
        end

    end
end

%% A0. Test Prices
if (bl_bfw_solveequi_kwfw_display_verbose)
    [fl_w2o1, fl_w2o2, fl_w2o3] = deal(fl_w2o1_init, fl_w2o2_init, fl_w2o3_init);
    it_solve_occ = 1;
    [fl_w2ox_iter_gap, fl_w2ox_mainendo, ar_w2_iter_gap, ar_w2_iter_hat, ar_w1_iter_endo] = ffi_p2top1_p1top2(...
        it_solve_occ, ...
        fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
        fl_w2o1, fl_w2o2, fl_w2o3);
    [fl_w2o1, fl_w2o2, fl_w2o3] = deal(ar_w2_iter_hat(1), ar_w2_iter_hat(2), ar_w2_iter_hat(3));
    [fl_w1o1, fl_w1o2, fl_w1o3] = deal(ar_w1_iter_endo(1), ar_w1_iter_endo(2), ar_w1_iter_endo(3));
end

%% Initialize w2 prices
[fl_w2o1, fl_w2o2, fl_w2o3] = deal(fl_w2o1_init, fl_w2o2_init, fl_w2o3_init);
% ar_fl_p2_min = [fl_p2_min, fl_p2_min, fl_w2o3*0.10];
% ar_fl_p2_max = [fl_p2_max, fl_p2_max, fl_w2o3*2];
ar_fl_p2_min = [fl_p2_min, fl_p2_min, fl_p2_min];
ar_fl_p2_max = [fl_p2_max, fl_p2_max, fl_p2_max];

%% A. Solve Contraction Problem via Bisection
if (it_solve_n1n2n3 == 1)

    % Define contraction equation
    it_solve_occ = 1;
    fc_w2_fixedpoint = @(x) ffi_w2_fixed_point(x, ...
        it_solve_occ, ...
        fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
        fl_w2o1, fl_w2o2, fl_w2o3, ...
        ar_fl_p2_min, ar_fl_p2_max);

    % optimally borrowing given the parameters here
    bl_verbose = false;
    bl_timer = false;
    mp_mlsec_ctrlinfo = containers.Map('KeyType','char', 'ValueType','any');
    mp_mlsec_ctrlinfo('it_mlsect_jnt_pnts') = 20;
    mp_mlsec_ctrlinfo('it_mlsect_max_iter') = 20;
    mp_mlsec_ctrlinfo('bl_returnmin') = true;
    [fl_w2ox_equi_ratio, fl_w2ox_equi] = ...
        ff_optim_mlsec_savezrone(fc_w2_fixedpoint, bl_verbose, bl_timer, mp_mlsec_ctrlinfo);
    [fl_w2ox_iter_gap, fl_w2ox, ar_w2_iter_gap, ar_w2_iter_hat, ar_w1_iter_endo] = ...
        fc_w2_fixedpoint(fl_w2ox_equi_ratio);
end

%% B. Solving Two prices, Bisect + Multisec
if (it_solve_n1n2n3 == 2)
    % fl_w2o3 = 0.67;
    % Define contraction equation
    it_solve_occ = 2;
    it_nest_solve_occ = 1;
    % Contraction equation
    fc_w2_fixedpointnest2 = @(x) ffi_w2_fixed_point_nest2(x, ...
        it_solve_occ, it_nest_solve_occ, bl_checkminmax, ...
        fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
        fl_w2o1, fl_w2o2, fl_w2o3, ...
        ar_fl_p2_min, ar_fl_p2_max);

    % update solution bound for IT_SOLVE_OCC
    [ar_x_points_noimg, ar_obj_eval_noimg, it_exit_condition] = ...
        ff_nonimg_posnegbd(0, 1, fc_w2_fixedpointnest2, 100, 1, true, false, false);
    [fl_x_left_start, fl_x_right_start] = deal(min(ar_x_points_noimg), max(ar_x_points_noimg));

    % optimally borrowing given the parameters here
    bl_verbose = false;
    bl_timer = false;
    mp_bisec_ctrlinfo = containers.Map('KeyType','char', 'ValueType','any');
    mp_bisec_ctrlinfo('it_bisect_max_iter') = 25;
    mp_bisec_ctrlinfo('fl_x_left_start') = fl_x_left_start;
    mp_bisec_ctrlinfo('fl_x_right_start') = fl_x_right_start';

    [fl_w2ox_equi_ratio, fl_w2ox_equi] = ...
        ff_optim_bisec_savezrone(fc_w2_fixedpointnest2, bl_verbose, bl_timer, mp_bisec_ctrlinfo);
    [fl_w2ox_iter_gap, fl_w2ox_mainendo, ar_w2_iter_gap, ar_w2_iter_hat, ar_w1_iter_endo] = ...
        fc_w2_fixedpointnest2(fl_w2ox_equi_ratio);
    ar_w2_iter_hat
    ar_w2_iter_gap
end

%% C. Solving Three prices, Bisect + Multisec
if (it_solve_n1n2n3 == 3)
    % Define contraction equation
    % fl_w2o3 = 100;
    it_solve_occ = 3;
    it_nest_solve_occ = 2;
    it_nestnest_solve_occ = 1;

    fc_w2_fixedpointnest3 = @(x) ffi_w2_fixed_point_nest3A(x, ...
        it_solve_occ, it_nest_solve_occ, it_nestnest_solve_occ, bl_checkminmax, ...
        fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
        fl_w2o1, fl_w2o2, fl_w2o3, ...
        ar_fl_p2_min, ar_fl_p2_max);

    % update solution bound for IT_SOLVE_OCC
    [ar_x_points_noimg, ar_obj_eval_noimg, it_exit_condition] = ...
        ff_nonimg_posnegbd(0, 1, fc_w2_fixedpointnest3, 10, 1, true, false, false);
    [fl_x_left_start, fl_x_right_start] = deal(min(ar_x_points_noimg), max(ar_x_points_noimg));

    % optimally borrowing given the parameters here
    bl_verbose = false;
    bl_timer = false;
    mp_bisec_ctrlinfo = containers.Map('KeyType','char', 'ValueType','any');
    mp_bisec_ctrlinfo('it_bisect_max_iter') = 25;
    mp_bisec_ctrlinfo('fl_x_left_start') = fl_x_left_start;
    mp_bisec_ctrlinfo('fl_x_right_start') = fl_x_right_start';
    [fl_w2ox_equi_ratio, fl_w2ox_equi] = ...
        ff_optim_bisec_savezrone(fc_w2_fixedpointnest3, bl_verbose, bl_timer, mp_bisec_ctrlinfo);
    [fl_w2ox_iter_gap, fl_w2ox_mainendo, ar_w2_iter_gap, ar_w2_iter_hat, ar_w1_iter_endo] = ...
        fc_w2_fixedpointnest3(fl_w2ox_equi_ratio);
end

%% Get equilibrium prices
[fl_w1o1, fl_w1o2, fl_w1o3] = deal(ar_w1_iter_endo(1), ar_w1_iter_endo(2), ar_w1_iter_endo(3));
[fl_w2o1, fl_w2o2, fl_w2o3] = deal(ar_w2_iter_hat(1), ar_w2_iter_hat(2), ar_w2_iter_hat(3));

%% Quantity Demanded
Z = 1;

% Labor demand manual
p1 = fl_w1o1;
p2 = fl_w2o1;
Y = fl_Y_manual;
rho = fl_rho_manual;
beta_1 = fl_beta_1_manual;
beta_2 = fl_beta_2_manual;
fl_lab_demand_w1o1 = fc_d1(p1, p2, Y, Z, rho, beta_1, beta_2);
fl_lab_demand_w2o1 = fc_d2(p1, p2, Y, Z, rho, beta_1, beta_2);
% Labor demand routine
p1 = fl_w1o2;
p2 = fl_w2o2;
Y = fl_Y_routine;
rho = fl_rho_routine;
beta_1 = fl_beta_1_routine;
beta_2 = fl_beta_2_routine;
fl_lab_demand_w1o2 = fc_d1(p1, p2, Y, Z, rho, beta_1, beta_2);
fl_lab_demand_w2o2 = fc_d2(p1, p2, Y, Z, rho, beta_1, beta_2);
% Labor demand analytical
p1 = fl_w1o3;
p2 = fl_w2o3;
Y = fl_Y_analytical;
rho = fl_rho_analytical;
beta_1 = fl_beta_1_analytical;
beta_2 = fl_beta_2_analytical;
fl_lab_demand_w1o3 = fc_d1(p1, p2, Y, Z, rho, beta_1, beta_2);
fl_lab_demand_w2o3 = fc_d2(p1, p2, Y, Z, rho, beta_1, beta_2);

%% Generate quantity of workers supplied and fill quantity demanded
mp_wages = containers.Map('KeyType','char', 'ValueType','any');
mp_fl_labor_demanded = containers.Map('KeyType','char', 'ValueType','any');
ar_st_gen_occ_categories = mt_st_gen_occ_categories(:)';
for st_category_key=ar_st_gen_occ_categories
    % input wages same way for all occupations
    st_sex = ar_cate2gensklocc_sex(ar_cate2gensklocc_category==st_category_key);
    st_occupation = ar_cate2gensklocc_occupation(ar_cate2gensklocc_category==st_category_key);
    % input wages same way for all occupations
    if (strcmp(st_sex, 'Female') && (strcmp(st_occupation, 'Manual')))
        fl_wage = fl_w2o1;
        fl_lab_demand = fl_lab_demand_w2o1;
    elseif (strcmp(st_sex, 'Female') && (strcmp(st_occupation, 'Routine')))
        fl_wage = fl_w2o2;
        fl_lab_demand = fl_lab_demand_w2o2;
    elseif (strcmp(st_sex, 'Female') && (strcmp(st_occupation, 'Analytical')))
        fl_wage = fl_w2o3;
        fl_lab_demand = fl_lab_demand_w2o3;
    elseif (strcmp(st_sex, 'Male') && (strcmp(st_occupation, 'Manual')))
        fl_wage = fl_w1o1;
        fl_lab_demand = fl_lab_demand_w1o1;
    elseif (strcmp(st_sex, 'Male') && (strcmp(st_occupation, 'Routine')))
        fl_wage = fl_w1o2;
        fl_lab_demand = fl_lab_demand_w1o2;
    elseif (strcmp(st_sex, 'Male') && (strcmp(st_occupation, 'Analytical')))
        fl_wage = fl_w1o3;
        fl_lab_demand = fl_lab_demand_w1o3;
    end
    mp_wages(st_category_key) = fl_wage;
    mp_fl_labor_demanded(st_category_key) = fl_lab_demand;
end

% Quantity demanded and probability
[mp_fl_labor_occprbty, mp_fl_labor_supplied] = ...
    bfw_mlogit(mp_params, mp_data, mp_func, mp_controls, mt_st_gen_occ_categories, it_data_year, mp_wages);

%% Differences in Demand and Supply
mp_fl_labor_excess_demand = containers.Map('KeyType','char', 'ValueType','any');
param_map_keys = keys(mp_fl_labor_demanded);
param_map_vals_labor_demand = values(mp_fl_labor_demanded);
param_map_vals_labor_supply = values(mp_fl_labor_supplied);
fl_mse_excess_demand = 0;
for i = 1:length(mp_fl_labor_supplied)
    st_category_key = param_map_keys{i};
    fl_demand = param_map_vals_labor_demand{i};
    fl_supply = param_map_vals_labor_supply{i};
    fl_excess_demand = fl_demand - fl_supply;
    fl_mse_excess_demand = fl_mse_excess_demand + fl_excess_demand^2;
    mp_fl_labor_excess_demand(st_category_key) = fl_demand - fl_supply;
end

%% Display
if (bl_bfw_solveequi_kwfw_display)
    st_display = strjoin(...
        ["Completed BFW_SOLVEEQUI_KWFW", ...
        ['fl_mse_excess=' num2str(fl_mse_excess_demand)], ...
        ['ar_w1_iter_endo=' num2str(ar_w1_iter_endo)], ...
        ['ar_w2_iter_hat=' num2str(ar_w2_iter_hat)], ...
        ['ar_w2_iter_gap=' num2str(ar_w2_iter_gap)], ...
        ], ";");
    disp(st_display);
end
if (bl_bfw_solveequi_kwfw_display_verbose)
    ff_container_map_display(mp_wages);
    ff_container_map_display(mp_fl_labor_demanded);
    ff_container_map_display(mp_fl_labor_supplied);
    ff_container_map_display(mp_fl_labor_occprbty);
    ff_container_map_display(mp_fl_labor_excess_demand);
end

%% Return
varargout = cell(nargout,0);
for it_k = 1:nargout
    if (it_k==1)
        ob_out_cur = ar_w1_iter_endo;
    elseif (it_k==2)
        ob_out_cur = ar_w2_iter_hat;
    elseif (it_k==3)
        ob_out_cur = ar_w2_iter_gap;
    elseif (it_k==4)
        ob_out_cur = mp_wages;
    elseif (it_k==5)
        ob_out_cur = mp_fl_labor_demanded;
    elseif (it_k==6)
        ob_out_cur = mp_fl_labor_supplied;
    elseif (it_k==7)
        ob_out_cur = mp_fl_labor_occprbty;
    elseif (it_k==8)
        ob_out_cur = fl_mse_excess_demand;
    elseif (it_k==9)
        ob_out_cur = mp_fl_labor_excess_demand;
    end
    varargout{it_k} = ob_out_cur;
end

end

%% FUNC1: Root search function Single Price
% it_solve_occ: solving inside which one of the three occupation nests
% ar_wages: six fixed wages
function [ar_w2ox_iter_gap, ar_w2ox, mt_w2_iter_gap, mt_w2_iter_hat, mt_w1_iter_endo] = ...
    ffi_w2_fixed_point(...
    ar_p2maxmingapratio, ...
    it_solve_occ, ...
    fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
    fl_w2o1, fl_w2o2, fl_w2o3, ...
    ar_fl_p2_min, ar_fl_p2_max)

% For the occupational category currently solving over, update wage
fl_w2ox = ar_p2maxmingapratio*(ar_fl_p2_max(1)-ar_fl_p2_min(1)) + ar_fl_p2_min(1);
if (it_solve_occ == 1)
    fl_w2o1 = fl_w2ox;
elseif (it_solve_occ == 2)
    fl_w2o2 = fl_w2ox;
elseif (it_solve_occ == 3)
    fl_w2o3 = fl_w2ox;
end

% Iterate and solve
[ar_w2ox_iter_gap, ar_w2ox, mt_w2_iter_gap, mt_w2_iter_hat, mt_w1_iter_endo] = ...
    ffi_p2top1_p1top2(...
    it_solve_occ, ...
    fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
    fl_w2o1, fl_w2o2, fl_w2o3);

end

%% FUNC2: Root search function Double Nest
function [fl_w2ox_iter_gap, fl_w2ox_mainendo, ar_w2_iter_gap, ar_w2_iter_hat, ar_w1_iter_endo] = ...
    ffi_w2_fixed_point_nest2(...
    fl_p2maxmingapratio, ...
    it_solve_occ, it_nest_solve_occ, bl_checkminmax, ...
    fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
    fl_w2o1, fl_w2o2, fl_w2o3, ...
    ar_fl_p2_min, ar_fl_p2_max)

% [fl_w2o1_init, fl_w2o2_init, fl_w2o3_init] = deal(fl_w2o1, fl_w2o2, fl_w2o3);
% A. Endo Wage 1
% For the occupational category currently solving over, update wage
fl_w2ox_mainendo = fl_p2maxmingapratio*(ar_fl_p2_max(2)-ar_fl_p2_min(2)) + ar_fl_p2_min(2);
if (it_solve_occ == 1)
    fl_w2o1 = fl_w2ox_mainendo;
elseif (it_solve_occ == 2)
    fl_w2o2 = fl_w2ox_mainendo;
elseif (it_solve_occ == 3)
    fl_w2o3 = fl_w2ox_mainendo;
end

% B. Nested Endo Wage 2
% Define contraction equation
fc_w2_fixedpoint = @(x) ffi_w2_fixed_point(x, ...
    it_nest_solve_occ, ...
    fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
    fl_w2o1, fl_w2o2, fl_w2o3, ...
    ar_fl_p2_min, ar_fl_p2_max);
% Initial start and end percentages
fl_x_left_start = 10e-6;
fl_x_right_start = 1-10e-6;

% C1. Check min and max if objective signs the same
if (bl_checkminmax)

    % check min and max
    [ar_w2ox_iter_gap_min, ar_w2ox_min] = fc_w2_fixedpoint(fl_x_left_start);
    [ar_w2ox_iter_gap_max, ar_w2ox_max] = fc_w2_fixedpoint(fl_x_right_start);

    % if one end is not real redo
    if (isreal(ar_w2ox_max) + isreal(ar_w2ox_min) < 2)
        [ar_x_points_noimg, ar_obj_eval_noimg, it_exit_condition] = ...
            ff_nonimg_posnegbd(0, 1, fc_w2_fixedpoint, 100, 2, false, false);
        [fl_x_left_start, fl_x_right_start] = deal(min(ar_x_points_noimg), max(ar_x_points_noimg));
        [ar_w2ox_iter_gap_min, ar_w2ox_min] = fc_w2_fixedpoint(fl_x_left_start);
        [ar_w2ox_iter_gap_max, ar_w2ox_max] = fc_w2_fixedpoint(fl_x_right_start);
    end

    % Same sign at min and max means there is no contraction possible
    if (ar_w2ox_iter_gap_min*ar_w2ox_iter_gap_max > 0)
        bl_solve_nested = false;
        if (abs(ar_w2ox_iter_gap_min) < abs(ar_w2ox_iter_gap_max))
            fl_w2ox_equi_nestendo = ar_w2ox_min;
        else
            fl_w2ox_equi_nestendo = ar_w2ox_max;
        end
    else
        bl_solve_nested = true;
    end
end

% C2. Solve for Equilibrium Gap minimizing Wage for the Nested Wage
if (bl_solve_nested)
    % optimally borrowing given the parameters here
    bl_verbose = false;
    bl_timer = false;
    mp_mlsec_ctrlinfo = containers.Map('KeyType','char', 'ValueType','any');
    mp_mlsec_ctrlinfo('it_mlsect_jnt_pnts') = 20;
    mp_mlsec_ctrlinfo('it_mlsect_max_iter') = 10;
    mp_mlsec_ctrlinfo('fl_x_left_start') = fl_x_left_start;
    mp_mlsec_ctrlinfo('fl_x_right_start') = fl_x_right_start;
    mp_mlsec_ctrlinfo('bl_returnmin') = true;
    [~, fl_w2ox_equi_nestendo] = ...
        ff_optim_mlsec_savezrone(fc_w2_fixedpoint, bl_verbose, bl_timer, mp_mlsec_ctrlinfo);
end

% C3. Updated nested wage
if (it_nest_solve_occ == 1)
    fl_w2o1 = fl_w2ox_equi_nestendo;
elseif (it_nest_solve_occ == 2)
    fl_w2o2 = fl_w2ox_equi_nestendo;
elseif (it_nest_solve_occ == 3)
    fl_w2o3 = fl_w2ox_equi_nestendo;
end

% D. Solve for wage iterative
[fl_w2ox_iter_gap, fl_w2ox_mainendo, ar_w2_iter_gap, ar_w2_iter_hat, ar_w1_iter_endo] = ...
    ffi_p2top1_p1top2(...
    it_solve_occ, ...
    fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
    fl_w2o1, fl_w2o2, fl_w2o3);

end

%% FUNC3A: Root search function Double Nest
function [fl_w2ox_iter_gap, fl_w2ox_mainendo, ar_w2_iter_gap, ar_w2_iter_hat, ar_w1_iter_endo] = ...
    ffi_w2_fixed_point_nest3A(...
    fl_p2maxmingapratio, ...
    it_solve_occ, it_nest_solve_occ, it_nestnest_solve_occ, bl_checkminmax, ...
    fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
    fl_w2o1, fl_w2o2, fl_w2o3, ...
    ar_fl_p2_min, ar_fl_p2_max)

% [fl_w2o1_init, fl_w2o2_init, fl_w2o3_init] = deal(fl_w2o1, fl_w2o2, fl_w2o3);
% A. Endo Wage 1
% For the occupational category currently solving over, update wage
fl_w2ox_cur = fl_p2maxmingapratio*(ar_fl_p2_max(3)-ar_fl_p2_min(3)) + ar_fl_p2_min(3);
if (it_solve_occ == 1)
    fl_w2o1 = fl_w2ox_cur;
elseif (it_solve_occ == 2)
    fl_w2o2 = fl_w2ox_cur;
elseif (it_solve_occ == 3)
    fl_w2o3 = fl_w2ox_cur;
end

% Contraction equation
fc_w2_fixedpointnest2 = @(x) ffi_w2_fixed_point_nest2(x, ...
    it_nest_solve_occ, it_nestnest_solve_occ, bl_checkminmax, ...
    fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
    fl_w2o1, fl_w2o2, fl_w2o3, ...
    ar_fl_p2_min, ar_fl_p2_max);

% update solution bound for IT_SOLVE_OCC
[ar_x_points_noimg, ar_obj_eval_noimg, it_exit_condition] = ...
    ff_nonimg_posnegbd(0, 1, fc_w2_fixedpointnest2, 100, 1, true, false, false);
[fl_x_left_start, fl_x_right_start] = deal(min(ar_x_points_noimg), max(ar_x_points_noimg));

% optimally borrowing given the parameters here
bl_verbose = false;
bl_timer = false;
mp_bisec_ctrlinfo = containers.Map('KeyType','char', 'ValueType','any');
mp_bisec_ctrlinfo('it_bisect_max_iter') = 25;
mp_bisec_ctrlinfo('fl_x_left_start') = fl_x_left_start;
mp_bisec_ctrlinfo('fl_x_right_start') = fl_x_right_start';

[fl_w2ox_equi_ratio, fl_w2ox_equi] = ...
    ff_optim_bisec_savezrone(fc_w2_fixedpointnest2, bl_verbose, bl_timer, mp_bisec_ctrlinfo);
[~, ~, ar_w2_iter_gap, ar_w2_iter_hat, ar_w1_iter_endo] = ...
    fc_w2_fixedpointnest2(fl_w2ox_equi_ratio);

% update gap and main endo
[fl_w2ox_iter_gap, fl_w2ox_mainendo] = deal(ar_w2_iter_gap(it_solve_occ), ar_w2_iter_hat(it_solve_occ));
end

%% FUNC3B: Root search function Double Nest
function [fl_w2ox_iter_gap, fl_w2ox_mainendo, ar_w2_iter_gap, ar_w2_iter_hat, ar_w1_iter_endo] = ...
    ffi_w2_fixed_point_nest3B(...
    fl_p2maxmingapratio, ...
    it_solve_occ, ar_it_nest_solve_occ, bl_checkminmax, ...
    fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
    fl_w2o1, fl_w2o2, fl_w2o3, ...
    fl_p2_min, fl_p2_max)

% [fl_w2o1_init, fl_w2o2_init, fl_w2o3_init] = deal(fl_w2o1, fl_w2o2, fl_w2o3);
fl_p2maxmingapratio = fl_p2maxmingapratio;
% A. Endo Wage 1
% For the occupational category currently solving over, update wage
fl_w2ox_cur = fl_p2maxmingapratio*(fl_p2_max-fl_p2_min) + fl_p2_min;
if (it_solve_occ == 1)
    fl_w2o1 = fl_w2ox_cur;
elseif (it_solve_occ == 2)
    fl_w2o2 = fl_w2ox_cur;
elseif (it_solve_occ == 3)
    fl_w2o3 = fl_w2ox_cur;
end

% B. Given Wage 1, solve nested Endo Wage 2/3
% Define contraction equation
it_solve_occ_nest2 = ar_it_nest_solve_occ(1);
it_nest_solve_occ_nest2 = ar_it_nest_solve_occ(2);
fc_w2_fixedpointnest2 = @(x) ffi_w2_fixed_point_nest2(x, ...
    it_solve_occ_nest2, it_nest_solve_occ_nest2, bl_checkminmax, ...
    fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
    fl_w2o1, fl_w2o2, fl_w2o3, ...
    fl_p2_min, fl_p2_max);
% Initial start and end percentages
fl_x_left_start = 10e-6;
fl_x_right_start = 1-10e-6;

% C1. Check min and max if objective signs the same
if (bl_checkminmax)
    [ar_w2ox_iter_gap_min, ar_w2ox_min] = fc_w2_fixedpointnest2(fl_x_left_start);
    [ar_w2ox_iter_gap_max, ar_w2ox_max] = fc_w2_fixedpointnest2(fl_x_right_start);

    % if one end is not real redo
    if (isreal(ar_w2ox_max) + isreal(ar_w2ox_min) < 2)
        [ar_x_points_noimg, ar_obj_eval_noimg, it_exit_condition] = ...
            ff_nonimg_posnegbd(0, 1, fc_w2_fixedpointnest2, 100, 2, true, false, false);
        [fl_x_left_start, fl_x_right_start] = deal(min(ar_x_points_noimg), max(ar_x_points_noimg));
        [ar_w2ox_iter_gap_min, ar_w2ox_min] = fc_w2_fixedpointnest2(fl_x_left_start);
        [ar_w2ox_iter_gap_max, ar_w2ox_max] = fc_w2_fixedpointnest2(fl_x_right_start);
    end

    % Same sign at min and max means there is no contraction possible
    if (ar_w2ox_iter_gap_min*ar_w2ox_iter_gap_max > 0)
        bl_solve_nested = false;
        if (abs(ar_w2ox_iter_gap_min) < abs(ar_w2ox_iter_gap_max))
            fl_w2ox_equi_ratio = fl_x_left_start;
            fl_w2ox_equi = ar_w2ox_min;
        else
            fl_w2ox_equi_ratio = fl_x_right_start;
            fl_w2ox_equi = ar_w2ox_max;
        end
    else
        bl_solve_nested = true;
    end
end

% C2. Solve for Equilibrium Gap minimizing Wage for the Nested Wage
if (bl_solve_nested)
    bl_verbose = false;
    bl_timer = false;
    mp_bisec_ctrlinfo = containers.Map('KeyType','char', 'ValueType','any');
    mp_bisec_ctrlinfo('it_bisect_max_iter') = 25;
    [fl_w2ox_equi_ratio, fl_w2ox_equi] = ...
        ff_optim_bisec_savezrone(fc_w2_fixedpointnest2, bl_verbose, bl_timer, mp_bisec_ctrlinfo);
end

% C3. Prices update
[fl_w2ox_iter_gap, fl_w2ox_mainendo, ar_w2_iter_gap, ar_w2_iter_hat, ar_w1_iter_endo] = ...
    fc_w2_fixedpointnest2(fl_w2ox_equi_ratio);
if (it_solve_occ_nest2 == 1 || it_nest_solve_occ_nest2 == 1)
    fl_w2o1 = ar_w2_iter_hat(1);
end
if (it_solve_occ_nest2 == 2 || it_nest_solve_occ_nest2 == 2)
    fl_w2o2 = ar_w2_iter_hat(2);
end
if (it_solve_occ_nest2 == 3 || it_nest_solve_occ_nest2 == 3)
    fl_w2o3 = ar_w2_iter_hat(3);
end

% D. Solve for wage iterative
[fl_w2ox_iter_gap, fl_w2ox_mainendo, ar_w2_iter_gap, ar_w2_iter_hat, ar_w1_iter_endo] = ...
    ffi_p2top1_p1top2(...
    it_solve_occ, ...
    fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
    fl_w2o1, fl_w2o2, fl_w2o3);
end

%% FUNC4: Price Iteration system
function [fl_w2ox_iter_gap, fl_w2ox_mainendo, ar_w2_iter_gap, ar_w2_iter_hat, ar_w1_iter_endo] = ...
    ffi_p2top1_p1top2(...
    it_solve_occ, ...
    fc_w1o1, fc_w1o2, fc_w1o3, fc_w2o1, fc_w2o2, fc_w2o3, ...
    fl_w2o1, fl_w2o2, fl_w2o3)

% fl_w2o1 = 1e-3;
% fl_w2o2 = fl_w2o2;
% fl_w2o3 = fl_w2o3;

% A. w2 to w1 array
fl_w1o1 = fc_w1o1(fl_w2o1, fl_w2o2, fl_w2o3);
fl_w1o2 = fc_w1o2(fl_w2o1, fl_w2o2, fl_w2o3);
fl_w1o3 = fc_w1o3(fl_w2o1, fl_w2o2, fl_w2o3);

% B. w1 to w2 array
fl_w2o1_hat = fc_w2o1(fl_w1o1, fl_w1o2, fl_w1o3);
fl_w2o2_hat = fc_w2o2(fl_w1o1, fl_w1o2, fl_w1o3);
fl_w2o3_hat = fc_w2o3(fl_w1o1, fl_w1o2, fl_w1o3);

% C. gap
fl_w2o1_iter_gap = fl_w2o1 - fl_w2o1_hat;
fl_w2o2_iter_gap = fl_w2o2 - fl_w2o2_hat;
fl_w2o3_iter_gap = fl_w2o3 - fl_w2o3_hat;
ar_w2_iter_gap = [fl_w2o1_iter_gap(:)', fl_w2o2_iter_gap(:)', fl_w2o3_iter_gap(:)'];

% store w2hats
ar_w2_iter_hat = [fl_w2o1_hat(:)', fl_w2o2_hat(:)', fl_w2o3_hat(:)'];
ar_w1_iter_endo = [fl_w1o1(:)', fl_w1o2(:)', fl_w1o3(:)'];

% D. return
if (it_solve_occ == 1)
    fl_w2ox_iter_gap = fl_w2o1_iter_gap;
    fl_w2ox_mainendo = fl_w2o1_hat;
elseif (it_solve_occ == 2)
    fl_w2ox_iter_gap = fl_w2o2_iter_gap;
    fl_w2ox_mainendo = fl_w2o2_hat;
elseif (it_solve_occ == 3)
    fl_w2ox_iter_gap = fl_w2o3_iter_gap;
    fl_w2ox_mainendo = fl_w2o3_hat;
end

end
