results = NaN(1,4);
force_node_compare = 82;
e = NaN;
performance = NaN;
estd = NaN;
y_magg = cell(1,1);
y_dirr = cell(1,1);

i=1;
for node_choice = 1:10:1080
    err = [];
    stad = [];
    perf = [];
    
    load_data = 1;
    
    [nn_input,nn_input_compare,nn_output,nn_output_compare] = SVM_Var_Setup(force_node_compare,node_choice);
    
    mdl = fitrsvm(nn_input,nn_output,'KernelFunction','rbf','KernelScale','auto','Standardize',true);
    svm_fit = predict(mdl,nn_input_compare);
    y_magg{i} = svm_fit;

    [nn_input,nn_input_compare,nn_output,nn_output_compare] = SVM_DIr_Setup(force_node_compare,node_choice);
        for zz = 1:3
            mdl = fitrsvm(nn_input,nn_output(:,zz),'KernelFunction','rbf','KernelScale','auto','Standardize',true);
            svm_fit = predict(mdl,nn_input_compare);
            y_dirr{i,zz} = svm_fit;
        end
    i=i+1
end

save('SVM_output','y_magg','y_dirr')