classdef MOMFEAII_GEP_teacher < ALGORITHM
    methods
        function main(Algorithm,Problem)
            [function_numbers, head_length, inProcess, num_more] = Algorithm.ParameterSet([], [], [], []);
            Population = initializePop(function_numbers, head_length, num_more, Problem, 'teacher');

            SubPopulation = Divide(Population,length(Problem.SubD));

            if inProcess.flag
                generation = 0;
                generation = save_data_in_process(inProcess, generation, SubPopulation, 'teacher');
            end

            while Algorithm.NotTerminated([SubPopulation{:}])
                RMP                  = learnRMP(Problem,SubPopulation);
                [SubPopulation,Rank] = Sort_1obj(Problem,SubPopulation);
                Population           = [SubPopulation{:}];
                ParentPool           = Population(TournamentSelection(2,length(Population),[Rank{:}]));
                SubOffspring         = CreateOff(Problem,ParentPool,SubPopulation,RMP);
                for i = 1 : length(Problem.SubD)
                    SubPopulation{i} = EnviSelect_1obj([SubPopulation{i},SubOffspring{i}],(Problem.N/length(Problem.SubD)));
                end

                if inProcess.flag
                    generation = save_data_in_process(inProcess, generation, SubPopulation, 'teacher');
                end
            end
        end
    end
end