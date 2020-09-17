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
use STD.TEXTIO.ALL;

entity MaskLUT_8bit is
	port(
		d_in		: in  UNSIGNED (7 downto 0);
		p_in		: in  UNSIGNED (14 downto 0);
		a_out		: out UNSIGNED (1 downto 0)
	);
end MaskLUT_8bit;
	
architecture Behavioral of MaskLUT_8bit is

	signal		a_int	:	UNSIGNED (7 downto 0);

begin

	process(d_in, p_in, a_int)
	begin
		case? d_in is
			when "1-------" => a_int <= p_in(14 downto 7);
			when "01------" => a_int <= p_in(13 downto 6);
			when "001-----" => a_int <= p_in(12 downto 5);
			when "0001----" => a_int <= p_in(11 downto 4);
			when "00001---" => a_int <= p_in(10 downto 3);
			when "000001--" => a_int <= p_in(9 downto 2);
			when "0000001-" => a_int <= p_in(8 downto 1);
			when others		=> a_int <= p_in(7 downto 0);
		end case?;
		
		if (a_int < 64) then
			a_out <= "00";
		elsif (a_int < 128) then
			a_out <= "01";
		elsif (a_int < 192) then
			a_out <= "10";
		else
			a_out <= "11";
		end if;
	end process;

end Behavioral;