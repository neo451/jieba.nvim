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
dependencies = { "lua >= 5.1", "vim", "wordmotion.nvim" }
build = {
  type = 'xmake',
  copy_directories = { 'plugin' },
}
