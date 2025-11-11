%% MTGP-BS
% pltemo version: PlatEMO 4.0 
clear; clc; dbstop if error
cd(fileparts(mfilename('fullpath')));addpath(genpath(cd));

[para, distill, userVar] = initialize_parmeter_v1();

for run_num = 1: para.shared.run
    for pro_num = para.shared.pro_processed
        
        [GEP_info, para, userVar] = set_parameter(pro_num, para, userVar);

        [teacher.Dec, teacher.Obj] = platemo('problem', {@pro_MT_GEP,para.teacher_opt,GEP_info.teacher}, 'algorithm', {@MOMFEAII_GEP_teacher, GEP_info.teacher.function_numbers, GEP_info.teacher.head_length, para.inProcess, para.teacher_opt.num_more}, ...
            'N', para.teacher_opt.N, 'D', para.teacher_opt.D, 'M', para.teacher_opt.M, 'maxFE', para.teacher_opt.maxFE);
        cd(fileparts(mfilename('fullpath')));

        [teacher_GEP_Dec, idx_task] = deal(teacher.Dec(:,1:end-1), teacher.Dec(:,end));
        teacher.GEP = GEP_translate(teacher_GEP_Dec, GEP_info.teacher);

        teacher = sort_task(teacher, para.teacher_opt);
        for i = 1: size(teacher.GEP, 1)
            GEP_string_temp = teacher.GEP(i, :);
            tree = decoder_GEP(GEP_string_temp, GEP_info.teacher);
            teacher.expression{i, 1} = tree.math_expression;
        end

        teacher = evaluate_quality_student_teacher(teacher, para.teacher_opt);
        teacher = get_simplified_expression(teacher, para.teacher_opt);

        % corrensponding to "Proposed Method" in main paper
        fusion = model_fusion_v3(teacher, para.teacher_opt, userVar);

        fusion = evaluate_quality_fusion_v2(fusion, para.teacher_opt, userVar);

        file_name = [mfilename, '_head10'];
        field_name = [para.shared.problem_name, '_run_', num2str(run_num)];
        if exist(['./results/',file_name, '.mat'],'file')
            load(['./results/',file_name, '.mat'],'pop_results_this')
        else
            mkdir('./results');
        end
        
        pop_results_this.(field_name).para = para;
        pop_results_this.(field_name).GEP_info = GEP_info;
        pop_results_this.(field_name).distill = distill;
        pop_results_this.(field_name).userVar = userVar;
        pop_results_this.(field_name).teacher = teacher;
        pop_results_this.(field_name).fusion = fusion;
        save(['./results/',file_name, '.mat'],'pop_results_this');
    end
end

disp('Finished running')
disp(datestr(now,'yyyy-mm-dd HH:MM'))