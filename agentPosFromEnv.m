function agentPosIdx = agentPosFromEnv(Obs, agentEnvVariables, envVariables)

onesInObs = find(Obs == 1);
posIdx =  onesInObs(1);
agentPosIdx = linearMap(posIdx, agentEnvVariables.Size, envVariables.Size);

end
