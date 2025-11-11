function member = get_simplified_expression(member, para)
    for task_num = 1: para.D_y
        expression = member.expression_with_coefficient(:, task_num);

        for i = 1: para.D_x
            termianl_name_new = ['X', num2str(i)];
            syms(termianl_name_new)
            termianl_name_old = ['X(:,', num2str(i), ')'];
            expression = cellfun(@strrep, expression,repmat({termianl_name_old}, size(expression)), repmat({termianl_name_new}, size(expression)), 'UniformOutput', 0);
        end

        expression_simplify = cellfun(@eval, expression, 'UniformOutput', 0);
        idx = ~cellfun(@isa, expression_simplify, repmat({'sym'}, size(expression_simplify)));
        if sum(idx) ~= 0
            expression_simplify(idx) = mat2cell(sym(expression_simplify(idx)), ones(size(expression_simplify(idx), 1), 1), 1);
        end
        
        expression_simplify_expand = cellfun(@expand, expression_simplify, 'UniformOutput', 0);
        idx1 = ~cellfun(@isnumeric,expression_simplify_expand);
        expression_simplify_expand(idx1) = cellfun(@vpa, expression_simplify_expand(idx1),repmat({4}, size(expression_simplify_expand)), 'UniformOutput', 0);
        expression_simplify_expand(idx1) = cellfun(@char,expression_simplify_expand(idx1),'UniformOutput',0);
        
        expression_simplify_no_expand = expression_simplify;
        idx1 = ~cellfun(@isnumeric,expression_simplify_no_expand);
        expression_simplify_no_expand(idx1) = cellfun(@vpa,expression_simplify_no_expand(idx1),repmat({4},size(expression_simplify_no_expand(idx1))),'UniformOutput',0);
        expression_simplify_no_expand(idx1) = cellfun(@char,expression_simplify_no_expand(idx1),'UniformOutput',0);
        
        length_expression_simplify_expand = cellfun(@length,expression_simplify_expand);
        idx2 = length_expression_simplify_expand>100; % 过长
        expression_simplify_expand(idx2) = expression_simplify_no_expand(idx2);
        expression_simplify_no_expand(~idx2) = expression_simplify_expand(~idx2);

        member.expression_with_coefficient(:, task_num) = expression;
        member.expression_with_coefficient_simplified(:, task_num) = expression_simplify_no_expand;
    end
end