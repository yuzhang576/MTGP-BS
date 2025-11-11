function GEP_string_all = GEP_translate(PopDec, GEP_info)
    string_temp = num2cell(PopDec);
    string_temp = cellfun(@num2str, string_temp, 'UniformOutput', false);

    terminals_functions = [GEP_info.terminals, GEP_info.functions];
    for i = numel(terminals_functions): -1: 1
        string_temp = strrep(string_temp, num2str(i), terminals_functions(i));
    end
    GEP_string_all = cell2mat(string_temp);
end