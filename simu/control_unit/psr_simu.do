vlib work

vcom -2008 ../../src/psr.vhd
vcom -2008 psr_tb.vhd

vsim psr_tb(Bench)

view signals
add wave *

run -all