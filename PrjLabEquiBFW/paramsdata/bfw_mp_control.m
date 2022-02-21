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

    if (length(varargin)==2)
        [bl_display_status, bl_display_verbose_status] = varargin{:};
    elseif (length(varargin)==3)
        [bl_display_status, bl_display_verbose_status, ...
            bl_verbose] = varargin{:};
    elseif (length(varargin) > 3)
        error('bfw_mp_control:TooManyOptionalParameters', ...
            'allows at most 3 optional parameters');
    end


else

    bl_display_status = true;
    bl_display_verbose_status = false;
    bl_verbose = false;

end

%% Control Profiling and Display
bl_timer = true;

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
mp_opti_controls('fmin_controls_b') = optimset('display','off');
mp_opti_controls('fmin_controls_c') = optimset('Display', 'iter',...
    'MaxIter', 500, 'MaxFunEvals', 750, ...
    'TolX', 10^-5, 'TolFun', 10^-5);
mp_opti_controls('fmin_controls_d') = optimset('Display', 'iter',...
    'PlotFcns',...
    {@optimplotfval,@optimplotx,@optimplotstepsize,@optimplotfunccount},...
    'MaxIter', 15, 'MaxFunEvals', 5000,...
    'TolX', 10^-6,'TolFun', 10^-6);;

% Estimation Additional Controls
% PES = Parameter for Estimation Separator
% Used to split map key value: mp_params('arpie_f_u_i1') = [-1];
mp_opti_controls('PES') = '_i';

%% What to Print Out, Store, Etc
mp_profile = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_profile('bl_timer') = bl_timer;

mp_display = containers.Map('KeyType', 'char', 'ValueType', 'any');

% Equilibrium Solutions
mp_display('bl_bfw_solveequi_kwfw_display') = bl_display_status;
mp_display('bl_bfw_solveequi_kwfw_display_verbose') = bl_display_verbose_status;
mp_display('bl_bfw_solveequi_w2q2w_display') = bl_display_status;
mp_display('bl_bfw_solveequi_w2q2w_display_verbose') = bl_display_verbose_status;

%% Combine Maps
mp_controls = [mp_solu_controls; mp_opti_controls; mp_profile; mp_display];

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
