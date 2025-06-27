#ifndef FILE_READER_H
#define FILE_READER_H

#ifdef __cplusplus
extern "C"
{
#endif

    char *read_file(const char *file_path);
    void free_string(char *str);
    int file_exists(const char *file_path);

#ifdef __cplusplus
}
#endif

#endif
