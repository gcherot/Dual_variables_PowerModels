function tot_constraints(model::JuMP.Model)
    n_cstr = 0
    for (F, S) in JuMP.list_of_constraint_types(model)
        n_cstr = n_cstr + JuMP.num_constraints(model,F,S)
    end
    return n_cstr
end

function get_cstr_dual(model::JuMP.Model)
    n_cstr = tot_constraints(model)
    dual_cstr_array = Array{Float64}(undef, n_cstr)
    dual_cstr_name = Array{String}(undef, n_cstr)
    idx = 1
    for (F, S) in JuMP.list_of_constraint_types(model)
        for cref in JuMP.all_constraints(model, F, S)
            dual_cstr_array[idx] = JuMP.dual(cref)
            dual_cstr_name[idx] = string(cref)
            idx = idx+1
        end
    end
    return dual_cstr_array, dual_cstr_name
end

function get_var_dual(model::JuMP.Model)
    n = length(JuMP.all_variables(model))
    dual_var_upr_array = Array{Float64}(undef, n)
    dual_var_lwr_array = Array{Float64}(undef, n)
    dual_var_name = Array{String}(undef, n)

    # retreive all duals associated to a variable (not sorted)
    k = 1
    for var in JuMP.all_variables(model)
        if JuMP.has_lower_bound(var)
            dual_var_lwr_array[k] = JuMP.dual(JuMP.LowerBoundRef(var))
        end
        if JuMP.has_upper_bound(var)
            dual_var_upr_array[k] = JuMP.dual(JuMP.UpperBoundRef(var))
        end
        dual_var_name[k] = string(var)
        k = k+1
    end
    return dual_var_upr_array, dual_var_lwr_array, dual_var_name
end

function get_dual(model::JuMP.Model)
    dual_cstr_array, dual_cstr_name = get_cstr_dual(model)
    dual_var_upr_array, dual_var_lwr_array, dual_var_name = get_var_dual(model)
    return dual_cstr_array, dual_cstr_name, dual_var_upr_array, dual_var_lwr_array, dual_var_name
end