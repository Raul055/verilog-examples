#ifndef TESTBENCH_H
#define TESTBENCH_H

// Dependencies
#define _POSIX_C_SOURCE 200809L
#include <stdlib.h>
#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include <sys/stat.h>

// Function prototypes
void free_char_list(char **file_paths, int count);
char **get_files_from_dir_ext(const char *dir_path, const char *extention, int *count);
char **get_project_dirs(const char *project_path, const char *dir_search, int *count);

#endif /* TESTBENCH_H */