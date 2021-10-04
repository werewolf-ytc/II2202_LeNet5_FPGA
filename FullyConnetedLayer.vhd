Library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use work.ParameterPkg.all;


Entity FullyConnectedLayer is
  Generic (
    matrix_width : integer := 4
    );
  Port(
    clk_in : IN std_logic;
    reset_in : IN std_logic;
    
    data_in : IN Narray (matrix_width * matrix_width - 1 downto 0);
    weight_in : IN Narray (matrix_width * matrix_width - 1 downto 0);
    bias_in : IN data_type;
    
    result_out : OUT data_type
  );
end FullyConnectedLayer;

Architecture FullyParallel of FullyConnectedLayer is
  signal Input_data_sig, Input_weight_sig : Narray (matrix_width * matrix_width downto 0);
  signal REG_sig : data_type;
  signal Out_arr_sig		  : Narray (0 to matrix_width * matrix_width + 1);
    component MACBasicN is
		Generic(
			Int_length :integer;
			Frac_length : integer
		);
		Port(
			a_in, b_in, c_in : IN data_type;
			MAC_out : Out data_type
		);
	end component;
      
  begin 
	Input_weight_sig (matrix_width * matrix_width downto 1)
	    <= weight_in (matrix_width * matrix_width - 1 downto 0);
	Input_weight_sig (0) <= (My_frac_length => '1', others => '0');
	Input_data_sig (0) <= bias_in;
	Input_data_sig (matrix_width * matrix_width downto 1)
	    <= data_in (matrix_width * matrix_width - 1 downto 0);
    Out_arr_sig (0) <= (others => '0');
    U0 : FOR i IN 0 TO matrix_width * matrix_width GENERATE
		MAC_a : MACBasicN
			generic map(
				Int_length => My_int_length,
				Frac_length => My_frac_length
			)
			port map(
				a_in => Input_data_sig(i),
				b_in => Input_weight_sig(i),
				c_in => Out_arr_sig(i),
				MAC_out => Out_arr_sig(i+1)
		);
    END GENERATE;
	
	clk_update : process (clk_in, reset_in)
	begin
		if(reset_in = '1')then
			REG_sig <= (others => '0');
		elsif (rising_edge (clk_in)) then
			REG_sig <= Out_arr_sig(matrix_width * matrix_width + 1);
		end if;
	end process;
	result_out <= REG_sig;
end FullyParallel;