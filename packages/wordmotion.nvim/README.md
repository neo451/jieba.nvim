# wordmotion.nvim

A lua library to simulate vim's word motion.
It is created for jieba.nvim.

`test.txt`:

```text
hello, world!
你好，世界！
こんにちわ，世界！
```

```lua
local Cursor = require "wordmotion.jieba".Cursor
local cursor = Cursor:from_path"/the/path/of/test.txt"
-- |你好，世界！
local pos = { 2, 0 }

-- press 1w
pos = cursor:get_position(1, true, pos)
-- 你好|，世界！

-- press 1ge
pos = cursor:get_position(-1, false, pos)
-- 你|好，世界！

-- press 1b
pos = cursor:get_position(-1, true, pos)
-- |你好，世界！

-- press 1e
pos = cursor:get_position(1, false, pos)
-- 你|好，世界！
```
