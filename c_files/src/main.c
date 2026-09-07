#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "verilog.h"

int main(void) {
    // Scans all available projects in "project" directory
    int count;
    Project *projects = get_projects("projects", &count);

    // No projects were found, exit
    if (!projects) { printf("No projects found, sorry :(\n"); return 1; }

    // Iterates between all projects
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
                 "mkdir -p sim/{waveforms,bin,log}/%s",
                  project_name);
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
                     "iverilog -DVCD_PATH=\\\"sim/waveforms/%s/%s.vcd\\\" -o sim/bin/%s/%s.vout %s%s",
                     project_name, tb_base, project_name, tb_base, src_buffer, tb_file);

            // Makes system call
            int status = system(cmd);

            // Depending on status
            if (status == 0) {
                char run_cmd[1024];
                snprintf(run_cmd, sizeof(run_cmd), "vvp sim/bin/%s/%s.vout > sim/log/%s/%s.log",
                                                    project_name, tb_base, project_name, tb_base);
                system(run_cmd);
            } else {
                fprintf(stderr, "Compilation failed for %s\n", tb_base);
            }
        }
    }

    free_project_list(projects, count);
    return 0;
}