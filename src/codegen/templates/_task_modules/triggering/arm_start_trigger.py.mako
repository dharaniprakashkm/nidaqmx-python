<%
    from codegen.utilities.text_wrappers import wrap
    from codegen.utilities.function_helpers import get_functions, get_enums_used as functions_enums
    from codegen.utilities.attribute_helpers import get_attributes,  get_enums_used as attribute_enums, transform_attributes
    from codegen.utilities.helpers import get_enums_to_import
    from codegen.utilities.text_wrappers import wrap
    attributes = get_attributes(data, "ArmStartTrigger")
    attributes =  transform_attributes(attributes, "ArmStartTrigger")
    functions = get_functions(data,"ArmStartTrigger")
    attr_enums = attribute_enums(attributes)
    fuct_enums = functions_enums(functions)
    enums_used = get_enums_to_import(attr_enums, fuct_enums)
%>\
# Do not edit this file; it was automatically generated.

import ctypes
import numpy

from nidaqmx._lib import (
    lib_importer, wrapped_ndpointer, ctypes_byte_str, c_bool32)
from nidaqmx.system.physical_channel import PhysicalChannel
from nidaqmx.errors import (
    check_for_error, is_string_buffer_too_small, is_array_buffer_too_small)
%if enums_used:
from nidaqmx.constants import (
    ${', '.join([c for c in enums_used]) | wrap(4, 4)})
%endif


class ArmStartTrigger:
    """
    Represents the arm start trigger configurations for a DAQmx task.
    """
    def __init__(self, task_handle, interpreter):
        self._handle = task_handle
        self._interpreter = interpreter

<%namespace name="property_template" file="/property_template.py.mako"/>\
%for attribute in attributes:
${property_template.script_property(attribute)}\
%endfor
\
<%namespace name="function_template" file="/function_template.py.mako"/>\
%for function_object in functions:
${function_template.script_function(function_object)}
%endfor