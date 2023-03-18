vlib work

vcom -2008 ../../src/pc_extender.vhd
vcom -2008 pc_extender_tb.vhd

vsim pc_extender_tb(Bench)

view signals
add wave *

run -all