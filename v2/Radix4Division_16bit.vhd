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

entity Radix4Division_16bit is
	port(
		clk			: in  STD_LOGIC;
		n_in	    : in  STD_LOGIC_VECTOR (15 downto 0);
		d_in	    : in  STD_LOGIC_VECTOR (15 downto 0);
		q_out		: out STD_LOGIC_VECTOR (15 downto 0);
		r_out		: out STD_LOGIC_VECTOR (15 downto 0)
	);
end Radix4Division_16bit;
	
architecture Behavioral of Radix4Division_16bit is

	component Radix4Stage_16bit is
		port(
			clk			: in  STD_LOGIC;
			d_in		: in  UNSIGNED (15 downto 0);
			p_in		: in  UNSIGNED (31 downto 0);
			q_in		: in  UNSIGNED (15 downto 0);
			d_out		: out UNSIGNED (15 downto 0);
			p_out		: out UNSIGNED (31 downto 0);
			q_out		: out UNSIGNED (15 downto 0)
		);
	end component;
	
	type		u32_array		is	ARRAY (integer range <>) of UNSIGNED (31 downto 0);
	type		u16_array		is	ARRAY (integer range <>) of UNSIGNED (15 downto 0);
	
	signal		p_int			:	u32_array(0 to 8) := (others => (others => '0'));
	signal		d_int			:	u16_array(0 to 8) := (others => (others => '0'));	
	signal		q_int			:	u16_array(0 to 8) := (others => (others => '0'));

begin

	d_int(0) <= unsigned(d_in);
	p_int(0) <= x"0000" & unsigned(n_in);

	Stages: for i in 0 to 7 generate
		Stage: Radix4Stage_16bit port map (
			clk		=> clk,
			d_in	=> d_int(i),
			p_in	=> p_int(i),
			q_in	=> q_int(i),
			d_out	=> d_int(i+1),
			q_out	=> q_int(i+1),
			p_out	=> p_int(i+1)
		);		
	end generate;
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (p_int(8)(31 downto 16) >= d_int(8)(15 downto 0)) then
				q_out <= std_logic_vector(q_int(8) + 1);
				r_out <= std_logic_vector(p_int(8)(31 downto 16) - d_int(8)(15 downto 0));
			else
				q_out <= std_logic_vector(q_int(8));
				r_out <= std_logic_vector(p_int(8)(31 downto 16));
			end if;
		end if;
	end process;

end Behavioral;