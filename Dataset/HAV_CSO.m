function HAV_CSO
    % Parameters
    numNodes = 200;
    maxIterations = 100;
    popSize = 40; % Population size
    MR = 0.3;     % Mutation rate for virus
    CDC = 0.5;    % Seeking mode probability for CSO

    % Initialize population
    population = initializePopulation(popSize, numNodes);

    % Optimization loop
    for iter = 1:maxIterations
        % Virus Infection and Mutation
        for i = 1:popSize
            if rand < MR
                population(i) = virusMutation(population(i));
            end
        end

        % Cat Swarm Optimization: Seeking and Tracing modes
        for i = 1:popSize
            if rand < CDC
                population(i) = seekingMode(population(i));
            else
                population(i) = tracingMode(population(i));
            end
        end

        % Evaluate fitness
        population = evaluateFitness(population);

        % Best solution
        [bestFitness, bestIdx] = min([population.fitness]);
        bestSolution = population(bestIdx);

        disp(['Iteration ', num2str(iter), ': Best Fitness = ', num2str(bestFitness)]);
    end
end
function population = evaluateFitness(population)
    numNodes = size(population(1).positions, 1);

    for i = 1:length(population)
        positions = population(i).positions;
        isCH = population(i).isCH;

        % Fix: Ensure logical indexing for isCH
        if ~islogical(isCH)
            isCH = isCH > 0;  % Convert to logical if not already
        end

        % Fix: Check if there are any cluster heads
        if any(isCH)
            % Compute intra-cluster distances only if there are cluster heads
            intraClusterDist = 0;
            for j = 1:numNodes
                if ~isCH(j)  % If not a cluster head
                    % Calculate distance to nearest CH
                    chPositions = positions(isCH, :);
                    distances = vecnorm(chPositions - positions(j, :), 2, 2);
                    intraClusterDist = intraClusterDist + min(distances);
                end
            end

            % Fitness: Minimize distance + energy consumption
            energyConsumption = sum(population(i).energy);
            population(i).fitness = 1 / (intraClusterDist + energyConsumption + 1e-6);
        else
            % Penalize solutions without any CH
            population(i).fitness = 1e-6;  % Small penalty fitness
        end
    end
end

