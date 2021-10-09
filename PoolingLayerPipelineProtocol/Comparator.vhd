Library IEEE;
Use IEEE.STD_LOGIC_1164.all;
Use IEEE.numeric_std.all;
Use IEEE.STD_LOGIC_SIGNED.all;
Use Work.ParameterPkg.all;

-- Compares two logic vectors.
-- Return the larger vector.
Entity Comparator is
    Port (
        input_data_1, input_data_2 : IN data_type;
        result_out : OUT data_type
    );
End Comparator;

Architecture Dataflow of Comparator is
Begin
    Result_out <= input_data_1 when input_data_1 > input_data_2 
    else input_data_2;
End Dataflow;