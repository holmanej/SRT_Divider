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

entity Radix4LUT_8bit is
	port(
		d_in		: in  UNSIGNED (9 downto 0);
		p_in		: in  UNSIGNED (9 downto 0);
		q_out		: out UNSIGNED (1 downto 0)
	);
end Radix4LUT_8bit;
	
architecture Behavioral of Radix4LUT_8bit is

	signal		d25		:	UNSIGNED (9 downto 0) := (others => '0');
	signal		d50		:	UNSIGNED (9 downto 0) := (others => '0');
	signal		d75		:	UNSIGNED (9 downto 0) := (others => '0');

begin

	d25 <= d_in;
	d50 <= d_in(8 downto 0) & "0";
	d75 <= d25 + d50;
	
	q_out <= "00" when (p_in < d25) else
			 "01" when (p_in < d50) else
			 "10" when (p_in < d75) else
			 "11";

end Behavioral;