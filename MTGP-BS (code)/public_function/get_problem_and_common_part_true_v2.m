function [problem_name, common_part_true] = get_problem_and_common_part_true_v2(pro_type)
    if strcmp(pro_type, 'test')
        pro_num_all = 16;
    elseif strcmp(pro_type, 'benchmark')
        pro_num_all = 6;
    end
    for pro_num = 1: pro_num_all
        para = [];
        if strcmp(pro_type, 'test')
            para = define_test_problem_v3(pro_num, para);
        elseif strcmp(pro_type, 'benchmark')
            para = define_benchmark_problem_v2(pro_num, para);
        else
            error('No such type of test problems, please check file initialize_parmeter_v1.m!');
        end
        problem_name{pro_num, 1} = para.problem_name;
        common_part_true{pro_num, 1} = para.term_sharing;
    end
end