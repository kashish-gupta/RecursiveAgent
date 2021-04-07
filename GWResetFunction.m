function [InitialObservation, LoggedSignal] = GWResetFunction(envVariables)

ROIFactor = envVariables.ROIFactor;

gridSize = envVariables.Size;

cellOverlapCheck = true;
if envVariables.DynamicStartState == true
    while cellOverlapCheck == true
     rowStartCell = randi(gridSize);
     colStartCell = randi(gridSize);
     startCell = [rowStartCell, colStartCell];
    
     cellOverlapCheck = isObstacle(startCell,envVariables);
    end
else
    startCell = envVariables.StartState;
end


cellOverlapCheck = true;
if envVariables.DynamicEndState == true
while cellOverlapCheck == true
    if ROIFactor > 0
     rowEndCell = randi([max(1,rowStartCell-ROIFactor), min(gridSize,rowStartCell+ROIFactor)]);
     colEndCell = randi([max(1,colStartCell-ROIFactor), min(gridSize,colStartCell+ROIFactor)]);
    else
     rowEndCell = randi(gridSize);
     colEndCell = randi(gridSize);
    end

endCell = [rowEndCell, colEndCell];
cellOverlapCheck = startCell==endCell | isObstacle(endCell,envVariables);
end
else
    endCell = envVariables.EndState;
end

if isObstacle(endCell,envVariables) || isObstacle(startCell,envVariables)
    disp("Error: endCell or startCell overlaps with an obstacle");
end
startCellIdx = state2Idx(startCell, gridSize);
endCellIdx = state2Idx(endCell, gridSize);
cellError = sum(abs(endCell-startCell));

% Return initial environment state variables as logged signals.
if envVariables.Type == 1
LoggedSignal.State = [cellError];
elseif envVariables.Type == 2
LoggedSignal.State = [endCellIdx; cellError];
elseif envVariables.Type == 3
LoggedSignal.State = [startCellIdx; endCellIdx; cellError];
end

InitialObservation = LoggedSignal.State;

end
