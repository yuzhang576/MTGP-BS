function mse = get_mse(y_pred,y_norm,ymin,ymax)
    y_pred_norm = map0to1(y_pred,ymin,ymax);
    mse = sum(sqrt((y_pred_norm - y_norm).^2) ./ size(y_norm,1), 'all');
end