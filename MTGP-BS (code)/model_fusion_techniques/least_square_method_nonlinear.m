function [expression_theta, y_predicted, sub_expressions, theta] = least_square_method_nonlinear(final_str, sub_expressions, y_pred, y, para, userVar)
    [~, ~, sub_expressions, ~] = least_square_method_multinomial(final_str, sub_expressions, y_pred, y, para, userVar);

    sub_expressions_temp = sub_expressions;
    sub_expressions_temp(cellfun(@strcmp, sub_expressions_temp, repmat({'$'}, size(sub_expressions_temp)))) = [];

    sub_expressions_temp = regexprep(sub_expressions_temp, '10\.0\^(X[0-9]+)', '10.0^\(b\*$1\)');
    sub_expressions_temp = regexprep(sub_expressions_temp, '10\.0\^\((X)', '10.0^\(b\*$1');

    expression = ['b*', char(join(sub_expressions_temp, ' + b*'))];

    idx = strfind(expression, 'b');
    for i = numel(idx): -1: 1
        coefficient = ['b(', num2str(i), ')'];
        expression = [expression(1: idx(i) - 1), coefficient, expression(idx(i) + 1: end)];
    end

    expression = strrep(expression, '*', '.*');
    expression = strrep(expression, '/', './');
    expression = strrep(expression, '^', '.^');
    for i = 1: para.D_x
        expression = strrep(expression, ['X', num2str(i)], ['X(:, ', num2str(i), ')']);
    end
    mymodel = inline(expression,'b','X');
    beta0 = ones(1, numel(idx));
    beta = nlinfit(para.x, y, mymodel, beta0);
    
    [start_idx, end_idx] = regexp(expression, 'b\(*[0-9]+\)');
    for i = numel(beta): -1: 1
        expression = [expression(1: start_idx(i) - 1), num2str(beta(i)), expression(end_idx(i) + 1: end)];
    end
    expression_theta = expression;
    theta = beta;
    X = para.x;
    y_predicted = eval(expression);

    expression_theta = strrep(expression_theta, '.*', '*');
    expression_theta = strrep(expression_theta, './', '/');
    expression_theta = strrep(expression_theta, '.^', '^');
end