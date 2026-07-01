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
