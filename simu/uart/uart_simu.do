vlib work

vcom -2008 ../../src/reg_en.vhd
vcom -2008 ../../src/fdiv.vhd
vcom -2008 ../../src/uart_tx.vhd
vcom -2008 ../../src/uart.vhd
vcom -2008 uart_tb.vhd

vsim uart_tb(Bench)

view signals
add wave *
add wave /uart_tb/uart/Tick
add wave /uart_tb/uart/uart_tx/reg
run -all
wave zoom full