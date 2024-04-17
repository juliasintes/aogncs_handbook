% sen_gyro_params.m
% 
% This script is used to define the gyroscope model parameters
% 
% Version:  v1.0
% Date: 2024-04-17
% Author: J. Sintes Garcia
% Copyright: AOGNCS Handbook


%% GYROSCOPE
% STIM300 Inertial Measurement Unit
% Source: https://www.sensonor.com/products/inertial-measurement-units/stim300/
sen.imu_mBfToImu = [1 0 0; 0 1 0; 0 0 1];   % DCM matrix body frame to IMU frame
sen.imu_rate     = 1/100;   % IMU sample rate (1/Hz)

sen.gyro_I       = eye(3);
sen.gyro_sf      = diag([500 500 500]) * 1e-6;     % scale factor accuracy
sen.gyro_M       = [0 1 1; 1 0 1; 1 1 0] * 1e-3;   % missalignment

sen.gyro_sensitivity = 0.22 / 3600;   % sensitivity (dps/digit)

sen.gyro_bRunRun     = deg2rad([0 0 0]) / 3600;   % turn-on bias or bias repeatibility (rad/s) --> spec 4 deg/h (1-sigma)
sen.gyro_bInst       = deg2rad(0.3) / 3600;   % bias instability or in-run bias (rad/s)

sen.gyro_arw_ns      = 0.15;   % Angle Random Walk (ARW) noise (deg/√h) (Noise Density)
sen.gyro_arw         = deg2rad(sen.gyro_arw_ns) / sqrt(3600) * sqrt(1/sen.imu_rate);   % Angle Random Walk (ARW) noise (rad/s)
sen.gyro_arw_seed    = abs(randi(1e5,1,3));

tau = (deg2rad(sen.gyro_arw_ns)/sqrt(3600))^2 / (sen.gyro_bInst^2 * 2 * log(2) / pi);
sen.gyro_rrw_ns      = sqrt( 2/pi*log(2)*sen.gyro_bInst^2  * 3/tau );   % Rate Random Walk (RRW) noise (rad/s/√s) (Noise Density)
sen.gyro_rrw_ns      = rad2deg(sen.gyro_rrw_ns) * 3600 * sqrt(3600);   % Rate Random Walk (RRW) noise (deg/h/√h) (Noise Density)
sen.gyro_rrw         = deg2rad(sen.gyro_rrw_ns) / 3600 / sqrt(3600) * sqrt(1/sen.imu_rate);   % Rate Random Walk (RRW) noise (rad/s^2) (1-sigma)
sen.gyro_rrw_seed    = abs(randi(1e5,1,3));

sen.gyro_dyn_wn      = 2*pi*1000;           % gyro dynamics natural frequency (rad/s)
sen.gyro_dyn_zeta    = sqrt(2)/2;           % gyro dynamics damping factor (-)
sen.gyro_lpf_wc      = 2*pi*12.5;           % LPF cut-off frequency (rad/s)


