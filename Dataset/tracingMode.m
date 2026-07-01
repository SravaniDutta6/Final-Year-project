function tracedVirus = tracingMode(virus)
    tracingFactor = 0.3;  % Factor for tracing step size
    numNodes = size(virus.positions, 1);

    % Copy original virus
    tracedVirus = virus;

    % Apply tracing to improve positions
    for i = 1:numNodes
        if virus.isCH(i) % If it's a cluster head
            % Adjust position slightly towards the centroid of neighboring nodes
            neighbors = virus.positions(randperm(numNodes, min(5, numNodes)), :);
            centroid = mean(neighbors, 1);
            tracedVirus.positions(i, :) = virus.positions(i, :) + tracingFactor * (centroid - virus.positions(i, :));
        else
            % Move slightly in a random direction to explore
            tracedVirus.positions(i, :) = virus.positions(i, :) + randn(1, 2) * tracingFactor;
        end

        % Ensure positions remain within bounds (200x200 area)
        tracedVirus.positions(i, :) = max(0, min(200, tracedVirus.positions(i, :)));
    end
end
