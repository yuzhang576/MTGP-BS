function fusion = model_fusion_v3(teacher, para, userVar)

    expression_teacher = teacher.expression_with_coefficient_simplified;
    [~, idx] = min(teacher.mse.train, [], 1);

    % get subexpressions from population
    % Corresponding Line 3 of Algorithm 1 in main paper
    if strcmp(userVar.problem_type, 'test_function')
        [teacher.sub_expressions.expressions, teacher.sub_expressions.occurrence_num] = sub_expresion_statistic_v2(expression_teacher, para);
        [teacher.sub_expressions.best_expressions, teacher.sub_expressions.best_occurrence_num] = sub_expresion_statistic_v2(expression_teacher(idx, :), para);
    elseif strcmp(userVar.problem_type, 'case_study')
        [teacher.sub_expressions.expressions, teacher.sub_expressions.occurrence_num] = sub_expresion_statistic_v2_case_study(expression_teacher, para);
        [teacher.sub_expressions.best_expressions, teacher.sub_expressions.best_occurrence_num] = sub_expresion_statistic_v2_case_study(expression_teacher(1, :), para);
    end

    % Corresponding to "Bidirectional Subexpression Cooperative Extrac-tion Method" and Consensus-Accelerated Shapley Analysis in main paper
    % （Algrithm S1 and Algrithm S2 in Appendix）
    fusion = get_subExpressions_v3_1(teacher, para, userVar);

    % Corresponding to "least sqyares method"（Line 7 of Algorithm 1 in main paper）
    fusion = get_fusion_model_v3(fusion, para, userVar);
end