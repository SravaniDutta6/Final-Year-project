function soughtVirus = seekingMode(virus)
    seekingFactor = 0.4;  % Factor for seeking step size
    numNodes = size(virus.positions, 1);

    % Copy original virus
    soughtVirus = virus;

    % Apply seeking behavior to enhance positions
    for i = 1:numNodes
        if virus.isCH(i) % If it's a cluster head
            % Seek better positions by exploring nearby
            direction = randn(1, 2);
            direction = direction / norm(direction);  % Normalize direction
            soughtVirus.positions(i, :) = virus.positions(i, :) + seekingFactor * direction;
        else
            % Move slightly to explore new regions
            soughtVirus.positions(i, :) = virus.positions(i, :) + randn(1, 2) * seekingFactor;
        end

        % Ensure positions remain within bounds (200x200 area)
        soughtVirus.positions(i, :) = max(0, min(200, soughtVirus.positions(i, :)));
    end
end
