% test_acc.m
% 
% This script is used to validate the accelerometer model against the
% specifications from the sensor datasheet
% 
% Version:  v1.0
% Date: 2024-04-17
% Author: J. Sintes Garcia
% Copyright: AOGNCS Handbook

clear; close all; clc;

% ALGORITHM START
% -------------------------------------------------------------------------
fprintf('ACCELERATOR MODEL VALIDATION...\n')
rng(123456789)

Nsamples = 5;   % number of samples

% Initialize vectors
vVrw = zeros(3,Nsamples);   % Velocity Random Walk - VRW (m/s/√h)
vBi  = zeros(3,Nsamples);   % Bias Instability - BI (mg)

figure()
h = axes;
set(h,'XScale','log'); set(h,'YScale','log')
hold on
for i = 1:Nsamples
    
    % Load gyro parameters
    sen_acc_params()
    
    % Run simulation
    simOut = sim('sen_acc_test','SimulationMode','Normal','StopTime',string(20000));
    
    % Compute Allan variance
    velocityX = cumsum(simOut.sen_acc_rawAccImu.Data(:,1)) * sen.imu_rate;
    [avarX,tau] = allanvariance(velocityX,1/sen.imu_rate,500,'angle');
    adevX = sqrt(avarX) / sen.acc_g_to_ms2 * 1e3;
    velocityY = cumsum(simOut.sen_acc_rawAccImu.Data(:,2)) * sen.imu_rate;
    [avarY,tau] = allanvariance(velocityY,1/sen.imu_rate,500,'angle');
    adevY = sqrt(avarY) / sen.acc_g_to_ms2 * 1e3;
    velocityZ = cumsum(simOut.sen_acc_rawAccImu.Data(:,3)) * sen.imu_rate;
    [avarZ,tau] = allanvariance(velocityZ,1/sen.imu_rate,500,'angle');
    adevZ = sqrt(avarZ) / sen.acc_g_to_ms2 * 1e3;
    
    % Estimate noise parameters
    vVrw(1,i) = getVrw(adevX,tau) * sen.acc_g_to_ms2 * 60 * 1e-3;   % VRW x-axis
    vVrw(2,i) = getVrw(adevY,tau) * sen.acc_g_to_ms2 * 60 * 1e-3;   % VRW y-axis
    vVrw(3,i) = getVrw(adevZ,tau) * sen.acc_g_to_ms2 * 60 * 1e-3;   % VRW z-axis
    vBi(1,i) = getBi(adevX,tau);   % BI x-axis
    vBi(2,i) = getBi(adevY,tau);   % BI y-axis
    vBi(3,i) = getBi(adevZ,tau);   % BI z-axis
    
    % Plot Allan deviation
    loglog(tau,adevX,'Color','#0072BD')
    loglog(tau,adevY,'Color','#0072BD')
    loglog(tau,adevZ,'Color','#0072BD')
    
end
xlabel('\tau (s)')
ylabel('Allan deviation (mg)')
xlim([1e-1 1e4])
grid on

% Print observed results
fprintf('Observed Velocity Random Walk (VRW): %.4f m/s/√h (expected %.4f m/s/√h)\n',rms(rms(vVrw)),sen.acc_vrw_ns)
fprintf('Observed Bias Instability (BI): %.4f mg (expected %.4f mg)\n',rms(rms(vBi)),sen.acc_bInst*1e3)

% -------------------------------------------------------------------------
% ALGORITHM END


