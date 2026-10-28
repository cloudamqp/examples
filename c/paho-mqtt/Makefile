CFLAGS ?= -Wall -Wextra -Werror -O2
LDLIBS = -lpaho-mqtt3cs

all: publisher worker

test: all
	./test.sh

clean:
	rm -f publisher worker

.PHONY: all test clean
