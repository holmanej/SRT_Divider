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
		p_in		: in  UNSIGNED (17 downto 0);
		q_in		: in  UNSIGNED (7 downto 0);
		d_out		: out UNSIGNED (7 downto 0);
		p_out		: out UNSIGNED (17 downto 0);
		q_out		: out UNSIGNED (7 downto 0)
	);
end Radix4Stage_8bit;
	
architecture Behavioral of Radix4Stage_8bit is

	component MaskLUT_8bit is
		port(
			d_in		: in  UNSIGNED (7 downto 0);
			p_in		: in  UNSIGNED (14 downto 0);
			a_out		: out UNSIGNED (1 downto 0)
		);
	end component;

	component QLUT_2bit is
		port(
			a_in		: in  UNSIGNED (3 downto 0);
			q_out		: out UNSIGNED (1 downto 0)
		);
	end component;
	
	signal		d1_int		:	UNSIGNED (9 downto 0) := (others => '0');
	signal		d2_int		:	UNSIGNED (9 downto 0) := (others => '0');
	signal		d3_int		:	UNSIGNED (9 downto 0) := (others => '0');
	signal		d_prod		:	UNSIGNED (17 downto 0) := (others => '0');
	
	signal		a_int		:	UNSIGNED (1 downto 0) := (others => '0');
	signal		p_int		:	UNSIGNED (17 downto 0) := (others => '0');
	signal		q_int		:	UNSIGNED (1 downto 0) := (others => '0');

begin

	d1_int <= unsigned("00" & d_in);
	d2_int <= unsigned("0" & d_in & "0");
	d3_int <= d1_int + d2_int;
	
	MaskLUT: MaskLUT_8bit port map (
		d_in	=> d_in,
		p_in	=> p_in(14 downto 0),
		a_out	=> a_int
	);
	
	q_int <= "11" when (p_in(15 downto 6) > d3_int) else a_int;
	
	d_prod <= d3_int & "00000000" when (q_int = "11") else
			  d2_int & "00000000" when (q_int = "10") else
			  d1_int & "00000000" when (q_int = "01") else
			  (others => '0');
	
	p_int <= p_in sll 2;
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			d_out <= d_in;
			q_out <= q_in(5 downto 0) & q_int;
			p_out <= p_int - d_prod;
		end if;
	end process;
	
end Behavioral;