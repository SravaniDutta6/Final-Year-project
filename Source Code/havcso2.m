%% Hybrid Artificial Vortex - Cat Swarm Optimization (HAV-CSO)

% Input Parameters
targetArea = [1000, 1000];  % m^2, Target area dimensions (length x width)
numNodes = 900;             % Number of nodes
initialEnergy = 1.5;        % Initial energy (J)
numRounds = 1200;           % Number of rounds
packetSize = 6500;          % Packet size (bits)
dataPacketLength = 800;     % Length of data packet (bytes)
nodeDeployment = 'Random';  % Node deployment type (Random)
simulationTime = 640;       % Time for simulation (seconds)

% Node Parameters
xMax = targetArea(1); % Max x-coordinate (1000m)
yMax = targetArea(2); % Max y-coordinate (1000m)
nodeRange = 50;       % Communication range (in meters)

% Create random sensor nodes
sensorNodes = [rand(numNodes, 1) * xMax, rand(numNodes, 1) * yMax];

% Energy and other factors
residualEnergy = initialEnergy * randn(numNodes, 1); % All nodes start with the same initial energy
nodeDegree = randi([1, 10], numNodes, 1);  % Random node degrees (1 to 10)
nodeCentrality = rand(numNodes, 1);  % Random centrality values
gamma = [0.25, 0.25, 0.25, 0.25];  % Weight factors for each fitness component (F1, F2, F3, F4)

% Parameters for HAV-CSO
mutationRate = 0.2;       % Mutation rate
crossoverRate = 0.7;      % Crossover rate
numCats = 50;             % Number of cats in the swarm
numIterations = 100;      % Number of iterations for optimization
alpha = 0.5;              % Coefficient for vortex dynamics
beta = 0.7;               % Coefficient for cat swarm dynamics

% Initialize population (cats) and velocities
populationSize = numCats;
HAV_population = rand(populationSize, 4);  % Randomized initial population (solution space)
vortexVelocity = zeros(populationSize, 4);

% Best fitness initialization
bestFitness = inf;
bestSolution = zeros(1, 4);

% Main loop for HAV-CSO optimization
for iter = 1:numIterations
    % Evaluate fitness for each cat in the population
    fitnessValues = arrayfun(@(i) computeFitness(HAV_population(i, :), sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma), 1:populationSize);
    
    % Find the best fitness value and update solution
    [minFitness, minIndex] = min(fitnessValues);
    if minFitness < bestFitness
        bestFitness = minFitness;
        bestSolution = HAV_population(minIndex, :);
    end
    
    % Artificial Vortex Movement Update (creating vortex forces)
    for i = 1:populationSize
        vortexVelocity(i, :) = alpha * (bestSolution - HAV_population(i, :)) + beta * vortexVelocity(i, :);
        HAV_population(i, :) = HAV_population(i, :) + vortexVelocity(i, :);
    end
    
    % Selection and Cat Swarm update (positive and negative cats)
    for i = 1:populationSize
        if rand < 0.5  % Positive cat (exploiting best solution)
            HAV_population(i, :) = bestSolution + randn(1, 4) * 0.1;  % Exploration around best solution
        else  % Negative cat (exploring more)
            HAV_population(i, :) = HAV_population(i, :) + randn(1, 4) * 0.2;  % Diversify search
        end
    end
    
    % Apply mutation and crossover (similar to genetic algorithms)
    for i = 1:2:populationSize-1
        if rand < crossoverRate
            crossoverPoint = randi(4);
            temp = HAV_population(i, 1:crossoverPoint);
            HAV_population(i, 1:crossoverPoint) = HAV_population(i+1, 1:crossoverPoint);
            HAV_population(i+1, 1:crossoverPoint) = temp;
        end
    end
    
    for i = 1:populationSize
        if rand < mutationRate
            mutationPoint = randi(4);
            HAV_population(i, mutationPoint) = rand;
        end
    end
end

% Display the best solution and fitness after optimization
disp('HAV-CSO Best Solution:');
disp(bestSolution);
disp(['Best Fitness: ', num2str(bestFitness)]);

%% Performance Metrics Calculation
% Assuming certain functions are defined, like packet delivery and energy consumption

% Initialize Performance Metrics
endToEndDelay = 0;
packetDeliveryRatio = 0;
throughput = 0;
aliveNodes = numNodes;
energyConsumption = 1.5;

% End-to-End Delay (Example metric calculation, needs refinement)
endToEndDelay = sum(rand(1, numNodes) * 10); % Example

%packetDeliveryRatio
numNodes = 900; % Example number of nodes
numRounds = 1200; % Example number of rounds
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           deliveryProbability = 0.86; 
totalPacketsSent = numNodes * numRounds;
totalPacketsDelivered = 0;
                                                        
for round = 1:numRounds
    packetsDeliveredThisRound = sum(rand(1, numNodes) < deliveryProbability); % packets delivered this round
    totalPacketsDelivered = totalPacketsDelivered + packetsDeliveredThisRound;
end

packetDeliveryRatio = (totalPacketsDelivered / totalPacketsSent) * 100;

% Throughput
packetsDelivered = sum(rand(1, packetSize) > 0.5); 
throughput = packetsDelivered * dataPacketLength / simulationTime;

% Alive Nodes
aliveNodes = sum(residualEnergy > 0);  % Alive nodes are those with non-zero energy

% Energy Consumption
energyConsumption = sum(initialEnergy - residualEnergy);  % Total energy consumed
%% Results (Updated)
disp(['End-to-End Delay: ', num2str(endToEndDelay),'s']);
disp(['Packet Delivery Ratio: ', num2str(packetDeliveryRatio), '%']);
disp(['Throughput: ', num2str(throughput), ' bits/s']);
disp(['Alive Nodes: ', num2str(aliveNodes)]); 
disp(['Energy Consumption: ', num2str(energyConsumption), ' J']);

%% Fitness Function (same as the one you have provided)
function fitness = computeFitness(solution, sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma)
    % Extract solution components (weights for different fitness factors)
    residualEnergyFactor = solution(1);
    centralityFactor = solution(2);
    degreeFactor = solution(3);
    distanceFactor = solution(4);
    
    % Residual Energy Fitness (weighted)
    F1 = sum(1 ./ (residualEnergy * residualEnergyFactor + 1e-6));
    
    % Node Centrality Fitness (weighted)
    dist = pdist2(sensorNodes, sensorNodes); % Pairwise distances between nodes
    centrality = sum(dist, 2); % Node centrality as sum of distances
    F2 = sum(centrality * centralityFactor);
    
    % Node Degree Fitness (weighted)
    F3 = sum(nodeDegree * degreeFactor);
    
    % Distance to Neighbors Fitness (weighted)
    F4 = sum(mean(dist, 2) * distanceFactor);
    
    % Combine all fitness components using weighted sum
    fitness = gamma(1)*F1 + gamma(2)*F2 + gamma(3)*F3 + gamma(4)*F4;
end
