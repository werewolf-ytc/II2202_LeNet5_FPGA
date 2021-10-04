library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use work.ParameterPkg.all;

Entity ReLU is
	port (
		x_in : in data_type; -- input of ReLU from neuron
		y_out:out data_type	-- output of ReLU
	);
End Entity ReLU;

Architecture Behave of ReLU is
Begin
	y_out <= (others => '0') when ((x_in = 0) or (x_in(My_int_length + My_frac_length - 1) = '1')) else x_in; 
End Architecture Behave;