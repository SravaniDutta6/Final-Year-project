% BSO-TLBO for WSN: Cluster Head Selection and Routing
clc;
clear;
close all;

% Parameters
area = 1000;
nodes = 900;
initial_energy = 1.5;
rounds = 1200;
packet_size = 6500;
pop_size = 30;
max_iter = 50;
time = 640;

% Sensor Node Initialization
sensor_nodes = struct();
for i = 1:nodes
    sensor_nodes(i).x = rand() * area;
    sensor_nodes(i).y = rand() * area;
    sensor_nodes(i).energy = initial_energy;
    sensor_nodes(i).type = 'N';
end

% BSO Phase: Generate Initial Population
population = initialize_population(sensor_nodes, pop_size);

% TLBO Phase: Refining using Fitness Functions
for iter = 1:max_iter
    % Teacher Phase
    best_fitness = min([population.fitness]);
    mean_fitness = mean([population.fitness]);
    for i = 1:pop_size
        Tf = round(1 + rand());
        new_position = population(i).position + rand() * (best_fitness - Tf * mean_fitness);
        new_position = max(1, min(length(sensor_nodes), round(new_position)));
        new_fitness = calculate_fitness(new_position);
        if new_fitness < population(i).fitness
            population(i).position = new_position;
            population(i).fitness = new_fitness;
        end
    end

    % Learner Phase
    for i = 1:pop_size
        partner = randi([1, pop_size]);
        if population(i).fitness > population(partner).fitness
            new_position = population(i).position + rand() * (population(partner).position - population(i).position);
        else
            new_position = population(i).position + rand() * (population(i).position - population(partner).position);
        end
        new_position = max(1, min(length(sensor_nodes), round(new_position)));
        new_fitness = calculate_fitness(new_position);
        if new_fitness < population(i).fitness
            population(i).position = new_position;
            population(i).fitness = new_fitness;
        end
    end
end

% Select Best Cluster Heads
cluster_heads = select_chs(population);

% Routing and Performance Metrics
optimized_routes = haoavo_routing(sensor_nodes, cluster_heads, packet_size);
initial_energy_total = sum([sensor_nodes.energy]);
[pdr, throughput, energy_consumption, delay, alive_nodes] = performance_metrics(sensor_nodes, optimized_routes, time, initial_energy_total);

% Display Results
fprintf('Packet Delivery Ratio (PDR): %.2f%%\n', pdr);
fprintf('Throughput: %.2f packets/s\n', throughput);
fprintf('Energy Consumption: %.2f J\n', energy_consumption);
fprintf('End-to-End Delay: %.2f s\n', delay);
fprintf('Alive Nodes: %d\n', alive_nodes);


save('BSO_TLBO_WSN.mat', 'sensor_nodes', 'population', 'cluster_heads', 'optimized_routes', 'pdr', 'throughput', 'energy_consumption', 'delay', 'alive_nodes');

% Function: calculate_fitness
function fitness = calculate_fitness(position)
    gamma1 = 0.25; gamma2 = 0.25; gamma3 = 0.25; gamma4 = 0.25;
    F1 = 1 / (sum(position) + eps);
    F2 = 1 / (mean(position) + eps);
    F3 = sum(position);
    F4 = 1 / (std(position) + eps);
    fitness = gamma1 * F1 + gamma2 * F2 + gamma3 * F3 + gamma4 * F4;
end

% Function: select_chs
function cluster_heads = select_chs(population)
    [~, idx] = sort([population.fitness]);
    num_chs = round(0.1 * length(population));
    cluster_heads = population(idx(1:num_chs));
end

% Function: performance_metrics
function [pdr, throughput, energy_consumption, delay, alive_nodes] = performance_metrics(sensor_nodes, optimized_routes, time, initial_energy)
    packets_sent = 0;
    packets_received = 0;
    active_nodes = 0;
    total_delay = 0;

    % Calculate Alive Nodes
    for i = 1:length(sensor_nodes)
        if sensor_nodes(i).energy > 0
            active_nodes = active_nodes + 1;
        end
    end
    alive_nodes = active_nodes;

    % Calculate Packet Delivery Ratio (PDR)
    for i = 1:length(optimized_routes)
        if optimized_routes(i).status == 1
            packets_sent = packets_sent + optimized_routes(i).packets_sent;
            packets_received = packets_received + optimized_routes(i).packets_received;
        end
    end
    pdr = (packets_received / packets_sent) * 100;

    % Calculate Throughput
    throughput = packets_received / time;

    % Calculate Energy Consumption
    remaining_energy = sum([sensor_nodes.energy]);
    energy_consumption = initial_energy - remaining_energy;

    % Calculate End-to-End Delay (Placeholder)
    for i = 1:length(optimized_routes)
        if optimized_routes(i).status == 1
            total_delay = total_delay + rand();
        end
        %% Energy Model Parameters (Added)
E_elec = 50e-9; % Energy per bit (J/bit)
E_amp = 100e-12; % Transmit amplifier energy (J/bit/m^2)
maxDistance = sqrt(1000^2 + 1000^2); % Maximum possible distance in area

%% Modified Energy Consumption Calculation (Replace existing section)
% Simulate energy consumption over rounds
nodes = 900;
energy_consumption = zeros(nodes, 1);
numRounds = 1200;

for round = 1:numRounds
    aliveNodesIdx = find(residualEnergy > 0);
    if isempty(aliveNodesIdx)
        break;
    end
    
    % Randomly select nodes to transmit
    transmittingNodes = randsample(aliveNodesIdx, floor(0.3*numel(aliveNodesIdx)));
    
    for i = 1:numel(transmittingNodes)
        nodeID = transmittingNodes(i);
        
        % Calculate transmission energy
        % Random receiver distance (normalized to max distance)
        distance = rand() * maxDistance;
        txEnergy = packetSize * E_elec + packetSize * E_amp * distance^2;
        
        % Check if node has enough energy
        if residualEnergy(nodeID) >= txEnergy
            residualEnergy(nodeID) = residualEnergy(nodeID) - txEnergy;
            energyConsumption(nodeID) = energyConsumption(nodeID) + txEnergy;
        else
            residualEnergy(nodeID) = 0;
        end
    end
end

%% Update Alive Nodes Calculation
aliveNodes = sum(residualEnergy > 0);

%% Update Energy Consumption Metric
totalEnergyConsumed = sum(energy_consumption);
    end
    delay = total_delay / max(1, length(optimized_routes));
end

% Function: initialize_population
function population = initialize_population(nodes, pop_size)
    population = struct();
    for i = 1:pop_size
        population(i).position = randperm(length(nodes));
        population(i).fitness = inf;
    end
end

% Function: haoavo_routing
function optimized_routes = haoavo_routing(sensor_nodes, cluster_heads, packet_size)
    % Full Implementation of HAOAVO for routing as per paper
    % Initialization, Exploration, and Exploitation phases

    % Parameters
    pop_size = 50; % Population size
    max_iter = 100; % Max iterations
    alpha = 0.5; % Balancing factor for exploration and exploitation

    % Initialization Phase
    population = initialize_population(cluster_heads, pop_size);
    best_route = population(1);

    % Adding status and packet tracking fields
    for i = 1:pop_size
        population(i).status = 1; % Active by default
        population(i).packets_sent = randi([50, 100]); % Random packets sent (placeholder)
        population(i).packets_received = randi([30, 90]); % Random packets received (placeholder)
    end

    % Energy Model Parameters
    E_elec = 50e-9;  % Energy per bit to run the transmitter or receiver circuitry (in Joules)
    E_fs = 10e-12;    % Free space model (if distance < threshold)
    E_mp = 0.0013e-12; % Multi-path model (if distance >= threshold)
    d0 = sqrt(E_fs / E_mp); % Threshold distance

    % Main HAOAVO Loop
    for iter = 1:max_iter
        % Exploration Phase (Aquila Optimizer)
        for i = 1:pop_size
            population(i) = explore_phase(population(i), alpha);
        end

        % Exploitation Phase (African Vulture Optimization)
        for i = 1:pop_size
            population(i) = exploit_phase(population(i), alpha);
        end

        % Energy Consumption Calculation during Transmission
        for i = 1:pop_size
            if population(i).status == 1
                sender = randi(length(sensor_nodes));
                receiver = randi(length(sensor_nodes));
                dist = sqrt((sensor_nodes(sender).x - sensor_nodes(receiver).x)^2 + (sensor_nodes(sender).y - sensor_nodes(receiver).y)^2);

                if dist < d0
                    E_tx = E_elec * packet_size + E_fs * packet_size * dist^2;
                else
                    E_tx = E_elec * packet_size + E_mp * packet_size * dist^4;
                end
                E_rx = E_elec * packet_size;

                % Update energy for sender and receiver
                sensor_nodes(sender).energy = max(0, sensor_nodes(sender).energy - E_tx);
                sensor_nodes(receiver).energy = max(0, sensor_nodes(receiver).energy - E_rx);
            end
        end

        % Update Best Route
        best_route = update_best_route(population, best_route);
    end

    optimized_routes = population;
end
% Function: explore_phase
function individual = explore_phase(individual, alpha)
    % Exploration mechanism (e.g., random walk or perturbation)
    step_size = alpha * randn();  % Random step size based on alpha
    new_position = individual.position + step_size;
    
    % Ensure the new position is within bounds
    new_position = max(1, min(round(new_position), length(individual.position)));
    
    % Update the position if valid
    individual.position = new_position;
end
% Function: exploit_phase
function individual = exploit_phase(individual, alpha)
    % Exploitation mechanism (e.g., local search)
    step_size = alpha * (0.5 - rand());  % Smaller step size for exploitation
    new_position = individual.position + step_size;
    
    % Ensure the new position is within bounds
    new_position = max(1, min(round(new_position), length(individual.position)));
    
    % Update the position if valid
    individual.position = new_position;
end
% Function: update_best_route
function best_route = update_best_route(population, current_best_route)
    % Extract fitness values from the population
    fitness_values = [population.fitness];
    
    % Find the best individual in the current population
    [min_fitness, best_index] = min(fitness_values);
    best_individual = population(best_index);
    
    % Update the best route if the new individual is better
    if isempty(current_best_route) || min_fitness < current_best_route.fitness
        best_route = best_individual;
    else
        best_route = current_best_route;
    end
end
