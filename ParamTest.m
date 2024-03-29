% Investigate parameters independently
% More data points, but smaller search area

% Best param combination selected: 
% N_ii = 1000
% N_rw = 1e5
% N_t  = 1e3
% it's the result with the best SD and computation time tradeoff
% since elapsed time between others is marginally shorter
% but the SD is still in the 0.12 range

% Sim1 only

%% generate data
%% N_ii
% params
ra    = [2.5,5.0]*1e-6;
gam   = 2.675e8;
gMax  = 0.5;
delta = 50e-3;
Delta = 100e-3;
tf    = 2*Delta;
D = [2.0,2.0,2.0]*1e-9;
kappa = [1.0,0]*1e-5;
relax = [Inf Inf];
E = 0; % total experiments

N_rw = 1e5;
N_t  = 1e3;

for N_ii = [1e1,2e1,3e1,4e1,5e1,6e1,7e1,8e1,9e1] %[1e2,2e2,3e2,4e2,5e2,6e2,7e2,8e2,9e2,...
        %1e3,2e3,3e3,4e3,5e3,6e3,7e3,8e3,9e3]
    U     = N_rw * N_t;
    if ~(U > 10^8)
        % begin
        t = linspace(0,tf,N_t);
        U     = N_rw * N_t;

        % substrate
        [X,Y] = meshgrid(linspace(-ra(2)*1.3,ra(2)*1.3,N_ii));
        d = sqrt(X.^2+Y.^2);
        I = uint8(d<=ra(2)) + uint8(d<ra(1));

        % sequence
        gRes = 0.001; gSteps = gMax/gRes;
        G=0*t; G(t<=delta)=1; G(t>=Delta&t<=Delta+delta)=-1;
        dir=[1,0]; G=kron(dir,G');
        seq.G = G; seq.t = t; seq.G_s = 0:gRes:gMax;
        bVal = (gam^2 * seq.G_s.*seq.G_s * delta^2 * (Delta - delta/3));

        % analytical
        if ~exist ('Sa','var') % debugging - save time
            ML.d = 2; ML.r = ra; ML.D = [D(1), D(2)]; ML.W = [kappa(1),kappa(2)]; ML.T = relax;
            Sa = ML_compute(seq.G_s,delta,Delta,ML);
        end

        % simulation
        tic
        simu.r = X(1,2)-X(1,1);
        simu.N = N_rw;
        simu.D = D;
        simu.P = flip([ML.W; flip(ML.W)]);
        S = diffSim(I,seq,simu,gam);
        elapsedTime = toc;
        E = E + 1;
        save(sprintf('Results/Params/Nii/Nii=%d',N_ii)); % save                                                                                                                                                                                                                                                                                          
    else
        %fprintf("Skipped N_rw = %d and N_t = %d\n", N_rw, N_t);                                                                                                       
    end
end

%% N_rw
% params
ra    = [2.5,5.0]*1e-6;
gam   = 2.675e8;
gMax  = 0.5;
delta = 50e-3;
Delta = 100e-3;
tf    = 2*Delta;
D = [2.0,2.0,2.0]*1e-9;
kappa = [1.0,0]*1e-5;
relax = [Inf Inf];
E = 0; % total experiments

N_ii = 1000;
N_t  = 1e3;

for N_rw = [1e2,2e2,3e2,4e2,5e2,6e2,7e2,8e2,9e2,...
            1e3,2e3,3e3,4e3,5e3,6e3,7e3,8e3,9e3,...
            1e4,2e4,3e4,4e4,5e4,6e4,7e4,8e4,9e4,1e5]
    U     = N_rw * N_t;
    if ~(U > 10^8)
        % begin
        t = linspace(0,tf,N_t);
        U     = N_rw * N_t;

        % substrate
        [X,Y] = meshgrid(linspace(-ra(2)*1.3,ra(2)*1.3,N_ii));
        d = sqrt(X.^2+Y.^2);
        I = uint8(d<=ra(2)) + uint8(d<ra(1));

        % sequence
        gRes = 0.001; gSteps = gMax/gRes;
        G=0*t; G(t<=delta)=1; G(t>=Delta&t<=Delta+delta)=-1;
        dir=[1,0]; G=kron(dir,G');
        seq.G = G; seq.t = t; seq.G_s = 0:gRes:gMax;
        bVal = (gam^2 * seq.G_s.*seq.G_s * delta^2 * (Delta - delta/3));

        % analytical
        if ~exist ('Sa','var') % debugging - save time
            ML.d = 2; ML.r = ra; ML.D = [D(1), D(2)]; ML.W = [kappa(1),kappa(2)]; ML.T = relax;
            Sa = ML_compute(seq.G_s,delta,Delta,ML);
        end

        % simulation
        tic
        simu.r = X(1,2)-X(1,1);
        simu.N = N_rw;
        simu.D = D;
        simu.P = flip([ML.W; flip(ML.W)]);
        S = diffSim(I,seq,simu,gam);
        elapsedTime = toc;
        E = E + 1;
        save(sprintf('Results/Params/Nrw/Nrw=%d',(N_rw))); % save                                                                                                                                                                                                                                                                                          
    else
        %fprintf("Skipped N_rw = %d and N_t = %d\n", N_rw, N_t);                                                                                                       
    end
end

%% N_t
% params
ra    = [2.5,5.0]*1e-6;
gam   = 2.675e8;
gMax  = 0.5;
delta = 50e-3;
Delta = 100e-3;
tf    = 2*Delta;
D = [2.0,2.0,2.0]*1e-9;
kappa = [1.0,0]*1e-5;
relax = [Inf Inf];
E = 0; % total experiments

N_ii = 1000;
N_rw  = 1e5;

for N_t = [1e2,2e2,3e2,4e2,5e2,6e2,7e2,8e2,9e2,...
            1e3,2e3,3e3,4e3,5e3,6e3,7e3,8e3,9e3,...
            1e4,2e4,3e4,4e4,5e4,6e4,7e4,8e4,9e4,1e5]
    U     = N_rw * N_t;
    %if ~(U > 10^8)
        % begin
        t = linspace(0,tf,N_t);
        U     = N_rw * N_t;

        % substrate
        [X,Y] = meshgrid(linspace(-ra(2)*1.3,ra(2)*1.3,N_ii));
        d = sqrt(X.^2+Y.^2);
        I = uint8(d<=ra(2)) + uint8(d<ra(1));

        % sequence
        gRes = 0.001; gSteps = gMax/gRes;
        G=0*t; G(t<=delta)=1; G(t>=Delta&t<=Delta+delta)=-1;
        dir=[1,0]; G=kron(dir,G');
        seq.G = G; seq.t = t; seq.G_s = 0:gRes:gMax;
        bVal = (gam^2 * seq.G_s.*seq.G_s * delta^2 * (Delta - delta/3));

        % analytical
        if ~exist ('Sa','var') % debugging - save time
            ML.d = 2; ML.r = ra; ML.D = [D(1), D(2)]; ML.W = [kappa(1),kappa(2)]; ML.T = relax;
            Sa = ML_compute(seq.G_s,delta,Delta,ML);
        end

        % simulation
        tic
        simu.r = X(1,2)-X(1,1);
        simu.N = N_rw;
        simu.D = D;
        simu.P = flip([ML.W; flip(ML.W)]);
        S = diffSim(I,seq,simu,gam);
        elapsedTime = toc;
        E = E + 1;
        save(sprintf('Results/Params/Nt/Nt=%d',(N_t))); % save                                                                                                                                                                                                                                                                                          
    %else
        %fprintf("Skipped N_rw = %d and N_t = %d\n", N_rw, N_t);                                                                                                       
    %end
end
%fprintf("\nTotal experiments: %d",E);

%% Data anaylsis
%% Nii
clear; folder = (dir("Results/Params/Nii/"));
names = extractfield(folder(3:length(folder)),'name')';

Nii      = zeros(length(names),1);
MRAE     = zeros(length(names),1);
compTime = zeros(length(names),1);
SD       = zeros(length(names),1);

for val=1:length(names)
    load(char(names(val)));
    Nii(val) = N_ii;
    MRAE(val) = mean((abs((Sa-real(S'))./Sa)));
    compTime(val) = elapsedTime;
    SD(val) = std(real(S'));
end
[Nii2,idx] = sort(Nii); errVals = MRAE(idx);
figure; semilogx(Nii2,errVals)
ylabel('MRAE'), xlabel('N_{ii}')

figure; semilogx(Nii2,compTime(idx)); ylabel('Time (s)'), xlabel('N_{ii}')

save("Results/Params/Nii_exp",'errVals','compTime','Nii2');
%% Nrw
clear; folder = (dir("Results/Params/Nrw/"));
names = extractfield(folder(3:length(folder)),'name')';
num = length(names);

Nrw      = zeros(num,1);
MRAE     = zeros(num,1);
compTime = zeros(num,1);

for val=1:num
    load(char(names(val)));
    Nrw(val) = N_rw;
    MRAE(val) = mean((abs((Sa-real(S'))./Sa)));
    compTime(val) = elapsedTime;
end
[Nrw2,idx] = sort(Nrw); errVals = MRAE(idx);
figure; semilogx(Nrw2,errVals)
ylabel('MRAE'), xlabel('N_{rw}')

figure; semilogx(Nrw2,compTime(idx)); ylabel('Time (s)'), xlabel('N_{rw}')

save("Results/Params/Nrw_exp",'errVals','compTime','Nrw2');
%barh(bestTimes,0.2), set(gca,'YTickLabel',bestTimesName); xlabel('Elapsed time (s)'), set(gca,'YTickLabelRotation',45);

%% Nt
clear; folder = (dir("Results/Params/Nt/"));
names = extractfield(folder(3:length(folder)),'name')';
num = length(names);

Nt      = zeros(num,1);
MRAE     = zeros(num,1);
compTime = zeros(num,1);

for val=1:num
    load(char(names(val)));
    Nt(val) = N_t;
    MRAE(val) = mean((abs((Sa-real(S'))./Sa)));
    compTime(val) = elapsedTime;
end
[Nt2,idx] = sort(Nt); errVals = MRAE(idx);
figure; semilogx(Nt(idx),errVals),
ylabel('MRAE'), xlabel('N_{t}')%, set(gca,'XTickLabelRotation',45);

figure; semilogx(Nt2,compTime(idx)); ylabel('Time (s)'), xlabel('N_{t}')

save("Results/Params/Nt_exp",'errVals','compTime','Nt2');
%% clean files!!!
clear; clearFolder = (dir("Results/Params/Nt/")); clearName = extractfield(clearFolder(3:length(clearFolder)),'name')';
for i=1:length(clearName)
    load(char(clearName(i)));
    clearvars disks Nii Nrw Nt val E dir bestTimes num bestTimesName compTime errVals fileName fileNames folder id idx item k loadFolder mean_compTime mean_SD MRAE N_params N_trials repeatReadings rpt SD SDvals names
    save(sprintf('Results/Params/Nt/%s',char(clearName(i))))
end

%% comparing between parameters
clear;

Nii_exp = load("Results/Params/Nii_exp");
Nrw_exp = load("Results/Params/Nrw_exp");
Nt_exp = load("Results/Params/Nt_exp");

% MRAE between pairs
figure;
scatter(Nrw_exp.Nrw2(1:19),Nrw_exp.errVals(1:19),'filled'), hold on
scatter(Nt_exp.Nt2,Nt_exp.errVals,'filled'),
ylabel('MRAE')
xlabel('Parameter value')
set(gca,'xscale','log'),lsline
legend('N_{rw}','N_t','','')

figure;
scatter(Nii_exp.Nii2(10:19),Nii_exp.errVals(10:19),'filled'), hold on
scatter(Nt_exp.Nt2(1:10),Nt_exp.errVals(1:10),'filled'),
ylabel('MRAE')
xlabel('Parameter value')
%set(gca,'xscale','log'),
lsline,
legend('N_{ii}','N_t','','')

figure;
scatter(Nii_exp.Nii2(10:19),Nii_exp.errVals(10:19),'filled'), hold on
scatter(Nrw_exp.Nrw2(1:10),Nrw_exp.errVals(1:10),'filled'),
ylabel('MRAE')
xlabel('Parameter value')
%set(gca,'xscale','log'),
lsline,
legend('N_{ii}','N_{rw}','','')

% Time between pairs
figure;
scatter(Nrw_exp.Nrw2(1:19),Nrw_exp.compTime(1:19),'filled'), hold on
scatter(Nt_exp.Nt2,Nt_exp.compTime,'filled'),
ylabel('Elapsed time (s)')
xlabel('Parameter value')
set(gca,'xscale','log'),lsline
legend('N_{rw}','N_t','','')

figure;
scatter(Nii_exp.Nii2(10:19),Nii_exp.compTime(10:19),'filled'), hold on
scatter(Nt_exp.Nt2(1:10),Nt_exp.compTime(1:10),'filled'),
ylabel('Elapsed time (s)')
xlabel('Parameter value')
%set(gca,'xscale','log'),
legend('N_{ii}','N_t','','')

figure;
scatter(Nii_exp.Nii2(10:19),Nii_exp.compTime(10:19),'filled'), hold on
scatter(Nrw_exp.Nrw2(1:10),Nrw_exp.compTime(1:10),'filled'),
ylabel('Elapsed time (s)')
xlabel('Parameter value')
%set(gca,'xscale','log'),
lsline,
legend('N_{ii}','N_{rw}','','')














