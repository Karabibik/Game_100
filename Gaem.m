%% Preamble

close all
clear
clc

%% Define Game Settings

% Size of the game square
gaem_size = 5;

%% Additional Calculations

% Number of numbers
N_num = gaem_size^2;

% Create game grid
gaem_grid = zeros(gaem_size);

% Give random start position
% init_pos = [1,7];
init_pos = [randi(gaem_size),randi(gaem_size)];
gaem_grid(init_pos(1),init_pos(2)) = 1;

% Create open/closed and heuristic lists
open_list = {gaem_grid};
closed_list = {};
f_open = [getHeuristic(gaem_grid,1)];
f_closed = 0;

%% Start Search

% Until the puzzle is solved
solved = 0;
N_states = 0;
tic;
while ~solved
    
    MAX = f_closed;
    T = toc;
    
    [~,I] = max(f_open);
    node = open_list{I};
    
    if max(node,[],'all') == N_num
        % If we reached max number, stop
        solved = 1;
    else
        % Put the node in closed list
        if f_open(I) > f_closed
            f_closed = f_open(I);
            closed_list = open_list{I};
        end
        open_list(I) = [];
        f_open(I) = [];
        N_states = N_states + 1;
        
        % Find action space
        action_space = actionSpace(node);
        
        if size(action_space,1) == 0
            % If no action can be taken, do nothing
            
        else
            
            % Find child nodes
            childs = {};
            for action_num = 1:size(action_space,1)

                % Apply the action and get the childs
                action = action_space(action_num,:);
                childs{action_num} = goStep(node, action);
            end

            % For each neighbor of the current node
            for child_num = 1:size(childs,2)
                
                if min(childs{child_num}~=0)
                    found_it = childs{child_num}
                    plot_gaem(found_it,gaem_size)
                    error("I'VE FREAKING FUCKING FOUND IT!")
                else
                    open_list = [open_list, childs{child_num}];
                    f_open = [f_open, getHeuristic(childs{child_num},3)];
                end
            end
            
        end
        
    end
    
end

%% Define Functions to be Used

function action_space = actionSpace(gaem_grid)
% Returns the action space for given grid and position

    % Default action space
    % North, northeast, east, southeast, south, southwest, west, northwest
    action_space = [-3,0;
                    -2,2;
                    0,3;
                    2,2;
                    3,0;
                    -2,-2;
                    0,-3;
                    2,-2];

    % Find the index of maximum number, assign as current position
    [~,I] = max(gaem_grid(:));
    [x,y] = ind2sub(size(gaem_grid), I);
    pos = [x,y];
    
    i = 1;
    while i <= size(action_space,1)

        % Take action to find new position
        newpos = pos + action_space(i,:);

        if newpos(1)<1 || newpos(2)<1 || ...
           newpos(1)>size(gaem_grid,1) || newpos(2)>size(gaem_grid,1)
            % Out of grid
            action_space(i,:) = [];
        elseif gaem_grid(newpos(1),newpos(2)) ~= 0
            % Not empty
            action_space(i,:) = [];
        else
            i = i+1;
        end
    end

end

function [new_grid] = goStep(gaem_grid, action)
% Returns the new grid and position, given action

    % Find the maximum number and index, assign as current position
    [max_num,I] = max(gaem_grid(:));
    [x,y] = ind2sub(size(gaem_grid), I);
    pos = [x,y];
    
    % Get new position
    new_pos = pos + action;
    
    % Put new number, return new grid
    new_grid = gaem_grid;
    new_grid(new_pos(1), new_pos(2)) = max_num + 1;
end

function heur = getHeuristic(gaem_grid, type)
% Returns the heuristic value for a given grid

    max_num = max(gaem_grid,[],'all');

    if type == 1
        % Max number is the heuristic
        heur = max_num;
    elseif type == 2
        % Square of number is heuristic
        heur = max_num^2;
    elseif type == 3
        % Max number minus std of spaces
        [X,Y] = find(gaem_grid == 0);
        
        dist = sqrt(sum((X-mean(X)).^2) + sum((Y-mean(Y)).^2));
        
        heur = max_num - dist;
    end
    
end