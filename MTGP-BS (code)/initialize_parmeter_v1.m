function [para, distill, userVar] = initialize_parmeter_v1()

    task_num = 2;
    popsize = 50;
    M = 1;
    maxFE = 1000%100000;
    userVar.test_problem_type = 'test';

    para.shared.members = {'teacher', 'student'};

    [problem_name, common_part_true] = get_problem_and_common_part_true_v2(userVar.test_problem_type);
    para.shared.pro_num_all = numel(problem_name);
    para.shared.pro_processed = 1:16;
    para.shared.run = 30;

    para.inProcess.flag = 0;
    
    para.teacher_opt.N = popsize*task_num;
    para.teacher_opt.N_each = popsize;
    para.teacher_opt.M = M;
    para.teacher_opt.maxFE = maxFE;
    para.teacher_opt.num_more = popsize*2;

    userVar.teacher_head_length = 10;
    userVar.student_head_length = 5;
    userVar.common_part_true = common_part_true;
    userVar.expression_length = 10;

    userVar.method = 1;
    userVar.classfy_num = 2;

    userVar.rank_common_part = 1;

    userVar.problem_type = 'test_function';
    
    userVar.data_name = 'part1';

    para.student_opt.N = 200;
    para.student_opt.M = 1;
    para.student_opt.maxFE = 5000;
    
    para.student_dist.N = 100;
    para.student_dist.M = 1;
    para.student_dist.maxFE = 2500;
    
    distill.classify_num = 2;
    distill.sub_size = [50, 50];
end