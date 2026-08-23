#include "verilog.h"

/* Free the char list given */
void free_char_list(char **file_paths, int count) {
    for (int i = 0; i < count; i++)
        free(file_paths[i]);
    free(file_paths);
}

/* Free a project typedef struct */
void free_project(Project *p) {
    if (!p) return;
    free(p->src_dir);
    free(p->tb_dir);
    for (int i = 0; i < p->src_count; i++) free(p->src_files[i]);
    free(p->src_files);
    for (int i = 0; i < p->tb_count; i++) free(p->tb_files[i]);
    free(p->tb_files);
}

/* Free a project list*/
void free_project_list(Project *projects, int count) {
    for (int i = 0; i < count; i++)
        free_project(&projects[i]);
    free(projects);
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

/* -- Gets the project information--
 *   project_path - path where the project is located
 *   count - counter pointer
*/
Project *get_projects(const char *project_path, int *count) {
    DIR *d = opendir(project_path);
    struct dirent *entry;
    Project *projects = NULL;
    int n = 0, cap = 0;
    *count = 0;
    
    // Error if path is bad
    if (!d) {perror("Fail with given path :("); return NULL;}

    // Searches projects directories
    while ((entry = readdir(d)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        // Build path -> project_path/project
        char project_dir[1024];
        snprintf(project_dir, sizeof(project_dir), "%s/%s", project_path, entry->d_name);

        // Not a directory
        struct stat st;
        if (stat(project_dir, &st) != 0 || !S_ISDIR(st.st_mode))
            continue;

        // src & tb -> project_path/project/(src / tb)
        char src_dir[1024], tb_dir[1024];
        snprintf(src_dir, sizeof(src_dir), "%s/src", project_dir);
        snprintf(tb_dir, sizeof(tb_dir), "%s/tb", project_dir);

        // Check if src or tb exists
        struct stat src_st, tb_st;
        int has_src = (stat(src_dir, &src_st) == 0 && S_ISDIR(src_st.st_mode));
        int has_tb  = (stat(tb_dir, &tb_st) == 0 && S_ISDIR(tb_st.st_mode));

        // Source or testbench is missing, ignore
        if (!has_src && !has_tb)
            continue;

        // Add element into the array
        if (n >= cap) {
            cap = cap ? cap * 2 : 8;
            Project *tmp = realloc(projects, cap * sizeof(Project));
            if (!tmp) {
                perror("realloc");
                closedir(d);
                *count = 0;
                return NULL;
            }
            projects = tmp;
        }

        // Add all data into the struct
        Project *p = &projects[n];
        p->src_dir = has_src ? strdup(src_dir) : NULL;
        p->tb_dir  = has_tb  ? strdup(tb_dir)  : NULL;
        p->src_files = has_src ? get_files_from_dir_ext(src_dir, ".v", &p->src_count) : NULL;
        if (!has_src) p->src_count = 0;
        p->tb_files = has_tb ? get_files_from_dir_ext(tb_dir, "_tb.v", &p->tb_count) : NULL;
        if (!has_tb) p->tb_count = 0;
        n++;
    }

    closedir(d);
    *count = n;
    return projects;
}