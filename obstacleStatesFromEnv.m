function [obstacleStates checkObstacle] = obstacleStatesFromEnv(Obs, agentEnvVariables, envVariables)

onesInObs = find(Obs==1);
currPos = idx2State(onesInObs(1),envVariables.Size);
currPosLinear = linearMap(onesInObs(1),agentEnvVariables.Size,envVariables.Size);

obstacleStates = [];
j = 0;

if length(onesInObs)>2
    obstacleStateIdxs = onesInObs(3:end)-envVariables.Size^2; % All Obstacles
    
    minCell = currPos - currPosLinear - [1, 1];
    maxCell = currPos + [agentEnvVariables.Size agentEnvVariables.Size] - currPosLinear;    

    for i = 1:size(obstacleStateIdxs,1)
        obsState = idx2State(obstacleStateIdxs(i), envVariables.Size);
        if obsState(1) > minCell(1) && obsState(1) < maxCell(1) && obsState(2) > minCell(2) && obsState(2) < maxCell(2)
            j = j+1;
            obstacleStates(j,:) = idx2State(linearMap(obstacleStateIdxs(i),agentEnvVariables.Size, envVariables.Size),agentEnvVariables.Size);
        end
    end
end

if size(obstacleStates,1) == 0
    checkObstacle = false;
else
    checkObstacle = true;
end
end
