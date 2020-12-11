% 
% Copyright (c) 2016, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
% 
% Project Code: YPEA126
% Project Title: Non-dominated Sorting Genetic Algorithm III (NSGA-III)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Implemented by: Mostapha Kalami Heris, PhD (member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, NSGA-III: Non-dominated Sorting Genetic Algorithm, the Third Version — MATLAB Implementation (URL: https://yarpiz.com/456/ypea126-nsga3), Yarpiz, 2016.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
% 
% Base Reference Paper:
% K. Deb and H. Jain, "An Evolutionary Many-Objective Optimization Algorithm 
% Using Reference-Point-Based Nondominated Sorting Approach, Part I: Solving
% Problems With Box Constraints, "
% in IEEE Transactions on Evolutionary Computation, 
% vol. 18, no. 4, pp. 577-601, Aug. 2014.
% 
% Reference Paper URL: http://doi.org/10.1109/TEVC.2013.2281535
% 

function [pop, F, params] = SortAndSelectPopulation(pop, params)

    [pop, params] = NormalizePopulation(pop, params);

    [pop, F] = NonDominatedSorting(pop);
    
    nPop = params.nPop;
    if numel(pop) == nPop
        return;
    end
    
    [pop, d, rho] = AssociateToReferencePoint(pop, params);
    
    newpop = [];
    for l = 1:numel(F)
        if numel(newpop) + numel(F{l}) > nPop
            LastFront = F{l};
            break;
        end
        
        newpop = [newpop; pop(F{l})];   %#ok
    end
    
    while true
        
        [~, j] = min(rho);
        
        AssocitedFromLastFront = [];
        for i = LastFront
            if pop(i).AssociatedRef == j
                AssocitedFromLastFront = [AssocitedFromLastFront i]; %#ok
            end
        end
        
        if isempty(AssocitedFromLastFront)
            rho(j) = inf;
            continue;
        end
        
        if rho(j) == 0
            ddj = d(AssocitedFromLastFront, j);
            [~, new_member_ind] = min(ddj);
        else
            new_member_ind = randi(numel(AssocitedFromLastFront));
        end
        
        MemberToAdd = AssocitedFromLastFront(new_member_ind);
        
        LastFront(LastFront == MemberToAdd) = [];
        
        newpop = [newpop; pop(MemberToAdd)]; %#ok
        
        rho(j) = rho(j) + 1;
        
        if numel(newpop) >= nPop
            break;
        end
        
    end
    
    [pop, F] = NonDominatedSorting(newpop);
    
end
