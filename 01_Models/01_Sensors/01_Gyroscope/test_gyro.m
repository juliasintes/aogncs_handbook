% test_gyro.m
% 
% This script is used to validate the gyroscope model against the
% specifications from the sensor datasheet
% 
% Version:  v1.0
% Date: 2024-04-17
% Author: J. Sintes Garcia
% Copyright: AOGNCS Handbook

clear; close all; clc;

% ALGORITHM START
% -------------------------------------------------------------------------
fprintf('GYROSCOPE MODEL VALIDATION...\n')
rng(123456789)

Nsamples = 5;   % number of samples

% Initialize vectors
vArw = zeros(3,Nsamples);   % Angle Random Walk - ARW (deg/√h)
vRrw = zeros(3,Nsamples);   % Rate Random Walk - RRW (deg/h/√h)
vBi  = zeros(3,Nsamples);   % Bias Instability - BI (deg/h)

figure()
h = axes;
set(h,'XScale','log'); set(h,'YScale','log')
hold on
for i = 1:Nsamples
    
    % Load gyro parameters
    sen_gyro_params()
    
    % Run simulation
    simOut = sim('sen_gyro_test','SimulationMode','Normal','StopTime',string(20000));
    
    % Compute Allan variance
    omegaX = cumsum(rad2deg(simOut.sen_gyro_rawAngle.Data(:,1)));
    [avarX,tau] = allanvariance(omegaX,1/sen.imu_rate,500,'angle');
    adevX = sqrt(avarX) * 3600;
    omegaY = cumsum(rad2deg(simOut.sen_gyro_rawAngle.Data(:,2)));
    [avarY,tau] = allanvariance(omegaY,1/sen.imu_rate,500,'angle');
    adevY = sqrt(avarY) * 3600;
    omegaZ = cumsum(rad2deg(simOut.sen_gyro_rawAngle.Data(:,3)));
    [avarZ,tau] = allanvariance(omegaZ,1/sen.imu_rate,500,'angle');
    adevZ = sqrt(avarZ) * 3600;
    
    % Estimate noise parameters
    vArw(1,i) = getArw(adevX,tau);   % ARW x-axis
    vArw(2,i) = getArw(adevY,tau);   % ARW y-axis
    vArw(3,i) = getArw(adevZ,tau);   % ARW z-axis
    vRrw(1,i) = getRrw(adevX,tau);   % RRW x-axis
    vRrw(2,i) = getRrw(adevY,tau);   % RRW y-axis
    vRrw(3,i) = getRrw(adevZ,tau);   % RRW z-axis
    vBi(1,i) = getBi(adevX,tau);   % BI x-axis
    vBi(2,i) = getBi(adevY,tau);   % BI y-axis
    vBi(3,i) = getBi(adevZ,tau);   % BI z-axis
    
    % Plot Allan deviation
    loglog(tau,adevX,'Color','#0072BD')
    loglog(tau,adevY,'Color','#0072BD')
    loglog(tau,adevZ,'Color','#0072BD')
    
end
xlabel('\tau (s)')
ylabel('Allan deviation (deg/h)')
xlim([1e-1 1e4])
grid on

% Print observed results
fprintf('Observed Angle Random Walk (ARW): %.4f deg/√h (expected %.4f deg/√h)\n',rms(rms(vArw)),sen.gyro_arw_ns)
fprintf('Observed Rate Random Walk (RRW): %.4f deg/h/√h (expected %.4f deg/h/√h)\n',rms(rms(vRrw)),sen.gyro_rrw_ns)
fprintf('Observed Bias Instability (BI): %.4f deg/h (expected %.4f deg/h)\n',rms(rms(vBi)),rad2deg(sen.gyro_bInst)*3600)

% -------------------------------------------------------------------------
% ALGORITHM END


