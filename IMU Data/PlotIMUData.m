% File Path (Change to your actual file path)
filePath = 'MobaXterm_COM5STMicroelectronicsSTLinkVirtualCOMPortCOM5_20250127_140416.rtf';

% Read file as a string array
fileData = fileread(filePath);

% Split into lines
lines = splitlines(fileData);

% Preallocate arrays
numSamples = length(lines);
roll = zeros(numSamples, 1);
pitch = zeros(numSamples, 1);
yaw = zeros(numSamples, 1);

for i = 1:numSamples
    matches = regexp(lines{i}, 'roll = ([\-0-9.]+), pitch = ([\-0-9.]+), yaw = ([\-0-9.]+)', 'tokens');
    if ~isempty(matches)
        roll(i) = str2double(matches{1}{1});
        pitch(i) = str2double(matches{1}{2});
        yaw(i) = str2double(matches{1}{3});
    end
end

t = linspace(0,numSamples,numSamples);

start = 25;
figure
yline(0.2,"LineWidth",2)
plot(t(start:end).*(1/60),roll(start:end)-roll(start)-0.05)
hold on
plot(t(start:end).*(1/60),pitch(start:end)-pitch(start)-0.05)
plot(t(start:end).*(1/60),yaw(start:end)-yaw(start)-0.08)
grid on;
xlabel("Time [mins]")
ylabel("Euler Angle [deg]")
legend("Roll","Pitch","Yaw")
ylim([-0.3,0.31])
title("45 Minute Stationary IMU Test")