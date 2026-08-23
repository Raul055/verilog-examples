#ifndef VERILOG_H
#define VERILOG_H

// Dependencies
#define _POSIX_C_SOURCE 200809L
#include <stdlib.h>
#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include <sys/stat.h>

// Typedef
typedef struct {
    char *src_dir;
    char *tb_dir;
    char **src_files;
    char **tb_files;
    int src_count;
    int tb_count;
} Project;

// Function prototypes
void free_char_list(char **file_paths, int count);
void free_project(Project *p);
void free_project_list(Project *projects, int count);
char **get_files_from_dir_ext(const char *dir_path, const char *extention, int *count);
Project *get_projects(const char *project_path, int *count);

#endif /* VERILOG_H */