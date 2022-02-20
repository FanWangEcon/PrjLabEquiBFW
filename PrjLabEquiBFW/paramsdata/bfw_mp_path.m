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

% Upon installation, should go to the line segment for "fan" below and change to user own path, so that default no parameter call to the function uses the right paths.
st_computer_default = 'fan';

if (~isempty(varargin))

    bl_verbose = false;
    if (length(varargin)==1)
        st_computer = st_computer_default;
        bl_verbose = varargin{:};
    elseif (length(varargin)==2)
        [spt_repo_root, spt_output_root] = varargin{:};
    elseif (length(varargin)==3)
        [spt_repo_root, spt_output_root, bl_verbose] = varargin{:};
    elseif (length(varargin)> 3)
        error('bfw_mp_path:TooManyOptionalParameters', ...
              'allows at most 3 optional parameters');
    end

else

    % Defaults if nothing is specified
    st_computer = st_computer_default;
    bl_verbose = false;   
end

%% Dropbox Root Auto Detect by Computer
if exist('st_computer', 'var')

    % only path for fan specified
    if (strcmp(st_computer, 'fan'))

         if (exist('G:/repos', 'dir')>0)
             spt_repo_root = fullfile('G:/repos/PrjLabEquiBFW/');
         elseif (exist('C:/Users/fan/PrjLabEquiBFW', 'dir')>0)
             spt_repo_root = fullfile('C:/Users/fan/PrjLabEquiBFW/');
         end

         if (exist('D:/Dropbox (UH-ECON)/', 'dir')>0)
             spt_output_root = fullfile('D:/Dropbox (UH-ECON)/Latex_BhalotraFernandez/');
         elseif (exist('C:/Users/fan/Documents/Dropbox (UH-ECON)/', 'dir')>0)
             spt_output_root = fullfile('C:/Users/fan/Documents/Dropbox (UH-ECON)/Latex_BhalotraFernandez/');
         end
     end

else
    % If ST_COMPUTER not specified, must specify output and repo roots
    % st_output_root
    % st_repo_root
end

%% Parametesr Grid Points
% store output mat files, this is to save speed during check calculation,
% re-calculation
spt_codem = fullfile(spt_repo_root, 'PrjLabEquiBFW', filesep);
spt_simu_outputs = fullfile(spt_output_root, 'PrjLabEquiBFWOutput', filesep);

spt_codem_doc = fullfile(spt_codem, 'doc', filesep);
spt_codem_data = fullfile(spt_codem, '_data', filesep);

spt_simu_outputs_prf = fullfile(spt_simu_outputs, 'prof', filesep);
spt_simu_outputs_vig = fullfile(spt_simu_outputs, 'vig', filesep);
spt_simu_results_img = fullfile(spt_simu_outputs, 'img', filesep);
spt_simu_outputs_log = fullfile(spt_simu_outputs, 'log', filesep);
spt_simu_outputs_mat = fullfile(spt_simu_outputs, 'mat', filesep);
spt_simu_results_csv = fullfile(spt_simu_outputs, 'res', filesep);

% Create directories if does not exist
if ~exist(spt_simu_outputs_prf, 'dir')
    mkdir(spt_simu_outputs_prf);
end
if ~exist(spt_simu_outputs_vig, 'dir')
    mkdir(spt_simu_outputs_vig);
end
if ~exist(spt_simu_results_img, 'dir')
    mkdir(spt_simu_results_img);
end
if ~exist(spt_simu_outputs_log, 'dir')
    mkdir(spt_simu_outputs_log);
end
if ~exist(spt_simu_outputs_mat, 'dir')
    mkdir(spt_simu_outputs_mat);
end
if ~exist(spt_simu_results_csv, 'dir')
    mkdir(spt_simu_results_csv);
end

%% Set Parameter Maps
mp_path_external = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp_path_external('spt_repo_root') = spt_repo_root;
mp_path_external('spt_output_root') = spt_output_root;

mp_path_external('spt_codem') = spt_codem;
mp_path_external('spt_codem_doc') = spt_codem_doc;
mp_path_external('spt_codem_data') = spt_codem_data;

mp_path_external('spt_simu_outputs_prf') = spt_simu_outputs_prf;
mp_path_external('spt_simu_outputs_vig') = spt_simu_outputs_vig;
mp_path_external('spt_simu_results_img') = spt_simu_results_img;
mp_path_external('spt_simu_outputs_log') = spt_simu_outputs_log;
mp_path_external('spt_simu_outputs_mat') = spt_simu_outputs_mat;
mp_path_external('spt_simu_results_csv') = spt_simu_results_csv;

%% Combine Maps
mp_path = [mp_path_external];
if exist('st_computer', 'var')
    mp_path('st_computer') = string(st_computer);
end

%% Print
if (bl_verbose)
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
