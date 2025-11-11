function member = evaluate_quality_student_teacher(member, para)
    idx_task = member.Dec(:,end);

    X = para.x;
    y_pred = cellfun(@eval, member.expression, 'UniformOutput',false);
    for task_num = 1: para.D_y
        idx_sel = idx_task == task_num;
        y(idx_sel, 1) = {para.y(:, task_num)};
    end

    [expression_new, y_pred_new] = cellfun(@least_square_method, member.expression, y_pred, y, 'UniformOutput', 0);

    expression_new = reshape(expression_new, [], para.D_y);
    member.expression_with_coefficient = expression_new;
    
    X = para.x;
    y = para.y_norm;
    clear y_pred
    for task_num = 1: para.D_y
        y_pred(:, task_num) = cellfun(@eval, expression_new(:, task_num), 'UniformOutput', 0);
        mse_temp(:, task_num) = cellfun(@get_mse, y_pred(:, task_num), repmat({y(:, task_num)}, size(y_pred(:, task_num))), ...
            repmat({para.ymin(:, task_num)}, size(y_pred(:,task_num))), repmat({para.ymax(:, task_num)}, size(y_pred(:, task_num))));
    end
    member.mse.train = mse_temp;

    X = para.x_t1;
    y = para.y_norm_t1;
    clear y_pred
    for task_num = 1: para.D_y
        y_pred(:, task_num) = cellfun(@eval, expression_new(:, task_num), 'UniformOutput', 0);
        mse_temp(:, task_num) = cellfun(@get_mse, y_pred(:, task_num), repmat({y(:, task_num)}, size(y_pred(:, task_num))), ...
            repmat({para.ymin(:, task_num)}, size(y_pred(:,task_num))), repmat({para.ymax(:, task_num)}, size(y_pred(:, task_num))));
    end
    member.mse.test1 = mse_temp;

    X = para.x_t2;
    y = para.y_norm_t2;
    clear y_pred
    for task_num = 1: para.D_y
        y_pred(:, task_num) = cellfun(@eval, expression_new(:, task_num), 'UniformOutput', 0);
        mse_temp(:, task_num) = cellfun(@get_mse, y_pred(:, task_num), repmat({y(:, task_num)}, size(y_pred(:, task_num))), ...
            repmat({para.ymin(:, task_num)}, size(y_pred(:,task_num))), repmat({para.ymax(:, task_num)}, size(y_pred(:, task_num))));
    end
    member.mse.test2 = mse_temp;
end