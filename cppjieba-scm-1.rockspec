rockspec_format = '3.0'
description = {
  summary = '',
  detailed = '',
  labels = {},
  homepage = 'https://github.com/neo451/jieba.nvim',
  license = 'GPL-3.0',
}
-- not jieba.nvim
package = 'cppjieba'
version = 'scm-1'
source = {
  url = description.homepage:gsub('https', 'git')
}

build_dependencies = { "luanativeobjects" }
dependencies = { "lua >= 5.1", "vim", "wordmotion.nvim", "datafile" }
build = {
  type = 'xmake',
  copy_directories = { 'plugin' },
  install = {
    conf = {
      ['hmm_model.utf8'] = 'etc/conf/hmm_model.utf8',
      ['idf.utf8'] = 'etc/conf/idf.utf8',
      ['jieba.dict.utf8'] = 'etc/conf/jieba.dict.utf8',
      ['user.dict.utf8'] = 'etc/conf/user.dict.utf8',
      ['stop_words.utf8'] = 'etc/conf/stop_words.utf8',
      ['pos_dict/char_state_tab.utf8'] = 'etc/conf/pos_dict/char_state_tab.utf8',
      ['pos_dict/prob_emit.utf8'] = 'etc/conf/pos_dict/prob_emit.utf8',
      ['pos_dict/prob_start.utf8'] = 'etc/conf/pos_dict/prob_start.utf8',
      ['pos_dict/prob_trans.utf8'] = 'etc/conf/pos_dict/prob_trans.utf8',
    }
  }
}
