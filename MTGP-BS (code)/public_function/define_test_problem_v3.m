function [para, GEP_info, expression] = define_test_problem_v3(pro_num, para)
    [para.x_lower, para.x_upper] = deal(0, 10);
    num_test_data_term_sharing = 100000;

    [x.lower, x.upper, x.num_data] = deal(para.x_lower, para.x_upper, 100);
    [t1.lower, t1.upper, t1.num_data] = deal(para.x_lower, para.x_upper, 30);
    [t2.lower, t2.upper, t2.num_data] = deal(10, 20, 30);

    function_1D.parallelEllipsoid = 'X1^2';
    function_1D.rotatedEllipsoid = 'X1^2';
    function_1D.Rastrigin = 'X1^2 - 10*cos(X1) + 10';
    function_1D.Griewangk = 'X1^2/4000 - cos(X1) + 1';

    function_2D.parallelEllipsoid = 'X1^2 + 2*X2^2';
    function_2D.rotatedEllipsoid = 'X1^2 + (X1 + X2)^2';
        function_2D.rotatedEllipsoid_expand = '2*X1^2 + 2*X1*X2 + X2^2';
    function_2D.Rosenbrock = '100*(X2 - X1^2)^2 + (1 - X1)^2';
        function_2D.Rosenbrock_expand = '100*X1^4 - 200*X1^2*X2 + X1^2 - 2*X1 + 100*X2^2 + 1';
    function_2D.Rastrigin = 'X1^2 + X2^2 - 10*cos(X1) - 10*cos(X2) + 20';
    function_2D.Griewangk = 'X1^2/4000 + X2^2/4000 - cos(X1)*cos(X2/1.41) + 1';
    function_2D.Branins = '(X2 - 0.13*X1^2 + 1.59*X1 - 6)^2 + 9.6*cos(X1) + 10';
        function_2D.Branins_expand = '9.6*cos(X1) - 12*X2 - 19.08*X1 + 3.18*X1*X2 - 0.26*X1^2*X2 + 4.09*X1^2 - 0.41*X1^3 + X2^2 + 0.017*X1^4 + 46';

    function_3D.parallelEllipsoid = 'X1^2 + 2*X2^2 + 3*X3^2';
    function_3D.rotatedEllipsoid = 'X1^2 + (X1 + X2)^2 + (X1 + X2 + X3)^2';
        function_3D.rotatedEllipsoid_expand = '3*X1^2 + 4*X1*X2 + 2*X1*X3 + 2*X2^2 + 2*X2*X3 + X3^2';
    function_3D.Rastrigin = 'X1^2 + X2^2 + X3^2 - 10*cos(X1) - 10*cos(X2) - 10*cos(X3) + 30';

    function_4D.parallelEllipsoid = 'X1^2 + 2*X2^2 + 3*X3^2 + 4*X4^2';

    switch pro_num
        case 1
            GEP_info.num_X = 3;
            GEP_info.functions = ['+', '*', '-', 'q'];

            para.problem_name = 'merge_parallelEllipsoid_rotatedEllipsoid_3D';
            para.term_sharing = 'X1^2 + X2^2 + X3^2';
        case 2
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'n', 'q'];

            para.problem_name = 'merge_parallelEllipsoid_Rosenbrock_2D';
            para.term_sharing = 'X1^2 + X2^2';
        case 3
            GEP_info.num_X = 3;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_parallelEllipsoid_Rastrigin_3D';
            para.term_sharing = 'X1^2 + X2^2 + X3^2';
        case 4
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_parallelEllipsoid_Griewangk_2D';
            para.term_sharing = 'X1^2 + X2^2';
        case 5
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_parallelEllipsoid_Branins_2D';
            para.term_sharing = 'X1^2 + X2^2';
        case 6
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'n', 'q'];

            para.problem_name = 'merge_rotatedEllipsoid_Rosenbrock_2D';
            para.term_sharing = 'X1^2 + X2^2';
        case 7
            GEP_info.num_X = 3;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_rotatedEllipsoid_Rastrigin_3D';
            para.term_sharing = 'X1^2 + X2^2 + X3^2';
        case 8
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_rotatedEllipsoid_Griewangk_2D';
            para.term_sharing = 'X1^2 + X2^2';
        case 9
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_rotatedEllipsoid_Branins_2D';
            para.term_sharing = 'X1^2 + X1*X2 + X2^2';
        case 10
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_Rosenbrock_Rastrigin_2D';
            para.term_sharing = 'X1^2 + X2^2';
        case 11
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_Rosenbrock_Griewangk_2D';
            para.term_sharing = 'X1^2 + X2^2';
        case 12
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_Rosenbrock_Branins_2D';
            para.term_sharing = 'X1^4 - X1^2*X2 + X1^2 - X1 + X2^2';
        case 13
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_Rastrigin_Griewangk_2D';
            para.term_sharing = 'X1^2 + X2^2';
        case 14
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_Rastrigin_Branins_2D';
            para.term_sharing = 'X1^2 + X2^2';
        case 15
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_Griewangk_Branins_2D';
            para.term_sharing = 'X1^2 + X2^2';
        case 16
            GEP_info.num_X = 1;
            GEP_info.functions = ['+', '*', '-', 'n', 'q', 'c'];

            para.problem_name = 'merge_Rastrigin_Griewangk_1D';
            para.term_sharing = 'X1^2 - cos(X1)';
        otherwise
            error('no such kind of problmes, please check your 【pro_num】!');
    end

    GEP_info = complete_GEP_info(GEP_info);

    name_set = split(para.problem_name, '_');
    f1_name = name_set{2};
    f2_name = name_set{3};

    structure_name = ['function_', num2str(GEP_info.num_X), 'D'];
    f1 = eval(structure_name).(f1_name);
    f2 = eval(structure_name).(f2_name);

    expression =  ['[', f1, ',', f2, '];'];
    para = get_x(x, t1, t2, GEP_info.num_X, para);
    para = get_y(expression, para);

    X = rand(num_test_data_term_sharing, GEP_info.num_X) .* (para.x_upper - para.x_lower) + para.x_lower;
    for i = 1:size(X,2)
        eval(['X',num2str(i),'=X(:,',num2str(i),');'])
    end
    para.term_sharing = regexprep(para.term_sharing, '*', '.*');
    para.term_sharing = regexprep(para.term_sharing, '/', './');
    para.term_sharing = regexprep(para.term_sharing, '\^', '.\^');
    y = eval(para.term_sharing);
    [~, para.ymin_common, para.ymax_common] = map0to1(y);
end

function GEP_info = complete_GEP_info(GEP_info)
    GEP_info.terminals = [];
    for i = 1: GEP_info.num_X
        terminal = char(i + 64);
        GEP_info.terminals = [GEP_info.terminals, terminal];
    end
    GEP_info.terminals = [GEP_info.terminals, 't'];

    for i = 1: numel(GEP_info.functions)
        switch GEP_info.functions(i)
            case 'q'
                GEP_info.operators{i} = 'square_1';
                GEP_info.fnary(i) = 1;
            case 'c'
                GEP_info.operators{i} = 'cos';
                GEP_info.fnary(i) = 1;
            case 'n'
                GEP_info.operators{i} = '-';
                GEP_info.fnary(i) = 1;
            otherwise
                GEP_info.operators{i} = GEP_info.functions(i);
                GEP_info.fnary(i) = 2;
        end
    end
end

function para = get_x(x, t1, t2, num_X, para)
    para.x = rand(x.num_data, num_X) .* (x.upper - x.lower) + x.lower;
    para.x_t1 = rand(t1.num_data, num_X) .* (t1.upper - t1.lower) + t1.lower;
    para.x_t2 = rand(t2.num_data, num_X) .* (t2.upper - t2.lower) + t2.lower;
end

function para = get_y(expression, para)
    expression = regexprep(expression,'X([1-9])','X\(:,$1\)');

    expression = regexprep(expression, '*', '.*');
    expression = regexprep(expression, '/', './');
    expression = regexprep(expression, '\^', '.\^');

    X = para.x;
    para.y = eval(expression);

    X = para.x_t1;
    para.y_t1 =  eval(expression);

    X = para.x_t2;
    para.y_t2 =  eval(expression);
end