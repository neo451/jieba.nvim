#include "cppjieba/Jieba.hpp"
#include "jieba.h"

#define DEFAULT_BUFFER_SIZE 1024

using cppjieba::Jieba, cppjieba::Word, std::string, std::vector;

extern "C" jieba *jieba_new(const char *dict_path, const char *model_path,
                            const char *user_dict_path, const char *idf_path,
                            const char *stop_word_path) {
  return reinterpret_cast<jieba *>(new Jieba{
      dict_path, model_path, user_dict_path, idf_path, stop_word_path});
}

extern "C" char **jieba_cut(jieba *jieba, const char *str, bool hmm) {
  vector<string> words;
  vector<Word> jiebawords;
  string s = str;

  reinterpret_cast<Jieba *>(jieba)->Cut(s, words, hmm);
  char **results = (char **)malloc(sizeof(char *) * DEFAULT_BUFFER_SIZE);
  char **p = results;
  for (auto word : words)
    *p++ = strdup(word.c_str());
  *p = nullptr;
  return results;
}

extern "C" void jieba_delete(jieba *jieba) {
  delete reinterpret_cast<Jieba *>(jieba);
}
