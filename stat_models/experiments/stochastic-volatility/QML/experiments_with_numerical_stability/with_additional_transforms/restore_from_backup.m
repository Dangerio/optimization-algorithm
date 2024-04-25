esr_paths = [];
sim_name = "qml_shvedov_params_gs";
num_parts = 5;

for i = 1:num_parts
    esr_paths = [esr_paths, sim_name + "_" + i];
end

[result_object, summary_table] = merge_esr_parts(esr_paths, sim_name, "summary_table");
