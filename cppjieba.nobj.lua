-- luacheck: ignore 113
---@diagnostic disable: undefined-global
c_module "cppjieba" {
    use_globals = true,
    include "jieba.h",
    object "Jieba" {
        constructor {
            c_call "Jieba *>1" "NewJieba" { "const char *", "dict_path",
                "const char *", "model_path", "const char *", "user_dict_path",
                "const char *", "idf_path", "const char *", "stop_word_path" },
        },
        destructor "delete" {
            c_method_call "void" "FreeJieba" {}
        },
        method "cut" {
            var_in { "const char *", "s" },
            var_out { "<any>", "words" },
            c_source [[
  size_t len = strlen(${s});
  CJiebaWord* words = Cut(${this}, ${s}, len);
  CJiebaWord* x;
  lua_newtable(L);
  int i = 1;
  for (x = words; x && x->word; x++) {
      char *p = (char *)malloc(x->len + 1);
      strncpy(p, x->word, x->len);
      p[x->len] = '\0';
      lua_pushstring(L, p);
      lua_rawseti(L, -2, i++);
  }
  FreeWords(words);
]],
        }
    },
}
