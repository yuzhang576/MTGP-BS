function fusion = evaluate_quality_fusion_v2(fusion, para, userVar)
    for task_num = 1: para.D_y
        field_name = ['task', num2str(task_num)];
        expressions{task_num} = fusion.(field_name).expression;
    end

    expressions = strrep(expressions, '^', '.^');
    expressions = strrep(expressions, '*', '.*');
    expressions = strrep(expressions, '/', './');

    X = para.x;
    for X_num = 1: para.D_x
        eval(['X',num2str(X_num),'=X(:,',num2str(X_num),');'])
    end
    y = para.y_norm;
    clear y_pred
    for task_num = 1: para.D_y
        field_name = ['task', num2str(task_num)];
        temp = eval(expressions{:, task_num});
        if numel(temp) == 1
            y_pred(:, task_num) = repmat(temp, size(X, 1), 1);
        else
            y_pred(:, task_num) = temp;
        end
        clear temp
        fusion.(field_name).mse.train = get_mse(y_pred(:, task_num), y(:, task_num), para.ymin(:, task_num), para.ymax(:, task_num));
    end

    X = para.x_t1;
    for X_num = 1: para.D_x
        eval(['X',num2str(X_num),'=X(:,',num2str(X_num),');'])
    end
    y = para.y_norm_t1;
    clear y_pred
    for task_num = 1: para.D_y
        field_name = ['task', num2str(task_num)];
        temp = eval(expressions{:, task_num});
        if numel(temp) == 1
            y_pred(:, task_num) = repmat(temp, size(X, 1), 1);
        else
            y_pred(:, task_num) = temp;
        end
        clear temp
       fusion.(field_name).mse.test1 = get_mse(y_pred(:, task_num), y(:, task_num), para.ymin(:, task_num), para.ymax(:, task_num));
    end

    X = para.x_t2;
    for X_num = 1: para.D_x
        eval(['X',num2str(X_num),'=X(:,',num2str(X_num),');'])
    end
    y = para.y_norm_t2;
    clear y_pred
    for task_num = 1: para.D_y
        field_name = ['task', num2str(task_num)];
        temp = eval(expressions{:, task_num});
        if numel(temp) == 1
            y_pred(:, task_num) = repmat(temp, size(X, 1), 1);
        else
            y_pred(:, task_num) = temp;
        end
        clear temp
        fusion.(field_name).mse.test2 = get_mse(y_pred(:, task_num), y(:, task_num), para.ymin(:, task_num), para.ymax(:, task_num));
    end
end