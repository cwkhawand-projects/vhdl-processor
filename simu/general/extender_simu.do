vlib work

vcom -2008 ../../src/extender.vhd
vcom -2008 extender_tb.vhd

vsim extender_tb(Bench)

view signals
add wave *

run -all