#ifndef JIEBA_H
#define JIEBA_H 1
#include <stdbool.h>
#include <sys/cdefs.h>
__BEGIN_DECLS

struct jieba_path {
  const char *dict_path;
  const char *model_path;
  const char *user_dict_path;
  const char *idf_path;
  const char *stop_word_path;
};
void init(struct jieba_path);
char **cut(const char *str, bool hmm);
void deinit();

__END_DECLS
#endif /* jieba.h */
