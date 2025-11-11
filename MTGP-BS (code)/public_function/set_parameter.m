function [GEP_info, para, userVar] = set_parameter(pro_num, para, userVar)
    if strcmp(userVar.test_problem_type, 'test')
        [para.teacher_opt, GEP_info.shared] = define_test_problem_v3(pro_num, para.teacher_opt);
    elseif strcmp(userVar.test_problem_type, 'benchmark')
        [para.teacher_opt, GEP_info.shared] = define_benchmark_problem_v2(pro_num, para.teacher_opt);
    else
        error('No such type of test problems, please check file initialize_parmeter_v1.m!');
    end

    GEP_info.shared.terminal_numbers = 1: numel(GEP_info.shared.terminals);
    GEP_info.shared.function_numbers = numel(GEP_info.shared.terminals) + 1: numel(GEP_info.shared.functions) + numel(GEP_info.shared.terminals);
    
    GEP_info.teacher = GEP_info.shared;
    GEP_info.teacher.head_length = userVar.teacher_head_length;
    GEP_info.teacher.tail_length = GEP_info.teacher.head_length + 1;
    GEP_info.teacher.gene_length = GEP_info.teacher.head_length + GEP_info.teacher.tail_length;

    GEP_info.student = GEP_info.shared;
    GEP_info.student.head_length = userVar.student_head_length;
    GEP_info.student.tail_length = GEP_info.student.head_length + 1;
    GEP_info.student.gene_length = GEP_info.student.head_length + GEP_info.student.tail_length;

    [para.teacher_opt.y_norm, para.teacher_opt.ymin, para.teacher_opt.ymax] = map0to1(para.teacher_opt.y);
    [para.teacher_opt.y_norm_t1] = map0to1(para.teacher_opt.y_t1, para.teacher_opt.ymin, para.teacher_opt.ymax);
    [para.teacher_opt.y_norm_t2] = map0to1(para.teacher_opt.y_t2, para.teacher_opt.ymin, para.teacher_opt.ymax);
    
    para.teacher_opt.D_x = size(para.teacher_opt.x,2);
    para.teacher_opt.D_y = size(para.teacher_opt.y,2);
    para.teacher_opt.coefficient_range = [-10, 10];

    para.teacher_opt.D = GEP_info.teacher.gene_length;
    para.teacher_opt.lower = ones(1, para.teacher_opt.D);
    para.teacher_opt.upper = [max(GEP_info.shared.function_numbers)*ones(1, GEP_info.teacher.head_length), max(GEP_info.shared.terminal_numbers)*ones(1, GEP_info.teacher.tail_length)];

    [para.student_opt, ~] = define_test_problem_v3(pro_num, para.student_opt);
    [para.student_opt.y_norm, para.student_opt.ymin, para.student_opt.ymax] = map0to1(para.student_opt.y);
    [para.student_opt.y_norm_t1] = map0to1(para.teacher_opt.y_t1, para.student_opt.ymin, para.student_opt.ymax);
    [para.student_opt.y_norm_t2] = map0to1(para.teacher_opt.y_t2, para.student_opt.ymin, para.student_opt.ymax);
    
    para.student_opt.D_x = size(para.student_opt.x,2);
    para.student_opt.D_y = size(para.student_opt.y,2);
    para.student_opt.coefficient_range = [-10, 10];

    para.student_opt.D = GEP_info.student.gene_length;
    para.student_opt.lower = ones(1, para.student_opt.D);
    para.student_opt.upper = [max(GEP_info.shared.function_numbers)*ones(1, GEP_info.student.head_length), max(GEP_info.shared.terminal_numbers)*ones(1, GEP_info.student.tail_length)];

    para.student_dist.D_x = para.teacher_opt.D_x;
    para.student_dist.D_y = para.teacher_opt.D_y;
    para.student_dist.coefficient_range = para.teacher_opt.coefficient_range;

    para.student_dist.x_size = size(para.teacher_opt.x,1);
    para.student_dist.x_lower = para.teacher_opt.x_lower;
    para.student_dist.x_upper = para.teacher_opt.x_upper;

    para.student_dist.D = GEP_info.student.gene_length;
    para.student_dist.lower = ones(1, para.student_dist.D);
    para.student_dist.upper = [max(GEP_info.shared.function_numbers)*ones(1, GEP_info.student.head_length), max(GEP_info.shared.terminal_numbers)*ones(1, GEP_info.student.tail_length)];
    
    para.shared.problem_name = para.teacher_opt.problem_name;
    para.shared.D_y = para.teacher_opt.D_y;
    para.shared.D_x = para.teacher_opt.D_x;

    userVar.common_part = userVar.common_part_true{pro_num};
    userVar.x_size = size(para.teacher_opt.x,1)*100;
end