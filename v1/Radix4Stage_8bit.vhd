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

entity Radix4Stage_8bit is
	port(
		clk			: in  STD_LOGIC;
		d_in		: in  UNSIGNED (7 downto 0);
		p_in		: in  UNSIGNED (15 downto 0);
		q_in		: in  UNSIGNED (7 downto 0);
		d_out		: out UNSIGNED (7 downto 0);
		p_out		: out UNSIGNED (15 downto 0);
		q_out		: out UNSIGNED (7 downto 0)
	);
end Radix4Stage_8bit;
	
architecture Behavioral of Radix4Stage_8bit is
	
	signal		d25			:	UNSIGNED (9 downto 0) := (others => '0');
	signal		d50			:	UNSIGNED (9 downto 0) := (others => '0');
	signal		d75			:	UNSIGNED (9 downto 0) := (others => '0');
	
	signal		p_int		:	UNSIGNED (15 downto 0) := (others => '0');
	signal		q_int		:	UNSIGNED (1 downto 0) := (others => '0');

begin
	
	d25 <= unsigned("00" & d_in);
	d50 <= "0" & unsigned(d_in) & "0";
	d75 <= d25 + d50;
	
	q_int <= "00" when (p_in(15 downto 6) < d25) else
			 "01" when (p_in(15 downto 6) < d50) else
			 "10" when (p_in(15 downto 6) < d75) else
			 "11";
			 
	p_int <= p_in when (p_in(15 downto 6) < d25) else
			 p_in - (d25 & "000000") when (p_in(15 downto 6) < d50) else
			 p_in - (d50 & "000000") when (p_in(15 downto 6) < d75) else
			 p_in - (d75 & "000000");
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			d_out <= d_in;
			q_out <= q_in(5 downto 0) & q_int;
			p_out <= p_int sll 2;
		end if;
	end process;
	
end Behavioral;