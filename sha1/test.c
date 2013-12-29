#include <stdio.h>
#include <string.h>

static unsigned shadigest[5];
void main(int argc, char *argv[])
{
   int i;
   sha1(argv[1], argc > 1 ? strlen(argv[1]) : 0, shadigest);
   for (i = 0; i < 5; ++i) {
       printf("%08x", shadigest[i]);
   }
   printf("\n");
}
