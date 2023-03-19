%% Acceleration Forces Sim

function [Fx,Ax] = AccelSim(ThrottleInput,Velocity,GR,vehicle)
    rr = 0.015;
    fRR = rr * vehicle.TotalWeight; %lbs
    
    % Linear Map of Throttle Input to Motor Torque
    
    % Motor Torque -> Torque at Wheels -> Fx

    MotorSpeed = Velocity*GR / (2*pi*vehicle.TireRadius);
    torque = 0.7376*MotorTorque(MotorSpeed*60); %ft lbs
    finalTorque = GR * torque; %ft lbs
    Fx = finalTorque/wheelRadius; %lbs
    
    % Ax
    
    fDrag = 0.5 * (Velocity)^2 * 0.00237 * 5.080705e-01 * 0.946;
    fNet = Fx-fRR-fDrag; % lbs
    Ax = (fNet / mass)*32.2; % g's
end