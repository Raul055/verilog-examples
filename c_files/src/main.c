#include <stdio.h>
#include <stdlib.h>
#include "testbench.h"
#include "bash.h"

int main(void) {

    testbench_prototype();
    bash_prototype();
    int count;
    char **files = get_files_from_dir_ext(".", "_tb.v", &count);

    if (files == NULL) {
        printf("No files found or error occurred.\n");
        return 1;
    }

    printf("Found %d .vcd file(s):\n", count);
    for (int i = 0; i < count; i++) {
        printf("  %s\n", files[i]);
    }

    return 0;
}