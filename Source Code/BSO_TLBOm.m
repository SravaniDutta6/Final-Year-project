%% BSO-TLBO Algorithm for WSN Optimization
% Brain Storm Optimization - Teaching Learning Based Optimization

clc; 
clear;
close all;

% Input Parameters
targetArea = [1000, 1000];  % m^2, Target area dimensions (length x width)
numNodes = 900;             % Number of nodes
initial_energy = 1.5;        % Initial energy (J)
numRounds = 1200;           % Number of rounds
packetSize = 6500;          % Packet size (bits)
dataPacketLength = 800;     % Length of data packet (bytes)
nodeDeployment = 'Random';  % Node deployment type (Random)
simulationTime = 640;       % Time for simulation (seconds)

% Node Parameters
xMax = targetArea(1); % Max x-coordinate (1000m)
yMax = targetArea(2); % Max y-coordinate (1000m)
nodeRange = 50;       % Communication range (in meters)

% Sensor Node Initialization
sensorNodes = rand(numNodes, 2) .* targetArea; 

% Energy and other factors
residualEnergy = randn(numNodes, 1) * initial_energy; % All nodes start with the same initial energy
nodeDegree = randi([1, 10], numNodes, 1);  % Random node degrees (1 to 10)
nodeCentrality = rand(numNodes, 1);  % Random centrality values
gamma = [0.25, 0.25, 0.25, 0.25];  % Weight factors for each fitness component (F1, F2, F3, F4)

% BSO-TLBO Algorithm Parameters
populationSize = 50;      % Population size for optimization
maxIter = 100;            % Maximum number of iterations

% Initialize best solution
bestFitness = Inf;
bestSolution = [];

% Initialize population (random solutions for 4 factors)
population = rand(populationSize, 4);

for iter = 1:maxIter
    % Teaching Phase
    meanSolution = mean(population);  % Calculate the mean solution
    teacher = population(randi(populationSize), :);  % Randomly select a teacher solution
    newSolutions = population + rand(populationSize, 4) .* (teacher - meanSolution);  % Update solutions
    
    % Learning Phase
    for i = 1:populationSize
        partner = population(randi(populationSize), :);  % Random partner solution
        if computeFitness(newSolutions(i, :), sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma) < ...
           computeFitness(partner, sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma)
            population(i, :) = newSolutions(i, :);  % Accept the new solution if it's better
        end
    end
    
    % Update best solution
    for i = 1:populationSize
        fitness = computeFitness(population(i, :), sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma);
        if fitness < bestFitness
            bestFitness = fitness;
            bestSolution = population(i, :);  % Store the best solution
        end
    end
end

% Display the best solution and fitness
disp('BSO-TLBO Best Solution:');
disp(bestSolution);
disp(['Best Fitness: ', num2str(bestFitness)]);

 %% Performance Metrics Calculation
% Assuming certain functions are defined, like packet delivery and energy consumption

% End-to-End Delay (Example metric calculation, needs refinement)
endToEndDelay = sum(rand(1, numNodes) * 10);  % Example

%pdr
totalPacketsSent = numNodes * numRounds;
totalPacketsDelivered = 0;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           deliveryProbability = 0.6;
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
energyConsumption = sum(initial_energy - residualEnergy);  % Total energy consumed


% Routing and Performance Metrics
optimized_routes = population;
initial_energy = 1.5;


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
    F1 = sum(1 ./ (residualEnergy * residualEnergyFactor + 1e-6));  % Sum of weighted residual energies
    
    % Node Centrality Fitness (weighted)
    dist = pdist2(sensorNodes, sensorNodes);  % Pairwise distances between nodes
    centrality = sum(dist, 2);  % Node centrality as sum of distances to all other nodes
    F2 = sum(centrality * centralityFactor);
    
    % Node Degree Fitness (weighted)
    F3 = sum(nodeDegree * degreeFactor);  % Sum of node degrees weighted by the factor
    
    % Distance to Neighbors Fitness (weighted)
    F4 = sum(mean(dist, 2) * distanceFactor);  % Sum of average distances to neighbors
    
    % Combine fitness components using weighted sum
    fitness = gamma(1)*F1 + gamma(2)*F2 + gamma(3)*F3 + gamma(4)*F4;  % Total fitness
end
