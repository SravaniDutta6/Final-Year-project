%% IMD-EACBR Algorithm
% Improved Multi-Dimensional Energy-Aware Cluster-Based Routing

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

% IMD-EACBR Algorithm Parameters
mutationRate = 0.2;       % Mutation rate
crossoverRate = 0.7;      % Crossover rate
populationSize = 50;      % Population size for genetic algorithm
maxIter = 100;            % Maximum number of iterations for optimization

% Initialize population
IMD_population = rand(populationSize, 4);  % Randomized initial population

for iter = 1:maxIter
    % Evaluate fitness
    fitnessValues = arrayfun(@(i) computeFitness(IMD_population(i, :), sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma), 1:populationSize);
    
    % Selection: Sort the population based on fitness values
    [~, sortedIndices] = sort(fitnessValues);
    IMD_population = IMD_population(sortedIndices, :);
    
    % Crossover: Apply crossover operation to generate new solutions
    for i = 1:2:populationSize-1
        if rand < crossoverRate
            crossoverPoint = randi(4);
            temp = IMD_population(i, 1:crossoverPoint);
            IMD_population(i, 1:crossoverPoint) = IMD_population(i+1, 1:crossoverPoint);
            IMD_population(i+1, 1:crossoverPoint) = temp;
        end
    end
    
    % Mutation: Apply mutation operation to introduce diversity
    for i = 1:populationSize
        if rand < mutationRate
            mutationPoint = randi(4);
            IMD_population(i, mutationPoint) = rand;
        end
    end
end

% Evaluate the best fitness and solution
bestIMDFitness = computeFitness(IMD_population(1, :), sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma);
bestIMDSolution = IMD_population(1, :);

% Display the best solution and fitness
disp('IMD-EACBR Best Solution:');
disp(bestIMDSolution);
disp(['Best Fitness: ', num2str(bestIMDFitness)]);
save('IMD_EACBR2.mat', 'sensorNodes');

%% Performance Metrics Calculation
% Assuming certain functions are defined, like packet delivery and energy consumption

% End-to-End Delay (Example metric calculation, needs refinement)
endToEndDelay = sum(rand(1, numNodes) * 10); % Example

% Packet Delivery Ratio (PDR)
totalPacketsSent = numNodes * numRounds;
packetsDelivered = sum(rand(1, numNodes) > 0.1);  % Example delivery rate
packetDeliveryRatio = (packetsDelivered / totalPacketsSent) * 100;

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
    dist = pdist2(sensorNodes, sensorNodes); % Pairwise distances between nodes
    centrality = sum(dist, 2); % Node centrality as sum of distances
    F2 = sum(centrality * centralityFactor);
    
    % Node Degree Fitness (weighted)
    F3 = sum(nodeDegree * degreeFactor);
    
    % Distance to Neighbors Fitness (weighted)
    F4 = sum(mean(dist, 2) * distanceFactor);
    
    % Combine fitness components using weighted sum
    fitness = gamma(1)*F1 + gamma(2)*F2 + gamma(3)*F3 + gamma(4)*F4;
end
