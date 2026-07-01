function population = initializePopulation(popSize, numNodes)
    % Initialize population structure
    for i = 1:popSize
        % Randomly generate node positions (x, y) and cluster head status
        population(i).positions = rand(numNodes, 2) * 200; % Assuming a 200x200m area
        population(i).isCH = randi([0, 1], numNodes, 1);    % 0: Normal node, 1: Cluster Head
        population(i).fitness = inf; % Initial fitness value
    end
end
