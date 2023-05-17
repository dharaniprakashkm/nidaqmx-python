<%page args="function"/>\
<%
    from codegen.utilities.interpreter_helpers import get_grpc_interpreter_call_params, get_params_for_function_signature, get_output_params, get_compound_parameter, create_compound_parameter_request, get_input_arguments_for_compound_params, check_if_parameters_contain_read_array, get_read_array_parameters, is_custom_read_write_function, get_numpy_array_params
    from codegen.utilities.function_helpers import order_function_parameters_by_optional
    from codegen.utilities.text_wrappers import wrap
    from codegen.utilities.helpers import snake_to_pascal
%>\
<%
    params = get_params_for_function_signature(function, True)
    sorted_params = order_function_parameters_by_optional(params)
    output_parameters = get_output_params(function)
    compound_parameter = get_compound_parameter(function.base_parameters)
    grpc_interpreter_params = get_grpc_interpreter_call_params(function, sorted_params)
    is_read_method = check_if_parameters_contain_read_array(function.base_parameters)
    %>\
    %if (compound_parameter is not None):
        ${compound_parameter.parameter_name} = []
        for index in range(len(${get_input_arguments_for_compound_params(function)[0]})):
            ${compound_parameter.parameter_name}.append(${create_compound_parameter_request(function)})
    %endif
    %if (function.is_init_method):
        metadata = (
            ('ni-api-key', self._grpc_options.api_key),
        )
    %endif
        %if is_custom_read_write_function(function):
        %for parameter_name, parameter_dtype in get_numpy_array_params(function).items():
        _validate_array_dtype(${parameter_name}, ${parameter_dtype})
        %endfor
        %endif
        response = self._invoke(
            self._client.${snake_to_pascal(function.function_name)},
        %if (len(function.function_name) + len(grpc_interpreter_params)) > 68:
            grpc_types.${snake_to_pascal(function.function_name)}Request(
            %if function.is_init_method:
                ${grpc_interpreter_params | wrap(16, 16)}),
            metadata=metadata)
            %else:
                ${grpc_interpreter_params + ')' | wrap(16, 16)})
            %endif
        %else:
        %if function.is_init_method:
            grpc_types.${snake_to_pascal(function.function_name)}Request(${grpc_interpreter_params + ')'},
            metadata=metadata)
        %else:
            grpc_types.${snake_to_pascal(function.function_name)}Request(${grpc_interpreter_params + ')'})
        %endif
        %endif
        %if is_read_method:
        % for param in get_read_array_parameters(function):
        _assign_numpy_array(${param}, response.${param})
        % endfor
        %endif
        %if function.function_name == 'clear_task':
        self._unregister_done_event_callbacks()
        self._unregister_every_n_samples_event_callbacks()
        self._unregister_signal_event_callbacks()
        %endif
