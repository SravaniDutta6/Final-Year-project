%% Initialize Parameters
targetArea = [1000, 1000];  % m^2, Target area dimensions (length x width)
numNodes = 900;             % Number of nodes
initialEnergy = 1.5;        % Initial energy (J)
numRounds = 1200;           % Number of rounds
packetSize = 6500;          % Packet size (bits)
dataPacketLength = 800;     % Length of data packet (bytes)
nodeDeployment = 'Random';  % Node deployment type (Random)
simulationTime = 640;       % Time for simulation (seconds)

% Firefly Algorithm Parameters
alpha = 0.5; % Randomness factor
beta0 = 1;  % Attractiveness constant
gammaFA = 1; % Light absorption coefficient

% Initialize sensor nodes and network
sensorNodes = rand(numNodes, 2) .* targetArea;  % Random node deployment in area
residualEnergy = randn(numNodes, 1) * initialEnergy;  % Initial energy
nodeDegree = randi([1, 10], numNodes, 1);
nodeCentrality = rand(numNodes, 1);

% Initialize Performance Metrics
endToEndDelay = 0;
packetDeliveryRatio = 0;
throughput = 0;
aliveNodes = numNodes;
energyConsumption = 1.5;

% Initialization for all algorithms
populationSize = 50;
maxIter = 100;
gamma = [0.25, 0.25, 0.25, 0.25];

%% Algorithm - Firefly Algorithm (EECRAIFA)
fireflies = rand(populationSize, 4);
intensities = zeros(populationSize, 1);

for iter = 1:maxIter
    % Compute fitness for fireflies
    for i = 1:populationSize
        intensities(i) = computeFitness(fireflies(i, :), sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma);
    end
    
    % Move fireflies based on attractiveness
    for i = 1:populationSize
        for j = 1:populationSize
            if intensities(j) < intensities(i)
                r = norm(fireflies(i, :) - fireflies(j, :));
                beta = beta0 * exp(-gammaFA * r^2);
                fireflies(i, :) = fireflies(i, :) + beta * (fireflies(j, :) - fireflies(i, :)) + alpha * (rand(1, 4) - 0.5);
            end
        end
    end
end

% Find best firefly solution
[bestFAFitness, bestIndex] = min(intensities);
bestFASolution = fireflies(bestIndex, :);
disp('EECRAIFA Best Solution:');
disp(bestFASolution);
disp(['Best Fitness: ', num2str(bestFAFitness)]);

%% Performance Metrics Calculation
% Assuming certain functions are defined, like packet delivery and energy consumption

% End-to-End Delay (Example metric calculation, needs refinement)
endToEndDelay = sum(rand(1, numNodes) * 10); % Example

numNodes = 900; % Example number of nodes
numRounds = 1200; % Example number of rounds
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           deliveryProbability = 0.6; 
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
%% Results (Updated)
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
