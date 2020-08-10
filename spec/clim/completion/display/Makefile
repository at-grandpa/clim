PROGRAM_NAME:=sample

build:
	crystal build files/$(PROGRAM_NAME).cr -o /usr/local/bin/$(PROGRAM_NAME)
	$(PROGRAM_NAME) --bash-completion
	echo 'eval "`$(PROGRAM_NAME) --bash-completion`"' > ~/.bashrc
	/bin/bash -c 'source ~/.bashrc'
	/bin/bash -c 'echo $(INPUT)"	""	" | bash -i 2>&1 | sed '/^root@/d' ' > output
