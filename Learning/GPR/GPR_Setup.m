

%'ardsquaredexponential'
gprmdl = fitrgp(nn_input,nn_output,'KernelFunction','ardsquaredexponential');
gpr_fit = predict(gprmdl,nn_input_compare);

% Cross validation:
%CVMdl = crossval(mdl);
%svm_fit = kfoldPredict(CVMdl);

gpr_err_list = nn_output_compare-gpr_fit;
gpr_std = std(abs(gpr_err_list));
performance = immse(nn_output_compare,gpr_fit)
gpr_err = mean(abs(gpr_err_list))
histogram(gpr_err_list,20);
title('Error Histogram with 20 Bins');
xlabel('Errors (mm)')
ylabel('Instances')