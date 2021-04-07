function flatState = flattenState(currStateIdx, endStateIdx, envVariables)

flatState = zeros(envVariables.Size^2*3,1);
flatState(currStateIdx) = 1;
flatState(envVariables.Size^2+endStateIdx) = 1;

if envVariables.TrainWithObstacles && envVariables.CheckObstacle
for i = 1:size(envVariables.ObstacleStates,1)
    flatState(envVariables.Size^2*2+state2Idx(envVariables.ObstacleStates(i,:),envVariables.Size)) = 1;
end
end
end