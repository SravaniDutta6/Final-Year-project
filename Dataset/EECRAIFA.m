function EECRAIFA
    % Parameters
    numNodes = 200;
    maxIterations = 100;
    alpha = 0.2; % Attractiveness
    beta = 1;    % Absorption coefficient
    gamma = 1;   % Light absorption coefficient

    % Initialize fireflies
    fireflies = initializeFireflies(numNodes);

    for iter = 1:maxIterations
        % Move fireflies based on attractiveness
        for i = 1:length(fireflies)
            for j = 1:length(fireflies)
                if fireflies(j).fitness < fireflies(i).fitness
                    fireflies(i) = moveFirefly(fireflies(i), fireflies(j), beta, gamma);
                end
            end
        end

        % Evaluate fitness
        fireflies = evaluateFitness(fireflies);

        % Best solution
        [bestFitness, bestIdx] = min([fireflies.fitness]);
        bestSolution = fireflies(bestIdx);

        disp(['Iteration ', num2str(iter), ': Best Fitness = ', num2str(bestFitness)]);
    end
end
