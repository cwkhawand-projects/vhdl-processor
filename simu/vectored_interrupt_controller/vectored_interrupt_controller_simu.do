vlib work

vcom -2008 ../../src/vectored_interrupt_controller.vhd
vcom -2008 vectored_interrupt_controller_tb.vhd

vsim vectored_interrupt_controller_tb(Bench)

view signals
add wave *

run -all
