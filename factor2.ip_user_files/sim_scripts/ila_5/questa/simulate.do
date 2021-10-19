onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib ila_5_opt

do {wave.do}

view wave
view structure
view signals

do {ila_5.udo}

run -all

quit -force
