#!/bin/sh

# devicelist
devicelist()
{
	printf "STM32F072C8\n"
	printf "STM32F103RC\n"
	printf "STM32F042K6\n"
}

# gdbcheatsheet
gdbcheatsheet()
{
	printf "layout asm      -> Set the assembly layout\n"
	printf "layout src      -> Set the source layout\n"
	printf "layout regs     -> Set the register layout\n"
	printf "layout split    -> Set the split layout\n"
	printf "info break      -> List breakpoints\n"
	printf "info watch      -> List watchpoints\n"
	printf "break <address> -> Set breakpoint at address\n"
	printf "watch <address> -> Set watchpoint at address\n"
	printf "delete <n>      -> Delete break/watchpoint\n"
	printf "backtrace <n>   -> Show backtrace\n"
	printf "disassemble     -> Show disassembly\n"
	printf "list            -> Show source\n"
	printf "p/d <variable>  -> Print variable in decimal\n"
	printf "p/x <variable>  -> Print variable in hexadecimal\n"
	printf "p/t <variable>  -> Print variable in binary\n"
	printf "continue        -> Continue execution\n"
	printf "step            -> Step by line\n"
	printf "stepi           -> Step by instruction\n"
	printf "next            -> Step over line\n"
	printf "nexti           -> Step over instruction\n"
	printf "finish          -> Step out of stack frame\n"
	printf "call <function> -> Call a function\n"
	printf "thread          -> List threads\n"
	printf "monitor reset 2 -> Hardware reset\n"
	printf "quit            -> Quit debug session\n"
}

# jerase <device>
jerase()
{
	printf "device $1\nsi 1\nspeed auto\nconnect\nr\nerase\nq\n" > erase.jlink
	JLinkExe -If SWD -CommandFile erase.jlink
	rm -f erase.jlink
}

# jread <device> <start-address> <end-address> <file>
jread()
{
	printf "device $1\nsi 1\nspeed auto\nconnect\nr\nsavebin $4,$2,$3\nq\n" > read.jlink
	JLinkExe -If SWD -CommandFile read.jlink
	rm -f read.jlink
}

# jwrite <device> <start-address> <file>
jwrite()
{
	printf "device $1\nsi 1\nspeed auto\nconnect\nr\nloadfile $3,$2\nq\n" > write.jlink
	JLinkExe -If SWD -CommandFile write.jlink
	rm -f write.jlink
}

# jserver <device>
jserver()
{
	JLinkGDBServerCLExe -device $1 -endian little -if SWD -speed auto -noir -noLocalhostOnly -s
}

# jdebug <app-image> <?bootloader-image>
jdebug()
{
	if [ ! -z $2 ]
	then
		address=$(readelf -WS $2 | grep .text | awk '{ print "0x"$5 }')
		arm-none-eabi-gdb \
			--eval-command="target extended-remote localhost:2331" \
			--eval-command="set listsize 30" \
			--eval-command="set print pretty on" \
			--eval-command="set print array on" \
			--eval-command="layout src" \
			--eval-command="add-symbol-file $2 $(address)" \
			$1
	else
		arm-none-eabi-gdb \
			--eval-command="target extended-remote localhost:2331" \
			--eval-command="set listsize 30" \
			--eval-command="set print pretty on" \
			--eval-command="set print array on" \
			--eval-command="layout src" \
			$1
	fi
}