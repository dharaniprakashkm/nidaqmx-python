<%
    from codegen.utilities.function_helpers import get_functions,get_enums_used,get_function_name,order_function_parameters_by_optional,get_parameters_docstring_lines_length,get_parameter_signature,get_instantiation_lines,get_arguments_type,get_explicit_output_param,generate_function_call_args,instantiate_explicit_output_param
    from codegen.utilities.text_wrappers import wrap, docstring_wrap
    functions = get_functions(data)
    enums_used = get_enums_used(functions)
%>\
# Do not edit this file; it was automatically generated.
%if enums_used:
from nidaqmx.constants import (
    ${', '.join([c for c in enums_used]) | wrap(4, 4)})
%endif

class BaseInterpreter:
    """
    Contains signature of functions for all DAQmx APIs.
    """
################################################################################
## Script function signature.
################################################################################
% for func in functions:
    %if func.is_python_factory:
    @staticmethod
%endif
<%
    sorted_params = order_function_parameters_by_optional(func.parameters)
    parameter_signature = get_parameter_signature(is_python_factory, sorted_params)
    %>\
    %if (len(func.function_name) + len(parameter_signature)) > 68:
    def ${func.function_name}(
            ${parameter_signature + '):' | wrap(12, 12)}
    %else:
    def ${func.function_name}(${parameter_signature}):
    %endif
\
        pass

% endfor