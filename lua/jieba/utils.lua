--- copied from <https://github.com/neo451/jieba.nvim/>
local M = {}
-- local utf8 = require("lua-utf8")
-- local utf8 = require("jieba.utf8")
-- local lpeg = require("lpeg") or vim.lpeg
--
-- local spaces = lpeg.C(lpeg.S(" \t\n") ^ 1)
-- local hans = lpeg.C(lpeg.utfR(0x4E00, 0x9FFF) ^ 1) -- 0x9FA5?
-- local engs = lpeg.C(lpeg.R("az", "AZ") ^ 1)
-- local half_punc = lpeg.C(lpeg.S("·.,;!?()[]{}+-=_!@#$%^&*~`'\"<>:|\\"))
-- local nums = lpeg.C(lpeg.R("09") ^ 1)
-- local full_punc = lpeg.C(lpeg.utfR(0x3000, 0x303F) + lpeg.utfR(0xFF01, 0xFF5E)
-- + lpeg.utfR(0x2000, 0x206F)) -- 0xFF01 to 0xFF5E
--
-- local p_str = lpeg.Ct((hans + engs + half_punc + full_punc + nums + spaces) ^ 0)
--
-- function M.split_string(str)
--    return p_str:match(str)
-- end
--
-- function M.split_char(str)
--    local res = {}
--    local p = "[%z\1-\127\194-\244][\128-\191]*"
--
--    for ch in string.gmatch(str, p) do
--       table.insert(res, ch)
--    end
--    return res
-- end
--
local chsize = function(char)
   if not char then
      return 0
   elseif char > 240 then
      return 4
   elseif char > 225 then
      return 3
   elseif char > 192 then
      return 2
   else
      return 1
   end
end

M.sub = function(str, startChar, endChar)
   local startIndex = 1
   local numChars = endChar - startChar + 1
   while startChar > 1 do
      local char = string.byte(str, startIndex)
      startIndex = startIndex + chsize(char)
      startChar = startChar - 1
   end

   local currentIndex = startIndex

   while numChars > 0 and currentIndex <= #str do
      local char = string.byte(str, currentIndex)
      currentIndex = currentIndex + chsize(char)
      numChars = numChars - 1
   end
   return str:sub(startIndex, currentIndex - 1), numChars
end

-- M.is_eng = function(char)
--    if string.find(char, "[a-zA-Z0-9]") then
--       return true
--    else
--       return false
--    end
-- end
--
-- local compare = function(a, b)
--    if a[1] < b[1] then
--       return true
--    elseif a[1] > b[1] then
--       return false
--    end
-- end
--
-- M.max_of_array = function(t)
--    table.sort(t, compare)
--    return t[#t]
-- end
--
-- -- 不一定全
-- function M.is_punctuation(c)
--    local code = utf8.codepoint(c)
--    -- 全角标点符号的 Unicode 范围为：0x3000-0x303F, 0xFF00-0xFFFF
--    return (code >= 0x3000 and code <= 0x303F) or (code >= 0xFF00 and code <= 0xFFFF)
-- end
--
-- function M.is_chinese_char(c)
--    local code = utf8.codepoint(c)
--    return (code >= 0x4E00 and code <= 0x9FA5)
-- end
--
-- function M.is_chinese(sentence)
--    local tmp = true
--    for i in string.gmatch(sentence, "[%z\1-\127\194-\244][\128-\191]*") do
--       if not M.is_chinese_char(i) then
--          tmp = tmp and false
--       else
--          tmp = tmp and true
--       end
--    end
--    return tmp
-- end
--
-- function M.split_similar_char(s)
--    local t = {} -- 创建一个table用来储存分割后的字符
--    local currentString = ""
--    local previousIsChinese = nil
--
--    for i = 1, utf8.len(s) do -- 迭代整个字符串
--       -- local c = utf8.sub(s, i, i) -- 求出第i个字符
--       local c = M.sub(s, i, i) -- 求出第i个字符
--       local isChinese = M.is_chinese_char(c) --  判断是否是中文字符
--       if previousIsChinese == nil or isChinese == previousIsChinese then
--          currentString = currentString .. c
--       else
--          -- 添加先前的字符串
--          if currentString ~= "" then
--             table.insert(t, currentString)
--             currentString = ""
--          end
--          currentString = c
--       end
--       previousIsChinese = isChinese
--    end
--    -- 添加最后的字符串（如存在）
--    if currentString ~= "" then
--       table.insert(t, currentString)
--    end
--    return t -- 返回含有所有字符串的table
-- end

return M
