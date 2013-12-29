#include <stdio.h>
#include <string.h>

static unsigned char md5digest[128];
void main(int argc, char *argv[])
{
    int i;
    md5(argv[1], argc > 1 ? strlen(argv[1]) : 0, md5digest);
    for (i = 0; i < 16; ++i) {
        printf("%02x", md5digest[i]);
    }
    printf("\n");
}
