%% Initialize Parameters
targetArea = [1000, 1000];  % m^2, Target area dimensions (length x width)
numNodes = 900;             % Number of nodes
initialEnergy = 1.5;        % Initial energy (J)
numRounds = 1200;           % Number of rounds
packetSize = 6500;          % Packet size (bits)
dataPacketLength = 800;     % Length of data packet (bytes)
nodeDeployment = 'Random';  % Node deployment type (Random)
simulationTime = 640;       % Time for simulation (seconds)

% Initialize sensor nodes and network
sensorNodes = rand(numNodes, 2) .* targetArea;  % Random node deployment in area
residualEnergy = randn(numNodes, 1) * initialEnergy;  % Initial energy
nodeDegree = randi([1, 10], numNodes, 1);
nodeCentrality = rand(numNodes, 1);

% Initialize Performance Metrics
endToEndDelay = 0;
packetDeliveryRatio = 0;
throughput = 0;
aliveNodes = 0;
energyConsumption = 0;

% Initialization for GAPSO-H
populationSize = 50;
maxIter = 100;
gamma = [0.25, 0.25, 0.25, 0.25];

% PSO Parameters
inertiaWeight = 0.7;
c1 = 1.5; c2 = 1.5;  % Cognitive and social components
velocity = zeros(populationSize, 4);
personalBest = rand(populationSize, 4);
personalBestFitness = inf(populationSize, 1);
globalBest = rand(1, 4);  % Initialize global best as a row vector
globalBestFitness = Inf;

%% Algorithm - Hybrid GA-PSO (GAPSO-H)

for iter = 1:maxIter
    % PSO Update - Particle Swarm Optimization
    for i = 1:populationSize
        velocity(i, :) = inertiaWeight * velocity(i, :) + ...
                         c1 * rand * (personalBest(i, :) - rand(1, 4)) + ...
                         c2 * rand * (globalBest - rand(1, 4));
        personalBest(i, :) = personalBest(i, :) + velocity(i, :);

        % Fitness Evaluation
        fitness = computeFitness(personalBest(i, :), sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma);
        
        % Update personal and global best solutions
        if fitness < personalBestFitness(i)
            personalBestFitness(i) = fitness;
            personalBest(i, :) = personalBest(i, :);
        end
        if fitness < globalBestFitness
            globalBestFitness = fitness;
            globalBest = personalBest(i, :);  % Update globalBest
        end
    end

    % GA Crossover and Mutation
    for i = 1:populationSize / 2
        idx1 = randi(populationSize);
        idx2 = randi(populationSize);
        
        % Crossover - Simple averaging
        child = (personalBest(idx1, :) + personalBest(idx2, :)) / 2; 

        % Mutation
        if rand < 0.1  % Mutation probability
            child = child + 0.1 * randn(1, 4);  % Small random mutation
        end

        % Replace one of the parents with the child
        personalBest(idx1, :) = child;
    end
end

% Output Best Solution
disp('GAPSO-H Best Solution:');
disp(globalBest);
disp(['Best Fitness: ', num2str(globalBestFitness)]);

    %% Performance Metrics Calculation
% Assuming certain functions are defined, like packet delivery and energy consumption

% End-to-End Delay (Example metric calculation, needs refinement)
endToEndDelay = sum(rand(1, numNodes) * 10);  % Example

%packetDeliveryRatio
numNodes = 900; % Example number of nodes
numRounds = 1200; % Example number of rounds
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           deliveryProbability = 0.7;
totalPacketsSent = numNodes * numRounds;
totalPacketsDelivered = 0;

for round = 1:numRounds
    packetsDeliveredThisRound = sum(rand(1, numNodes) < deliveryProbability); % packets delivered this round
    totalPacketsDelivered = totalPacketsDelivered + packetsDeliveredThisRound;
end

packetDeliveryRatio = (totalPacketsDelivered / totalPacketsSent) * 100;

% Throughput
throughput = packetsDelivered * dataPacketLength / simulationTime;

% Alive Nodes
aliveNodes = sum(residualEnergy > 0);  % Alive nodes are those with non-zero energy

% Energy Consumption
energyConsumption = sum(initialEnergy - residualEnergy);  % Total energy consumed

%% Results
disp(['End-to-End Delay: ', num2str(endToEndDelay)]);
disp(['Packet Delivery Ratio: ', num2str(packetDeliveryRatio), '%']);
disp(['Throughput: ', num2str(throughput), ' bits/s']);
disp(['Alive Nodes: ', num2str(aliveNodes)]);
disp(['Energy Consumption: ', num2str(energyConsumption), ' J']);

%% Fitness Function Definition
function fitness = computeFitness(solution, sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma)
    % Extract solution components
    residualEnergyFactor = solution(1);
    centralityFactor = solution(2);
    degreeFactor = solution(3);
    distanceFactor = solution(4);
    
    % Residual Energy Fitness (weighted)
    F1 = sum(1 ./ (residualEnergy * residualEnergyFactor + 1e-6));
    
    % Node Centrality Fitness (weighted)
    dist = pdist2(sensorNodes, sensorNodes); % Pairwise distances
    centrality = sum(dist, 2); % Node centrality as sum of distances
    F2 = sum(centrality * centralityFactor);
    
    % Node Degree Fitness (weighted)
    F3 = sum(nodeDegree * degreeFactor);
    
    % Distance to Neighbors Fitness (weighted)
    F4 = sum(mean(dist, 2) * distanceFactor);
    
    % Combine fitness components using weighted sum
    fitness = gamma(1)*F1 + gamma(2)*F2 + gamma(3)*F3 + gamma(4)*F4;
end
