%% Simple Optimal Policy Model File
%
% This is the model file (i.e. the description of the variables and
% equations) for a simple optimal policy exercise. The model has a simple
% aggregate demand equation, a Phillips curve, and two verions of monetary
% policy specification: (1) a simple rule, and (2) a loss function used to
% calculate optimal policy. Choose between the two specifications using the
% switch |optimal_policy|. Furthermore, given the loss function, the type
% of optimal policy calculated in IRIS can be either optimal discretionary
% policy, or optimal commitment policy. Use the option |Optimal=| at the
% time of loading the model file (i.e. in the function |model( )|) to
% choose one or the other.
%

%% Declare Transition (aka Endogenous) Variables

!transition_variables

    'Output Gap' y, 'Inflation' pi, 'Policy Rate' r

%
    
%% Declare Parameters
%
% Note that parameters are not assigned any values in the model file.
% Instead, they are assigned after the model file has been loaded and
% converted into a model object, in |read_model|.
%

!parameters

    del1, del2, sgm, alp, gam
    bet, lmb1, lmb2, targ
    mu, rho

%

%% Declare Shocks

!transition_shocks

    'Demand Shock' e, 'Cost-Push Shock' u   

%
    
%% Write Transition (aka Endogenous) Equations
%
% Use the |min( )| operator to write a loss function; the term in the
% brackets (here |beta|) is the discount factor. The resulting optimal
% policy can be either discretionary or commitment, depending on the option
% |Optimal=| set in the funtion |model| when loading the model file.
%

!transition_equations

    % Aggregate Demand Equation.
    y = del1*y{-1} + del2*y{+1} - sgm*(r - pi{1}) + e;
    
    % Phillips curve.
    pi = alp*pi{-1} + (1-alp)*pi{1} + gam*y + u;
    
    % Monetary Policy.
    !if optimal_policy
        min(bet) (pi-targ)^2 + lmb1*y^2 + lmb2*(r-r{-1})^2;
    !else
        r = rho*r{-1} + (1-rho)*(targ + mu*(pi{1} - targ));
    !end

%
    
%% Get Help on IRIS Model Language Keywords Used in This File
%
%    help irislang/transition_variables
%    help irislang/transitionshocks
%    help irislang/parameters
%    help irislang/transitionequations
%    help irislang/min
%
