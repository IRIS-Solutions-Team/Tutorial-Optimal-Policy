%% Simulate Disinflation in Optimal Policy Models
%
% Simulate a permanent disinflation in the three types of models (a simple
% rule, discretionary policy, commitment policy). This experiment shows one
% of the possible ways how to simulate a permament change in the steady
% state of a model. It also illustrates the real cost associated with
% disinflation under different policy assumptions, measured by the
% sacrifice ratio.
%


%% Clear the Workspace
%
% Clear the workspace, close all graphics figures, clear the command
% window, and check the IRIS version.
%

clear
close all
clc
irisrequired 20140319


%% Load Discretion and Commitment Model Objects
%
% Load all three model objects created and saved previously in
% |read_model|.
%

load MAT/read_models.mat m1 m2 m3


%% Set Up an Input Database
%
% Disinflation is a permanent change in the steady state of the model.
% Create first a model object with a higher inflation target, |m3high|,
% based on the existing model object |m3|. Assign the inflation target a
% higher value, resolve the model and recompute its
% steady state. Then, create a database with both
% inflation and nominal interest rates higher by 1%. This database is then
% used as an input database in the disinflation experiments below.
%

m3high = m3;
m3high.targ = m3high.targ + 1; 
m3high = solve(m3high); 
m3high = sstate(m3high); 

m3.pi
m3high.pi

m3.r
m3high.r

d = sstatedb(m3high, 1:40); 
d
d.pi
d.r


%% Simulate Disinflation
%
% Run simulations starting from a steady state with higher inflation and
% higher nominal interest rates (database |d| created above) in models
% whose steady states see low inflation and low interest rates. Run the
% simulations in all three models: |m1| (a simple policy rule), |m2|
% (optimal discretionary policy), and |m3| (optimal commitment policy).
%
% When reporting the results, add one more graph showing the
% cumulative output gap (divided by 4 to annualize the quarterly simulation
% results). This is often called the sacrifice ratio, and it is one of the
% most important numerical characteristics of policy models. The sacrifice
% ratio is about 0.8 in all of the model versions here.
%

s1 = simulate(m1, d, 1:40, 'AppendPresample=', true);
s2 = simulate(m2, d, 1:40, 'AppendPresample=', true);
s3 = simulate(m3, d, 1:40, 'AppendPresample=', true);

s = s1 & s2 & s3;
dbplot(s, 0:40, {'y', 'pi', 'r', 'cumsum(y)/4'});

le = visual.hlegend( ...
    'Top', ...
    'Rule', ...
    'Discretion', ...
    'Commitment' ...
);

title(le, 'Disinflation');


%% Simulate Disinflation with Inflation-Only Objective
%
% Simulate the same disinflation in optimal policy models with zero weights
% on output and interest rates, |lmb1| and |lmb2|. In these kinds of
% theoretical models, the central bank can disinflate immediately by
% creating a sufficient slack in real economy activity in one single
% period. The sacrifice ratio is though about double the one observed in
% the original model versions above.
%
% As in |simulate_shocks|, create two new model objects, |m2i| and |m3i|,
% based on the existing optimal policy model objects |m2| and |m3|,
% respectively. Assign the parameters |lmb1| and |lmb2| zeros solve the
% model objects with these new parameters and run the disinflation
% simulation.
%

m2i = m2;
m2i.lmb1 = 0;
m2i.lmb2 = 0;

get(m2i, 'Parameters')

m3i = m3;
m3i.lmb1 = 0;
m3i.lmb2 = 0;

m2i = solve(m2i);
m3i = solve(m3i);

s2i = simulate(m2i, d, 1:40, 'AppendPresample=', true);
s3i = simulate(m3i, d, 1:40, 'AppendPresample=', true);

s = s2i & s3i;
dbplot(s, 0:40, {'y', 'pi', 'r', 'cumsum(y)/4'});

le = visual.hlegend( ...
    'Top', ...
    'Discretion with Only Inflation in Loss Function', ...
    'Commitment with Only Inflation in Loss Function' ...
);

title(le, 'Disinflation with Only Inflation in Loss Function');


%% Show Variables and Objects Created in This File

whos


%% Help on IRIS Functions Used in This File
%
%    help model
%    help model/model
%    help model/subsasgn
%    help model/solve
%    help model/sstate
%    help modle/sstatedb
%    help model/simulate
%    help dbase/dbplot
%    help visual/hlegend
%
