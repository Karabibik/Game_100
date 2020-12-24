function plot_gaem(gaem_grid,gaem_size)
%PLOT_GAEM Summary of this function goes here
%   Detailed explanation goes here
figure(1)
grid on
box on
axis([1 gaem_size+1 1 gaem_size+1])
axis square
xticklabels([])
yticklabels([])
for i = 1:gaem_size
    for j = 1:gaem_size
        text(i+0.4,j+0.5,num2str(gaem_grid(i,j)),"FontWeight","Bold")
    end
end
end

