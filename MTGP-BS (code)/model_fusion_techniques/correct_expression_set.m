function [sub_expressions_all, occurrence_num_all]  = correct_expression_set(sub_expressions_all, occurrence_num_all)
    occurrence_num_all(cellfun(@isempty, sub_expressions_all)) = [];
    sub_expressions_all(cellfun(@isempty, sub_expressions_all)) = [];

    occurrence_num_all(~cellfun(@check_str, sub_expressions_all)) = [];
    sub_expressions_all(~cellfun(@check_str, sub_expressions_all)) = [];

    occurrence_num_all(~cellfun(@contains, sub_expressions_all, repmat({'X'}, size(sub_expressions_all)))) = [];
    sub_expressions_all(~cellfun(@contains, sub_expressions_all, repmat({'X'}, size(sub_expressions_all)))) = [];
end

function is_legal = check_str(str)
    idx1 = findstr(str, '(');
    idx2 = findstr(str, ')');
    if numel(idx1) == numel(idx2)
        is_legal = 1;
    else
        is_legal = 0;
    end
end