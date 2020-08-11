FILE_NAME:=sample
PROGRAM_NAME:=sample

build:
	crystal build files/$(FILE_NAME).cr -o /usr/local/bin/$(PROGRAM_NAME)
	echo 'eval "`$(PROGRAM_NAME) --bash-completion`"' > ~/.bashrc
	/bin/bash -c 'source ~/.bashrc'
	echo $(INPUT)"	""	" | bash -i 2>&1 | sed '/^root@/d' | sed '/^bash:/d' | sed '/^<bash#/d' > output
