%% BFW_MP_FUNC_EQUI Core Equilibrium Functions
%   BFW_MP_FUNC_EQUI generates a container map with key multinomial logit
%   supply-side equation. Labor supply is a function of wages.
%
%   MP_FUNC_EQUI = BFW_MP_FUNC_EQUI(BL_LOG_WAGE)
%
%   MP_FUNC_EQUI = BFW_MP_FUNC_EQUI(BL_LOG_WAGE, BL_VERBOSE)
%
%   See also BFWX_MP_FUNC_EQUI
%

%%
function varargout = bfw_mp_func_equi(varargin)
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

%% Define Contraction Equations (Contraction does not workr, bisection)
% Define P1 as a function of P2
fc_p1_of_p2 = @(p2, ...
    G_2, zeta_2_0, zeta_2_1, ...
    Y, Z, rho, beta_1, beta_2) ...
    (((((( ...
    1+exp(-zeta_2_0-zeta_2_1.*p2) ...
    )./(G_2)).*(Y/Z) ...
    ).^rho).*(1/beta_1) - (beta_2/beta_1) ...
    ).^((rho-1)/(rho))).*(beta_1/beta_2).*p2;

% Define P2 as a function of P1
fc_p2_of_p1 = @(p1, ...
    G_1, zeta_1_0, zeta_1_1, ...
    Y, Z, rho, beta_1, beta_2) ...
    (((((( ...
    1+exp(-zeta_1_0-zeta_1_1.*p1) ...
    )./(G_1)).*(Y/Z) ...
    ).^rho).*(1/beta_2) - (beta_1/beta_2) ...
    ).^((rho-1)/(rho))).*(beta_2/beta_1).*p1;

%% Define Contraction Equations with supply equations
% Define P1 as a function of P2
fc_p1_of_p2andSupply = @(p2, supplyQofP, Y, Z, rho, beta_1, beta_2) ...
    ((((((Y/Z)./supplyQofP) ...
    ).^rho).*(1/beta_1) - (beta_2/beta_1) ...
    ).^((rho-1)/(rho))).*(beta_1/beta_2).*p2;

% Define P2 as a function of P1
fc_p2_of_p1andSupply = @(p1, supplyQofP, Y, Z, rho, beta_1, beta_2) ...
    ((((((Y/Z)./supplyQofP) ...
    ).^rho).*(1/beta_2) - (beta_1/beta_2) ...
    ).^((rho-1)/(rho))).*(beta_2/beta_1).*p1;

%% Define alpha root search equation
% x is alpha
fc_x_root = @(x, price_ratio, yfz_per_input, rho) (1-x) ...
    + (x).*(price_ratio.*(x./(1-x))).^((rho)./(1-rho)) ...
    - (yfz_per_input).^rho;

%% Function Map
mp_func = containers.Map('KeyType','char', 'ValueType','any');

mp_func('fc_p1_of_p2') = fc_p1_of_p2;
mp_func('fc_p2_of_p1') = fc_p2_of_p1;
mp_func('fc_p1_of_p2andSupply') = fc_p1_of_p2andSupply;
mp_func('fc_p2_of_p1andSupply') = fc_p2_of_p1andSupply;

mp_func('f_x_root') = fc_x_root;

%% Print
if (bl_verbose)
    ff_container_map_display(mp_func);
end

%% Return
if (nargout==1)
    varargout = cell(nargout,0);
    varargout{1} = mp_func;
end

end
