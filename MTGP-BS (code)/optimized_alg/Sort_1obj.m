function [SubPopulation,Rank] = Sort_1obj(Problem,SubPopulation)
    Rank = {};
    for i = 1 : length(Problem.SubD)
        [~,FrontNo,CrowdDis] = EnviSelect_1obj(SubPopulation{i},length(SubPopulation{i}));
        [~,rank]             = sortrows([FrontNo',-CrowdDis']);
        SubPopulation{i}     = SubPopulation{i}(rank);
        Rank{i}              = 1 : length(rank);
    end
end