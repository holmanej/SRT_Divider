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

entity QLUT_2bit is
	port(
		a_in		: in  UNSIGNED (3 downto 0);
		q_out		: out UNSIGNED (1 downto 0)
	);
end QLUT_2bit;
	
architecture Behavioral of QLUT_2bit is

	constant ram_depth : natural := 16;
	constant ram_width : natural := 2;

	type		q_array		is	ARRAY (0 to ram_depth-1) of UNSIGNED (ram_width-1 downto 0);

	impure function init_ram_bin return q_array is
		file text_file : text open read_mode is "C:/Users/holma/source/repos/SRT_Divider/v2/qlut.txt";
		variable text_line : line;
		variable ram_content : q_array;
	begin
		for i in 0 to ram_depth - 1 loop
		readline(text_file, text_line);
		bread(text_line, ram_content(i));
	end loop;
	 
		return ram_content;
	end function;
	
	
	signal		q_lut		:	q_array := init_ram_bin;

begin

	q_out <= q_lut(to_integer(a_in));

end Behavioral;