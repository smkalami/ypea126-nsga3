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

function params = PerformScalarizing(z, params)

    nObj = size(z, 1);
    nPop = size(z, 2);
    
    if ~isempty(params.smin)
        zmax = params.zmax;
        smin = params.smin;
    else
        zmax = zeros(nObj, nObj);
        smin = inf(1, nObj);
    end
    
    for j = 1:nObj
       
        w = GetScalarizingVector(nObj, j);
        
        s = zeros(1, nPop);
        for i = 1:nPop
            s(i) = max(z(:, i)./w);
        end

        [sminj, ind] = min(s);
        
        if sminj < smin(j)
            zmax(:, j) = z(:, ind);
            smin(j) = sminj;
        end
        
    end
    
    params.zmax = zmax;
    params.smin = smin;
    
end

function w = GetScalarizingVector(nObj, j)

    epsilon = 1e-10;
    
    w = epsilon*ones(nObj, 1);
    
    w(j) = 1;

end