function [para, GEP_info, expression] = define_benchmark_problem_v2(pro_num, para)
    num_test_data_term_sharing = 100000;

    function_1D.Nguyen1 = 'X1^3 + X1^2 + X1';
    function_1D.Nguyen2 = 'X1^4 + X1^3 + X1^2 + X1';
    function_1D.Nguyen3 = 'X1^5 + X1^4 + X1^3 + X1^2 + X1';
    function_1D.Nguyen4 = 'X1^6 + X1^5 + X1^4 + X1^3 + X1^2 + X1';
    function_1D.Nguyen5 = 'sin(X1^2)*cos(X1) - 1';
    function_1D.Nguyen6 = 'sin(X1) + sin(X1 + X1^2)';
    function_1D.Nguyen7 = 'log(X1 + 1) + log(X1^2 + 1)';
    function_1D.Nguyen8 = 'X1^0.5';

    function_2D.Jin1 = '2.5*X1^4 - 1.3*X1^3 + 0.5*X2^2 - 1.7*X2';
    function_2D.Jin2 = '8*X1^2 + 8*X2^3 - 15';
    function_2D.Jin3 = '0.2*X1^3 + 0.5*X2^3 - 1.2*X2 - 0.5*X1';
    function_2D.Jin4 = '1.5*exp(X1) + 5*cos(X2)';
    function_2D.Jin5 = '6*sin(X1)*cos(X2)';
    function_2D.Jin6 = '1.35*X1*X2 + 5.5*sin((X1 - 1)*(X2 - 1))';
        function_2D.Jin6_expand = '1.35*X1*X2 + 5.5*sin(X1*X2 - X2 - X1 + 1)';
    function_2D.Nguyen9 = 'sin(X1) + sin(X2^2)';
    function_2D.Nguyen10 = '2*sin(X1)*cos(X2)';
    function_2D.Nguyen11 = 'X1^X2';
    function_2D.Nguyen12 = 'X1^4 - X1^3 + 0.5*X2^2 - X2';

    switch pro_num
        case 1
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 'q', 'b'];
            [x_lower, x_upper, num_train, num_test] = deal(-3, 3, 100, 30);
            
            
            para.problem_name = 'merge_Jin2_Jin3_2D';
            para.term_sharing = 'X2^3';
        case 2
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 's', 'c', 'e'];
            [x_lower, x_upper, num_train, num_test] = deal(-3, 3, 100, 30);
            
            para.problem_name = 'merge_Jin4_Jin5_2D';
            para.term_sharing = 'cos(X2)';
        case 3
            GEP_info.num_X = 1;
            GEP_info.functions = ['+', '*', '-'];
            [x_lower, x_upper, num_train, num_test] = deal(-1, 1, 20, 10);
            
            para.problem_name = 'merge_Nguyen2_Nguyen3_1D_20';
            para.term_sharing = 'X1^4 + X1^3 + X1^2 + X1';
        case 4
            GEP_info.num_X = 1;
            GEP_info.functions = ['+', '*', '-'];
            [x_lower, x_upper, num_train, num_test] = deal(-1, 1, 100, 30);
            
            para.problem_name = 'merge_Nguyen2_Nguyen3_1D_100';
            para.term_sharing = 'X1^4 + X1^3 + X1^2 + X1';
        case 5
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 's', 'c'];
            [x_lower, x_upper, num_train, num_test] = deal(0, 1, 20, 10);
            
            para.problem_name = 'merge_Nguyen9_Nguyen10_2D_20';
            para.term_sharing = 'sin(X1)';
        case 6
            GEP_info.num_X = 2;
            GEP_info.functions = ['+', '*', '-', 's', 'c'];
            [x_lower, x_upper, num_train, num_test] = deal(0, 1, 100, 30);
            
            para.problem_name = 'merge_Nguyen9_Nguyen10_2D_100';
            para.term_sharing = 'sin(X1)';
        otherwise
            error('no such kind of problmes, please check your 【pro_num】!');
    end

    [para, x, t1, t2] = define_user_para(x_lower, x_upper, num_train, num_test, para);

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
            case 's'
                GEP_info.operators{i} = 'sin';
                GEP_info.fnary(i) = 1;
            case 'n'
                GEP_info.operators{i} = '-';
                GEP_info.fnary(i) = 1;
            case 'b'
                GEP_info.operators{i} = 'cube';
                GEP_info.fnary(i) = 1;
            case 'u'
                GEP_info.operators{i} = 'square_05';
                GEP_info.fnary(i) = 1;
            case 'e'
                GEP_info.operators{i} = 'exp';
                GEP_info.fnary(i) = 1;
            case 'g'
                GEP_info.operators{i} = 'log';
                GEP_info.fnary(i) = 1;
            case 'j'
                GEP_info.operators{i} = 'exp_10';
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

function [para, x, t1, t2] = define_user_para(x_lower, x_upper, num_train, num_test, para)
    [para.x_lower, para.x_upper] = deal(x_lower, x_upper);

    [x.lower, x.upper, x.num_data] = deal(para.x_lower, para.x_upper, num_train);
    [t1.lower, t1.upper, t1.num_data] = deal(para.x_lower, para.x_upper, num_test);
    [t2.lower, t2.upper, t2.num_data] = deal(para.x_lower + para.x_lower, para.x_upper + para.x_lower, num_test);
end