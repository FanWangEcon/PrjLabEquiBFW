%% File Paths
mp_path = bfw_mp_path('fan');
st_prj_folder = mp_path('spt_codem_doc');

st_mlx_search_name = '*.mlx';
% st_mlx_search_name = 'snwx_comp_beta_low_vs_high.mlx';

st_pub_format = 'html';
bl_run_mlx = true;
bl_run_mlx_only = false;
bl_verbose = true;

%% Run Vignettes
% cl_st_subfolder = {'calibrate', 'params', 'sdist', 'splannercheckval', ...
%     'splannerjaeemk', 'splannerjmky', 'svalpol', 'svalpolsmall', 'svalpolunemploy'};
st_out_folder = mp_path('spt_simu_outputs_vig');

it_vig_group = 99;
cl_st_subfolder_a = {'func', 'params', 'data'};
cl_st_subfolder_b = {'solvedemand', 'solvesupply'};
cl_st_subfolder_c = {'solveequiskl'};
if (it_vig_group == 1)
% 2 Parameters
    cl_st_subfolder = cl_st_subfolder_a;
elseif (it_vig_group == 2)
    cl_st_subfolder = cl_st_subfolder_b;
elseif (it_vig_group == 3)
    cl_st_subfolder = cl_st_subfolder_c;
elseif (it_vig_group == 99)
    cl_st_subfolder = [cl_st_subfolder_a, cl_st_subfolder_b, cl_st_subfolder_c];
end

ff_mlx2htmlpdf_runandexport(...
    st_prj_folder, cl_st_subfolder, ...
    st_mlx_search_name, st_out_folder, st_pub_format, ...
    bl_run_mlx, bl_run_mlx_only, ...
    bl_verbose);
