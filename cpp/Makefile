gcc_command = g++-8
gcc_options = -std=c++14 -O2

all:a.out b.out c.out d.out

a.out:a.cpp
	$(gcc_command) $(gcc_options) $< -o $@

b.out:b.cpp
	$(gcc_command) $(gcc_options) $< -o $@

c.out:c.cpp
	$(gcc_command) $(gcc_options) $< -o $@

d.out:d.cpp
	$(gcc_command) $(gcc_options) $< -o $@

a:a.out
	./a.out

b:b.out
	./b.out

c:c.out
	./c.out

d:d.out
	./d.out

clean:
	rm -f ./a.out ./b.out ./c.out ./d.out

.PHONY:all clean
