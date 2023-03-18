vlib work

vcom -2008 ../src/memory.vhd
vcom -2008 memory_tb.vhd

vsim memory_tb(Bench)

view signals
add wave *

run -all