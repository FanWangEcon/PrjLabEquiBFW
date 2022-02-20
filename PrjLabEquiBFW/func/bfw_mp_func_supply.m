%% BFW_MP_FUNC_SUPPLY Core CES Supply Side Anonymous Functions
%   BFW_MP_FUNC_SUPPLY generates a container map with key multinomial logit
%   supply-side equation. Labor supply is a function of wages.
%
%   * BL_LOG_WAGE boolean if true, log(Px/P0) is linear in log(wage), if
%   false, log(Px/P0) is linear in wage.
%
%   MP_FUNC_SUPPLY = BFW_MP_FUNC_SUPPLY(BL_LOG_WAGE)
%
%   MP_FUNC_SUPPLy = BFW_MP_FUNC_SUPPLY(BL_LOG_WAGE, BL_VERBOSE)
%
%   See also BFWX_MP_FUNC_SUPPLY, BFW_MP_FUNC_SUPPLY
%

%%
function varargout = bfw_mp_func_supply(varargin)
%% Parse Main Inputs and Set Defaults
if (~isempty(varargin))

    bl_log_wage = false;
    bl_verbose = false;

    if (length(varargin) == 1)
        bl_log_wage = varargin{:};
    elseif (length(varargin) == 2)
        [bl_log_wage, bl_verbose] = varargin{:};
    elseif (length(varargin) > 2)
        error('bfw_mp_func_supply:TooManyOptionalParameters', ...
            'allows at most 1 optional parameters');
    end

else

    bl_log_wage = true;
    bl_verbose = true;

end

%% Define Household Supply Equations, testing example
fc_s1 = @(p1, G_1, zeta_1_0, zeta_1_1) ...
    G_1./(1 + ( ...
    exp(-zeta_1_0 - zeta_1_1.*p1) ...
    ));
% s1_compo_1 = exp(-zeta_1_0 - zeta_1_1.*p1);
% s1 = G_1./(1 + s1_compo_1);

fc_s2 = @(p2, G_2, zeta_2_0, zeta_2_1) ...
    G_2./(1 + (...
    exp(-zeta_2_0 - zeta_2_1.*p2) ...
    ));
% s2_compo_1 = exp(-zeta_2_0 - zeta_2_1.*p2);
% s2 = G_2./(1 + s2_compo_1);

%% Supply equations for a particular worker
% There are four alternatives, we are interested in total workers supplied
% given parameters, but also price

% indirect utility equations
% arwage is column vector, evaluate at multiple wages for this occupation
if (bl_log_wage)
    % RHS is log(wage) rather than wage, important to extrapolate low wages
    fc_v_occ = @(psi0, psi1, arwage) exp(psi0 + psi1.*log(arwage));
else
    fc_v_occ = @(psi0, psi1, arwage) exp(psi0 + psi1.*arwage);
end
% t is deviation from 1989, so 1989 = 0
fc_v_lei = @(pie1, pie2, pie3, pie4, pie5, pie6, t, prbchd, prbmar, prbapp, prbjsy) ...
    exp(pie1 + pie2.*(t) + pie3.*prbchd + pie4.*prbmar + pie5.*prbapp + pie6.*prbjsy);
% log_pmdpo: log of the probability of category m vs prob. of category o ratio
% see: https://fanwangecon.github.io/R4Econ\/regnonlin/logit/htmlpdfr/fs_logit_aggregate_shares.html
if (bl_log_wage)
    fc_log_pmdpo_occ = @(psi0, psi1, arwage, pie1, pie2, pie3, pie4, pie5, pie6, t, prbchd, prbmar, prbapp, prbjsy) ...
        (psi0 + psi1.*log(arwage)) - (pie1 + pie2.*(t) + pie3.*prbchd + pie4.*prbmar + pie5.*prbapp + pie6.*prbjsy);
else
    fc_log_pmdpo_occ = @(psi0, psi1, arwage, pie1, pie2, pie3, pie4, pie5, pie6, t, prbchd, prbmar, prbapp, prbjsy) ...
        (psi0 + psi1.*arwage) - (pie1 + pie2.*(t) + pie3.*prbchd + pie4.*prbmar + pie5.*prbapp + pie6.*prbjsy);
end

% the arpsi0 array restructure as single row multiple column
% wage on the other hand can also be a vector, and is single column,
% multiple rows.
fc_prob_denom = @(arpsi0, psi1, arpie, arwage1, arwage2, arwage3, t, prbchd, prbmar, prbapp, prbjsy) ...
       fc_v_occ(arpsi0(1), psi1, arwage1) + ...
       fc_v_occ(arpsi0(2), psi1, arwage2) + ...
       fc_v_occ(arpsi0(3), psi1, arwage3) + ...
       fc_v_lei(arpie(1), arpie(2), arpie(3), arpie(4), arpie(5), arpie(6), t, prbchd, prbmar, prbapp, prbjsy);

% see above
fc_ar_prob_wrk = @(arpsi0, psi1, mtwage, probdenom) ...
    fc_v_occ( ...
    reshape(arpsi0, [1, length(arpsi0)]), ...
    psi1, ...
    mtwage ...
    )./probdenom;

fc_prob_lei = @(arpie, t, prbchd, prbmar, prbapp, prbjsy, probdenom) ...
    fc_v_lei(arpie(1), arpie(2), arpie(3), arpie(4), arpie(5), arpie(6), t, prbchd, prbmar, prbapp, prbjsy)./probdenom;

fc_supply = @(potlabor, prob) potlabor.*prob;

%% Function Map
mp_func = containers.Map('KeyType','char', 'ValueType','any');

mp_func('fc_s1') = fc_s1;
mp_func('fc_s2') = fc_s2;

mp_func('fc_prob_denom') = fc_prob_denom;
mp_func('fc_ar_prob_wrk') = fc_ar_prob_wrk;
mp_func('fc_prob_lei') = fc_prob_lei;
mp_func('fc_log_pmdpo_occ') = fc_log_pmdpo_occ;

mp_func('fc_supply') = fc_supply;

%% Print
if (bl_verbose)
    ff_container_map_display(mp_func);
end

%% Return
if (nargout==1)
    varargout = cell(nargout,0);
    varargout{1} = mp_func;
end

end
