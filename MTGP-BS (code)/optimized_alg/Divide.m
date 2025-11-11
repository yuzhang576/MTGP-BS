function SubPopulation = Divide(Population,SubCount)
    PopDec = Population.decs;
    skills = PopDec(:,end);
    for i = 1 : SubCount
        SubPopulation{i} = Population(skills==i);
    end
end