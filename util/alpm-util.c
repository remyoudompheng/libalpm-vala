#include <alpm.h>

pmpkg_t* alpm_pkg_load_file(const char *filename, int full)
{
    pmpkg_t *p;
    int err = alpm_pkg_load(filename, full, &p);
    if (err != 0) {
        return NULL;
    }
    else {
        return p;
    }
}

alpm_list_t *alpm_list_new() { return NULL; }

void alpm_list_free_all(alpm_list_t *list) {
   alpm_list_free_inner(list, free);
   alpm_list_free(list);
}

typedef struct __alpm_list_iterator_t {
    alpm_list_t* pos;
} alpm_list_iterator_t;

void alpm_list_iterator(alpm_list_t *list, alpm_list_iterator_t* i) {
    i->pos = list;
}

void* alpm_list_iterator_next_value (alpm_list_iterator_t *iter) {
    if (iter->pos) {
        void* result = alpm_list_getdata(iter->pos);
        iter->pos = alpm_list_next(iter->pos);
        return result;
    } else {
        return NULL;
    }
}

