%% BFW_CRS_NESTED_CES Solve Nested CES Demand Problems with Constant Returns
%    This function solves optimal choices given CES production function
%    under cost minimization. Works with Constant Elasticity of
%    Substitution problems with constant returns, up to four nest layers,
%    and two inputs in each sub-nest. Takes as inputs share and elasticity
%    parameters across layers of sub-nests, as well as input unit costs at
%    the bottom-most layer. Works with Constant Elasticity of Substitution
%    problems with constant returns, up to four nest layers, and two inputs
%    in each sub-nest. Allows for uneven branches, so that some branches go
%    up to four layers, but others have less layers, works with BFW (2022)
%    nested labor input problem.
%
%    The function is written to be independently invocable in terms of
%    parameters, all parameters are specified through input cell arrays.
%    The functional form for CRS nested CES is invariant given parameters,
%    and that does not need to be provided.
%
%    The share parameter is for the wage input in the first index position.
%
%    * FL_YZ float output divided by productivity, aggregate single term
%    * CL_MN_PRHO cell array of rho (elasticity) parameter between negative
%    infinity and 1. For example, suppose there are four nest layers, and
%    there are two branches at each layer, then we have 1, 2, 4, and 8
%    $\rho$ parameter values at the 1st, 2nd, 3rd, and 4th nest layers:
%    size(CL_MN_PRHO{1})=[1,1], size(CL_MN_PRHO{2})=[1,2],
%    size(CL_MN_PRHO{3})=[2,2], size(CL_MN_PRHO{4})=[2,2,2]. Note that if
%    the model has 4 nest layers, not all cells need to be specified, some
%    branches could be deeper than others.
%    * CL_MN_PSHARE cell array of share (between 0 and 1) for the first
%    input of the two inputs for each nest. The structure for this is
%    similar to CL_MN_PRHO.
%    * CL_MN_PRICE cell array of wages for both wages for the first and
%    second inputs of the bottom-most layer of sub-nests. The last index in
%    each element of the cell array indicates first (1) or second (2) wage.
%    For example, suppose we have four layers, with 2 branches at each
%    layer, as in the example for CL_MN_PRHO, then we have 2, 4, 8, and 16
%    wage values at the 1st, 2nd, 3rd, and 4th nest layers:
%    size(CL_MN_PRICE{1})=[1,2], size(CL_MN_PRICE{2})=[2,2],
%    size(CL_MN_PRICE{3})=[2,2,2], size(CL_MN_PRICE{4})=[2,2,2,2]. Note
%    that only the last layer of wage needs to be specified, in this case,
%    the 16 wages at the 4th layer. Given optimal solutions, we solve for
%    the 2, 4, and 8 aggregate wages at the higher nest layers. If some
%    branches are deeper than other branches, then can specific NA for
%    non-reached layers along some branches.
%    * BL_BFW_MODEL boolean true by default if true then will output
%    outcomes specific to the BFW 2022 problem.
%
%    [CL_MN_YZ_CHOICES, CL_MN_PRICE] = BFW_CRS_NESTED_CES(FL_YZ,
%    CL_MN_PRHO, CL_MN_PSHARE, CL_MN_PRICE, BL_VERBOSE) Solve for the
%    optimal expenditure minimization constant-returns nested CES problem
%    from BFW 2022 and generate all aggregate prices and aggregate
%    quantities. CL_MN_YZ_CHOICES has the same dimension as CL_MN_PRICE,
%    suppose there are four layers, the CL_MN_PRICE{4} results at the
%    lowest layer includes quantity choices that might be observed in the
%    data. CL_MN_PRICE cell values at non-bottom layers include aggregate
%    quantity outcomes. CL_MN_PRICE includes at the lowest layer observed
%    wages, however, also includes higher layer aggregate solved wages.
%    CL_MN_PRHO and CL_MN_PSHARE are identical to inputs.
%
%    [CL_MN_YZ_CHOICES, CL_MN_PRICE, CL_MN_PRHO, CL_MN_PSHARE] =
%    BFW_CRS_NESTED_CES(FL_YZ, CL_MN_PRHO, CL_MN_PSHARE, CL_MN_PRICE,
%    BL_VERBOSE) Also returns the initial $\rho$ and $\alpha$ share cell
%    arrays.
%
%    [CL_MN_YZ_CHOICES, CL_MN_PRICE] = BFW_CRS_NESTED_CES(FL_YZ,
%    CL_MN_PRHO, CL_MN_PSHARE, CL_MN_PRICE, MP_FUNC, BL_VERBOSE,
%    BL_BFW_MODEL) With BL_BFW_MODEL set to false, the function solves for
%    a generic CES expenditure minimization problem with constant-returns
%    with up to four layers. MP_FUNC is the map container of demand
%    function components from BFW_MP_FUNC_DEMAND().
%
%    see also BFW_CRS_NESTED_CES_MPL, BFWX_CRS_NESTED_CES
%

%%
function [varargout]=bfw_crs_nested_ces(varargin)

%% Default and Parse
if (~isempty(varargin))

    bl_verbose = false;
    bl_bfw_model = true;
    if (length(varargin)==4)
        [fl_yz, cl_mn_prho, cl_mn_pshare, cl_mn_price] = varargin{:};
        mp_func = bfw_mp_func_demand();
    elseif (length(varargin)==5)
        [fl_yz, cl_mn_prho, cl_mn_pshare, cl_mn_price, ...
            bl_verbose] = varargin{:};
        mp_func = bfw_mp_func_demand();
    elseif (length(varargin)==6)
        [fl_yz, cl_mn_prho, cl_mn_pshare, cl_mn_price, ...
            mp_func, bl_verbose] = varargin{:};
    elseif (length(varargin)==7)
        [fl_yz, cl_mn_prho, cl_mn_pshare, cl_mn_price, ...
            mp_func, bl_verbose, bl_bfw_model] = varargin{:};
    end

else
    clear all;
    close all;
    clc;

    % Controls
    bl_verbose = true;
    bl_bfw_model = true;

    % Given rho and beta, solve for equilibrium quantities
    bl_log_wage = false;
    mp_func = bfw_mp_func_demand(bl_log_wage);

    % Following instructions in: PrjFLFPMexicoBFW\solvedemand\README.md

    % Nests/layers
    it_nests = 4;

    % Input cell of mn matrixes
    it_prho_cl = 1;
    it_pshare_cl = 2;
    it_price_cl = 3;
    for it_cl_ctr = [1,2,3]

        cl_mn_cur = cell(it_nests,1);

        % Fill each cell element with NaN mn array
        for it_cl_mn = 1:it_nests

            bl_price = (it_cl_ctr == it_price_cl);

            if (~bl_price && it_cl_mn == 1)
                mn_nan = NaN;
            elseif (~bl_price && it_cl_mn == 2) || (bl_price && it_cl_mn == 1)
                mn_nan = [NaN, NaN];
            elseif (~bl_price && it_cl_mn == 3) || (bl_price && it_cl_mn == 2)
                mn_nan = NaN(2,2);
            elseif (~bl_price && it_cl_mn == 4) || (bl_price && it_cl_mn == 3)
                mn_nan = NaN(2,2,2);
            elseif (~bl_price && it_cl_mn == 5) || (bl_price && it_cl_mn == 4)
                mn_nan = NaN(2,2,2,2);
            elseif (~bl_price && it_cl_mn == 6) || (bl_price && it_cl_mn == 5)
                mn_nan = NaN(2,2,2,2,2);
            end
            cl_mn_cur{it_cl_mn} = mn_nan;
        end

        % Name cell arrays
        if (it_cl_ctr == it_prho_cl)
            cl_mn_prho = cl_mn_cur;
        elseif (it_cl_ctr == it_pshare_cl)
            cl_mn_pshare = cl_mn_cur;
        elseif (it_cl_ctr == it_price_cl)
            cl_mn_price = cl_mn_cur;
        end
    end

    % Initialize share matrix
    rng(123);
    for it_cl_mn = 1:it_nests
        mn_pshare = cl_mn_pshare{it_cl_mn};
        if it_cl_mn == 4
            mn_pshare(2,:,:) = rand(2,2);
        else
            mn_pshare = rand(size(mn_pshare));
        end
        cl_mn_pshare{it_cl_mn} = mn_pshare;
    end

    % Initialize rho matrix
    rng(456);
    for it_cl_mn = 1:it_nests
        mn_prho = cl_mn_prho{it_cl_mn};
        if it_cl_mn == 4
            mn_prho(2,:,:) = rand(2,2);
        else
            mn_prho = rand(size(mn_prho));
        end
        % Scalling rho between 0.7500 and -3.0000
        % 1 - 2.^(linspace(-2,2,5))
        mn_prho = 1 - 2.^(mn_prho*(4) - 2);
        cl_mn_prho{it_cl_mn} = mn_prho;
    end

    % Initialize wage matrix
    rng(789);
    for it_cl_mn = 1:it_nests
        mn_price = cl_mn_price{it_cl_mn};
        if it_cl_mn == 3
            mn_price(1,:,:) = rand(2,2);
        elseif it_cl_mn == 4
            mn_price(2,:,:,:) = rand(2,2,2);
        end
        % Scalling rho between 3 amd 5
        mn_price = mn_price*(2) + 3;
        cl_mn_price{it_cl_mn} = mn_price;
    end

    % Initialize yz matrix
    rng(101112);
    fl_yz = rand();
end

%% Parse Parameters
% Parse Function inputs
params_group = values(mp_func, {'fc_OMEGA', 'fc_d1', 'fc_d2'});
[fc_OMEGA, fc_d1, fc_d2] = params_group{:};

%% Step 1, Parse information

% Nest count
it_nests = length(cl_mn_price);
if (it_nests > 4)
    error('This version of the BFW_CRS_NESTED_CES function allows for a maximum of 4 nests.');
end

% Generate the inner-output cell array
cl_mn_yz_choices = cell(it_nests,1);
for it_cl_mn = 1:it_nests
    mn_price = cl_mn_price{it_cl_mn};
    cl_mn_yz_choices{it_cl_mn} = NaN(size(mn_price));
end

%% Step 2, Generate aggregate prices
% Generate intermediary wages using Equation A.8, starting at the N-1
% layer, and going upwards, filling in whenever there is NaN, using same
% layer rho and elasticity values and lower layer wages, if lower layer
% wages exist.
for it_cl_mn = (it_nests-1):-1:1

    % Get current layer wages
    mn_price = cl_mn_price{it_cl_mn};

    % Flatten wages and loop through
    ar_price_flat = mn_price(:);
    ar_id_isnan = isnan(ar_price_flat);
    if it_cl_mn == 4
        [ar_id_x1, ar_id_x2, ar_id_x3, ar_id_x4] = ind2sub(size(mn_price), find(ar_id_isnan));
    elseif it_cl_mn == 3
        [ar_id_x1, ar_id_x2, ar_id_x3] = ind2sub(size(mn_price), find(ar_id_isnan));
    elseif it_cl_mn == 2
        [ar_id_x1, ar_id_x2] = ind2sub(size(mn_price), find(ar_id_isnan));
    elseif it_cl_mn == 1
        [ar_id_x1] = ind2sub(size(mn_price), find(ar_id_isnan));
    end

    % Loop over each price
    % 1. get wage from below layer
    % 2. get elasticity and share from the layer below as well
    for it_price_ctr = 1:length(ar_id_x1)
        % Get index
        it_x1 = ar_id_x1(it_price_ctr);
        if it_cl_mn >= 2
            it_x2 = ar_id_x2(it_price_ctr);
        end
        if it_cl_mn >= 3
            it_x3 = ar_id_x3(it_price_ctr);
        end
        if it_cl_mn >= 4
            it_x4 = ar_id_x4(it_price_ctr);
        end

        % Get parameters
        if it_cl_mn == 1
            fl_prho = cl_mn_prho{it_cl_mn+1}(it_x1);
            fl_pshare = cl_mn_pshare{it_cl_mn+1}(it_x1);
            fl_wage_input_1 = cl_mn_price{it_cl_mn+1}(it_x1, 1);
            fl_wage_input_2 = cl_mn_price{it_cl_mn+1}(it_x1, 2);
        end
        if it_cl_mn == 2
            fl_prho = cl_mn_prho{it_cl_mn+1}(it_x1, it_x2);
            fl_pshare = cl_mn_pshare{it_cl_mn+1}(it_x1, it_x2);
            fl_wage_input_1 = cl_mn_price{it_cl_mn+1}(it_x1, it_x2, 1);
            fl_wage_input_2 = cl_mn_price{it_cl_mn+1}(it_x1, it_x2, 2);
        end
        if it_cl_mn == 3
            fl_prho = cl_mn_prho{it_cl_mn+1}(it_x1, it_x2, it_x3);
            fl_pshare = cl_mn_pshare{it_cl_mn+1}(it_x1, it_x2, it_x3);
            fl_wage_input_1 = cl_mn_price{it_cl_mn+1}(it_x1, it_x2, it_x3, 1);
            fl_wage_input_2 = cl_mn_price{it_cl_mn+1}(it_x1, it_x2, it_x3, 2);
        end
        if it_cl_mn == 4
            fl_prho = cl_mn_prho{it_cl_mn+1}(it_x1, it_x2, it_x3, it_x4);
            fl_pshare = cl_mn_pshare{it_cl_mn+1}(it_x1, it_x2, it_x3, it_x4);
            fl_wage_input_1 = cl_mn_price{it_cl_mn+1}(it_x1, it_x2, it_x3, it_x4, 1);
            fl_wage_input_2 = cl_mn_price{it_cl_mn+1}(it_x1, it_x2, it_x3, it_x4, 2);
        end

        % Aggregate price
        fl_aggregate_price = fc_OMEGA(...
            fl_wage_input_1, fl_wage_input_2, ...
            fl_prho, ...
            fl_pshare, 1 - fl_pshare);

        % Save agggregate price to wage matrix
        if it_cl_mn == 1
            cl_mn_price{it_cl_mn}(it_x1) = fl_aggregate_price;
        end
        if it_cl_mn == 2
            cl_mn_price{it_cl_mn}(it_x1, it_x2) = fl_aggregate_price;
        end
        if it_cl_mn == 3
            cl_mn_price{it_cl_mn}(it_x1, it_x2, it_x3) = fl_aggregate_price;
        end
        if it_cl_mn == 4
            cl_mn_price{it_cl_mn}(it_x1, it_x2, it_x3, it_x4) = fl_aggregate_price;
        end

    end
end

%% Step 3, Generate inner output, optimal choices downwards
% Current layer wage, rho, elasticity, generate next layer inner output
for it_cl_mn = 1:(it_nests)

    % Get current layer wages
    mn_prho = cl_mn_prho{it_cl_mn};

    % Flatten wages and loop through
    ar_price_flat = mn_prho(:);
    ar_id_isnan = isnan(ar_price_flat);
    if it_cl_mn == 4
        [ar_id_x1, ar_id_x2, ar_id_x3] = ind2sub(size(mn_prho), find(~ar_id_isnan));
    elseif it_cl_mn == 3
        [ar_id_x1, ar_id_x2] = ind2sub(size(mn_prho), find(~ar_id_isnan));
    elseif it_cl_mn == 2
        [ar_id_x1] = ind2sub(size(mn_prho), find(~ar_id_isnan));
    elseif it_cl_mn == 1
        [ar_id_x1] = [1];
    end

    % Generate inner-output
    for it_price_ctr = 1:length(ar_id_x1)

        % Get index
        it_x1 = ar_id_x1(it_price_ctr);
        if it_cl_mn >= 3
            it_x2 = ar_id_x2(it_price_ctr);
        end
        if it_cl_mn >= 4
            it_x3 = ar_id_x3(it_price_ctr);
        end

        % Get parameters
        if it_cl_mn == 1
            % fl_prho_lower_nest = cl_mn_prho{it_cl_mn+1}(1, 1);
            fl_prho = cl_mn_prho{it_cl_mn}(1);
            fl_pshare = cl_mn_pshare{it_cl_mn}(1);
            fl_wage_input_1 = cl_mn_price{it_cl_mn}(1);
            fl_wage_input_2 = cl_mn_price{it_cl_mn}(2);
            fl_output_requirement = fl_yz;
        end
        if it_cl_mn == 2
            % fl_prho_lower_nest = cl_mn_prho{it_cl_mn+1}(it_x1, 1);
            fl_prho = cl_mn_prho{it_cl_mn}(it_x1);
            fl_pshare = cl_mn_pshare{it_cl_mn}(it_x1);
            fl_wage_input_1 = cl_mn_price{it_cl_mn}(it_x1, 1);
            fl_wage_input_2 = cl_mn_price{it_cl_mn}(it_x1, 2);
            fl_output_requirement = cl_mn_yz_choices{it_cl_mn-1}(it_x1);
        end
        if it_cl_mn == 3
            % fl_prho_lower_nest = cl_mn_prho{it_cl_mn+1}(it_x1, it_x2, 1);
            fl_prho = cl_mn_prho{it_cl_mn}(it_x1, it_x2);
            fl_pshare = cl_mn_pshare{it_cl_mn}(it_x1, it_x2);
            fl_wage_input_1 = cl_mn_price{it_cl_mn}(it_x1, it_x2, 1);
            fl_wage_input_2 = cl_mn_price{it_cl_mn}(it_x1, it_x2, 2);
            fl_output_requirement = cl_mn_yz_choices{it_cl_mn-1}(it_x1, it_x2);
        end
        if it_cl_mn == 4
            % by construction the lowest nest.
            fl_prho = cl_mn_prho{it_cl_mn}(it_x1, it_x2, it_x3);
            fl_pshare = cl_mn_pshare{it_cl_mn}(it_x1, it_x2, it_x3);
            fl_wage_input_1 = cl_mn_price{it_cl_mn}(it_x1, it_x2, it_x3, 1);
            fl_wage_input_2 = cl_mn_price{it_cl_mn}(it_x1, it_x2, it_x3, 2);
            fl_output_requirement = cl_mn_yz_choices{it_cl_mn-1}(it_x1, it_x2, it_x3);
        end

        % Aggregate price
        fl_q1_demand = fc_d1(...
            fl_wage_input_1, fl_wage_input_2, ...
            fl_output_requirement, 1, ...
            fl_prho, fl_pshare, 1 - fl_pshare);
        fl_q2_demand = fc_d2(...
            fl_wage_input_1, fl_wage_input_2, ...
            fl_output_requirement, 1, ...
            fl_prho, fl_pshare, 1 - fl_pshare);

        % Save agggregate price to wage matrix
        if it_cl_mn == 1
            cl_mn_yz_choices{it_cl_mn}(1) = fl_q1_demand;
            cl_mn_yz_choices{it_cl_mn}(2) = fl_q2_demand;
        end
        if it_cl_mn == 2
            cl_mn_yz_choices{it_cl_mn}(it_x1, 1) = fl_q1_demand;
            cl_mn_yz_choices{it_cl_mn}(it_x1, 2) = fl_q2_demand;
        end
        if it_cl_mn == 3
            cl_mn_yz_choices{it_cl_mn}(it_x1, it_x2, 1) = fl_q1_demand;
            cl_mn_yz_choices{it_cl_mn}(it_x1, it_x2, 2) = fl_q2_demand;
        end
        if it_cl_mn == 4
            cl_mn_yz_choices{it_cl_mn}(it_x1, it_x2, it_x3, 1) = fl_q1_demand;
            cl_mn_yz_choices{it_cl_mn}(it_x1, it_x2, it_x3, 2) = fl_q2_demand;
        end
    end
end

%% Given results, fill up a labor demand and initial wage matrix
if (bl_bfw_model)
    % Follow structure in bfw_minputs_solveequi_p2q_srdp_cessolu.m
    % ROWS: ar_it_sklgen = [1, 2, 3, 4];
    % ar_st_sklgen_skl = ["skilled", "skilled", "unskilled", "unskilled"];
    % ar_st_sklgen_gen = ["Male", "Female", "Male", "Female"];
    % COLS: ar_st_occ_group = ["Manual", "Routine", "Analytical"];
    mt_fl_labor_demanded = NaN(4,3);
    % Manual (1) unskilled (1), male and female
    mt_fl_labor_demanded(3, 1) = cl_mn_yz_choices{4}(2, 1, 1, 1);
    mt_fl_labor_demanded(4, 1) = cl_mn_yz_choices{4}(2, 1, 1, 2);
    % Manual (1) skilled (2)
    mt_fl_labor_demanded(1, 1) = cl_mn_yz_choices{4}(2, 1, 2, 1);
    mt_fl_labor_demanded(2, 1) = cl_mn_yz_choices{4}(2, 1, 2, 2);
    % Routine (2) unskilled (1)
    mt_fl_labor_demanded(3, 2) = cl_mn_yz_choices{4}(2, 2, 1, 1);
    mt_fl_labor_demanded(4, 2) = cl_mn_yz_choices{4}(2, 2, 1, 2);
    % Routine (2) skilled (2)
    mt_fl_labor_demanded(1, 2) = cl_mn_yz_choices{4}(2, 2, 2, 1);
    mt_fl_labor_demanded(2, 2) = cl_mn_yz_choices{4}(2, 2, 2, 2);
    % LVL3 Analytical (1) unskilled (1)
    mt_fl_labor_demanded(3, 3) = cl_mn_yz_choices{3}(1, 1, 1);
    mt_fl_labor_demanded(4, 3) = cl_mn_yz_choices{3}(1, 1, 2);
    % LVL3 Analytical (1) skilled (2)
    mt_fl_labor_demanded(1, 3) = cl_mn_yz_choices{3}(1, 2, 1);
    mt_fl_labor_demanded(2, 3) = cl_mn_yz_choices{3}(1, 2, 2);

    mt_fl_wages = NaN(4,3);
    % Manual (1) unskilled (1), male and female
    mt_fl_wages(3, 1) = cl_mn_price{4}(2, 1, 1, 1);
    mt_fl_wages(4, 1) = cl_mn_price{4}(2, 1, 1, 2);
    % Manual (1) skilled (2)
    mt_fl_wages(1, 1) = cl_mn_price{4}(2, 1, 2, 1);
    mt_fl_wages(2, 1) = cl_mn_price{4}(2, 1, 2, 2);
    % Routine (2) unskilled (1)
    mt_fl_wages(3, 2) = cl_mn_price{4}(2, 2, 1, 1);
    mt_fl_wages(4, 2) = cl_mn_price{4}(2, 2, 1, 2);
    % Routine (2) skilled (2)
    mt_fl_wages(1, 2) = cl_mn_price{4}(2, 2, 2, 1);
    mt_fl_wages(2, 2) = cl_mn_price{4}(2, 2, 2, 2);
    % LVL3 Analytical (1) unskilled (1)
    mt_fl_wages(3, 3) = cl_mn_price{3}(1, 1, 1);
    mt_fl_wages(4, 3) = cl_mn_price{3}(1, 1, 2);
    % LVL3 Analytical (1) unskilled (2)
    mt_fl_wages(1, 3) = cl_mn_price{3}(1, 2, 1);
    mt_fl_wages(2, 3) = cl_mn_price{3}(1, 2, 2);
end

%% F. Print
if bl_verbose
    % Convert each cell array to a elements of a container map where key contain cell index
    mp_container_map = containers.Map('KeyType','char', 'ValueType','any');
    if (bl_bfw_model)
        mp_container_map('mt_fl_labor_demanded') = mt_fl_labor_demanded;
    end
    for it_cl_mn = 1:it_nests
        % Get ND arrays
        mn_yz_choices = cl_mn_yz_choices{it_cl_mn};
        mn_price = cl_mn_price{it_cl_mn};
        mn_prho = cl_mn_prho{it_cl_mn};
        mn_pshare = cl_mn_pshare{it_cl_mn};

        % Fill in container map
        mp_container_map(['yz_c' num2str(it_cl_mn)]) = mn_yz_choices;
        mp_container_map(['price_c' num2str(it_cl_mn)]) = mn_price;
        mp_container_map(['prho_c' num2str(it_cl_mn)]) = mn_prho;
        mp_container_map(['pshare_c' num2str(it_cl_mn)]) = mn_pshare;
    end

    % Display
    ff_container_map_display(mp_container_map, 10, 10);
end

%% G. Return
varargout = cell(nargout,0);
for it_k = 1:nargout

    if (it_k==1)
        ob_out_cur = cl_mn_yz_choices;
    elseif (it_k==2)
        ob_out_cur = cl_mn_price;
    elseif (it_k==3)
        ob_out_cur = cl_mn_prho;
    elseif (it_k==4)
        ob_out_cur = cl_mn_pshare;
    elseif (it_k==5)
        ob_out_cur = mt_fl_labor_demanded;
    elseif (it_k==6)
        ob_out_cur = mt_fl_wages;
    end
    varargout{it_k} = ob_out_cur;

end

end
