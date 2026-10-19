#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "verilog.h"

// Prototype definitions
int search_project(char *project_directory_name);

// main function
int main(void) {

    // Folder names inside projects directory
    char *project_folder_names[] = {"combinational", "sequential"};
    size_t count_folder_names = sizeof(project_folder_names) / sizeof(project_folder_names[0]);

    // Iterates for all project directories
    for (size_t x = 0; x < count_folder_names; x++) {
        if (search_project(project_folder_names[x]) == 1) {return 1;}
    }

    return 0;
}

// Function declaration
int search_project(char *project_directory_name) {
    // Scans all available projects in the project directory
    int count;
    char project_directory[1024];
    snprintf(project_directory, sizeof(project_directory), "projects/%s", project_directory_name);
    Project *projects = get_projects(project_directory, &count);

    // No projects were found, exit
    if (!projects) { printf("No projects found, sorry :(\n"); return 1; }

    // Iterates between all projects from source
    for (int i = 0; i < count; i++) {
        Project *p = &projects[i];

        // Project name
        char *project_name = p -> project_name;

        // Adds source files into buffer
        char **src_files = p -> src_files;
        char src_buffer[1024];
        char *src_pointer = src_buffer;
        for (int j = 0; j < (p -> src_count); j++) {
            src_pointer += sprintf(src_pointer, "%s ", src_files[j]);
        }

        // Adds tb files into struct
        char **tb_files = p -> tb_files;

        // Creates directories
        char dir_cmd[1024];
        snprintf(dir_cmd, sizeof(dir_cmd),
                 "mkdir -p sim/%s/{waveforms,bin,log}/%s",
                  project_directory_name, project_name);
        int dir_status = system(dir_cmd);

        // Error in mkdir
        if (dir_status != 0) {printf("Directories could not be done, sorry :(\n"); return 1;}

        // Iterates between each tb file
        for (int k = 0; k < (p -> tb_count); k++) {
            char *tb_file = tb_files[k];

            // Gets base name for each file
            char tb_base[1024];
            char *slash = strrchr(tb_file, '/');
            snprintf(tb_base, sizeof(tb_base), "%s", slash ? slash + 1 : tb_file);
            char *dot = strrchr(tb_base, '.');
            if (dot) *dot = '\0';

            // Creates cmd
            char cmd[1024];
            snprintf(cmd, sizeof(cmd),
                     "iverilog -DVCD_PATH=\\\"sim/%s/waveforms/%s/%s.vcd\\\" -o sim/%s/bin/%s/%s.vout %s%s",
                     project_directory_name, project_name, tb_base,
                     project_directory_name, project_name, tb_base, src_buffer, tb_file);

            // Makes system call
            int status = system(cmd);

            // Depending on status
            if (status == 0) {
                char run_cmd[1024];
                snprintf(run_cmd, sizeof(run_cmd), "vvp sim/%s/bin/%s/%s.vout > sim/%s/log/%s/%s.log",
                                                    project_directory_name, project_name, tb_base,
                                                    project_directory_name, project_name, tb_base);
                system(run_cmd);
            } else {
                fprintf(stderr, "Compilation failed for %s\n", tb_base);
                return 1;
            }
        }
    }

    // Free list
    free_project_list(projects, count);

    // All good
    return 0;
}