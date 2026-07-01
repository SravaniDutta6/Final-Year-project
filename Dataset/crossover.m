function trial = crossover(target, donor, CR)
    numNodes = length(target.positions);
    trial = target;

    % Uniform crossover
    for i = 1:numNodes
        if rand < CR
            trial.positions(i, :) = donor.positions(i, :);
            trial.isCH(i) = donor.isCH(i);
        end
    end
end
