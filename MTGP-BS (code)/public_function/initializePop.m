function Population = initializePop(function_numbers, head_length, num_more, Problem, member)
    head_range = [function_numbers(1), function_numbers(end)];
    tail_range = [1, function_numbers(1) - 1];
    
    if strcmp(member, 'teacher')
        popDec1 = [randi(head_range, num_more, head_length), randi(tail_range, num_more, head_length + 1), ones(num_more, 1)];
        popDec2 = [randi(head_range, num_more, head_length), randi(tail_range, num_more, head_length + 1), 2*ones(num_more, 1)];
        Population1 = Problem.Evaluation(popDec1);
        Population2 = Problem.Evaluation(popDec2);
        
        [~, idx1] = unique(Population1.objs, 'rows');
        [~, idx2] = unique(Population2.objs, 'rows');
        Population1 = Population1(idx1);
        Population2 = Population2(idx2);
        
        Population = [Population1(1: Problem.N/2), Population2(1: Problem.N/2)];
    else
        Population = [];

        tic
        while numel(Population) < Problem.N
            popDec = [randi(head_range, num_more, head_length), randi(tail_range, num_more, head_length + 1)];
            Population = Problem.Evaluation(popDec);
    
            [~, idx] = unique(Population.objs, 'rows');
            Population = [Population, Population(idx)];
            time = toc;
            if time > 5
                error('This running cannot generate a pop with N unique individuals!');
            end
        end

        Population = Population(1: Problem.N);
    end
end