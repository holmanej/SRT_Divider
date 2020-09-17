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
		LED			: out STD_LOGIC_VECTOR(0 downto 0)
	);
end Radix4Division_Top;
	
architecture Behavioral of Radix4Division_Top is

	component Radix4Division_nbit is
		generic(
			w			:	INTEGER := 8
		);
		port(
			clk			: in  STD_LOGIC;
			n_in	    : in  STD_LOGIC_VECTOR (w-1 downto 0);
			d_in	    : in  STD_LOGIC_VECTOR (w-1 downto 0);
			q_out		: out STD_LOGIC_VECTOR (w-1 downto 0);
			r_out		: out STD_LOGIC_VECTOR (w-1 downto 0)
		);
	end component;
	
	constant	w			:	INTEGER := 32;
	
	signal		cnt			:	UNSIGNED (2*w-1 downto 0);
	signal		n_int		:	STD_LOGIC_VECTOR (w-1 downto 0);
	signal		d_int		:	STD_LOGIC_VECTOR (w-1 downto 0);
	signal		q_int		:	STD_LOGIC_VECTOR (w-1 downto 0);
	signal		r_int		:	STD_LOGIC_VECTOR (w-1 downto 0);

begin

	process(clk, q_int, r_int, cnt)
	begin
		if (rising_edge(clk)) then
			cnt <= cnt + 1;
		end if;
		if (unsigned(q_int & r_int) = cnt) then
			LED <= "1";
		else
			LED <= "0";
		end if;
	end process;
	
	n_int <= std_logic_vector(cnt(2*w-1 downto w));
	d_int <= std_logic_vector(cnt(w-1 downto 0));

	uut: Radix4Division_nbit generic map(w) port map (
		clk		=> clk,
		n_in	=> n_int,
		d_in	=> d_int,
		q_out	=> q_int,
		r_out	=> r_int
	);

end Behavioral;