function agentObs = createObsIterative(agentObs, Obs, agentEnvVariables, envVariables)

agentCurrentPos = idx2State(agentObs(1),agentEnvVariables.Size);
agentDesiredPos = idx2State(agentObs(2),agentEnvVariables.Size);
agentError = agentObs(3);

ultCurrentPos = idx2State(Obs(1),envVariables.Size);

relativeAgentCurrentPos(1) = fix(ultCurrentPos(1)/envVariables.Size)+1;
relativeAgentCurrentPos(2) = fix(ultCurrentPos(2)/envVariables.Size)+1;

if mod(ultCurrentPos(1),envVariables.Size)==0
    relativeAgentCurrentPos(1) = relativeAgentCurrentPos(1) - 1;
    jumprow = true;
end
if mod(ultCurrentPos(2),envVariables.Size)==0
    relativeAgentCurrentPos(2) = relativeAgentCurrentPos(2) - 1;
    jumpcol = true;
end

if jumprow && jumpcol
    
agentObs = [state2Idx(relativeAgentCurrentPos, agentEnvVariables.Size);;];
end