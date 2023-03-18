vlib work

vcom -2008 ../../src/registers.vhd
vcom -2008 registers_tb.vhd

vsim registers_tb(Bench)

view signals
add wave *

run -all