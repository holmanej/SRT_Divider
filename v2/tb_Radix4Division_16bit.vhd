library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Radix4Division_16bit is
end tb_Radix4Division_16bit;
	
architecture Behavioral of tb_Radix4Division_16bit is

	component Radix4Division_16bit is
		port(
			clk			: in  STD_LOGIC;
			n_in	    : in  STD_LOGIC_VECTOR (15 downto 0);
			d_in	    : in  STD_LOGIC_VECTOR (15 downto 0);
			q_out		: out STD_LOGIC_VECTOR (15 downto 0);
			r_out		: out STD_LOGIC_VECTOR (15 downto 0)
		);
	end component;
	
	signal	clk			:	STD_LOGIC := '1';
	signal	n_in		:	STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal	d_in		:	STD_LOGIC_VECTOR (15 downto 0) := (0 => '1', others => '0');
	signal	q_out		:	STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal	r_out		:	STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	
	signal	q_test		:	UNSIGNED (15 downto 0) := (others => '0');
	signal	r_test		:	UNSIGNED (15 downto 0) := (others => '0');
	
	signal	q_match		:	STD_LOGIC := '0';
	signal	r_match		:	STD_LOGIC := '0';

begin

	process
	begin
		wait for 10 ns;
		
		for i in 0 to 255 loop
			for j in 1 to 255 loop
				n_in <= std_logic_vector(to_unsigned(i, 16));
				d_in <= std_logic_vector(to_unsigned(j, 16));
				
				wait for 10 ns;
			end loop;
		end loop;
		wait;
	end process;

	process
	begin	
		wait for 100 ns;
		
		for i in 0 to 255 loop
			for j in 1 to 255 loop				
				q_test <= to_unsigned(i / j, 16);
				r_test <= to_unsigned(i mod j, 16);
				
				wait for 5 ns;
				
				if (unsigned(q_out) /= q_test) then
					q_match <= '0';
				else
					q_match <= '1';
				end if;
				
				if (unsigned(r_out) /= r_test) then
					r_match <= '0';
				else
					r_match <= '1';
				end if;
				
				wait for 5 ns;
				
			end loop;
		end loop;
		wait;
	end process;

	process
	begin
		wait for 5 ns;
		clk <= not clk;
	end process;
	
	uut: Radix4Division_16bit port map (
		clk		=> clk,
		n_in	=> n_in,
		d_in	=> d_in,
		q_out	=> q_out,
		r_out	=> r_out
	);

end Behavioral;