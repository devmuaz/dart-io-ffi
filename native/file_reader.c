#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>

char *read_file(const char *file_path)
{
    if (file_path == NULL)
    {
        return NULL;
    }

    int fd = open(file_path, O_RDONLY);
    if (fd == -1)
    {
        return NULL;
    }

    struct stat file_stat;
    if (fstat(fd, &file_stat) == -1)
    {
        close(fd);
        return NULL;
    }

    size_t file_size = file_stat.st_size;
    char *buffer = malloc(file_size + 1);
    if (buffer == NULL)
    {
        close(fd);
        return NULL;
    }

    ssize_t bytes_read = read(fd, buffer, file_size);
    close(fd);

    if (bytes_read == -1)
    {
        free(buffer);
        return NULL;
    }

    buffer[bytes_read] = '\0';

    return buffer;
}

void free_string(char *str)
{
    if (str != NULL)
    {
        free(str);
    }
}

int file_exists(const char *file_path)
{
    if (file_path == NULL)
    {
        return 0;
    }

    return access(file_path, F_OK) == 0 ? 1 : 0;
}
