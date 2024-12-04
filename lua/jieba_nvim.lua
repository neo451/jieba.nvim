-- This code snippet is taken from [kkew3/jieba.vim] and is licensed under the MIT License.
-- Original License Text:
-- MIT License
-- Copyright 2023 Kaiwen Wu
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local M = {}
local jieba = require("jieba")
local ut = require("jieba.utils")
local utf8 = require("jieba.utf8")

local str_match = string.match
local sub = ut.sub
local len = utf8.len

local lpeg = vim.lpeg
local C, S, utfR, R = lpeg.C, lpeg.S, lpeg.utfR, lpeg.R
local hans = C(utfR(0x4E00, 0x9FFF) ^ 1) -- 0x9FA5?
local engs = C(R("az", "AZ") ^ 1)
local nums = C(R("09") ^ 1)
local half_punc = C(S("·.,;!?()[]{}+-=_!@#$%^&*~`'\"<>:|\\")) ^ 1
local full_punc = C(utfR(0x3000, 0x303F) + utfR(0xFF01, 0xFF5E) + utfR(0x2000, 0x206F)) ^ 1 -- 0xFF01 to 0xFF5E

-- TokenType Enum
TokenType = { hans = 1, punc = 2, space = 3, non_word = 4 }

local function get_token_type(str)
	if not str or str_match(str, "%s+") then
		return TokenType.space
	end
	if (half_punc + full_punc):match(str) then
		return TokenType.punc
	end
	if (nums + hans + engs):match(str) then
		return TokenType.hans
	end
	return TokenType.non_word
end
M.get_token_type = get_token_type

-- Parse each token as a table {i, j, t} such that i denotes the byte index of the first
-- character of the token, j denotes the byte index of the last character of the token,
-- t denotes the type of the token. If j is less than i, it means that the underlying
-- token is an empty string.
local function parse_tokens(tokens)
	local cum_l = 0
	local parsed = {}
	for _, tok in ipairs(tokens) do
		local i = cum_l
		cum_l = cum_l + #tok
		local j = cum_l - #sub(tok, len(tok), len(tok))
		parsed[#parsed + 1] = { i = i, j = j, t = get_token_type(tok) }
	end
	return parsed
end

local function _gen_implicit_space_in_between(parsed_tok2)
	local i2 = parsed_tok2.i
	return { i = i2, j = i2 - 1, t = TokenType.space }
end

local function insert_implicit_space_rule(parsed_tok1, parsed_tok2)
	if parsed_tok1 == nil then
		return nil
	end
	local rules = {
		[TokenType.hans] = {
			[TokenType.hans] = true,
			[TokenType.punc] = false,
			[TokenType.space] = false,
			[TokenType.non_word] = false,
		},
		[TokenType.punc] = {
			[TokenType.hans] = true,
			[TokenType.punc] = true,
			[TokenType.space] = false,
			[TokenType.non_word] = true,
		},
		[TokenType.space] = {
			[TokenType.hans] = false,
			[TokenType.punc] = false,
			[TokenType.space] = false,
			[TokenType.non_word] = false,
		},
		[TokenType.non_word] = {
			[TokenType.hans] = false,
			[TokenType.punc] = false,
			[TokenType.space] = false,
			[TokenType.non_word] = false,
		},
	}
	local t1 = rules[parsed_tok1.t][parsed_tok2.t]
	if t1 then
		local imp_space = _gen_implicit_space_in_between(parsed_tok2)
		return { parsed_tok1, imp_space, parsed_tok2 }
	end
	return nil
end

local function stack_merge(elements)
	local stack = {}
	for _, pt in ipairs(elements) do
		local trans_pt_list = insert_implicit_space_rule(stack[#stack], pt)
		if trans_pt_list == nil then
			-- Append to end of stack
			stack[#stack + 1] = pt
		elseif trans_pt_list[1] == nil then
			-- Remove the first element from trans_pt_list
			table.remove(trans_pt_list, 1)
			-- Extend stack with trans_pt_list
			for _, item in ipairs(trans_pt_list) do
				stack[#stack + 1] = item
			end
		else
			-- Remove last element from stack
			table.remove(stack)
			-- Extend stack with trans_pt_list
			for _, item in ipairs(trans_pt_list) do
				stack[#stack + 1] = item
			end
		end
	end

	return stack
end

local function index_tokens(parsed_tokens, bi)
	for ti = #parsed_tokens, 1, -1 do
		if parsed_tokens[ti].i <= bi then
			return ti, parsed_tokens[ti].i, parsed_tokens[ti].j
		end
	end
	error("token index of byte index " .. bi .. " not found in parsed tokens")
end

local function index_last_start_of_word(parsed_tokens)
	if #parsed_tokens == 0 then
		return 0
	end
	for ti = #parsed_tokens, 1, -1 do
		if parsed_tokens[ti].t ~= TokenType.space then
			return parsed_tokens[ti].i
		end
	end
	return nil
end

local function index_prev_start_of_word(parsed_tokens, ci)
	if #parsed_tokens == 0 then
		return nil
	end
	local ti = index_tokens(parsed_tokens, ci)
	if ci == parsed_tokens[ti].i then
		ti = ti - 1
	end
	while ti >= 1 do
		if parsed_tokens[ti].t ~= TokenType.space then
			return parsed_tokens[ti].i
		end
		ti = ti - 1
	end
	return nil
end

local function index_last_start_of_WORD(parsed_tokens)
	if #parsed_tokens == 0 then
		return 0
	end
	local last_valid_i = nil
	for ti = #parsed_tokens, 1, -1 do
		if parsed_tokens[ti].t ~= TokenType.space then
			last_valid_i = parsed_tokens[ti].i
		elseif last_valid_i ~= nil then
			break
		end
	end
	return last_valid_i
end

local function index_prev_start_of_WORD(parsed_tokens, ci)
	if #parsed_tokens == 0 then
		return nil
	end
	local ti = index_tokens(parsed_tokens, ci)
	if ci == parsed_tokens[ti].i then
		ti = ti - 1
	end
	local last_valid_i = nil
	while ti >= 1 do
		if parsed_tokens[ti].t ~= TokenType.space then
			last_valid_i = parsed_tokens[ti].i
		elseif last_valid_i ~= nil then
			break
		end
		ti = ti - 1
	end
	return last_valid_i
end

local function index_last_end_of_word(parsed_tokens)
	if #parsed_tokens == 0 then
		return 0
	end
	for ti = #parsed_tokens, 1, -1 do
		if parsed_tokens[ti].t ~= TokenType.space then
			return parsed_tokens[ti].j
		end
	end
	return nil
end

local function index_prev_end_of_word(parsed_tokens, ci)
	if #parsed_tokens == 0 then
		return nil
	end
	local ti = index_tokens(parsed_tokens, ci) - 1
	while ti >= 1 do
		if parsed_tokens[ti].t ~= TokenType.space then
			return parsed_tokens[ti].j
		end
		ti = ti - 1
	end
	return nil
end

local function index_last_end_of_WORD(parsed_tokens)
	if #parsed_tokens == 0 then
		return 0
	end
	for ti = #parsed_tokens, 1, -1 do
		if parsed_tokens[ti].t ~= TokenType.space then
			return parsed_tokens[ti].j
		end
	end
	return nil
end

local function index_prev_end_of_WORD(parsed_tokens, ci)
	if #parsed_tokens == 0 then
		return nil
	end
	local ti = index_tokens(parsed_tokens, ci)
	if parsed_tokens[ti].t == TokenType.space then
		ti = ti - 1
	else
		while ti >= 1 and parsed_tokens[ti].t ~= TokenType.space do
			ti = ti - 1
		end
	end
	while ti >= 1 do
		if parsed_tokens[ti].t ~= TokenType.space then
			return parsed_tokens[ti].j
		end
		ti = ti - 1
	end
	return nil
end

local function index_first_start_of_word(parsed_tokens)
	if #parsed_tokens == 0 then
		return 0
	end
	for i = 1, #parsed_tokens do
		if parsed_tokens[i].t ~= TokenType.space then
			return parsed_tokens[i].i
		end
	end
	return nil
end

local function index_next_start_of_word(parsed_tokens, ci)
	if #parsed_tokens == 0 then
		return nil
	end
	local ti = index_tokens(parsed_tokens, ci) + 1
	while ti <= #parsed_tokens do
		if parsed_tokens[ti].t ~= TokenType.space then
			return parsed_tokens[ti].i
		end
		ti = ti + 1
	end
	return nil
end

local function index_first_start_of_WORD(parsed_tokens)
	if #parsed_tokens == 0 then
		return 0
	end
	for i = 1, #parsed_tokens do
		if parsed_tokens[i].t ~= TokenType.space then
			return parsed_tokens[i].i
		end
	end
	return nil
end

local function index_next_start_of_WORD(parsed_tokens, ci)
	if #parsed_tokens == 0 then
		return nil
	end
	local ti = index_tokens(parsed_tokens, ci)
	if parsed_tokens[ti].t == TokenType.space then
		ti = ti + 1
	else
		while ti <= #parsed_tokens and parsed_tokens[ti].t ~= TokenType.space do
			ti = ti + 1
		end
	end
	while ti <= #parsed_tokens do
		if parsed_tokens[ti].t ~= TokenType.space then
			return parsed_tokens[ti].i
		end
		ti = ti + 1
	end
	return nil
end

local function index_first_end_of_word(parsed_tokens)
	if #parsed_tokens == 0 then
		return 0
	end
	for _, tok in ipairs(parsed_tokens) do
		if tok.t ~= TokenType.space then
			return tok.j
		end
	end
	return nil
end

local function index_next_end_of_word(parsed_tokens, ci)
	if #parsed_tokens == 0 then
		return nil
	end
	local ti = index_tokens(parsed_tokens, ci)
	if ci == parsed_tokens[ti].j then
		ti = ti + 1
	end
	while ti <= #parsed_tokens do
		if parsed_tokens[ti].t ~= TokenType.space then
			return parsed_tokens[ti].j
		end
		ti = ti + 1
	end
	return nil
end

local function index_first_end_of_WORD(parsed_tokens)
	if #parsed_tokens == 0 then
		return 0
	end
	local last_valid_j = nil
	for _, tok in ipairs(parsed_tokens) do
		if tok.t ~= TokenType.space then
			last_valid_j = tok.j
		elseif last_valid_j ~= nil then
			break
		end
	end
	return last_valid_j
end

local function index_next_end_of_WORD(parsed_tokens, ci)
	if #parsed_tokens == 0 then
		return nil
	end
	local ti = index_tokens(parsed_tokens, ci)
	if ci == parsed_tokens[ti].j then
		ti = ti + 1
	end
	local last_valid_j = nil
	while ti <= #parsed_tokens do
		if parsed_tokens[ti].t ~= TokenType.space then
			last_valid_j = parsed_tokens[ti].j
		elseif last_valid_j ~= nil then
			break
		end
		ti = ti + 1
	end
	return last_valid_j
end

-- determine the sentinel row and row step values based on the direction of movement
local function navigate(primary_index_func, secondary_index_func, backward, buffer, cursor_pos)
	local sentinel_row, row_step, pt
	if backward == true then
		sentinel_row = 1
		row_step = -1
	else
		sentinel_row = #buffer
		row_step = 1
	end
	-- unwrap the row and col from the cursor position
	local row, col = cursor_pos[1], cursor_pos[2]
	if row == sentinel_row then
		pt = parse_tokens(jieba.lcut(buffer[row], false, false))
		pt = stack_merge(pt)
		col = primary_index_func(pt, col)

		if col == nil then
			if backward == true then
				if #pt ~= 0 then
					col = pt[1].i
				else
					col = 0
				end
			else
				if #pt ~= 0 then
					col = pt[#pt].j
				else
					col = 0
				end
			end
		end
		-- return a table representing cursor position
		return { row, col }
	end
	-- similar steps for when row is not the sentinel_row
	pt = parse_tokens(jieba.lcut(buffer[row], false, false))
	pt = stack_merge(pt)
	col = primary_index_func(pt, col)
	if col ~= nil then
		return { row, col }
	end
	row = row + row_step
	while row ~= sentinel_row do
		pt = parse_tokens(jieba.lcut(buffer[row], false, false))
		pt = stack_merge(pt)
		col = secondary_index_func(pt)
		if col ~= nil then
			return { row, col }
		end
		row = row + row_step
	end
	pt = parse_tokens(jieba.lcut(buffer[row], false, false))
	pt = stack_merge(pt)
	col = secondary_index_func(pt)
	if col == nil then
		if backward == true then
			if #pt ~= 0 then
				col = pt[1].i
			else
				col = 0
			end
		else
			if #pt ~= 0 then
				col = pt[#pt].j
			else
				col = 0
			end
		end
	end
	return { row, col }
end

Lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

local update_lines = function()
	Lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
end

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI", "BufEnter" }, { callback = update_lines })

M.wordmotion_b = function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local pos = navigate(index_prev_start_of_word, index_last_start_of_word, true, Lines, cursor_pos)
	vim.api.nvim_win_set_cursor(0, pos)
end

M.wordmotion_B = function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local pos = navigate(index_prev_start_of_WORD, index_last_start_of_WORD, true, Lines, cursor_pos)
	vim.api.nvim_win_set_cursor(0, pos)
end

M.wordmotion_w = function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local pos = navigate(index_next_start_of_word, index_first_start_of_word, false, Lines, cursor_pos)
	vim.api.nvim_win_set_cursor(0, pos)
	return pos
end

M.wordmotion_W = function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local pos = navigate(index_next_start_of_WORD, index_first_start_of_WORD, false, Lines, cursor_pos)
	vim.api.nvim_win_set_cursor(0, pos)
end

M.wordmotion_e = function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local pos = navigate(index_next_end_of_word, index_first_end_of_word, false, Lines, cursor_pos)
	vim.api.nvim_win_set_cursor(0, pos)
end

M.wordmotion_E = function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local pos = navigate(index_next_end_of_WORD, index_first_end_of_WORD, false, Lines, cursor_pos)
	vim.api.nvim_win_set_cursor(0, pos)
end

M.wordmotion_ge = function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local pos = navigate(index_prev_end_of_word, index_last_end_of_word, true, Lines, cursor_pos)
	vim.api.nvim_win_set_cursor(0, pos)
end

M.wordmotion_gE = function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local pos = navigate(index_prev_end_of_WORD, index_last_end_of_WORD, true, Lines, cursor_pos)
	vim.api.nvim_win_set_cursor(0, pos)
end

M.change_w = function()
	M.delete_w()
	vim.cmd("startinsert")
end

M.delete_w_callback = function()
	M.select_w()
	vim.cmd("normal d")
	update_lines()
end

M.delete_w = function()
	M.delete_w_callback()
	vim.o.operatorfunc = "v:lua.require'jieba_nvim'.delete_w_callback()"
	return vim.cmd("normal! g@l")
end

M.select_w = function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = Lines[cursor_pos[1]]
	local line = parse_tokens(jieba.lcut(current_line, false, false))
	print(line)
	line = stack_merge(line)
	local _, start, row = index_tokens(line, cursor_pos[2])
	vim.api.nvim_cmd({ cmd = "normal", bang = true, args = { "v" } }, {})
	vim.api.nvim_win_set_cursor(0, { cursor_pos[1], start })
	vim.cmd("normal! o")
	vim.api.nvim_win_set_cursor(0, { cursor_pos[1], row })
end

-- local function high(line, start, stop)
-- 	local bufnr = vim.api.nvim_get_current_buf()
-- 	print(bufnr)
-- 	-- Define the highlight group and attributes
-- 	local hl_group = "MyHighlightGroup"
-- 	local hl_color = "#ff0000" -- 这里使用的是红色（#ff0000）
-- 	-- Define the start and end positions
-- 	vim.cmd("highlight " .. hl_group .. " guifg=" .. hl_color)
-- 	-- Add the highlight to the buffer
-- 	vim.api.nvim_buf_add_highlight(bufnr, -1, hl_group, line, start, stop)
-- end

-- TODO: 高亮当前光标下的词
-- local function hightlight_under_curosr()
-- 	local line = parse_tokens(jieba.lcut(vim.api.nvim_get_current_line(), false, true))
-- 	line = stack_merge(line)
-- 	local cursor_pos = vim.api.nvim_win_get_cursor(0)
-- 	local _, start, row = index_tokens(line, cursor_pos[2] + 1)
--   high(cursor_pos[1] - 1, start, row)
-- end
--
-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, { callback = hightlight_under_curosr })

M.setup = function(config)
	config = config or {}
	local map = vim.F.if_nil(config.use_default_mappings, true)
	if map then
		vim.keymap.set(
			"n",
			"B",
			'<cmd>lua require("jieba_nvim").wordmotion_B()<CR>',
			{ noremap = false, silent = true }
		)
		vim.keymap.set(
			"n",
			"b",
			'<cmd>lua require("jieba_nvim").wordmotion_b()<CR>',
			{ noremap = false, silent = true }
		)
		vim.keymap.set(
			"n",
			"w",
			'<cmd>lua require("jieba_nvim").wordmotion_w()<CR>',
			{ noremap = false, silent = true }
		)
		vim.keymap.set(
			"n",
			"W",
			'<cmd>lua require("jieba_nvim").wordmotion_W()<CR>',
			{ noremap = false, silent = true }
		)
		vim.keymap.set(
			"n",
			"E",
			'<cmd>lua require("jieba_nvim").wordmotion_E()<CR>',
			{ noremap = false, silent = true }
		)
		vim.keymap.set(
			"n",
			"e",
			'<cmd>lua require("jieba_nvim").wordmotion_e()<CR>',
			{ noremap = false, silent = true }
		)
		vim.keymap.set(
			"n",
			"ge",
			'<cmd>lua require("jieba_nvim").wordmotion_ge()<CR>',
			{ noremap = false, silent = true }
		)
		vim.keymap.set(
			"n",
			"gE",
			'<cmd>lua require("jieba_nvim").wordmotion_gE()<CR>',
			{ noremap = false, silent = true }
		)
	end
end

return M
