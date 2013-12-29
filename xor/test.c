#include <stdio.h>
#include <string.h>
#include "xor.h"

void main(int argc, char *argv[])
{
    printf("%x  -\n", xor(argv[1], argc > 1 ? strlen(argv[1]) : 0));
}
