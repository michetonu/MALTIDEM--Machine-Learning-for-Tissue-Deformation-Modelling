%% Train and test an SVM model for the displacement magnitude

force_node_compare = 91;
node_choice = 10;
[nn_input,nn_input_compare,nn_output,nn_output_compare] = SVM_load_data(force_node_compare,node_choice);
% Run SVM
mdl = fitrsvm(nn_input,nn_output,'KernelFunction','gaussian','KernelScale','auto','Standardize',true);
svm_fit = predict(mdl,nn_input_compare);

svm_err_list = nn_output_compare-svm_fit;
svm_std = std(abs(svm_err_list));
svm_err = mean(abs(svm_err_list))
performance = immse(nn_output_compare,svm_fit)

%Plot results
figure
hist(svm_err_list,20);
set(gca,'FontSize',16)
xlabel('Errors (mm)')
ylabel('Percentage')
x=get(gca,'YTickLabel');
x=[0;20;40;60;80;100;120;140];
x=x./sum(size(dist)); 
set(gca,'YTickLabel',num2str(x,2));