%% Equilibrium W to Q to W Contraction By Skill Group
% This is the example vignette for function: bfw_solveequi_w2q2w from the <https://fanwangecon.github.io/PrjLabEquiBFW/ 
% *PrjLabEquiBFW Package*>*.* 
%% Default

[mp_fl_labor_occprbty,mp_fl_labor_supplied] = bfw_solveequi_w2q2w();
%% Vary Parameters, Solve Equilibrium Quantities Wages, W to Q to W Contraction

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
mp_func_demand = bfw_mp_func_demand(bl_verbose_nest);
mp_func_supply = bfw_mp_func_supply(bl_log_wage, bl_verbose_nest);
mp_func_equi = bfw_mp_func_equi(bl_verbose_nest);
mp_func = [mp_func_equi; mp_func_supply; mp_func_demand];

% Get Controls
mp_controls = bfw_mp_control();
mp_controls('bl_bfw_solveequi_w2q2w_display') = false;
mp_controls('bl_bfw_solveequi_w2q2w_display_verbose') = false;

st_exa_common_str = 'bfw_solveequi_w2q2w()';
for it_example_inputs = [1,2,3,4]

    % Different testing scenariors
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
        
        st_exa_string = "homogeneous rho at 0.18, unskilled";

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

        st_exa_string = "homogeneous rho at 0.64, unskilled";

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

        st_exa_string = "homogeneous rho at 0.34, unskilled";

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

        st_exa_string = "heter rho (0.75, 0.24, 0.24), skilled";

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
    [~, ~, ~, ~, ~, ~, ~, ~, ~, ...
        mp_wages, mp_fl_labor_demanded, mp_fl_labor_supplied, ...
        mp_fl_labor_occprbty] = ...
        bfw_solveequi_w2q2w(mp_params, mp_data, mp_func, mp_controls, ...
        it_solve_n1n2n3, it_data_year, bl_skilled, bl_checkminmax);

    disp('');
    disp('');
    disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    disp(['EXAMPLE ' num2str(it_example_inputs) ', ' st_exa_common_str ', ' char(st_exa_string)]);
    disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    ff_container_map_display(mp_wages);
    ff_container_map_display(mp_fl_labor_demanded);
    ff_container_map_display(mp_fl_labor_supplied);
    ff_container_map_display(mp_fl_labor_occprbty);

end
%%