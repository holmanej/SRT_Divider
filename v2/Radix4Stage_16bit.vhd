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

entity Radix4Stage_16bit is
	port(
		clk			: in  STD_LOGIC;
		d_in		: in  UNSIGNED (15 downto 0);
		p_in		: in  UNSIGNED (31 downto 0);
		q_in		: in  UNSIGNED (15 downto 0);
		d_out		: out UNSIGNED (15 downto 0);
		p_out		: out UNSIGNED (31 downto 0);
		q_out		: out UNSIGNED (15 downto 0)
	);
end Radix4Stage_16bit;
	
architecture Behavioral of Radix4Stage_16bit is
	
	signal		d25			:	UNSIGNED (17 downto 0) := (others => '0');
	signal		d50			:	UNSIGNED (17 downto 0) := (others => '0');
	signal		d75			:	UNSIGNED (17 downto 0) := (others => '0');
	
	signal		p25			:	UNSIGNED (31 downto 0) := (others => '0');
	signal		p50			:	UNSIGNED (31 downto 0) := (others => '0');
	signal		p75			:	UNSIGNED (31 downto 0) := (others => '0');
	
	signal		p_int		:	UNSIGNED (31 downto 0) := (others => '0');
	signal		q_int		:	UNSIGNED (1 downto 0) := (others => '0');

begin
	
	d25 <= unsigned("00" & d_in);
	d50 <= "0" & unsigned(d_in) & "0";
	d75 <= d25 + d50;
	
	p25 <= p_in - (d25 & "00000000000000");
	p50 <= p_in - (d50 & "00000000000000");
	p75 <= p_in - (d75 & "00000000000000");
	
	process(p_in, d25, d50, d75, p25, p50, p75)
	begin
		if (p_in(31 downto 14) < d25) then
			q_int <= "00";
			p_int <= p_in;
		elsif (p_in(31 downto 14) < d50) then
			q_int <= "01";
			p_int <= p25;
		elsif (p_in(31 downto 14) < d75) then
			q_int <= "10";
			p_int <= p50;
		else
			q_int <= "11";
			p_int <= p75;
		end if;
	end process;
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			d_out <= d_in;
			q_out <= q_in(13 downto 0) & q_int;
			p_out <= p_int sll 2;
		end if;
	end process;
	
end Behavioral;