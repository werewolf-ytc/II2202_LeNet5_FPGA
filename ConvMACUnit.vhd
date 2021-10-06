Library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use work.ParameterPkg.all;

-- This unit performs vector dot product + bias
Entity ConvMACUnit is
  Generic (
    vector_length : integer := 4
    );
  Port(
    clk_in : IN std_logic;
    reset_in : IN std_logic;
    data_in : IN Narray (vector_length - 1 downto 0);
    kernel_in : IN Narray (vector_length - 1 downto 0);
    result_out : OUT data_type
  );
end ConvMACUnit;

Architecture FullyParallel of ConvMACUnit is
  signal REG_sig : data_type;
  signal Out_arr_sig : Narray (vector_length downto 0);-- Narray (0 to vector_length + 1);
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
    Out_arr_sig (0) <= (others => '0');
    U0 : FOR i IN 0 TO vector_length - 1 GENERATE
		MAC_a : MACBasicN
			generic map(
				Int_length => My_int_length,
				Frac_length => My_frac_length
			)
			port map(
				a_in => data_in(i),
				b_in => kernel_in(i),
				c_in => Out_arr_sig(i),
				MAC_out => Out_arr_sig(i+1)
		);
    END GENERATE;
	
	clk_update : process (clk_in, reset_in, REG_sig)
	begin
		if(reset_in = '1')then
			REG_sig <= (others => '0');
		elsif (rising_edge (clk_in)) then
			REG_sig <= Out_arr_sig(vector_length);
		end if;
	end process;
	result_out <= REG_sig;
end FullyParallel;