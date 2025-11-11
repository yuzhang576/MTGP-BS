function tree = tree_translate(tree)
    tree.math_expression = [];
    
    if ~isempty(tree.expression)

        for i = 1:length(tree.expression)
            switch tree.expression{i}
                case 'A'
                    tree.math_expression = [tree.math_expression, 'X(:,1)'];
                case 'B'
                    tree.math_expression = [tree.math_expression, 'X(:,2)'];
                case 'C'
                    tree.math_expression = [tree.math_expression, 'X(:,3)'];
                case 'D'
                    tree.math_expression = [tree.math_expression, 'X(:,1) - X(:,2)'];
                case 'd'
                    tree.math_expression = [tree.math_expression, 'X(:,2)/X(:,1)'];
                case 't'
                    tree.math_expression = [tree.math_expression, '0.5'];
                case '+'
                    tree.math_expression = [tree.math_expression, ' + '];
                case '-'
                    tree.math_expression = [tree.math_expression, ' - '];
                case 'n'
                    tree.math_expression = [tree.math_expression, '-'];
                case 'q'
                    tree.math_expression = [tree.math_expression, 'square_1'];
                case 'b'
                    tree.math_expression = [tree.math_expression, 'cube'];
                case 'u'
                    tree.math_expression = [tree.math_expression, 'square_05'];
                case 'c'
                    tree.math_expression = [tree.math_expression, 'cos'];
                case 's'
                    tree.math_expression = [tree.math_expression, 'sin'];
                case 'e'
                    tree.math_expression = [tree.math_expression, 'exp'];
                case 'g'
                    tree.math_expression = [tree.math_expression, 'log_1'];
                case 'j'
                    tree.math_expression = [tree.math_expression, 'exp_10'];
                otherwise
                    tree.math_expression = [tree.math_expression, tree.expression{i}];
            end
        end
    
        tree.math_expression = strrep(tree.math_expression, '*', '.*');
        tree.math_expression = strrep(tree.math_expression, '/', './');

        if tree.math_expression(1) == ' ' && tree.math_expression(2) == '+' && tree.math_expression(3) == ' '
            tree.math_expression = tree.math_expression(4, :);
        elseif tree.math_expression(1) == ' ' && tree.math_expression(2) == '-' && tree.math_expression(3) == ' '
            tree.math_expression = [tree.math_expression(2), tree.math_expression(4, :)];
        end
    end
end