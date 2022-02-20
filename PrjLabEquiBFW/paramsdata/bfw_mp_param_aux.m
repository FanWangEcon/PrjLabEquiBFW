%% BFW_MP_PARAM_AUX Map Container of Estimated Demand and Supply Parameters
%    BFW_MP_PARAM_ESTI creates a container map with 65 demand side parameters and 29 supply side parameters, 94 parameters all together. Some parameters stored as scalars, others stored as vectors.
%
%    Parameter counting (8 + 44 + 13 + 1 + 10 + 2 + 16) = 94:
%
%    * DEMAND: 8 elasticity parameters
%    * DEMAND: 44 demand share cubic trend polynomial coefficients
%    * DEMAND: 13 y/z coefficients for each year
%    * SUPPLY: 1 wage coefficient, psi_1
%    * SUPPLY: 10 gender-, skill-, and occupation-specific intercepts, psi
%    * SUPPLY: 2 gender-specific coefficient for supply variables (from leisure equaiont), pie_1
%    * SUPPLY: 16 gender- and skill-specific coefficients for supply variables, pie_2, pie_3, pie_4, pie_5
%
%    mp_params_aux = BFW_MP_PARAM_ESTI() Default estimated with log wage true.
%
%    mp_params_aux = BFW_MP_PARAM_ESTI(BL_LOG_WAGE, BL_VERBOSE) Get log wage or non-log wage parameters, and verbose print or not.
%
%    See also SNWX_MP_PARAM_ESTI
%

%%
function varargout = bfw_mp_param_aux(varargin)
%% Parse Main Inputs and Set Defaults
if (~isempty(varargin))

    bl_log_wage = true;
    bl_verbose = false;

    if (length(varargin) == 1)
        bl_verbose = varargin{:};
    elseif (length(varargin) > 1)
        error('bfw_mp_param_aux:TooManyOptionalParameters', ...
            'allows at most 1 optional parameters');
    end

else

    bl_log_wage = true;
    bl_verbose = true;

end

%% Key Inputs Initialize
mp_params_aux = containers.Map('KeyType', 'char', 'ValueType', 'any');

%% Scaling Parameters
fl_q_rescalar = 1e6;
fl_p_rescalar = 1e0;

mp_params_aux('fl_q_rescalar') = fl_q_rescalar;
mp_params_aux('fl_p_rescalar') = fl_p_rescalar;

%% Print
if (bl_verbose)
    ff_container_map_display(mp_params_aux, 10, 10);
end

%% Return
if (nargout == 1)
    varargout = cell(nargout, 0);
    varargout{1} = mp_params_aux;
end

end
