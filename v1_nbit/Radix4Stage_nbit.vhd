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

entity Radix4Stage_nbit is
	generic(
		w			:	INTEGER := 8
	);
	port(
		clk			: in  STD_LOGIC;
		d_in		: in  UNSIGNED (w-1 downto 0);
		p_in		: in  UNSIGNED (2*w-1 downto 0);
		q_in		: in  UNSIGNED (w-1 downto 0);
		d_out		: out UNSIGNED (w-1 downto 0);
		p_out		: out UNSIGNED (2*w-1 downto 0);
		q_out		: out UNSIGNED (w-1 downto 0)
	);
end Radix4Stage_nbit;
	
architecture Behavioral of Radix4Stage_nbit is

	constant	p_pad		:	UNSIGNED (w-3 downto 0) := (others => '0');
	
	signal		d25			:	UNSIGNED (w+1 downto 0) := (others => '0');
	signal		d50			:	UNSIGNED (w+1 downto 0) := (others => '0');
	signal		d75			:	UNSIGNED (w+1 downto 0) := (others => '0');
	
	signal		p25			:	UNSIGNED (2*w-1 downto 0) := (others => '0');
	signal		p50			:	UNSIGNED (2*w-1 downto 0) := (others => '0');
	signal		p75			:	UNSIGNED (2*w-1 downto 0) := (others => '0');
	
	signal		p_int		:	UNSIGNED (2*w-1 downto 0) := (others => '0');
	signal		q_int		:	UNSIGNED (1 downto 0) := (others => '0');

begin
	
	d25 <= unsigned("00" & d_in);
	d50 <= "0" & unsigned(d_in) & "0";
	d75 <= d25 + d50;
	
	p25 <= p_in - (d25 & p_pad);
	p50 <= p_in - (d50 & p_pad);
	p75 <= p_in - (d75 & p_pad);
	
	process(p_in, d25, d50, d75, p25, p50, p75)
	begin
		if (p_in(2*w-1 downto w-2) < d25) then
			q_int <= "00";
			p_int <= p_in;
		elsif (p_in(2*w-1 downto w-2) < d50) then
			q_int <= "01";
			p_int <= p25;
		elsif (p_in(2*w-1 downto w-2) < d75) then
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
			q_out <= q_in(w-3 downto 0) & q_int;
			p_out <= p_int sll 2;
		end if;
	end process;
	
end Behavioral;