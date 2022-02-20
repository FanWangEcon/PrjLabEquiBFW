%% BFW_MP_CONTROL Organizes and Sets Various Solution Simu Control Parameters
%    BFW_MP_CONTROL opitmizer control, graph, print, and other controls
%
%    MP_CONTROLS = BFW_MP_CONTROL() get default parameters all in the
%    same container map
%
%    MP_CONTROLS = BFW_MP_CONTROL(ST_PARAM_GROUP)
%    generates default parameters for the type ST_PARAM_GROUP.
%
%    MP_CONTROLS = BFW_MP_CONTROL(ST_PARAM_GROUP, bl_print_mp_controls) generates
%    default parameters for the type ST_PARAM_GROUP, display parameter map
%    details if bl_print_mp_controls is true.
%
%    See also SNWX_MP_CONTROLS
%

%%
function varargout = bfw_mp_control(varargin)
%% Parse Main Inputs and Set Defaults
if (~isempty(varargin))

    bl_display_status = true;
    bl_display_verbose_status = false;
    bl_verbose = false;

    if (length(varargin)==1)
        st_param_group = varargin{:};
    elseif (length(varargin)==3)
        [st_param_group, bl_display_status, bl_display_verbose_status] = varargin{:};
    elseif (length(varargin)==4)
        [st_param_group, ...
        bl_display_status, bl_display_verbose_status, ...
        bl_verbose] = varargin{:};
    end

else

    st_param_group = 'default_base';
    st_param_group = 'default_test';

    bl_display_status = true;
    bl_display_verbose_status = false;

    bl_verbose = false;
end

%% Control Profiling and Display
bl_timer = true;

%% Controls display print
bl_twoinputs_dsgivenwage_display = bl_display_status;
bl_twoinputs_solveequi_grid_display = bl_display_status;
bl_twoinputs_solveequi_iter_display = bl_display_status;
bl_twoinputs_equi_elasprod_display = bl_display_status;
bl_twoinputs_solveelasprod_display = bl_display_status;
bl_twoinputs_solveelasprodz_display = bl_display_status;
bl_twoinputs_prod_root_display = bl_display_status;

bl_qpdata_solve_interp_display = bl_display_status;
bl_qpdata_esti_fit_by_rho_display = bl_display_status;
bl_qpdata_esti_fit_by_rho_msr_err_display = bl_display_status;
bl_qpdata_esti_fit_by_rho_msr_err_lvl_display = bl_display_status;
bl_qpdata_esti_fit_by_rho_msr_err_multi_display = bl_display_status;
bl_qpdata_esti_fit_by_rho_msr_err_lvl_multi_display = bl_display_status;

bl_qpdata_esti_invoke_display = bl_display_status;
bl_qpdata_esti_invoke_mlvl_display = bl_display_status;
bl_qpdata_esti_invoke_mlvl_iter_display = bl_display_status;

bl_qpdata_esti_monte_carlo_display = bl_display_status;

bl_twoinputs_solveelasprod_foc_display = bl_display_status;
bl_minputs_solveequi_iter_display = bl_display_status;

bl_gen_poly_coef_display = bl_display_status;
bl_simu_onetier_display = bl_display_status;

%% Control display verbose print
bl_twoinputs_dsgivenwage_display_verbose = bl_display_verbose_status;;
bl_twoinputs_solveequi_grid_display_verbose = bl_display_verbose_status;;
bl_twoinputs_solveequi_iter_display_verbose = bl_display_verbose_status;;
bl_twoinputs_equi_elasprod_display_verbose =  true;
bl_twoinputs_solveelasprod_display_verbose = bl_display_verbose_status;;
bl_twoinputs_solveelasprodz_display_verbose = bl_display_verbose_status;;
bl_twoinputs_prod_root_display_verbose = bl_display_verbose_status;;

bl_qpdata_solve_interp_display_verbose = bl_display_verbose_status;;
bl_qpdata_esti_fit_by_rho_display_verbose = bl_display_verbose_status;;
bl_qpdata_esti_fit_by_rho_msr_err_display_verbose = bl_display_verbose_status;;
bl_qpdata_esti_fit_by_rho_msr_err_lvl_display_verbose = bl_display_verbose_status;;
bl_qpdata_esti_fit_by_rho_msr_err_multi_display_verbose = bl_display_verbose_status;;
bl_qpdata_esti_fit_by_rho_msr_err_lvl_multi_display_verbose = bl_display_verbose_status;;

bl_qpdata_esti_invoke_display_verbose = bl_display_verbose_status;;
bl_qpdata_esti_invoke_mlvl_display_verbose = bl_display_verbose_status;;
bl_qpdata_esti_invoke_mlvl_iter_display_verbose = bl_display_verbose_status;;

bl_qpdata_esti_monte_carlo_display_verbose = bl_display_verbose_status;;

bl_twoinputs_solveelasprod_foc_display_verbose = bl_display_verbose_status;;
bl_minputs_solveequi_iter_display_verbose = bl_display_verbose_status;;

bl_gen_poly_coef_display_verbose = bl_display_verbose_status;
bl_simu_onetier_display_verbose = bl_display_verbose_status;

%% Solution control
mp_solu_controls = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_solu_controls('srdp_method') = 'NESTFAST'; % Possible values are CESSOLU and NEST and NESTFAST
mp_solu_controls('srdp_equi_method') = 'SRDP'; % Possible values are SRDP and BISECT


%% Optimizer controls
mp_opti_controls = containers.Map('KeyType', 'char', 'ValueType', 'any');
% Default options
% Do not change FMIN_CONTROLS_A, which is for demand only estimation
options = optimset('Display', 'off', 'MaxIter', 2000, 'MaxFunEvals', 2500, 'TolX', 10^-5, 'TolFun', 10^-5);
mp_opti_controls('fmin_controls_a') = options;
options = optimset('Display', 'iter', 'MaxIter', 2000, 'MaxFunEvals', 3000, 'TolX', 10^-5, 'TolFun', 10^-5);
mp_opti_controls('fmin_controls_a1') = options;
options = optimset('Display', 'iter', 'MaxIter', 4000, 'MaxFunEvals', 6000, 'TolX', 10^-5, 'TolFun', 10^-5);
mp_opti_controls('fmin_controls_a2') = options;
options = optimset('Display', 'iter', 'MaxIter', 6000, 'MaxFunEvals', 9000, 'TolX', 10^-5, 'TolFun', 10^-5);
mp_opti_controls('fmin_controls_a3') = options;
options = optimset('Display', 'iter', 'MaxIter', 8000, 'MaxFunEvals', 12000, 'TolX', 10^-5, 'TolFun', 10^-5);
mp_opti_controls('fmin_controls_a4') = options;

mp_opti_controls('fmin_controls_b') = optimset('display','off');
% Alternatives
options = optimset('Display', 'iter',...
                   'PlotFcns',...
                     {@optimplotfval,@optimplotx,@optimplotstepsize,@optimplotfunccount},...
                   'MaxIter', 100, ...
                   'TolX', 10^-5,'TolFun', 10^-5);
mp_opti_controls('fmin_controls_c') = options;
% Fminunc main, preliminary
options = optimset('Display', 'iter',...
                   'MaxIter', 250, 'MaxFunEvals', 625, ...
                   'TolX', 10^-5, 'TolFun', 10^-5);
mp_opti_controls('fmin_controls_c1') = options;
% fminunc more intense
options = optimset('Display', 'iter',...
                   'MaxIter', 500, 'MaxFunEvals', 750, ...
                   'TolX', 10^-5, 'TolFun', 10^-5);
mp_opti_controls('fmin_controls_c2') = options;
options = optimset('Display', 'iter',...
                   'MaxIter', 750, 'MaxFunEvals', 1250, ...
                   'TolX', 10^-5, 'TolFun', 10^-5);
mp_opti_controls('fmin_controls_c3') = options;
options = optimset('Display', 'iter',...
                   'MaxIter', 1875, 'MaxFunEvals', 2500, ...
                   'TolX', 10^-5, 'TolFun', 10^-5);
mp_opti_controls('fmin_controls_c4') = options;

% Quickest test
options = optimset('Display', 'off',...
                   'MaxIter', 3, 'MaxFunEvals', 15,...
                   'TolX', 10^-2,'TolFun', 10^-2);
mp_opti_controls('fmin_controls_d') = options;
options = optimset('Display', 'off',...
                   'MaxIter', 1, 'MaxFunEvals', 1,...
                   'TolX', 10^-2,'TolFun', 10^-2);
mp_opti_controls('fmin_controls_e') = options;
% Quick test with visual
options = optimset('Display', 'iter',...
                   'PlotFcns',...
                      {@optimplotfval,@optimplotx,@optimplotstepsize,@optimplotfunccount},...
                   'MaxIter', 15, 'MaxFunEvals', 5000,...
                   'TolX', 10^-6,'TolFun', 10^-6);
mp_opti_controls('fmin_controls_f') = options;

% Estimation Additional Controls
% PES = Parameter for Estimation Separator
% Used to split map key value: mp_params('arpie_f_u_i1') = [-1];
mp_opti_controls('PES') = '_i';


%% What to Print Out, Store, Etc
mp_profile = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_profile('bl_timer') = bl_timer;

mp_display = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_display('bl_twoinputs_dsgivenwage_display') = bl_twoinputs_dsgivenwage_display;
mp_display('bl_twoinputs_dsgivenwage_display_verbose') = bl_twoinputs_dsgivenwage_display_verbose;
mp_display('bl_twoinputs_solveequi_grid_display') = bl_twoinputs_solveequi_grid_display;
mp_display('bl_twoinputs_solveequi_grid_display_verbose') = bl_twoinputs_solveequi_grid_display_verbose;
mp_display('bl_twoinputs_solveequi_iter_display') = bl_twoinputs_solveequi_iter_display;
mp_display('bl_twoinputs_solveequi_iter_display_verbose') = bl_twoinputs_solveequi_iter_display_verbose;
mp_display('bl_minputs_solveequi_iter_display') = bl_minputs_solveequi_iter_display;
mp_display('bl_minputs_solveequi_iter_display_verbose') = bl_minputs_solveequi_iter_display_verbose;

mp_display('bl_twoinputs_equi_elasprod_display') = bl_twoinputs_equi_elasprod_display;
mp_display('bl_twoinputs_equi_elasprod_display_verbose') = bl_twoinputs_equi_elasprod_display_verbose;

mp_display('bl_twoinputs_solveelasprod_foc_display') = bl_twoinputs_solveelasprod_foc_display;
mp_display('bl_twoinputs_solveelasprod_foc_display_verbose') = bl_twoinputs_solveelasprod_foc_display_verbose;
mp_display('bl_twoinputs_solveelasprod_display') = bl_twoinputs_solveelasprod_display;
mp_display('bl_twoinputs_solveelasprod_display_verbose') = bl_twoinputs_solveelasprod_display_verbose;
mp_display('bl_twoinputs_solveelasprodz_display') = bl_twoinputs_solveelasprodz_display;
mp_display('bl_twoinputs_solveelasprodz_display_verbose') = bl_twoinputs_solveelasprodz_display_verbose;

mp_display('bl_twoinputs_prod_root_display') = bl_twoinputs_prod_root_display;
mp_display('bl_twoinputs_prod_root_display_verbose') = bl_twoinputs_prod_root_display_verbose;

mp_display('bl_qpdata_solve_interp_display') = bl_qpdata_solve_interp_display;
mp_display('bl_qpdata_solve_interp_display_verbose') = bl_qpdata_solve_interp_display_verbose;

mp_display('bl_qpdata_esti_fit_by_rho_display') = bl_qpdata_esti_fit_by_rho_display;
mp_display('bl_qpdata_esti_fit_by_rho_display_verbose') = bl_qpdata_esti_fit_by_rho_display_verbose;
mp_display('bl_qpdata_esti_fit_by_rho_msr_err_display') = bl_qpdata_esti_fit_by_rho_msr_err_display;
mp_display('bl_qpdata_esti_fit_by_rho_msr_err_display_verbose') = bl_qpdata_esti_fit_by_rho_msr_err_display_verbose;
mp_display('bl_qpdata_esti_fit_by_rho_msr_err_lvl_display') = bl_qpdata_esti_fit_by_rho_msr_err_display;
mp_display('bl_qpdata_esti_fit_by_rho_msr_err_lvl_display_verbose') = bl_qpdata_esti_fit_by_rho_msr_err_display_verbose;

mp_display('bl_qpdata_esti_fit_by_rho_msr_err_multi_display') = bl_qpdata_esti_fit_by_rho_msr_err_multi_display;
mp_display('bl_qpdata_esti_fit_by_rho_msr_err_multi_display_verbose') = bl_qpdata_esti_fit_by_rho_msr_err_multi_display_verbose;
mp_display('bl_qpdata_esti_fit_by_rho_msr_err_lvl_multi_display') = bl_qpdata_esti_fit_by_rho_msr_err_lvl_multi_display;
mp_display('bl_qpdata_esti_fit_by_rho_msr_err_lvl_multi_display_verbose') = bl_qpdata_esti_fit_by_rho_msr_err_lvl_multi_display_verbose;

mp_display('bl_qpdata_esti_invoke_display') = bl_qpdata_esti_invoke_display;
mp_display('bl_qpdata_esti_invoke_display_verbose') = bl_qpdata_esti_invoke_display_verbose;
mp_display('bl_qpdata_esti_invoke_mlvl_display') = bl_qpdata_esti_invoke_mlvl_display;
mp_display('bl_qpdata_esti_invoke_mlvl_display_verbose') = bl_qpdata_esti_invoke_mlvl_display_verbose;
mp_display('bl_qpdata_esti_invoke_mlvl_iter_display') = bl_qpdata_esti_invoke_mlvl_iter_display;
mp_display('bl_qpdata_esti_invoke_mlvl_iter_display_verbose') = bl_qpdata_esti_invoke_mlvl_iter_display_verbose;

mp_display('bl_qpdata_esti_monte_carlo_display') = bl_qpdata_esti_monte_carlo_display;
mp_display('bl_qpdata_esti_monte_carlo_display_verbose') = bl_qpdata_esti_monte_carlo_display_verbose;

mp_display('bl_simu_onetier_display') = bl_simu_onetier_display;
mp_display('bl_simu_onetier_display_verbose') = bl_simu_onetier_display_verbose;
mp_display('bl_gen_poly_coef_display') = bl_gen_poly_coef_display;
mp_display('bl_gen_poly_coef_display_verbose') = bl_gen_poly_coef_display_verbose;

%% Directory store just parameter in map, changed strategy on 6/30/2021
mp_display('bfw_minputs_qpesti_solveequi_display') = bl_display_status;
mp_display('bfw_minputs_qpesti_solveequi_display_verbose') = bl_display_verbose_status;
mp_display('bfw_minputs_qpesti_solveequi_mlvl_display') = bl_display_status;
mp_display('bfw_minputs_qpesti_solveequi_mlvl_display_verbose') = bl_display_verbose_status;
mp_display('bfw_minputs_qpesti_solveequi_mlvl_wrapper_display') = bl_display_status;
mp_display('bfw_minputs_qpesti_solveequi_mlvl_wrapper_display_verbose') = bl_display_verbose_status;
mp_display('bfw_minputs_qpesti_solveequi_mlvl_wrapper_call_display') = bl_display_status;
mp_display('bfw_minputs_qpesti_solveequi_mlvl_wrapper_call_display_verbose') = bl_display_verbose_status;

%% CES full direct solution related
mp_display('bfw_mp_param_ces_input_display') = bl_display_status;
mp_display('bfw_mp_param_ces_input_display_verbose') = bl_display_verbose_status;

mp_display('bl_minputs_solveequi_iter_nest_display') = bl_display_status;
mp_display('bl_minputs_solveequi_iter_nest_display_verbose') = bl_display_verbose_status;

%% Supply problem
mp_display('bl_supply_levels_bf18_display') = bl_display_status;
mp_display('bl_supply_levels_bf18_display_verbose') = bl_display_verbose_status;
mp_display('bfw_simu_q_supply_display') = bl_display_status;
mp_display('bfw_simu_q_supply_display_verbose') = bl_display_verbose_status;

% simulation files
mp_display('bfw_simu_stats_display') = bl_display_status;
mp_display('bfw_simu_stats_display_verbose') = bl_display_verbose_status;

%% Combine Maps
mp_controls = [mp_solu_controls; mp_opti_controls; mp_profile; mp_display];
mp_controls('mp_params_name') = string(st_param_group);

%% Print
if (bl_verbose)
    ff_container_map_display(mp_controls);
end

%% Return
varargout = cell(nargout,0);
for it_k = 1:nargout
    if (it_k==1)
        ob_out_cur = mp_controls;
    elseif (it_k==2)
        ob_out_cur = mp_opti_controls;
    elseif (it_k==3)
        ob_out_cur = mp_profile;
    elseif (it_k==4)
        ob_out_cur = mp_display;
    end
    varargout{it_k} = ob_out_cur;
end


end
