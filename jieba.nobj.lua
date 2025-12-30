-- luacheck: ignore 113
---@diagnostic disable: undefined-global
c_module "jieba" {
    use_globals = true,
    include "jieba.h",
    object "Jieba" {
        constructor {
            c_call "jieba *>1" "jieba_new" { "const char *", "dict_path",
                "const char *", "model_path", "const char *", "user_dict_path",
                "const char *", "idf_path", "const char *", "stop_word_path" },
        },
        destructor "delete" {
            c_method_call "void" "jieba_delete" {}
        },
        method "cut" {
            var_in { "const char *", "str" },
            var_in { "bool", "hmm?" },
            var_out { "<any>", "words" },
            c_source [[
                char **words = jieba_cut(${this}, ${str}, ${hmm});
                char **p = words;
                int i = 1;
                lua_newtable(L);
                while (*p) {
                  lua_pushstring(L, *p);
                  lua_rawseti(L, -2, i++);
                  free(*p++);
                }
                free(words);
            ]],
        }
    },
}
