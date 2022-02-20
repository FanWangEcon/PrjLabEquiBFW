%% BFW_MP_PARAM_ESTI Map Container of Estimated Demand and Supply Parameters
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
%    Note that the parameter count would be 87 if the y/z coefficients have 4 parameters, 94-(13-4)=85, and then we add in for supply 12 rather than 10 gender-, skill-, and occupation-specific intercepts (but 2 of them are not identified because of the 2 gender-specific coefficients for supply variables), 94-(13-4)+(12-10)=87. Under this accounting, there would be 31 supply side parameters, and 56 demand side parameters. 
%
%    MP_PARAMS = BFW_MP_PARAM_ESTI() Default estimated with log wage true.
%
%    MP_PARAMS = BFW_MP_PARAM_ESTI(BL_LOG_WAGE, BL_VERBOSE) Get log wage or non-log wage parameters, and verbose print or not.
%
%    See also SNWX_MP_PARAM_ESTI
%

%%
function varargout = bfw_mp_param_esti(varargin)
%% Parse Main Inputs and Set Defaults
if (~isempty(varargin))

    bl_log_wage = true;
    bl_verbose = false;

    if (length(varargin) == 1)
        bl_log_wage = varargin{:};
    elseif (length(varargin) == 2)
        [bl_log_wage, bl_verbose] = varargin{:};
    elseif (length(varargin) > 2)
        error('bfw_mp_param_esti:TooManyOptionalParameters', ...
            'allows at most 1 optional parameters');
    end

else

    bl_log_wage = true;
    bl_verbose = true;

end

%% Key Inputs Initialize
mp_params = containers.Map('KeyType', 'char', 'ValueType', 'any');

%% A. Demand: Elasticity parameters (8)
fl_rho_gen_manual = 0.083519175;
fl_rho_gen_routine = 0.21768748;
fl_rho_gen_abstract = 0.659790692;
fl_rho_skill_manual = 0.73852019;
fl_rho_skill_routine = 0.300517472;
fl_rho_skill_abstract = 0.302314691;
fl_rho_abstract_vs_manualroutine = 0.031410541;
fl_rho_routine_vs_manual = -0.154375145;

mp_params('fl_rho_gen_manual') = fl_rho_gen_manual;
mp_params('fl_rho_gen_routine') = fl_rho_gen_routine;
mp_params('fl_rho_gen_abstract') = fl_rho_gen_abstract;
mp_params('fl_rho_skill_manual') = fl_rho_skill_manual;
mp_params('fl_rho_skill_routine') = fl_rho_skill_routine;
mp_params('fl_rho_skill_abstract') = fl_rho_skill_abstract;
mp_params('fl_rho_routine_vs_manual') = fl_rho_routine_vs_manual;
mp_params('fl_rho_abstract_vs_manualroutine') = fl_rho_abstract_vs_manualroutine;

mp_rho_nests_init = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_rho_nests_init('nest1112') = fl_rho_gen_manual;
mp_rho_nests_init('nest2122') = fl_rho_gen_routine;
mp_rho_nests_init('nest3132') = fl_rho_gen_abstract;
mp_rho_nests_init('nest10') = fl_rho_skill_manual;
mp_rho_nests_init('nest20') = fl_rho_skill_routine;
mp_rho_nests_init('nest30') = fl_rho_skill_abstract;
mp_rho_nests_init('nest2') = fl_rho_routine_vs_manual;
mp_rho_nests_init('nest1') = fl_rho_abstract_vs_manualroutine;

mp_rho_nests = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_rho_nests('nest11') = fl_rho_gen_manual;
mp_rho_nests('nest12') = fl_rho_gen_manual;
mp_rho_nests('nest21') = fl_rho_gen_routine;
mp_rho_nests('nest22') = fl_rho_gen_routine;
mp_rho_nests('nest31') = fl_rho_gen_abstract;
mp_rho_nests('nest32') = fl_rho_gen_abstract;
mp_rho_nests('nest10') = fl_rho_skill_manual;
mp_rho_nests('nest20') = fl_rho_skill_routine;
mp_rho_nests('nest30') = fl_rho_skill_abstract;
mp_rho_nests('nest2')  = fl_rho_routine_vs_manual;
mp_rho_nests('nest1')  = fl_rho_abstract_vs_manualroutine;

% Store map in map
mp_params('mp_rho_nests_init') = mp_rho_nests_init;
mp_params('mp_rho_nests') = mp_rho_nests;

%% B. Demand share parameters: a/alpha demand trends polynomial coefficients (11x4=44)
mp_params('ar_alpha_B001') = [7.11493E-05,-0.003177053,0.046410826,-1.333733427];
mp_params('ar_alpha_B002') = [7.7753E-05,-0.003223536,0.036754938,-1.135939409];
mp_params('ar_alpha_B003') = [4.30281E-05,-0.001888805,0.024990065,-0.873515216];
mp_params('ar_alpha_B101') = [-1.76751E-05,-0.001110641,0.104516778,-2.851973805];
mp_params('ar_alpha_B102') = [-0.000100963,0.004670866,-0.030629155,-1.338151975];
mp_params('ar_alpha_B103') = [-7.53691E-05,0.002346009,-0.00154869,-1.146380994];
mp_params('ar_alpha_A001') = [0.000133957,-0.005618715,0.06856678,-1.010068133];
mp_params('ar_alpha_A002') = [0.00017171,-0.00792741,0.115435368,-1.556531554];
mp_params('ar_alpha_A003') = [6.93624E-05,-0.003118057,0.043010364,-0.61099673];
mp_params('ar_alpha_AA01') = [3.36706E-05,-0.001977989,0.036610404,-0.714176995];
mp_params('ar_alpha_AA02') = [9.81273E-06,-0.000295015,0.00157302,-0.673087072];

%% C. Demand Y/Z ratios (13)
mp_params('fl_yzagg_y1989') = 1.490482879;
mp_params('fl_yzagg_y1992') = 1.460175375;
mp_params('fl_yzagg_y1994') = 1.649318884;
mp_params('fl_yzagg_y1996') = 1.768648233;
mp_params('fl_yzagg_y1998') = 1.801781344;
mp_params('fl_yzagg_y2000') = 2.059868536;
mp_params('fl_yzagg_y2002') = 2.059739224;
mp_params('fl_yzagg_y2004') = 2.28028296;
mp_params('fl_yzagg_y2005') = 2.33920036;
mp_params('fl_yzagg_y2008') = 2.490793369;
mp_params('fl_yzagg_y2010') = 2.715348477;
mp_params('fl_yzagg_y2012') = 2.822009753;
mp_params('fl_yzagg_y2014') = 2.870725101;

%% D. Parameters for Supply Side from 2018 paper
if ~bl_log_wage
    % Parameter Count = 1 + (3x4) + (4x4) = 1 + 12 + 16 = 29

    psi1 = 0.154;
    arpsi0_f_u = [0.036, -0.437, -0.555];
    arpsi0_f_s = [-0.756, -0.362, 0.508];
    arpsi0_k_u = [0.541, 0.296, -0.682];
    arpsi0_k_s = [-0.347, -0.347, 0.581];

    arpie_f_u = [0.961, -0.059, 0.712, 0.589, 0, 0];
    arpie_f_s = [0.961, -0.059, -0.139, 0.267, 0, 0];
    arpie_k_u = [-0.716, 0.054, -0.367, -0.524, 0, 0];
    arpie_k_s = [-0.716, 0.054, 0.122, 0.026, 0, 0];

else
    %  Parameter Count = 1 + (3x4-2) + (5x4-2) = 1 + 10 + 18 = 29

    psi1 = 0.966251368;

    arpsi0_f_u = [7.369697765,6.542162323,6.308089203];
    arpsi0_f_s = [0,1.159249173,2.193599999];
    arpsi0_k_u = [6.693466049,6.244315658,5.06492335];
    arpsi0_k_s = [0,0.42957658,1.349405344];

    arpie_f_u = [11.14461368,0,-0.256615837,-0.265194082,-2.074877543,-0.513504456];
    arpie_f_s = [11.14461368,0, 2.73507411 , 0.267461243,-8.348450335,-1.150844491];
    arpie_k_u = [2.445704986,0,-2.280896443, 3.016929363, 0.845131725, 0.711842504];
    arpie_k_s = [2.445704986,0,-0.043895883, 0.915660736,-3.03107843,  1.102295333];

end

mp_params('bl_log_wage') = bl_log_wage;
mp_params('psi1') = psi1;
mp_params('arpsi0_f_u') = arpsi0_f_u;
mp_params('arpsi0_f_s') = arpsi0_f_s;
mp_params('arpsi0_k_u') = arpsi0_k_u;
mp_params('arpsi0_k_s') = arpsi0_k_s;
mp_params('arpie_f_u') = arpie_f_u;
mp_params('arpie_f_s') = arpie_f_s;
mp_params('arpie_k_u') = arpie_k_u;
mp_params('arpie_k_s') = arpie_k_s;


%% Print
if (bl_verbose)
    ff_container_map_display(mp_params, 10, 10);
end

%% Return
if (nargout == 1)
    varargout = cell(nargout, 0);
    varargout{1} = mp_params;
end

end
