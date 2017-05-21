results = NaN(1,4);

force_nodes = [82;91;101;107;129;140;148;163;174;185;203];

i=1;
for fnc = 1:size(force_nodes)
    force_node_compare = force_nodes(fnc);
    err = [];
    stad = [];
    perf = [];
    emax = [];
    
        [nn_input,nn_input_compare,nn_output,nn_output_compare] = SVM_Var_Setup(force_node_compare);

        
        mdl = fitrsvm(nn_input,nn_output,'KernelFunction','rbf','KernelScale','auto','Standardize',true);
        svm_fit = predict(mdl,nn_input_compare);
        
        %Cross validation:
        %CVMdl = crossval(mdl);
        %svm_fit = kfoldPredict(CVMdl);
        
        svm_err_list = nn_output_compare-svm_fit;
        estd = std(abs(svm_err_list));
        err = mean(abs(svm_err_list));
        maxe = max(abs(svm_err_list));
        performance = immse(nn_output_compare,svm_fit);
        figure
        histogram(svm_err_list,20);
        title('Error Histogram with 20 Bins');
        xlabel('Errors (mm)')
        ylabel('Instances')
        
        err = [err e];
        stad = [stad estd];
        perf = [perf performance];
        emax = [emax maxe];
    
    Error(i,1) = mean(err);
    %Perc_Error(i,1) = mean(ep);
    Performance(i,1) = mean(perf);
    Std(i,1) = mean(stad);
    MaxErr(i,1) = mean(emax);
    %Node_Number{i,1} = num2str(force_node_compare);
    i=i+1
end

T = table(Performance,Error,Std,MaxErr);
