create_clock -period 20.000 -name CLK_50
create_clock -period 1000.000 -name EXT_CLK
derive_pll_clocks
derive_clock_uncertainty