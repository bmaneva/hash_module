echo -n $1 | md5sum
gcc -O0 -m32 -march=i386 test.s md5-i386.S -o md5test
./md5test $1
