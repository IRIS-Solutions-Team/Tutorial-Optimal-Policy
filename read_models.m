%% Read and Solve Models with Optimal Policy
%
% Load the model file |optimal_policy.model| and create three different
% versions of it: a model with a simple policy rule, an optimal
% discretionary (time-consistent) policy model, and an optimal commitment
% policy model. Calibrate, solve and save the model objects for further
% use.


%% Clear the Workspace
%
% Clear workspace, close all graphics figures, clear command window, and
% check the IRIS version.

clear
close all
clc
irisrequired 20180209


%% Prepare a Calibration Dababase
%
% Create a parameter database, |P|, before loading the model file. This
% very same parameter database will be reused in all versions of the model.
% We assign the database to each of the model objects.
%
 
P = struct( ); 
P.del1 = 0.7; 0.5;
P.del2 = 0.1;
P.sgm = 0.05;
P.alp = 0.65; 0.5;
P.gam = 0.1;
P.bet = 0.9; 0.99;
P.lmb1 = 0.1;
P.lmb2 = 0.1;
P.rho = 0.8;
P.mu = 5;
P.targ = 2;

disp(P)


%% Load Three Versions of the Model
%
% Load the model file three times, using different combinations of the
% switch |optimal_policy| (a switch, or a control variables, defined and
% and used in the model file to select model equations either with a simple
% rule or a loss function), and the option |Optimal=| through which we can
% control the type of optimal policy request.
%
% # Set |optimal_policy=false| in the model file to load the model with a
% simple inflation-targeting rule.
% # Set the control variable |optimal_policy=true| in the model file to
% load the model with a loss function, and then set the suboption
% |Type='Commitment'| in the option |Optimal=| when calling the function
% |model( )| telling IRIS to calculate equations that describe
% discretionary optimal policy. Under discretion, expectations (the leads
% of variables) are taken as given, and not differentiated with respect to.
% # Set the control variable |optimal_policy=true| to load the model file
% with a loss function, and set the suboption |Type='Commitment'| in the
% option |Optimal=| when calling the functin |model( )| telling IRIS to
% calculate equations that describe optimal commitment policy. Under
% commitment, expectations (the leads of variables) are internalized by the
% policymaker when optimizing the loss function.

m1 = model( ...
    'optimal_policy.model', ...
    'Linear=', true, ...
    'Assign=', P, ... 
    'optimal_policy=', false ...
);

m2 = model( ...
    'optimal_policy.model', ...
    'Linear=', true, ...
    'Assign=', P, ... 
    'optimal_policy=', true, ... 
    'Optimal=', {'Type=', 'Discretion'} ...
); 

m3 = model( ...
    'optimal_policy.model', ...
    'Linear=', true, 'Assign=', P, ...
    'optimal_policy=', true, ...
    'optimal=', {'Type=', 'Commitment'} ...
);

disp(m1)
disp(m2)
disp(m3)


%% Show the Newly Created Optimal Policy Equations
%
% In model objects |m2| and |m3|, IRIS calculates the equations
% corresponding to the derivatives of the Lagrangian (consisting of the
% loss function and the model equations) with respect to the individual
% variables, and adds these equations to the model, together with the
% corresponding number of newly created variables, the Lagrange mutlipliers
% associated with individual equations (see below). Under discretion, |m2|,
% the expectations (the leads of variables) are taken as given; the terms
% related to the derivatives of expectations present in the |m3| equations
% are therefore missing from the |m2| equations.

eqtn1 = get(m1, 'Equations');
eqtn2 = get(m2, 'Equations'); 
eqtn3 = get(m3, 'Equations'); 

disp(eqtn1)
disp(eqtn2) 
disp(eqtn3)


%% Solve the Models and Compute Their Steady States
%
% All three models are linear (in the case of optimal policy models, a
% linear model with a quadratic loss function always results in a linear
% model). Calculate first their first-order solutions  (steady
% state does need to be known in linear models), and then, based on the
% dynamic solution, determine the steady state. Use the function
% |get( )| to retrieve a database with the steady-state values.
% The steady state values are identical for all three models. In the
% optimal policy models, |m2| and |m3|, the steady-state databases also
% include the newly created Lagrange multipliers, |Mu_Eq1| and |Mu_Eq2|.
%

m1 = solve(m1); 
m1 = sstate(m1); 
ss1 = get(m1, 'Steady');

m2 = solve(m2); 
m2 = sstate(m2); 
ss2 = get(m2, 'Steady');

m3 = solve(m3); 
m3 = sstate(m3);  
ss3 = get(m3, 'Steady');

disp(ss1)
disp(ss2)
disp(ss3)


%% Verify Steady State
%
% Verify that the steady state databases are identical for all three
% models, up to rounding errors.
%

structfun( @(x) x(1)-x(2), ss1 & ss2, 'UniformOutput', false)
structfun( @(x) x(1)-x(2), ss2 & ss3, 'UniformOutput', false)


%% Save Model Objects for Further Use
%
% Save the solved model objects to a mat-file (binary file) for further
% use.

save MAT/read_models.mat m1 m2 m3


%% Show Variables and Objects Created in This File                         

whos


%% Get Help on IRIS Functions Used in This File
%
%    help model/model
%    help model/get
%    help model/solve
%    help model/sstate
%
