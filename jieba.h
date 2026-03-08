#ifndef JIEBA_H
#define JIEBA_H 1
#include <stdbool.h>
#include <sys/cdefs.h>
__BEGIN_DECLS

typedef void Jieba;
Jieba *jieba_new(const char *dict_path, const char *model_path,
                 const char *user_dict_path, const char *idf_path,
                 const char *stop_word_path);
char **jieba_cut(Jieba *jieba, const char *str, bool hmm);
void jieba_delete(Jieba *jieba);

__END_DECLS
#endif /* jieba.h */
