results = NaN(1,4);

force_nodes = [82;91;101;107;129;140;148;163;174;185;203];
error = []
performance = []
stdev = []
maxerr = []
i=1;
for fnc = 1:size(force_nodes)
    force_node_compare = force_nodes(fnc);
    err = [];
    stad = [];
    perf = [];
    maxe = [];
    
        [nn_input,nn_input_compare,nn_output,nn_output_compare] = GPR_Function_Setup(force_node_compare);

        
        %'ardsquaredexponential'
        gprmdl = fitrgp(nn_input,nn_output,'KernelFunction','ardsquaredexponential');
        gpr_fit = predict(gprmdl,nn_input_compare);
        
        % Cross validation:
        %CVMdl = crossval(mdl);
        %svm_fit = kfoldPredict(CVMdl);
        
        gpr_err_list = nn_output_compare-gpr_fit;
        estd = std(abs(gpr_err_list));
        performance = immse(nn_output_compare,gpr_fit);
        e = mean(abs(gpr_err_list));
        emax = max(abs(gpr_err_list));
        
        err = [err e];
        maxe = [maxe emax];
        stad = [stad estd];
        perf = [perf performance];

    
    error(i,1) = mean(err);
    performance(i,1) = mean(perf);
    stdev(i,1) = mean(stad);
    maxerr(i,1) = mean(maxe);
    i=i+1
end

T = table(error,performance,stdev,maxerr);
