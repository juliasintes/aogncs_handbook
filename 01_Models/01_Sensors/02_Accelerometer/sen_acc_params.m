% sen_acc_params.m
% 
% This script is used to define the accelerometer model parameters
% 
% Version:  v1.0
% Date: 2024-04-17
% Author: J. Sintes Garcia
% Copyright: AOGNCS Handbook


%% ACCELEROMETER
% STIM300 Inertial Measurement Unit
% Source: https://www.sensonor.com/products/inertial-measurement-units/stim300/
sen.imu_mBfToImu = [1 0 0; 0 1 0; 0 0 1];   % DCM matrix body frame to IMU frame
sen.imu_rate     = 1/100;   % IMU sample rate (1/Hz)

sen.acc_I       = eye(3);
sen.acc_sf      = diag([200 200 200]) * 1e-6;     % scale factor accuracy
sen.acc_M       = [0 1 1; 1 0 1; 1 1 0] * 1e-3;   % missalignment

sen.acc_g_to_ms2 = 9.80665;   % conversion factor from g to m/s^2

sen.acc_sensitivity  = 1 * 1e-6;   % sensitivity (g/digit)

sen.acc_bTurnOn      = [0 0 0];   % turn-on bias or bias repeatibility (g) --> spec +/-0.38 mg (1-sigma)
sen.acc_bInst        = 0.02 * 1e-3;   % bias instability or in-run bias (g)

sen.acc_vrw_ns       = 0.03;   % Velocity Random Walk (VRW) noise (m/s/√h) (Noise Density)
sen.acc_vrw          = sen.acc_vrw_ns / sqrt(3600) * sqrt(1/sen.imu_rate);   % Velocity Random Walk (VRW) noise (m/s^2)
sen.acc_vrw_seed     = abs(randi(1e5,1,3));

sen.acc_lpf_wc      = 2*pi*12.5;           % LPF cut-off frequency (rad/s)


