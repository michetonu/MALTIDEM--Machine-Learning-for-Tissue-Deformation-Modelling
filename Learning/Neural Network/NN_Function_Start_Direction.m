results = NaN(1,4);
%force_node_compare = 82;
node_choice = 10;
e = NaN;
performance = NaN;
estd = NaN;

force_nodes = [82;91;101;107;129;140;148;163;174;185;203];

i=1;
for fnc = 1:size(force_nodes)
    force_node_compare = force_nodes(fnc);
    err = [];
    err2 = [];
    stad = [];
    perf = [];
    load_data = 1;
    nn_input = NaN;
    nn_input_compare = NaN;
    nn_output_compare = NaN;
    nn_output = NaN;
    
    for z = 1
        if z==1
            [nn_input,nn_input_compare,nn_output,nn_output_compare] = NN_Setup_OneNode_Directions_FUN(force_node_compare,node_choice,3);
        end
        [aaaa,y,e,e2,performance] = Script_OneNode_Dir(nn_input,nn_output,nn_input_compare,nn_output_compare);
        e;
        estd = std(aaaa);
        
        err = [err e];
        err2 = [err2 e2];
        stad = [stad estd];
        perf = [perf performance];
        load_data = 0;
    end
    
    results(i,1) = force_node_compare;
    results(i,2) = mean(err);
    results(i,3) = mean(stad);
    results(i,4) = mean(err2);
    i=i+1
end

