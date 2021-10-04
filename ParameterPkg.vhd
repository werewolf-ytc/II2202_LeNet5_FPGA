library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

-- This package specifies the parameters for LeNet-5.
package ParameterPkg is 
	constant My_number_of_inputs	: integer := 4; --Number of Inputs
	constant My_int_length	: integer := 3; --integer part of fixed points number
	constant My_frac_length	: integer := 5; --fractional part of fixed points number
	subtype data_type is std_logic_vector(My_int_length +My_frac_length - 1 downto 0);
	type Narray is array (natural range <>) of data_type;
end ParameterPkg;