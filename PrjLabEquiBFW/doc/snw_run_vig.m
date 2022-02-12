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

it_vig_group = 1;

if (it_vig_group == 1)
% 2 Parameters
    cl_st_subfolder = {'func'};
elseif (it_vig_group == 2)
% Sections 3, 4, 5, 6
    cl_st_subfolder = {...
        'svalpol', ... % sec3
        'svalpolsmall', ... % sec4
        'svalpolunemploy', ... % sec5
        'svalpolstimulus' ...  % sec6
        };
elseif (it_vig_group == 3)
    cl_st_subfolder = {'sdist'};
elseif (it_vig_group == 4)
    cl_st_subfolder = {'splannercheckval', 'splannerjaeemk', 'splannerjmky'};
elseif (it_vig_group == 5)
    cl_st_subfolder = {'fgov', 'calibrate'};
elseif (it_vig_group == 6)
    % Added on 2021 12 06 comparative statistics
    cl_st_subfolder = {'compstat'};
elseif (it_vig_group == 99)
%     , 'calibrate'
    cl_st_subfolder = {'svalpolsmall'};
end

ff_mlx2htmlpdf_runandexport(...
    st_prj_folder, cl_st_subfolder, ...
    st_mlx_search_name, st_out_folder, st_pub_format, ...
    bl_run_mlx, bl_run_mlx_only, ...
    bl_verbose);
