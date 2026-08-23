#include "testbench.h"
#include <stdio.h>
#include <dirent.h>
#include <string.h>

// Prototype (debug)
void testbench_prototype(void) {
    printf("This is the testbench library! \n");
}

/* -- Gets the files from a directory given the extention --
 *   dir_path - path from directory (DIR)
 *   extention - extention as a string (ex. "_tb.v")
 *   count - counter pointer
*/
char **get_files_from_dir_ext(const char *dir_path, const char *extention, int *count) {
    /* Init parameters */
    DIR *d = opendir(dir_path);
    struct dirent *entry;
    char **file_paths = NULL;    // Inits as a null pointer
    size_t extention_length = strlen(extention);
    int n = 0, cap = 0;
    *count = 0;

    // Error if path is bad
    if (!d) {perror("Fail with given path :("); return NULL;}

    // Searches for files
    while ((entry = readdir(d)) != NULL) {
        size_t name_length = strlen(entry -> d_name);

        // Checks if name ends with given extention
        if (name_length <= extention_length)
            continue;
        if (strcmp(entry->d_name + name_length - extention_length, extention) != 0)
            continue;

        
        // Grow array if needed
        if (n >= cap) {
            cap = cap ? cap * 2 : 8;
            char **tmp = realloc(file_paths, cap * sizeof(char *));
            if (!tmp) {
                perror("realloc");
                closedir(d);
                // free what we have so far before bailing
                for (int i = 0; i < n; i++) free(file_paths[i]);
                free(file_paths);
                *count = 0;
                return NULL;
            }
            file_paths = tmp;
        }

        // Build full path: dir_path + "/" + filename
        size_t full_length = strlen(dir_path) + 1 + name_length + 1;
        char *full_path = malloc(full_length);
        if (!full_path) {
            perror("malloc");
            continue;
        }
        snprintf(full_path, full_length, "%s/%s", dir_path, entry->d_name);

        file_paths[n++] = full_path;
    }

    closedir(d);
    *count = n;
    return file_paths;
}


