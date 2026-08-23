#ifndef TESTBENCH_H
#define TESTBENCH_H

// Dependencies
#include <stdlib.h>
#include <dirent.h>

// Function prototypes
void testbench_prototype(void);
char **get_files_from_dir_ext(const char *dir_path, const char *extention, int *count);

#endif /* TESTBENCH_H */