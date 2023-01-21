#include <stdio.h>

// The make system sets up the include search path for us
#include <libA.h>

int main(void)
{
    printf("Hello, world!\n");
    libAfunc();
    return 0;
}
