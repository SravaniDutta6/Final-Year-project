function IMDEACBR
    % Parameters
    numNodes = 200;
    maxGenerations = 100;
    popSize = 30;
    F = 0.5;  % Mutation factor
    CR = 0.9; % Crossover rate

    % Initialize population
    population = initializePopulation(popSize, numNodes);

    % Optimization loop
    for gen = 1:maxGenerations
        for i = 1:popSize
            % Mutation
            donor = mutation(population, i, F);

            % Crossover
            trial = crossover(population(i), donor, CR);

            % Selection
            trial = evaluateFitness(trial);
            if trial.fitness < population(i).fitness
                population(i) = trial;
            end
        end

        % Best solution
        [bestFitness, bestIdx] = min([population.fitness]);
        bestSolution = population(bestIdx);

        disp(['Generation ', num2str(gen), ': Best Fitness = ', num2str(bestFitness)]);
    end
end
