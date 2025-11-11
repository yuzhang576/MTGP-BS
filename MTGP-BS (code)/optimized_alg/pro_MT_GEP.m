classdef pro_MT_GEP < PROBLEM
% <multi> <real> <large/none> <multitask>

    properties
        SubM;
        SubD;
        L1;
        L2;
        U1;
        U2;
        rotmx;
    end
    methods
        function Setting(obj)
            [para, ~] = obj.ParameterSet();
            obj.SubD      = repmat(para.D, 1, para.D_y);
            obj.SubM      = repmat(1, 1, para.D_y);
            obj.M         = max(obj.SubM);
            obj.D         = max(obj.SubD) + 1;
            obj.L1        = para.lower;
            obj.U1        = para.upper;
            obj.L2        = para.lower;
            obj.U2        = para.upper;
            obj.lower     = [para.lower, 1];
            obj.upper     = [para.upper, length(obj.SubD)];
            obj.encoding  = 2*ones(1,obj.D);
        end
        function PopObj = CalObj(obj,PopDec)
            [GEP_all, idx_task] = deal(PopDec(:,1:end-1), PopDec(:,end));

            [para, GEP_info] = obj.ParameterSet();
            GEP_string_all = GEP_translate(GEP_all, GEP_info);

            for i = 1: size(GEP_string_all, 1)
                GEP_string = GEP_string_all(i, :);
                tree = decoder_GEP(GEP_string, GEP_info);
                expression{i, 1} = tree.math_expression;
                GEP{i, 1} = tree.GEP;
            end

            X = para.x; % x
            y_pred = cellfun(@eval, expression, 'UniformOutput',false);
            for task_num = 1: para.D_y
                idx_sel = idx_task == task_num;
                y(idx_sel, 1) = {para.y(:, task_num)};
            end

            [expression_new, y_pred_new] = cellfun(@least_square_method, expression, y_pred, y, 'UniformOutput', 0);

            y_norm = para.y_norm;
            y_min = para.ymin;
            y_max = para.ymax;
            for task_num = 1: para.D_y
                mse(:, task_num) = cellfun(@get_mse, y_pred_new, repmat({y_norm(:, task_num)},size(y_pred_new)), repmat({y_min(:, task_num)},size(y_pred_new)), repmat({y_max(:, task_num)},size(y_pred_new)));
                idx_sel = idx_task == task_num;
                PopObj(idx_sel, 1) = mse(idx_sel, task_num);
            end
        end
    end
end