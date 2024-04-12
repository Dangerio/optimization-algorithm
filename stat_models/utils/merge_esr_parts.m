function [result_object, summary_table] = merge_esr_parts(esr_paths, ouput_esr, output_summary)
    esrs = [];
    for i = 1:size(esr_paths, 2)
        esrs = [esrs, struct2array(load(esr_paths(i)))];
    end
    result_object = EstimationSimulationResult.merge(esrs);
    summary_table = EstimationSimulationResult.aggregate_results(result_object);

    save(ouput_esr, "result_object");
    save(output_summary, "summary_table");
end


