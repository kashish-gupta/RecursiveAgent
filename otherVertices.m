function otherVertexIdxs = otherVertices(currState, gridSizeLocal, gridSizeGlobal)

currStateIdx = state2Idx(currState,gridSizeGlobal);
if mod(currState,gridSizeLocal) == [1,1]
    otherVertexIdxs = [currStateIdx + (gridSizeLocal-1);
                       currStateIdx + (gridSizeLocal-1)*gridSizeGlobal;
                       currStateIdx + (gridSizeLocal-1) + (gridSizeLocal-1)*gridSizeGlobal];
    
elseif mod(currState,gridSizeLocal) == [1,0]
    otherVertexIdxs = [currStateIdx - (gridSizeLocal-1);
                       currStateIdx + (gridSizeLocal-1)*gridSizeGlobal;
                       currStateIdx - (gridSizeLocal-1) + (gridSizeLocal-1)*gridSizeGlobal];
                   
elseif mod(currState,gridSizeLocal) == [0,1]
    otherVertexIdxs = [currStateIdx + (gridSizeLocal-1);
                       currStateIdx - (gridSizeLocal-1)*gridSizeGlobal;
                       currStateIdx + (gridSizeLocal-1) - (gridSizeLocal-1)*gridSizeGlobal];
                   
elseif mod(currState,gridSizeLocal) == [0,0]
    otherVertexIdxs = [currStateIdx - (gridSizeLocal-1);
                       currStateIdx - (gridSizeLocal-1)*gridSizeGlobal;
                       currStateIdx - (gridSizeLocal-1) - (gridSizeLocal-1)*gridSizeGlobal];
                   
end

end