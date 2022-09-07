function run_powermodels_pf(json_path)
    pm = load_pm_from_json(json_path)
    active_powermodels_silence!(pm)
    pm = check_powermodels_data!(pm)

    # calculate branch power flows
    if pm["pm_model"] == "ACNative"
        result = _PM.compute_ac_pf(pm)
    elseif pm["pm_model"] == "DCNative"
        result = _PM.compute_dc_pf(pm)
    else
        model = get_model(pm["pm_model"])
        solver = get_solver(pm)
        result = _PM.solve_pf(
            pm,
            model,
            solver,
            setting = Dict("output" => Dict("branch_flows" => true)),
        )
    end

    # add result to net data
    _PM.update_data!(pm, result["solution"])
    # calculate branch power flows
    if pm["ac"]
        flows = _PM.calc_branch_flow_ac(pm)
    else
        flows = _PM.calc_branch_flow_dc(pm)
    end
    # add flow to net and result
    _PM.update_data!(result["solution"], flows)
    # _PM.update_data!(pm, result["solution"])
    # _PM.update_data!(pm, flows)
    return result
end

function run_powermodels_opf(json_path)
    pm = _PdM.load_pm_from_json(json_path)
    active_powermodels_silence!(pm)

    model = get_model(pm["pm_model"])
    solver = get_solver(pm)
    cl = check_current_limit!(pm)

    if cl == 0
        pm = check_powermodels_data!(pm)
        pm_model = _PM.instantiate_model(pm, model, PowerModels.build_opf)
        result = _IM.optimize_model!(pm_model,
            optimizer=Ipopt.Optimizer
        )
    else

        for (key, value) in pm["gen"]
           value["pmin"] /= pm["baseMVA"]
           value["pmax"] /= pm["baseMVA"]
           value["qmax"] /= pm["baseMVA"]
           value["qmin"] /= pm["baseMVA"]
           value["pg"] /= pm["baseMVA"]
           value["qg"] /= pm["baseMVA"]
           value["cost"] *= pm["baseMVA"]
        end

        for (key, value) in pm["branch"]
           value["c_rating_a"] /= pm["baseMVA"]
        end

        for (key, value) in pm["load"]
           value["pd"] /= pm["baseMVA"]
           value["qd"] /= pm["baseMVA"]
        end
        pm_model = _PM.instantiate_model(pm, model, PowerModels.build_opf)

        result = _IM.optimize_model!(pm_model,
            optimizer=Ipopt.Optimizer
        )
    end

    dual_cstr_array, dual_cstr_name, dual_var_upr_array, dual_var_lwr_array, dual_var_name = get_dual(pm_model.model)
    return result, dual_cstr_array, dual_cstr_name, dual_var_upr_array, dual_var_lwr_array, dual_var_name
end

function run_powermodels_tnep(json_path)
    pm = _PdM.load_pm_from_json(json_path)
    active_powermodels_silence!(pm)
    pm = check_powermodels_data!(pm)
    model = get_model(pm["pm_model"])
    solver = get_solver(pm)

    result = _PM.solve_tnep(
        pm,
        model,
        solver,
        setting = Dict("output" => Dict("branch_flows" => true)),
    )
    return result
end

function run_powermodels_ots(json_path)
    pm = _PdM.load_pm_from_json(json_path)
    active_powermodels_silence!(pm)
    pm = check_powermodels_data!(pm)
    model = get_model(pm["pm_model"])
    solver = get_solver(pm)

    result = _PM.solve_ots(
        pm,
        model,
        solver,
        setting = Dict("output" => Dict("branch_flows" => true)),
    )
    return result
end
