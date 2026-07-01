function population = evaluateFitness(population)
    % Parameters for fitness calculation
    Eelec = 50e-9;    % Energy to run the circuitry (J/bit)
    Eamp = 100e-12;   % Energy for transmission amplifier (J/bit/m^2)
    packetSize = 4000; % Packet size in bits

    for i = 1:length(population)
        positions = population(i).positions;
        isCH = population(i).isCH;
        numCH = sum(isCH);

        % Calculate intra-cluster energy consumption
        intraClusterEnergy = 0;
        for j = 1:length(positions)
            if isCH(j)
                % Energy for CH to receive and forward packets
                intraClusterEnergy = intraClusterEnergy + Eelec * packetSize * numCH;
            else
                % Energy for normal node to transmit to nearest CH
                distances = vecnorm(positions(isCH, :) - positions(j, :), 2, 2);
                [~, idx] = min(distances);
                intraClusterEnergy = intraClusterEnergy + ...
                    (Eelec + Eamp * distances(idx)^2) * packetSize;
            end
        end

        % Fitness: Minimize energy consumption
        population(i).fitness = intraClusterEnergy;
    end
end
