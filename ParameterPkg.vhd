library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

-- This package specifies the parameters for LeNet-5.

package ParameterPkg is 
	constant My_int_length	: integer := 3; --integer part of fixed points number
	constant My_frac_length	: integer := 5; --fractional part of fixed points number
	subtype data_type is std_logic_vector
	    (My_int_length + My_frac_length - 1 downto 0);
	type Narray is array (natural range <>) of data_type;
	    -- an array of data

-- Matrix is stored as vectors, in the form of
-- a1 | a2
-- a3 | a4  => [a1, a2, a3, a4, a5, a6]
-- a5 | a6
-- The location of the element A[i][j] in the matrix A of size N = w * w
-- is Array[i * w + j]. All indices start with 0.
	FUNCTION Matrix2VectorIndexConvertion (
	    matrix_width : IN INTEGER;
	    line_index : IN INTEGER;
	    column_index : IN INTEGER
    ) RETURN INTEGER;
end package ParameterPkg;

PACKAGE BODY ParameterPkg IS

FUNCTION Matrix2VectorIndexConvertion (
	    matrix_width : IN INTEGER;
	    line_index : IN INTEGER;
	    column_index : IN INTEGER
    ) RETURN INTEGER IS
    BEGIN
        RETURN line_index * matrix_width + column_index;
    END;
    
END PACKAGE BODY ParameterPkg;