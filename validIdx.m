function vIdx = validIdx(stateIdx, gridSize)

if stateIdx >=1 && stateIdx <= gridSize^2
    vIdx = true;
else
    vIdx = false;
end
end
