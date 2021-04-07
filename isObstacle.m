function isObst = isObstacle(state, envVariables)

if envVariables.TrainWithObstacles && envVariables.CheckObstacle
    if sum(ismember(envVariables.ObstacleStates,state,'rows'))
        isObst = true;
    else
        isObst = false;
    end
else
    isObst = false;
end

end