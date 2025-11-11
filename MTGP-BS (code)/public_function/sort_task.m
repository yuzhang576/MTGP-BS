function member = sort_task(member, para)
    pop_size = para.N/para.D_y;
    for task_num = 1: para.D_y
        [dec_temp, GEP_temp, obj_temp] = deal(member.Dec((task_num - 1)*pop_size + 1: task_num*pop_size, :), ...
                                              member.GEP((task_num - 1)*pop_size + 1: task_num*pop_size, :), ...
                                              member.Obj((task_num - 1)*pop_size + 1: task_num*pop_size, :));

        [obj_temp, idx] = sort(obj_temp);
        dec_temp = dec_temp(idx, :);
        GEP_temp = GEP_temp(idx, :);

        [member.Dec((task_num - 1)*pop_size + 1: task_num*pop_size, :), ...
         member.GEP((task_num - 1)*pop_size + 1: task_num*pop_size, :), ...
         member.Obj((task_num - 1)*pop_size + 1: task_num*pop_size, :)] = deal(dec_temp, GEP_temp, obj_temp);
    end
end