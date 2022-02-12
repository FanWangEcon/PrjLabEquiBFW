%% SNW_MP_PATH Controls and Keeps Track of Paths
%    SNW_MP_PATH controls and keeps track of paths. Keeps track of external
%    path for storing larger data and simulation files.
%
%    ST_COMPUTER, whose computer this is on: 'fan'
%
%    mp_paths = snw_mp_path('fan');
%    spt_simu_codem = mp_paths('spt_simu_codem');
%    spt_simu_outputs = mp_paths('spt_simu_outputs');
%    spt_simu_outputs_log = mp_paths('spt_simu_outputs_log');
%    spt_simu_results_csv = mp_paths('spt_simu_results_csv');
%

%%
function varargout = bfw_mp_path(varargin)
%% Parse Main Inputs and Set Defaults
if (~isempty(varargin))

    bl_print_mp_path = false;
    if (length(varargin)==1)
        st_computer = varargin{:};
        bl_print_mp_path = false;
    elseif (length(varargin)==2)
        [st_computer, mp_folder_suffix_ext] = varargin{:};
    elseif (length(varargin)==3)
        [st_computer, mp_folder_suffix_ext, bl_print_mp_path] = varargin{:};
    end

else

    st_computer = 'fan';
    bl_print_mp_path = true;

end

%% Dropbox Root Auto Detect by Computer
if (strcmp(st_computer, 'fan'))

     if (exist('G:/repos', 'dir')>0)
         spt_repo_root = fullfile('G:/repos/PrjLabEquiBFW/');
     elseif (exist('C:/Users/fan/PrjLabEquiBFW', 'dir')>0)
         spt_repo_root = fullfile('C:/Users/fan/PrjLabEquiBFW/');
     end

     if (exist('D:/Dropbox (UH-ECON)/', 'dir')>0)
         spt_dropbox_root = fullfile('D:/Dropbox (UH-ECON)/Latex_BhalotraFernandez/');
     elseif (exist('C:/Users/fan/Documents/Dropbox (UH-ECON)/', 'dir')>0)
         spt_dropbox_root = fullfile('C:/Users/fan/Documents/Dropbox (UH-ECON)/Latex_BhalotraFernandez/');
     end

end

%% Suffixes

mp_folder_suffix = containers.Map('KeyType', 'char', 'ValueType', 'any');
% mp_folder_suffix('spt_simu_estilog_log') = datestr(now, 'yymmdd');
mp_folder_suffix('spt_simu_estilog_log') = 'test';
if exist('mp_folder_suffix_ext', 'var')
    mp_folder_suffix = [mp_folder_suffix; mp_folder_suffix_ext];
end

%% Parametesr Grid Points
% store output mat files, this is to save speed during check calculation,
% re-calculation
spt_codem = fullfile(spt_repo_root, 'PrjLabEquiBFW', filesep);
spt_simu_outputs = fullfile(spt_dropbox_root, 'PrjLabEquiBFWOutput', filesep);

spt_codem_doc = fullfile(spt_codem, 'doc', filesep);
spt_codem_data = fullfile(spt_codem, '_data', filesep);
spt_codem_esti = fullfile(spt_codem, '_esti', filesep);
spt_codem_estilog = fullfile(spt_simu_outputs, '_estilog', filesep);
spt_codem_profile = fullfile(spt_codem, '_profile', filesep);

spt_simu_outputs_vig = fullfile(spt_simu_outputs, 'vig', '02-11-2021', filesep);
spt_simu_outputs_log = fullfile(spt_simu_outputs, 'log', filesep);
spt_simu_outputs_mat = fullfile(spt_simu_outputs, 'mat', filesep);

% spt_simu_results_csv = fullfile(spt_simu_outputs, 'results_202104', filesep);
spt_simu_results_csv = fullfile(spt_codem_esti, 'results_202106', filesep);

spt_simu_estilog_log = fullfile(spt_codem_estilog, ...
    ['results_' char(mp_folder_suffix('spt_simu_estilog_log'))], filesep);
spt_simu_profile_html = fullfile(spt_codem_profile, 'results_202106', filesep);
spt_simu_results_nest_csv = fullfile(spt_simu_results_csv, 'nestesti', filesep);
spt_simu_results_csv_img = fullfile(spt_simu_results_csv, 'img', filesep);

% create directories
% if ~exist(spt_simu_results_csv, 'dir')
%     mkdir(spt_simu_results_csv);
% end
% if ~exist(spt_simu_estilog_log, 'dir')
%     mkdir(spt_simu_estilog_log);
% end
% if ~exist(spt_simu_profile_html, 'dir')
%     mkdir(spt_simu_profile_html);
% end
% if ~exist(spt_simu_results_nest_csv, 'dir')
%     mkdir(spt_simu_results_nest_csv);
% end

%% Set Parameter Maps
mp_path_external = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_path_external('spt_repo_root') = spt_repo_root;
mp_path_external('spt_dropbox_root') = spt_dropbox_root;

mp_path_external('spt_codem') = spt_codem;
mp_path_external('spt_codem_doc') = spt_codem_doc;
mp_path_external('spt_codem_data') = spt_codem_data;
mp_path_external('spt_codem_esti') = spt_codem_esti;
mp_path_external('spt_codem_estilog') = spt_codem_estilog;

mp_path_external('spt_simu_outputs') = spt_simu_outputs;
mp_path_external('spt_simu_outputs_vig') = spt_simu_outputs_vig;
mp_path_external('spt_simu_outputs_log') = spt_simu_outputs_log;
mp_path_external('spt_simu_outputs_mat') = spt_simu_outputs_mat;
mp_path_external('spt_simu_estilog_log') = spt_simu_estilog_log;
mp_path_external('spt_simu_profile_html') = spt_simu_profile_html;

mp_path_external('spt_simu_results_csv') = spt_simu_results_csv;
mp_path_external('spt_simu_results_nest_csv') = spt_simu_results_nest_csv;
mp_path_external('spt_simu_results_csv_img') = spt_simu_results_csv_img;

%% Combine Maps
mp_path = [mp_path_external];
mp_path('st_computer') = string(st_computer);

% MP_PARAMS = [MP_PARAMS_PREFTECHPRICE; MP_PARAMS_STATESGRID ; ...
%     MP_PARAMS_EXOTRANS; MP_PARAMS_TYPELIFE; MP_PARAMS_INTLEN];

%% Print
if (bl_print_mp_path)
    ff_container_map_display(mp_path_external);
end

%% Return
if (nargout==1)
    varargout = cell(nargout,0);
    varargout{1} = mp_path;
elseif (nargout==2)
    varargout = cell(nargout,0);
    varargout{1} = mp_path;
    varargout{2} = mp_path_external;
end

end
