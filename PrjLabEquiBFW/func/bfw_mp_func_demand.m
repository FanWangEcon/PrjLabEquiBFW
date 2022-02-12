%% BFW_MP_FUNC_DEMAND Core CES Demand Side Anonymous Functions
%   BFW_MP_FUNC_DEMAND generates a container map with key CES demand-side equation for a particular sub-nest.
%   
%   MP_FUNC_DEMAND = BFW_MP_FUNC_DEMAND() get default parameters
%   
%   MP_FUNC_DEMAND = BFW_MP_FUNC_DEMAND(BL_VERBOSE) prints details
%   
%   See also BFWX_MP_FUNC_DEMAND
%

%%
function varargout = bfw_mp_func_demand(varargin)
    %% Parse Main Inputs and Set Defaults
    if (~isempty(varargin))

        bl_verbose = false;

        if (length(varargin) == 1)
            bl_verbose = varargin{:};
        elseif (length(varargin) > 1)
            error('bfw_mp_func_demand:TooManyOptionalParameters', ...
            'allows at most 1 optional parameters');
        end

    else

        bl_verbose = false;

    end

    %% FOC Relative demand and prices
    % The relative prices and quantity equation must be satisfied
    fc_w1dw2 = @(x_1, x_2, rho, beta_1, beta_2) (x_2 / x_1)^(1 - rho) * (beta_1 / beta_2);

    %% Define Functions Demand
    fc_d1 = @(p1, p2, Y, Z, rho, beta_1, beta_2) ...
    (Y / Z) .* ( ...
        beta_1 + beta_2 .* ( ...
        (p1 ./ p2) .* (beta_2 ./ beta_1) ...
    ).^(rho / (1 - rho)) ...
    ).^(-1 / rho);
    % d1_compo_1 = (p1./p2).*(beta_2/beta_1);
    % d1_compo_2 = beta_1 + beta_2.*d1_compo_1.^(rho/(1-rho));
    % d1 = (Y/Z).*(d1_compo_2).^(-1/rho);

    fc_d2 = @(p1, p2, Y, Z, rho, beta_1, beta_2) ...
    (Y / Z) .* ( ...
        beta_1 .* ( ...
        (p2 ./ p1) .* (beta_1 ./ beta_2) ...
    ).^(rho / (1 - rho)) + beta_2 ...
    ).^(-1 / rho);
    % d2_compo_1 = (p2./p1).*(beta_1/beta_2);
    % d2_compo_2 = beta_1.*d2_compo_1.^(rho/(1-rho)) + beta_2;
    % d2 = (Y/Z).*(d2_compo_2).^(-1/rho);

    %% Equation to calculate the lagrange multiplier
    % Identical lagrangian plugging in either x1 or x2
    % WAGE = MPL*LAGRANGE_MULTIPLIER
    % fc_lagrange_x1 = fc_lagrange_x2 by construction
    fc_lagrange_x1 = @(p1, rho, beta_1, beta_2, x_1, x_2) ...
    p1 / (((beta_1 * x_1^(rho) + beta_2 * x_2^(rho))^((1 / rho) - 1)) * (beta_1 * x_1^(rho - 1)));
    fc_lagrange_x2 = @(p2, rho, beta_1, beta_2, x_1, x_2) ...
        p2 / (((beta_1 * x_1^(rho) + beta_2 * x_2^(rho))^((1 / rho) - 1)) * (beta_2 * x_2^(rho - 1)));
    fc_p1_foc = @(lagrangem, rho, beta_1, beta_2, x_1, x_2) ...
        lagrangem * (((beta_1 * x_1^(rho) + beta_2 * x_2^(rho))^((1 / rho) - 1)) * (beta_1 * x_1^(rho - 1)));
    fc_p2_foc = @(lagrangem, rho, beta_1, beta_2, x_1, x_2) ...
        lagrangem * (((beta_1 * x_1^(rho) + beta_2 * x_2^(rho))^((1 / rho) - 1)) * (beta_2 * x_2^(rho - 1)));

    %% Define Y/Z Equation
    % omega equation, the common price equation, note y=1, z=1 both.
    % note for inner O, don't need to worry about z
    fc_OMEGA = @(p1, p2, rho, beta_1, beta_2) ...
    p1 .* fc_d1(p1, p2, 1, 1, rho, beta_1, beta_2) + ...
        p2 .* fc_d2(p1, p2, 1, 1, rho, beta_1, beta_2);

    % crs revenue = cost
    fc_revenue = @(p1, p2, q1, q2) p1 * q1 + p2 * q2;

    % revenue divide by omega for Y/Z ratio, this is the output level
    fc_yz_ratio = @(p1, p2, q1, q2, rho, beta_1, beta_2) ...
    fc_revenue(p1, p2, q1, q2) / fc_OMEGA(p1, p2, rho, beta_1, beta_2);
    fc_output_nest = @(q1, q2, rho, beta_1, beta_2) ...
        ((beta_1) * q1^(rho) + beta_2 * q2^(rho))^(1 / rho);

    %% Define relative
    fc_share_given_elas_foc_Q = @(rho, p1, p2, x1, x2) ((p1 / p2) * (x1 / x2)^(1 - rho));
    fc_share_given_elas_foc = @(rho, p1, p2, x1, x2) ...
        fc_share_given_elas_foc_Q(rho, p1, p2, x1, x2) / (1 + fc_share_given_elas_foc_Q(rho, p1, p2, x1, x2));

    %% Function Map
    mp_func = containers.Map('KeyType', 'char', 'ValueType', 'any');

    mp_func('fc_w1dw2') = fc_w1dw2;
    mp_func('fc_d1') = fc_d1;
    mp_func('fc_d2') = fc_d2;

    mp_func('fc_lagrange_x1') = fc_lagrange_x1;
    mp_func('fc_lagrange_x2') = fc_lagrange_x2;
    mp_func('fc_p1_foc') = fc_p1_foc;
    mp_func('fc_p2_foc') = fc_p2_foc;

    mp_func('fc_OMEGA') = fc_OMEGA;
    mp_func('fc_yz_ratio') = fc_yz_ratio;
    mp_func('fc_output_nest') = fc_output_nest;

    mp_func('fc_share_given_elas_foc') = fc_share_given_elas_foc;

    %% Print
    if (bl_verbose)
        ff_container_map_display(mp_func);
    end

    %% Return
    if (nargout == 1)
        varargout = cell(nargout, 0);
        varargout{1} = mp_func;
    end

end
