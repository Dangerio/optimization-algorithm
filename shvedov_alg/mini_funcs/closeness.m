function [val] = closeness(population)
center = mean(population);
val = mean(pdist2(population, center));    
end