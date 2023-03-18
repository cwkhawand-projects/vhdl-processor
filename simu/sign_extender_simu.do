vlib work

vcom -2008 ../src/sign_extender.vhd
vcom -2008 sign_extender_tb.vhd

vsim sign_extender_tb(Bench)

view signals
add wave *

run -all