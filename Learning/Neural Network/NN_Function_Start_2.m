aa=1;
T_ERR = cell(1,1);

node_choice = 10;

force_nodes = [82;91;101;107;129;140;148;163;174;185;203];
%force_node_compare = 82;
%force_nodes = force_nodes(force_nodes(:,1)~=force_node_compare,1);

e = NaN;
performance = NaN;
estd = NaN;
maxe = NaN;
Node_Number = cell(1,1);

for i = 1:size(force_nodes)
    force_node_compare = force_nodes(i);
    
    err = [];
    stad = [];
    perf = [];
    ep = [];
    emax = [];
    
    for z = 1
        
        if z==1
            [nn_input,nn_input_compare,nn_output,nn_output_compare] = NN_Setup_OneNode_MoreVar_FUN(force_node_compare,node_choice);
        end
        [aaaa,y,e,eperc,performance] = Script_OneNode(nn_input,nn_output,nn_input_compare,nn_output_compare,4);
        e;
        estd = std(aaaa);
        maxe = max(aaaa);
        
        err = [err e];
        ep = [ep eperc];
        stad = [stad estd];
        perf = [perf performance];
        emax = [emax maxe];
    end
    
    %results(i,1) = node_choice;
    Error(i,1) = mean(err);
    Perc_Error(i,1) = mean(ep);
    Performance(i,1) = mean(perf);
    Std(i,1) = mean(stad);
    MaxErr(i,1) = mean(emax);
    %Node_Number{i,1} = num2str(node_choice);
    i=i+1
end

T = table(Performance,Error,Std,MaxErr);

