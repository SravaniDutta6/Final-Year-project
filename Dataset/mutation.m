function donor = mutation(population, idx, F)
    popSize = length(population);
    indices = randperm(popSize, 3);
    while any(indices == idx)
        indices = randperm(popSize, 3);
    end

    % Differential mutation
    donor.positions = population(indices(1)).positions + ...
                      F * (population(indices(2)).positions - population(indices(3)).positions);
    donor.isCH = round(rand(size(population(1).isCH))); % Randomly mutate CH status
    donor.fitness = inf;
end
