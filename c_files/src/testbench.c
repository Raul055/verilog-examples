#include "testbench.h"

/* Free the char list given */
void free_char_list(char **file_paths, int count) {
    for (int i = 0; i < count; i++)
        free(file_paths[i]);
    free(file_paths);
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

        // Grows array
        if (n >= cap) {
            cap = cap ? cap * 2 : 8;
            char **tmp = realloc(file_paths, cap * sizeof(char *));
            if (!tmp) {
                perror("realloc");
                closedir(d);
                // Free mem
                for (int i = 0; i < n; i++) free(file_paths[i]);
                free(file_paths);
                *count = 0;
                return NULL;
            }
            file_paths = tmp;
        }

        // Build full path
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

/* -- Gets the direcory from a project --
 *   dir_path - path from the project directory (DIR)
 *   dir - directory to search
 *   count - counter pointer
*/
char **get_project_dirs(const char *project_path, const char *dir_search, int *count) {
    DIR *d = opendir(project_path);
    struct dirent *entry;
    char **dir_paths = NULL;
    int n = 0, cap = 0;

    *count = 0;

    // Error if path is bad
    if (!d) {perror("Fail with given path :("); return NULL;}

    // Searches for directory in project directory
    while ((entry = readdir(d)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        // Build path -> project_path/entry
        char project_dir[1024];
        snprintf(project_dir, sizeof(project_dir), "%s/%s", project_path, entry->d_name);

        struct stat st;
        if (stat(project_dir, &st) != 0 || !S_ISDIR(st.st_mode))
            continue;  // Non dir

        // Build path -> project_path/entry/dir
        char dir[1024];
        snprintf(dir, sizeof(dir), "%s/%s", project_dir, dir_search);

        struct stat dir_st;
        if (stat(dir, &dir_st) != 0 || !S_ISDIR(dir_st.st_mode))
            continue;  // No subdir

        // Dir found, add it
        if (n >= cap) {
            cap = cap ? cap * 2 : 8;
            char **tmp = realloc(dir_paths, cap * sizeof(char *));
            if (!tmp) {
                perror("realloc");
                for (int i = 0; i < n; i++) free(dir_paths[i]);
                free(dir_paths);
                closedir(d);
                *count = 0;
                return NULL;
            }
            dir_paths = tmp;
        }

        dir_paths[n++] = strdup(dir);
    }

    closedir(d);
    *count = n;
    return dir_paths;
}