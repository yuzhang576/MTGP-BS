function SubOffspring = CreateOff(Problem,Population,SubPopulation,RMP)
    Parent11 = [];
    Parent21 = [];
    Parent12 = [];
    Parent22 = [];
    for i = 1 : floor(length(Population)/2)
        P1  = Population(i);
        P2  = Population(i+floor(length(Population)/2));
        rmp = RMP(P1.dec(end),P2.dec(end));
        if (P1.dec(end) == P2.dec(end)) || (rand<rmp)
            Parent11 = [Parent11,P1];
            Parent21 = [Parent21,P2];
        else
            Parent12 = [Parent12,P1,P2];
            Parent22 = [Parent22,SubPopulation{P1.dec(end)}(randi(end)),SubPopulation{P2.dec(end)}(randi(end))];
        end
    end
    
    if ~isempty(Parent11)
        Parent1Dec     = Parent11.decs;
        Parent2Dec     = Parent21.decs;
        OffDec1        = OperatorGA(Problem,[Parent1Dec;Parent2Dec]);
        OffDec1(:,end) = [Parent1Dec(:,end);Parent2Dec(:,end)];
    else
        OffDec1 = [];
    end
    if ~isempty(Parent12)
        Parent1Dec     = Parent12.decs;
        Parent2Dec     = Parent22.decs;
        OffDec2        = OperatorGAhalf(Problem,[Parent1Dec;Parent2Dec]);
        OffDec2(:,end) = Parent1Dec(:,end);
    else
        OffDec2 = [];
    end
    SubOffspring = Divide(Problem.Evaluation([OffDec1;OffDec2]),length(Problem.SubD));
end