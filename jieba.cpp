#include "cppjieba/Jieba.hpp"
#include "jieba.h"

#define DEFAULT_BUFFER_SIZE 1024

using namespace std;

extern "C" char **cut(const char *str, bool hmm, struct jieba_path jieba_path) {
  cppjieba::Jieba jieba{jieba_path.dict_path, jieba_path.model_path,
                        jieba_path.user_dict_path, jieba_path.idf_path,
                        jieba_path.stop_word_path};
  vector<string> words;
  vector<cppjieba::Word> jiebawords;
  string s = str;

  jieba.Cut(s, words, hmm);
  char **results = new char *[DEFAULT_BUFFER_SIZE] {};
  char **p = results;
  for (auto word : words)
    *p++ = strdup(word.c_str());
  return results;
}
