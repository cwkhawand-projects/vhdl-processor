vlib work

vcom -2008 ../../src/reg.vhd
vcom -2008 reg_tb.vhd

vsim reg_tb(Bench)

view signals
add wave *

run -all