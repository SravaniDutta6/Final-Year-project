function mutatedVirus = virusMutation(virus)
    mutationRate = 0.1;  % Probability of mutation
    numNodes = size(virus.positions, 1);

    % Copy original virus
    mutatedVirus = virus;

    % Apply mutation to positions and cluster head status
    for i = 1:numNodes
        if rand < mutationRate
            % Randomly perturb the position slightly
            mutatedVirus.positions(i, :) = virus.positions(i, :) + randn(1, 2) * 5;
            
            % Ensure positions remain within bounds (200x200 area)
            mutatedVirus.positions(i, :) = max(0, min(200, mutatedVirus.positions(i, :)));
        end
        if rand < mutationRate
            % Flip cluster head status
            mutatedVirus.isCH(i) = ~virus.isCH(i);
        end
    end
end
