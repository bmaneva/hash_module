echo -n $1 | sha1sum
gcc -O0 -m32 -march=i386 test.s sha1-i386.S -o sha1test
./sha1test $1
