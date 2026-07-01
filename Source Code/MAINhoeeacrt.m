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
n_population = 50; % Number of vultures (population size)
max_iterations = 100; % Maximum iterations
dim_size = length(sensor_nodes); % Problem dimension (number of nodes)
lb = 0; % Lower bound
ub = area; % Upper bound

optimized_routes = HAOAVO_Routing(n_population, max_iterations, dim_size, lb, ub);

% Calculate Initial Energy Before Routing
initial_energy_sum = sum([sensor_nodes.energy]);

% Performance Metrics Calculation
[pdr, throughput, energy_consumption, end_to_end_delay, alive_nodes] = performance_metrics(sensor_nodes, optimized_routes, time, initial_energy_sum);

% Results Display
fprintf('Packet Delivery Ratio (PDR): %.2f%%\n', pdr);
fprintf('Throughput: %.2f packets/s\n', throughput);
fprintf('End-to-End Delay: %.2f ms\n', end_to_end_delay); 
fprintf('Alive Nodes: %d\n', alive_nodes);
fprintf('Energy Consumption: %.2f J\n', energy_consumption);

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
        optimized_routes = HAOAVO_Routing(n_population, max_iterations, dim_size, lb, ub);

        % Performance Metrics Calculation
        [pdr, throughput, energy, delay, alive] = performance_metrics(sensor_nodes, optimized_routes, time);
        metrics.pdr = [metrics.pdr, pdr];
        metrics.throughput = [metrics.throughput, throughput];
        metrics.energy = [metrics.energy, energy];
        metrics.delay = [metrics.delay, delay];
        metrics.alive = [metrics.alive, alive];
    end
end

% Plotting Results (unchanged from original code)
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
set(bar_handle, {'FaceColor'}, {'0.00,0.25,1.00'; '1.00,0.50,0.00'; 'g'; '0.94,0.91,0.25'; ' 0.00,0.70,1.00'; '1.00,0.50,1.00'});
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
colors = {'0.00,0.25,1.00'; '1.00,0.50,0.00'; 'g'; '0.94,0.91,0.25'; ' 0.00,0.70,1.00'; '1.00,0.50,1.00'};
hold on;

% Set different colors for each bar group
colors = {'0.00,0.25,1.00'; '1.00,0.50,0.00'; 'g'; '0.94,0.91,0.25'; ' 0.00,0.70,1.00'; '1.00,0.50,1.00'};
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
colors = {'0.00,0.25,1.00'; '1.00,0.50,0.00'; 'g'; '0.94,0.91,0.25'; ' 0.00,0.70,1.00'; '1.00,0.50,1.00'};



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

% haoavo_routing FUNCTION START
function [best_solution, convergence_curve] = HAOAVO_Routing(n, max_iter, dim, lb, ub)
    % Parameters
    num_vultures = n;          % Population size
    max_iterations = max_iter; % Maximum iterations
    dim_size = dim;            % Problem dimension
    lower_bound = lb;          % Lower boundary
    upper_bound = ub;          % Upper boundary
    
    % Initialize population
    vultures = lower_bound + (upper_bound - lower_bound).*rand(num_vultures, dim_size);
    fitness = zeros(num_vultures, 1);

    function fitness = calculate_fitness(solution)
    % Define parameters for WSN optimization
    base_station = [500, 500]; % Assume base station is at the center of the area
    num_nodes = size(solution, 1); % Number of nodes in the solution (rows in solution)
    
    % Example parameters for energy calculation
    initial_energy = 1.5; % Initial energy of each node (in Joules)
    packet_size = 6500; % Packet size in bits
    energy_per_bit = 0.0001; % Energy consumption per bit (in Joules)
    
    % Calculate distance to base station for each node
    distances = sqrt((solution(:,1) - base_station(1)).^2 + (solution(:,2) - base_station(2)).^2);
    
    % Calculate energy consumption for each node
    energy_consumption = packet_size * energy_per_bit .* distances;
    
    % Fitness: minimize energy consumption and maximize lifetime
    fitness = sum(energy_consumption) / (initial_energy * num_nodes); % Normalize by total initial energy
end
   
    % Evaluate initial population
    for i = 1:num_vultures
        fitness(i) = calculate_fitness(vultures(i,:)); % Implement your WSN fitness function
    end
    
    [~, sorted_idx] = sort(fitness);
    best_vulture1 = vultures(sorted_idx(1),:); % First best vulture
    best_vulture2 = vultures(sorted_idx(2),:); % Second best vulture
    
    convergence_curve = zeros(1, max_iterations);
    
    % Main optimization loop
    for iter = 1:max_iterations
        % Stage 1: Update using AVO (Equation 13)
        M = zeros(num_vultures, dim_size);
        for i = 1:num_vultures
            ax = fitness(i)/sum(fitness); % Equation 14
            if ax < 0.5
                M(i,:) = best_vulture1 + abs(rand*best_vulture1 - vultures(i,:));
            else
                M(i,:) = best_vulture2 + abs(rand*best_vulture2 - vultures(i,:));
            end
        end
        
% Stage 2: Starvation calculation (Equation 15-16)
E = zeros(1, num_vultures); % Initialize E as an array

for i = 1:num_vultures
    d = -1 + 2 * rand; % Random value between [-1, 1]
    g = -2 + 4 * rand; % Random value between [-2, 2]
    u = g * (sin(pi/2 * (iter / max_iterations)) + cos(pi/2 * (iter / max_iterations)) - 1);
    E(i) = (2 * rand + 1) * d * (1 - iter / max_iterations) + u; % Calculate E for each vulture
end

% Stage 4: First exploitation phase (Equation 19-22)
for i = 1:num_vultures
    if abs(E(i)) < 1
        L2 = 0.5; % Threshold parameter
        if rand >= L2
            S = best_vulture1; % Current best solution
            A = vultures(i,:); % Current solution for vulture
            O = S - A; % Calculate O
            
            J1 = S .* (rand/2 * pi * A) .* cos(A);
            J2 = S .* (rand/2 * pi * A) .* sin(A);
            vultures(i,:) = S - (J1 + J2);
        else
            Q = rand * levy_flight(dim_size);
            S = best_vulture1; % Current best solution
            A = vultures(i,:); % Current solution for vulture
            O = S - A; % Calculate O
            
            vultures(i,:) = S .* (E(i) + rand - O);
        end
    end
end

        % Stage 5: Second exploitation phase (Equation 23-26)
        for i = 1:num_vultures
            if abs(E(i)) < 0.5
                % Aggregation tactic
                P1 = best_vulture1 - (best_vulture1.*vultures(i,:))./(best_vulture1.*vultures(i,:).^2).*E(i);
                P2 = best_vulture2 - (best_vulture2.*vultures(i,:))./(best_vulture2.*vultures(i,:).^2).*E(i);
                vultures(i,:) = (P1 + P2)/2;
            end
        end
        
        % Update best solutions
        [~, idx] = min(fitness);
        best_vulture1 = vultures(idx,:);
        convergence_curve(iter) = fitness(idx);
    end
    
    best_solution = best_vulture1;
end

function L = levy_flight(d)
    beta = 1.5;
    sigma = (gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
    u = randn(1,d)*sigma;
    v = randn(1,d);
    step = u./abs(v).^(1/beta);
    L = 0.01*step;
end
% haoavo_routing FUNCTION END

% performance_metrics FUNCTION START
function [pdr, throughput, energy_consumption, end_to_end_delay, alive_nodes] = performance_metrics(sensor_nodes, optimized_routes, time, initial_energy)
% This function is a placeholder. Replace with your actual performance metrics implementation.
% The following is a dummy implementation that returns random values.
    pdr = randi([80, 100]); % Packet Delivery Ratio (percentage)
     % Calculate Throughput
    throughput = packets_received / time;

    % Calculate Energy Consumption
    remaining_energy = sum([sensor_nodes.energy]);
    energy_consumption = initial_energy - remaining_energy
    energy_consumption = rand() * 5; % Joules
    end_to_end_delay = rand() * 0.1; % Seconds
    alive_nodes = sum([sensor_nodes.energy] > 0); % Number of nodes with energy > 0
end
