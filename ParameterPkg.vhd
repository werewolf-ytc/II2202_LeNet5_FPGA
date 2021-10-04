library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

package ParameterPkg is 
	constant Ninput	: integer := 4; --Number of Inputs
	constant INTE	: integer := 3; --integer part of fixed points number
	constant FRAC	: integer := 5; --fractional part of fixed points number
	subtype data_type is std_logic_vector(INTE+FRAC-1 downto 0);
	type Narray is array (natural range <>) of data_type;
end ParameterPkg;