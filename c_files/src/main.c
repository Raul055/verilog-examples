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

    // Adds directories if needed
    system("mkdir -p sim/waveforms");
    system("mkdir -p sim/bin");
    system("mkdir -p sim/log");

    // Iterates between all projects
    for (int i = 0; i < count; i++) {
        Project *p = &projects[i];

        // Adds source files into buffer
        char **src_files = p -> src_files;
        char src_buffer[1024];
        char *src_pointer = src_buffer;
        for (int j = 0; j < (p -> src_count); j++) {
            src_pointer += sprintf(src_pointer, "%s ", src_files[j]);
        }
        //printf("%s\n", src_buffer);

        // Adds testebench files into buffer
        char **tb_files = p -> tb_files;
        char tb_buffer[1024];
        char *tb_pointer = tb_buffer;
        for (int j = 0; j < (p -> tb_count); j++) {
            tb_pointer += sprintf(tb_pointer, "%s ", tb_files[j]);
        }
        //printf("%s\n", tb_buffer);

        // Creates simulation name from project
        char *simulation_name =  strcat(p -> project_name, "_sim");

        // Creates cmd
        char cmd[1024];
        snprintf(cmd, sizeof(cmd), "iverilog -DVCD_PATH=\\\"sim/waveforms/%s.vcd\\\" -o sim/bin/%s.vout %s%s", p -> project_name, simulation_name, src_buffer, tb_buffer);
        //printf("%s\n", cmd);
        
        // Makes system call
        int status = system(cmd);

        // Depending on status
        if (status == 0) {
            char run_cmd[1024];
            snprintf(run_cmd, sizeof(run_cmd), "vvp sim/bin/%s.vout > sim/log/%s.log", simulation_name, simulation_name);
            system(run_cmd);
        } else {
            fprintf(stderr, "Compilation failed for %s\n", p -> project_name);
        }
    }

    free_project_list(projects, count);
    return 0;
}