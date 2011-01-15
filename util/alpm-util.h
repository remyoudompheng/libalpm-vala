#ifndef ALPM_VALA_H
#define ALPM_VALA_H

#include <alpm.h>

typedef struct __alpm_list_iterator_t {
    alpm_list_t* pos;
} alpm_list_iterator_t;

alpm_list_t *alpm_list_new();
void alpm_list_free_all(alpm_list_t *list);
void alpm_list_iterator(alpm_list_t *list, alpm_list_iterator_t* i);
void* alpm_list_iterator_next_value (alpm_list_iterator_t *iter);

pmpkg_t* alpm_pkg_load_file(const char *filename, int full);

#endif //!ALPM_VALA_H
