%% bfw_mp_path
% This is the example vignette for function: bfw_mp_path from the <https://fanwangecon.github.io/PrjLabEquiBFW/ 
% *PrjLabEquiBFW Package*>*.* 
%% Default Map of Path (Fan path)

bl_verbose = true;
mp_path = bfw_mp_path(bl_verbose);
%% Map of Path for Alternative Path Installer
% Two directories, one for the repo and one for where outputs go, need to be 
% specified. 

spt_repo_root = "~\PrjLabEquiBFW";
spt_output_root = "~\Dropbox\PrjLabEquiBFW";
bl_verbose = true;
mp_path = bfw_mp_path(spt_repo_root, spt_output_root, bl_verbose);
%%