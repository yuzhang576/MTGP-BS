function [expression_theta, y_predicted, sub_expressions, theta] = least_square_method_multinomial(final_str, sub_expressions, y_pred, y, para, userVar)
    expression = final_str;
    y_predict = [y_pred, ones(size(y_pred,1), 1)];
    prj = y_predict' * y_predict;
    try
        theta = pinv(prj) * y_predict' * y;
    catch
        theta = [1;0];
    end

    sub_expressions = [sub_expressions; {'$'}];
    idx = abs(theta) < 10e-6;
    if sum(idx) < numel(theta)
        sub_expressions(idx) = [];
        theta(idx) = [];
        y_predict(:, idx) = [];
    else
        y_predict_temp = y_predict;
        [theta, idx] = sort(abs(theta), 'descend');
        sub_expressions = sub_expressions(idx);
        y_predict = y_predict_temp(:, idx);

        theta(floor(userVar.expression_length/2) + 1: end) = [];
        sub_expressions(floor(userVar.expression_length/2) + 1: end) = [];
        y_predict(:, floor(userVar.expression_length/2) +  1: end) = [];
    end

    y_predict_temp = y_predict;
    if numel(sub_expressions) > userVar.expression_length
        [theta, idx] = sort(abs(theta), 'descend');
        sub_expressions = sub_expressions(idx);
        y_predict = y_predict_temp(:, idx);

        theta(userVar.expression_length + 1: end) = [];
        sub_expressions(userVar.expression_length + 1: end) = [];
        y_predict(:, userVar.expression_length +  1: end) = [];
    end

    prj = y_predict' * y_predict;
    try
        theta = pinv(prj) * y_predict' * y;
    catch
        theta = [1;0];
    end

    idx = abs(theta) < 10e-6;
    while any(idx)
        sub_expressions(idx) = [];
        theta(idx) = [];
        y_predict(:, idx) = [];

        prj = y_predict' * y_predict;
        try
            theta = pinv(prj) * y_predict' * y;
        catch
            theta = [1;0];
        end

        idx = abs(theta) < 10e-6;
    end

    if strcmp(userVar.problem_type, 'case_study')
        idx_selected_constant = contains(sub_expressions, '$');
        feature_selected = sub_expressions(idx_selected_constant);
        theta_selected = theta(idx_selected_constant);
        y_predicted_selected = y_predict(:, idx_selected_constant);

        idx_feature_power = any([contains(sub_expressions, '10.0^X1'), contains(sub_expressions, '10.0^X2')], 2);
        if sum(idx_feature_power) > 2
            [feature_selected, theta_selected, y_predicted_selected] = get_important_feature(idx_feature_power, sub_expressions, theta, y_predict, feature_selected, theta_selected, y_predicted_selected);
        else
            feature_selected = [feature_selected; sub_expressions(idx_feature_power)];
            theta_selected = [theta_selected; theta(idx_feature_power)];
            y_predicted_selected = [y_predicted_selected, y_predict(:, idx_feature_power)];
        end

        idx_feature_poly = ~any([contains(sub_expressions, '10.0^X1'), contains(sub_expressions, '10.0^X2'), contains(sub_expressions, '$')], 2);
        if sum(idx_feature_poly) > 2
            [feature_selected, theta_selected, y_predicted_selected] = get_important_feature(idx_feature_poly, sub_expressions, theta, y_predict, feature_selected, theta_selected, y_predicted_selected);
        else
            feature_selected = [feature_selected; sub_expressions(idx_feature_poly)];
            theta_selected = [theta_selected; theta(idx_feature_poly)];
            y_predicted_selected = [y_predicted_selected, y_predict(:, idx_feature_poly)];
        end

        clear sub_expressions theta y_predicted
        sub_expressions = feature_selected;
        theta = theta_selected;
        y_predict = y_predicted_selected;

        prj = y_predict' * y_predict;
        try
            theta = pinv(prj) * y_predict' * y;
        catch
            theta = [1;0];
        end
    end

    y_predicted = y_predict * theta;

    expression_theta = [];
    for i  = 1: numel(sub_expressions)
        expression_theta = [expression_theta, num2str(theta(i)),'*(',sub_expressions{i},')', '+'];
    end

    expression_theta = strrep(expression_theta, '*($)', '');
    expression_theta(end) = [];

    expression_theta = strrep(expression_theta, '^', '.^');
    expression_theta = strrep(expression_theta, '*', '.*');
    expression_theta = strrep(expression_theta, '/', './');

    for X_num = 1: para.D_x
        syms(['X', num2str(X_num)]);
    end
    expression_theta = char(vpa(eval(expression_theta), 2));

end

function [feature_selected, theta_selected, y_predicted_selected] = get_important_feature(idx_feature_more, sub_expressions, theta, y_predict, feature_selected, theta_selected, y_predicted_selected)
    feature_more = sub_expressions(idx_feature_more);
    theta_feature_more_abs = abs(theta(idx_feature_more));
    theta_feature_more = theta(idx_feature_more);
    y_predicted_more = y_predict(:, idx_feature_more);

    idx_feature_grouping = kmeans(theta_feature_more_abs, 2);
    [~, idx_feature_max_theta] = max(theta_feature_more_abs);
    idx_feature_selcted = idx_feature_grouping == idx_feature_grouping(idx_feature_max_theta);

    feature_selected = [feature_selected; feature_more(idx_feature_selcted)];
    theta_selected = [theta_selected; theta_feature_more(idx_feature_selcted)];
    y_predicted_selected = [y_predicted_selected, y_predicted_more(:, idx_feature_selcted)];
end