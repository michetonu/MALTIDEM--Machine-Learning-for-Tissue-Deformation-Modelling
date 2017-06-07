force_node_compare = 91;
node_choice = 10;

[nn_input,nn_input_compare,nn_output,nn_output_compare] = GPR_load_data(force_node_compare, node_choice);

gprmdl = fitrgp(nn_input,nn_output,'KernelFunction','ardsquaredexponential');
gpr_fit = predict(gprmdl,nn_input_compare);

gpr_err_list = nn_output_compare-gpr_fit;
gpr_std = std(abs(gpr_err_list));
performance = immse(nn_output_compare,gpr_fit)
gpr_err = mean(abs(gpr_err_list))

%Plot errors
histogram(gpr_err_list,20);
title('Error Histogram with 20 Bins');
xlabel('Errors (mm)')
ylabel('Instances')