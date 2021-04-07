function iVer = isVertex(stateIdx, gridSizeLocal, gridSizeGlobal)

state = idx2State(stateIdx,gridSizeGlobal);
if sum(mod(state(1),gridSizeLocal) == [0,1]) && sum(mod(state(2),gridSizeLocal) == [0,1])
    iVer = true;
else
    iVer = false;
end
end
