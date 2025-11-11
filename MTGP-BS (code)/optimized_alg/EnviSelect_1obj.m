function [Population,FrontNo,CrowdDis] = EnviSelect_1obj(Population,N)
    [~, idx] = unique(Population.objs);
    Population = Population(idx);

    if numel(Population) < N
        idx_sel = randi(numel(Population), 1, N - numel(Population));
        Population = [Population, Population(idx_sel)];
    end
    [~,rank]   = sort(FitnessSingle(Population));
    Population = Population(rank(1: N));

    [FrontNo,~] = NDSort(Population.objs,Population.cons,N);

    CrowdDis = CrowdingDistance(Population.objs,FrontNo);

end