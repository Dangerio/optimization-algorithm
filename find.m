function [population_star] = find_star(population_s, c_r)
    grid_denomerator = 1:grid.'/grid;

    population_r_streched = repmat(population_s, grid, 1);
    c_r_streched = repmat(c_r,grid, 1);

    grid_population = grid_denomerator .* population_r_streched + (1 - grid_denomerator) .* c_r_streched;

    func_value_x_star = func(grid_population);
    func_value_x1 = func(population(1,:));
    func_value_xs = func(population_s);

    grid_condition = func_value_x_star < func_value_xs - alpha * (func_value_xs - func_value_x1);

    if any(grid_condition)
        population_star_index = find(grid_condition, 1, 'first');
        population_star = grid_population(population_star_index,:);

    else 
        population_star = 'N';
    end

end








            




                
