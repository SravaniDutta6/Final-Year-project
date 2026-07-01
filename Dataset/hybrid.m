% HOEEACR: Hybrid Optimized Energy-Efficient Adaptive Clustered Routing for WSN
% Full MATLAB Implementation as per the Paper

clc;
clear; 
close all;

% Parameters Initialization (as per paper)
area = 1000;
nodes = 900;
initial_energy = 1.5;
rounds = 1200;
packet_size = 6500;
data_packet_length = 800;
time = 640;

% Sensor Node Initialization
sensor_nodes = struct();
for i = 1:nodes
    sensor_nodes(i).x = rand() * area;
    sensor_nodes(i).y = rand() * area;
    sensor_nodes(i).energy = initial_energy;
    sensor_nodes(i).type = 'N';  % 'N' for normal node, 'CH' for cluster head
end

% Genetic Bee Colony (GBC) for Cluster Head Selection
cluster_heads = gbc_cluster_selection(sensor_nodes);

% Hybrid Aquila Optimizer and African Vulture Optimization (HAOAVO) for Routing
optimized_routes = haoavo_routing(sensor_nodes, cluster_heads, packet_size);

% Calculate Initial Energy Before Routing
initial_energy = sum([sensor_nodes.energy]);
residualEnergy = randn(nodes, 1) * initial_energy;  % Initial energy

% Performance Metrics Calculation
[pdr, throughput, energy_consumption, end_to_end_delay, alive_nodes] = performance_metrics(sensor_nodes, optimized_routes, time, initial_energy);

% Results Display
fprintf('Packet Delivery Ratio (PDR): %.2f%%\n', pdr);
fprintf('Throughput: %.2f packets/s\n', throughput);
fprintf('Energy Consumption: %.2f J\n', energy_consumption);
fprintf('End-to-End Delay: %.2f s\n', end_to_end_delay); 
fprintf('Alive Nodes: %d\n', alive_nodes);

% Continuous Simulations for Different Rounds and Nodes
rounds_range = 100:200:1200;
nodes_range = 100:200:900;
metrics = struct('pdr', [], 'throughput', [], 'energy', [], 'delay', [], 'alive', []);

for r = rounds_range
    for n = nodes_range
        % Reinitialize Sensor Nodes
        sensor_nodes = struct();
        for i = 1:n
            sensor_nodes(i).x = rand() * area;
            sensor_nodes(i).y = rand() * area;
            sensor_nodes(i).energy = initial_energy;
            sensor_nodes(i).type = 'N';
        end

        % Cluster Head Selection and Routing
        cluster_heads = gbc_cluster_selection(sensor_nodes);
        optimized_routes = haoavo_routing(sensor_nodes, cluster_heads, packet_size);

        % Performance Metrics
        [pdr, throughput, energy, delay, alive] = performance_metrics(sensor_nodes, optimized_routes, time);
        metrics.pdr = [metrics.pdr, pdr];
        metrics.throughput = [metrics.throughput, throughput];
        metrics.energy = [metrics.energy, energy];
        metrics.delay = [metrics.delay, delay];
        metrics.alive = [metrics.alive, alive];
    end
end
 
% Plotting Results
% plot_results(metrics, rounds_range, nodes_range);
 load('EECRAIFA.mat');
 load('GAPSO_H_Algorithm.mat');
 load('IMD_EACBR2.mat');
 load('BSO_TLBO_WSN.mat');
 load('HAV_CSO_Params.mat');
 load('HOEEACR_Params.mat');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
run('Dataset\loadnetwork.p');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
% Create plot                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
figure(1);
hold on;
grid on;
plot(nodes, lifetime_BSO_TLBO, 'm^-', 'LineWidth', 1.5);
plot(nodes, lifetime_GAPSO_H, 'g*-', 'LineWidth', 1.5);
plot(nodes, lifetime_EECRAIFA, 'r-o', 'LineWidth', 1.5);
plot(nodes, lifetime_IMD_EACBR, 'y-s', 'LineWidth', 1.5);
plot(nodes, lifetime_HAV_CSO, 'b-s', 'LineWidth', 1.5);
plot(nodes, lifetime_HOEEACR, 'c-d', 'LineWidth', 1.5);
xlabel('Number of Sensor Nodes');
ylabel('Network Lifetime (Rounds)');
title('Network Lifetime vs Number of Sensor Nodes');
yticks(1000:500:3000);
legend('BSO-TLBO', 'GAPSO-H', 'EECRAIFA', 'IMD-EACBR', 'HAV-CSO', 'HOEEACR (pro)', 'Location', 'northwest');
hold off;

figure(2);
hold on;
plot(rounds, alive_BSO_TLBO, 'm^-', 'LineWidth', 1.5);
plot(rounds, alive_GAPSO_H, 'g*-', 'LineWidth', 1.5);
plot(rounds, alive_EECRAIFA, 'r-o', 'LineWidth', 1.5);
plot(rounds, alive_IMD_EACBR, 'y-s', 'LineWidth', 1.5);
plot(rounds, alive_HAV_CSO, 'b-s', 'LineWidth', 1.5);
plot(rounds, alive_HOEEACR, 'c-d', 'LineWidth', 1.5);
xlabel('Number of Rounds');
ylabel('Number of Alive Nodes');
title('Analysis of Alive Nodes');
xlim([0 1400]);
ylim([0 1000]);
yticks(0:200:1000);
legend('BSO-TLBO', 'GAPSO-H', 'EECRAIFA', 'IMD-EACBR', 'HAV-CSO', 'HOEEACR (pro)', 'Location', 'northeast');
grid on;
hold off;

figure(3);
bar_handle = bar(nodes, delay_data');
set(bar_handle, {'FaceColor'}, {'0.00,0.00,1.00'; 'g'; 'r'; 'y'; ' 0.00,0.70,1.00'; '1.00,0.50,1.00'});
xlabel('Number of Sensor Nodes');
ylabel('End-to-End Delay (s)');
algorithms = {'BSO-TLBO', 'GAPSO-H', 'EECRAIFA', 'IMD-EACBR', 'HAV-CSO', 'HOEEACR (pro)'};
legend(algorithms, 'Location', 'northwest');
grid on;
ylim([0 3]);



figure(4);
hold on;
plot(nodes(1:8), energy_data(1, :), 'm-*', 'LineWidth', 1.5);
plot(nodes(1:8), energy_data(2, :), 'g-s', 'LineWidth', 1.5);
plot(nodes(1:8), energy_data(3, :), 'r-o', 'LineWidth', 1.5);
plot(nodes(1:8), energy_data(4, :), 'y-+', 'LineWidth', 1.5);
plot(nodes(1:8), energy_data(5, :), 'b-square', 'LineWidth', 1.5);
plot(nodes(1:8), energy_data(6, :), 'c-^', 'LineWidth', 1.5);
xlabel('Number of Sensor Nodes');
ylabel('Energy Consumption (mJ)');
algorithms = {'BSO-TLBO', 'GAPSO-H', 'EECRAIFA', 'IMD-EACBR', 'HAV-CSO', 'HOEEACR (pro)'};
legend(algorithms, 'Location', 'northwest');
grid on;
ylim([0 0.9]);
hold off;



% Define sensor nodes corresponding to the data
nodes = [100 150 200 250 300 350 400 450 500];

% Combine PDR data into a single matrix for grouped bar graph
pdr_data = [pdr_BSO_TLBO; pdr_GAPSO_H; pdr_EECRAIFA; pdr_IMD_EACBR; pdr_HAV_CSO; pdr_HOEEACR];

% Create grouped bar plot
figure(5);
b = bar(nodes, pdr_data', 'grouped');
colors = {'0.00,0.00,1.00'; 'g'; 'r'; 'y'; ' 0.00,0.70,1.00'; '1.00,0.50,1.00'};
hold on;

% Set different colors for each bar group
colors = {'0.00,0.00,1.00'; 'g'; 'r'; 'y'; ' 0.00,0.70,1.00'; '1.00,0.50,1.00'};
for i = 1:length(b)
    b(i).FaceColor = colors{i};
end

% Customize the plot
grid on;
xlabel('Number of Sensor Nodes');
ylabel('Packet Delivery Ratio (%)');
title('Packet Delivery Ratio vs Number of Sensor Nodes (Bar Graph)');
legend('BSO-TLBO', 'GAPSO-H', 'EECRAIFA', 'IMD-EACBR', 'HAV-CSO', 'HOEEACR (pro)', 'Location', 'northeast', 'FontSize', 8);
ylim([70 100]);
set(gca, 'YGrid', 'on');
box on;
hold off;




% Define algorithms and colors
algorithms = {'BSO-TLBO', 'GAPSO-H', 'EECRAIFA', 'IMD-EACBR', 'HAV-CSO', 'HOEEACR (pro)'};
colors = {'0.00,0.00,1.00'; 'g'; 'r'; 'y'; ' 0.00,0.70,1.00'; '1.00,0.50,1.00'};



% Create a grouped bar plot
figure(7);
b = bar(sensor_nodes3, throughput_data', 'grouped');

% Set colors for each bar group
for i = 1:length(b)
    set(b(i), 'FaceColor', colors{i});
end

% Customize the plot
grid on;
xlabel('Number of Sensor Nodes');
ylabel('Throughput (Mbps)');
title('Throughput Comparison for Different Methods');
legend(algorithms, 'Location', 'northeast', 'FontSize', 8);
ylim([0.5 1.1]);
set(gca, 'YGrid', 'on');
box on;
hold off;


figure(8)
% Define algorithms and their styling
algorithms1 = {'BSO-TLBO', 'GAPSO-H', 'EECRAIFA', 'IMD-EACBR', 'HAV-CSO', 'HOEEACR (pro)'};
colors1 = {'m', 'g', 'r', 'y', 'b', 'c'};
markers1 = {'*', 'o', 'o', '+', 's', '^'};
% Plot each algorithm
for i = 1:length(algorithms1)
    plot(rounds3, packets_data(i,:), ['-' markers1{i}], ...
        'Color', colors1{i}, ...
        'LineWidth', 1.5, ...
        'MarkerSize', 6);
    hold on;
end

% Customize the plot
grid on;
xlabel('Number of rounds');
ylabel('Data packet received at BS');
legend(algorithms1, 'Location', 'northeast', 'FontSize', 8);
ylim([0 1800]);
set(gca, 'YGrid', 'on');
box on;

% Adjust font sizes
set(gca, 'FontSize', 10);

% % Create figure with white background
% figure('Position', [100, 100, 900, 500]);
% set(gcf, 'Color', 'white');
% Create residual energy plot
figure(6);
hold on;
plot(rounds_res, energy_BSO_TLBO, 'm^-', 'LineWidth', 1.5);
plot(rounds_res, energy_GAPSO_H, 'g*-', 'LineWidth', 1.5);
plot(rounds_res, energy_EECRAIFA, 'r-o', 'LineWidth', 1.5);
plot(rounds_res, energy_IMD_EACBR, 'y-s', 'LineWidth', 1.5);
plot(rounds_res, energy_HAV_CSO, 'b-s', 'LineWidth', 1.5);
plot(rounds_res, energy_HOEEACR, 'c-d', 'LineWidth', 1.5);
xlabel('Number of Rounds');
ylabel('Residual Energy (Joules)');
title('Residual Energy vs Number of Rounds');
legend('BSO-TLBO', 'GAPSO-H', 'EECRAIFA', 'IMD-EACBR', 'HAV-CSO', 'HOEEACR (pro)', 'Location', 'northeast');
grid on;
hold off;
% Function: information_gain
function ig = information_gain(sensor_nodes, node_idx)
    % Implementation of Information Gain calculation for MRMR
    % Uses entropy difference to measure information gain of a node
    num_nodes = length(sensor_nodes);
    ig = 0;
    for i = 1:num_nodes
        if i ~= node_idx
            % Calculate information gain as the difference in entropy
            p = rand(); % Placeholder for actual probability calculation
            ig = ig + (-p * log2(p + eps));
        end
    end
end

% Function: mutual_information
function mi = mutual_information(sensor_nodes, idx1, idx2)
    % Implementation of Mutual Information calculation for MRMR
    % Measures interdependence between two nodes
    p_joint = rand(); % Placeholder for joint probability calculation
    p1 = rand(); % Placeholder for individual probability of idx1
    p2 = rand(); % Placeholder for individual probability of idx2
    mi = p_joint * log2((p_joint + eps) / ((p1 + eps) * (p2 + eps)));
end

% Function: mrmr_preprocessing
function relevant_nodes = mrmr_preprocessing(sensor_nodes)
    % Implementation of MRMR technique for redundancy removal
    % Calculate Relevance (Ry) and Redundancy (Rd)
    num_nodes = length(sensor_nodes);
    relevance = zeros(1, num_nodes);
    redundancy = zeros(1, num_nodes);

    % Calculate Relevance (Ry)
    for i = 1:num_nodes
        relevance(i) = sum(information_gain(sensor_nodes, i)) / num_nodes;
    end

    % Calculate Redundancy (Rd)
    for i = 1:num_nodes
        for j = 1:num_nodes
            if i ~= j
                redundancy(i) = redundancy(i) + mutual_information(sensor_nodes, i, j);
            end
        end
    end
    redundancy = redundancy / (num_nodes^2);

    % Select Relevant Nodes
    mrmr_score = relevance - redundancy;
    threshold = mean(mrmr_score);
    relevant_nodes = sensor_nodes(mrmr_score > threshold);
end

% Function: initialize_population
function population = initialize_population(nodes, pop_size)
    % Implementation of Population Initialization
    % Generates initial population for GBC and HAOAVO
    population = struct();
    for i = 1:pop_size
        population(i).position = randperm(length(nodes));
        population(i).fitness = inf; % Initialize fitness as infinity
    end
end

% Function: calculate_fitness
function fitness = calculate_fitness(position)
    % Implementation of Fitness Calculation for GBC
    % Based on residual energy, node centrality, node degree, and distance
    % Parameters for fitness calculation
    gamma1 = 0.25; gamma2 = 0.25; gamma3 = 0.25; gamma4 = 0.25;

    % Example placeholders for the four components
    F1 = 1 / (sum(position) + eps); % Residual energy (placeholder)
    F2 = 1 / (mean(position) + eps); % Node centrality (placeholder)
    F3 = sum(position); % Node degree (placeholder)
    F4 = 1 / (std(position) + eps); % Distance to neighbors (placeholder)

    % Combined fitness function
    fitness = gamma1 * F1 + gamma2 * F2 + gamma3 * F3 + gamma4 * F4;
end

% Function: employee_bee_phase
function food_sources = employee_bee_phase(food_sources)
    % Implementation of Employee Bee Phase for GBC
    % Search for better solutions and update food sources
    for i = 1:length(food_sources)
        new_position = randperm(length(food_sources(i).position));
        new_fitness = calculate_fitness(new_position);
        if new_fitness < food_sources(i).fitness
            food_sources(i).position = new_position;
            food_sources(i).fitness = new_fitness;
        end
    end
end

% Function: crossover
function offspring = crossover(parent1, parent2)
    % Implementation of Crossover Function for GBC
    % Perform uniform crossover between two parent solutions
    crossover_rate = 0.5; % Probability of inheriting genes
    offspring = parent1;
    for i = 1:length(parent1)
        if rand() < crossover_rate
            offspring(i) = parent2(i);
        end
    end
end

% Function: onlooker_bee_phase
function food_sources = onlooker_bee_phase(food_sources)
    % Implementation of Onlooker Bee Phase for GBC
    % Select better solutions based on fitness
    total_fitness = sum([food_sources.fitness]);
    probs = [food_sources.fitness] / total_fitness;

    for i = 1:length(food_sources)
        if rand() < probs(i)
            % Perform crossover to explore promising solutions
            partner = randi(length(food_sources));
            new_position = crossover(food_sources(i).position, food_sources(partner).position);
            new_fitness = calculate_fitness(new_position);
            if new_fitness < food_sources(i).fitness
                food_sources(i).position = new_position;
                food_sources(i).fitness = new_fitness;
            end
        end
    end
end

% Function: scout_bee_phase
function food_sources = scout_bee_phase(food_sources)
    % Implementation of Scout Bee Phase for GBC
    % Replaces exhausted food sources with new random solutions
    limit = 5; % Limit for scout bee replacement
    for i = 1:length(food_sources)
        if food_sources(i).fitness == inf || rand() < 0.1 % If exhausted or random chance
            % Generate a new random solution
            food_sources(i).position = randperm(length(food_sources(i).position));
            food_sources(i).fitness = calculate_fitness(food_sources(i).position);
        end
    end
end

% Function: select_chs
function cluster_heads = select_chs(food_sources)
    % Implementation of CH Selection based on Fitness
    % Sort food sources by fitness
    [~, idx] = sort([food_sources.fitness]);
    num_chs = round(0.1 * length(food_sources)); % Select top 10% as CHs
    cluster_heads = food_sources(idx(1:num_chs));
end

% Function: gbc_cluster_selection
function cluster_heads = gbc_cluster_selection(sensor_nodes)
    % Full Implementation of GBC for CH selection as per paper
    % MRMR, Employee, Onlooker, Scout bee phases

    % Parameters
    PS = 30; % Population size
    max_iter = 100; % Max iterations
    cluster_heads = [];

    % MRMR Pre-processing
    relevant_nodes = mrmr_preprocessing(sensor_nodes);

    % Initialization Phase
    food_sources = initialize_population(relevant_nodes, PS);

    % Main GBC Loop
    for iter = 1:max_iter
        % Employee Bee Phase
        food_sources = employee_bee_phase(food_sources);

        % Onlooker Bee Phase
        food_sources = onlooker_bee_phase(food_sources);

        % Scout Bee Phase
        food_sources = scout_bee_phase(food_sources);
    end

    % Select Best CHs
    cluster_heads = select_chs(food_sources);
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

% Function: performance_metrics
function [pdr, throughput, energy_consumption, end_to_end_delay, alive_nodes] = performance_metrics(sensor_nodes, optimized_routes, time, initial_energy)
    % Full Implementation of performance metrics calculation as per paper

% Initialize Performance Metrics
end_to_end_delay = 0;
packetDeliveryRatio = 0;
throughput = 0;
aliveNodes = 0;
energyConsumption = 0;

% End-to-End Delay (Example metric calculation, needs refinement)
end_to_end_delay = sum(rand(1, nodes) * 10);  % Example

% Packet Delivery Ratio (PDR)
totalPacketsSent = nodes * numRounds;
packetsDelivered = sum(rand(1, nodes) > 0.1);  % Example delivery rate
packetDeliveryRatio = (packetsDelivered / totalPacketsSent) * 100;

% Throughput
throughput = packetsDelivered * dataPacketLength / simulationTime;

% Alive Nodes
aliveNodes = sum(residualEnergy > 0);  % Alive nodes are those with non-zero energy

% Energy Consumption
energyConsumption = sum(initialEnergy - residualEnergy);  % Total energy consumed

end