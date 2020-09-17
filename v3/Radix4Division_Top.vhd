--------------------------------------------
-- Project		:	None

-- Component	:	
-- Description	:	
--				:	

-- Author		:	Eric Holman

-- Date Created	:	

-- Revisions	:

-- Date		Ref		Revision


--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Radix4Division_Top is
	port(
		clk			: in  STD_LOGIC;
		q_out		: out STD_LOGIC_VECTOR (31 downto 0);
		r_out		: out STD_LOGIC_VECTOR (31 downto 0)
	);
end Radix4Division_Top;
	
architecture Behavioral of Radix4Division_Top is

	component Radix4Division_32bit is
		port(
			clk			: in  STD_LOGIC;
			n_in	    : in  STD_LOGIC_VECTOR (31 downto 0);
			d_in	    : in  STD_LOGIC_VECTOR (31 downto 0);
			q_out		: out STD_LOGIC_VECTOR (31 downto 0);
			r_out		: out STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;
	
	signal		cnt			:	UNSIGNED (63 downto 0);
	signal		n_int		:	STD_LOGIC_VECTOR (31 downto 0);
	signal		d_int		:	STD_LOGIC_VECTOR (31 downto 0);

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			cnt <= cnt + 1;
		end if;
	end process;
	
	n_int <= std_logic_vector(cnt(63 downto 32));
	d_int <= std_logic_vector(cnt(31 downto 0));

	uut: Radix4Division_32bit port map (
		clk		=> clk,
		n_in	=> n_int,
		d_in	=> d_int,
		q_out	=> q_out,
		r_out	=> r_out
	);

end Behavioral;