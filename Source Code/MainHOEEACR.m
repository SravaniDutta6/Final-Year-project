% Main Simulation Code
% Parameters
nodes = 100; % Number of sensor nodes
maxRounds = 1200; % Maximum rounds
initial_energy = 1.5; % Initial energy for each node in Joules
energyPerTransmission = 0.1; % Energy consumed per transmission
populationSize = 50; % Population size (food sources for optimization algorithms)
dim = 4; % Number of optimization dimensions
maxIter = 100; % Maximum iterations for optimization
gamma = [0.25, 0.25, 0.25, 0.25]; % Weights for fitness function components
area = 1000;

% Initialize sensor nodes' positions
% Sensor Node Initialization
sensorNodes = struct();
for i = 1:nodes
    sensorNodes(i).x = rand() * area;
    sensorNodes(i).y = rand() * area;
    sensorNodes(i).energy = initial_energy;
    sensorNodes(i).type = 'N';  % 'N' for normal node, 'CH' for cluster head
end
residualEnergy = rand(numNodes, 1) * initial_energy; % Initial energy for each node
nodeDegree = randi([1, 10], numNodes, 1); % Random degree (1 to 10)
nodeCentrality = rand(numNodes, 1); % Centrality (0 to 1)

% Initialize the best fitness and solution
bestFitness = Inf;
bestSolution = [];

% Initialize food sources (population for optimization)
foodSources = rand(populationSize, dim); % Random initial positions of the food sources

% HOEEACR Algorithm: Genetic Bee Colony (GBC) for Cluster Head Selection
sensorNodes = rand(numNodes, 2) * 100; % Random positions in 100x100 area
nodes = 100;
for iter = 1:maxIter
    % Employed Bee Phase (GBC)
    for i = 1:populationSize
        % Generate a neighbor solution
        neighbor = rand(1, dim);
        
        % Fitness computation for current and neighbor solutions
        fitnessCurrent = computeFitness(neighbor, sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma);
        fitnessNeighbor = computeFitness(neighbor, sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma);
        
        % Update solution if the neighbor has better fitness
        if fitnessNeighbor < fitnessCurrent
            foodSources(i, :) = neighbor;
        end
    end
    
    % Onlooker Bee Phase (GBC)
    fitnessValues = zeros(populationSize, 1);
    for i = 1:populationSize
        fitnessValues(i) = computeFitness(foodSources(i, :), sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma);
    end
    prob = fitnessValues / sum(fitnessValues);
    for i = 1:populationSize
        if rand < prob(i)
            % Perform crossover to generate offspring
            parent1 = foodSources(i, :);
            parent2 = foodSources(randi(populationSize), :);
            offspring = (parent1 + parent2) / 2;
            foodSources(i, :) = offspring;
        end
    end
    
    % Scout Bee Phase (GBC)
    for i = 1:populationSize
        if rand < 0.1
            foodSources(i, :) = rand(1, dim); % Random new solution
        end
    end
    
    % Update the best solution
    for i = 1:populationSize
        fitness = computeFitness(foodSources(i, :), sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma);
        if fitness < bestFitness
            bestFitness = fitness;
            bestSolution = foodSources(i, :);
        end
    end
end

% Output the best solution
disp('Best Solution:');
disp(bestSolution);
disp(['Best Fitness: ', num2str(bestFitness)]);

% Visualization
figure(15);
hold on;
grid on;
axis([0 100 0 100]);
title('Wireless Sensor Network with Cluster Heads');
xlabel('X Coordinate');
ylabel('Y Coordinate');

% Plot sensor nodes
scatter(sensorNodes(:, 1), sensorNodes(:, 2), 50, 'b', 'filled', 'DisplayName', 'Sensor Nodes');

bestCHPosition = (sum(sensorNodes, 1) / numNodes) * bestSolution(1) + ...
                 (mean(sensorNodes, 1) * bestSolution(2)) + ...
                 (sum(sensorNodes, 1) / numNodes) * bestSolution(3) + ...
                 (mean(mean(pdist2(sensorNodes, sensorNodes))) * bestSolution(4));

% Ensure bestCHPosition is a 2D vector (row vector with 2 elements)
bestCHPosition = bestCHPosition(:)'; % Make sure it’s a row vector (1x2)

% If you want to highlight the best cluster head
scatter(bestCHPosition(1), bestCHPosition(2), 300, 'r', 'filled', 'DisplayName', 'Best Cluster Head');
% Connect sensor nodes to the best cluster head
for i = 1:size(sensorNodes, 1)
    plot([sensorNodes(i, 1), bestCHPosition(1)], [sensorNodes(i, 2), bestCHPosition(2)], 'g--');
end

% Add legend
legend('Sensor nodes', 'Cluster head', 'Location', 'northeast', 'FontSize', 8);
hold off;

              

%% Function Definitions
% Fitness function to evaluate the quality of solutions
function fitness = computeFitness(solution, sensorNodes, residualEnergy, nodeDegree, nodeCentrality, gamma)
    % Extract solution components
    residualEnergyFactor = solution(1);
    centralityFactor = solution(2);
    degreeFactor = solution(3);
    distanceFactor = solution(4);
    
    % Residual Energy Fitness (weighted by solution factor)
    F1 = sum(1 ./ (residualEnergy * residualEnergyFactor + 1e-6));
    
    % Node Centrality Fitness (weighted by solution factor)
    dist = pdist2(sensorNodes, sensorNodes); % Pairwise distances
    centrality = sum(dist, 2); % Node centrality as sum of distances
    F2 = sum(centrality * centralityFactor);
    
    % Node Degree Fitness (weighted by solution factor)
    F3 = sum(nodeDegree * degreeFactor);
    
    % Distance to Neighbors Fitness (weighted by solution factor)
    F4 = sum(mean(dist, 2) * distanceFactor);
    
    % Combine fitness components using weighted sum
    fitness = gamma(1)*F1 + gamma(2)*F2 + gamma(3)*F3 + gamma(4)*F4;
end

% Function to simulate energy consumption and check if all nodes are dead
function [allDead, nodeEnergy] = checkNodeEnergy(nodeEnergy, energyPerTransmission)
    nodeEnergy = nodeEnergy - energyPerTransmission;
    allDead = all(nodeEnergy <= 0); % Check if all nodes are dead
end



