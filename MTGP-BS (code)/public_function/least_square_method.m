function [expression_theta, y_predicted] = least_square_method(final_str,y_pred,y)
    expression = final_str;
    y_predict = [y_pred, ones(size(y_pred,1), 1)];
    prj = y_predict' * y_predict;
    try
        theta = pinv(prj) * y_predict' * y;
    catch
        theta = [1;0];
    end
    y_predicted = y_predict * theta;
    expression_theta = [num2str(theta(1)),'*(',expression,')', '+', num2str(theta(2))];
end