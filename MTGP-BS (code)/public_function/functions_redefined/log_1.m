function y = log_1(x1)
    if isnumeric(x1)
        idx = x1 <= 0;
        x1(idx) = 0;
    end

    y = log(x1);
end