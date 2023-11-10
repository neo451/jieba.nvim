local M = {}
local jieba = require("jieba")
local ut = require("jb_utils")
local pat_space = "%s+" -- 空格

-- 卡壳问题
-- hmm 会把"test = parse"这样的的情况判断为hans: test = par 和 se
-- 暂不用
-- TokenType Enum
TokenType = { hans = 1, punc = 2, space = 3, non_word = 4 }

local function get_token_type(token)
	if not token or string.match(token, pat_space) then
		return TokenType.space
	end
	if ut.is_punctuation(token) then
		return TokenType.punc
	end
	if ut.isChineseCharacter(token) or string.match(token, "[a-zA-Z0-9]") then
		return TokenType.hans
	end
	return TokenType.non_word
end

local parse_tokens = function(tokens)
	-- Parse each token as a table {i, j, t} such that i denotes the byte index of the first
	-- character of the token, j denotes the byte index of the last character of the token,
	-- t denotes the type of the token. If j is less than i, it means that the underlying
	-- token is an empty string.
	local cum_l = 0
	local parsed = {}
	for _, tok in ipairs(tokens) do
		local i = cum_l
		local t = get_token_type(tok)
		cum_l = cum_l + #tok
		local j = cum_l - #ut.sub(tok, ut.len(tok), ut.len(tok))
		table.insert(parsed, { i = i, j = j, t = t })
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
	local to_insert_table = {
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
	local t1 = to_insert_table[parsed_tok1.t][parsed_tok2.t]
	if t1 then
		local imp_space = _gen_implicit_space_in_between(parsed_tok2)
		return { parsed_tok1, imp_space, parsed_tok2 }
	end
	return nil
end

local function stack_merge(elements, rule_func)
	local stack = {}
	for _, pt in ipairs(elements) do
		-- Get last element from stack if possible, or use nil
		local last_in_stack = nil
		if #stack > 0 then
			last_in_stack = stack[#stack]
		end

		local trans_pt_list = rule_func(last_in_stack, pt)
		if trans_pt_list == nil then
			-- Append to end of stack
			table.insert(stack, pt)
		elseif trans_pt_list[1] == nil then
			-- Remove the first element from trans_pt_list
			table.remove(trans_pt_list, 1)
			-- Extend stack with trans_pt_list
			for _, item in ipairs(trans_pt_list) do
				table.insert(stack, item)
			end
		else
			-- Remove last element from stack
			table.remove(stack)
			-- Extend stack with trans_pt_list
			for _, item in ipairs(trans_pt_list) do
				table.insert(stack, item)
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
  print(vim.inspect(parsed_tokens))
	while ti <= #parsed_tokens do
		if parsed_tokens[ti].t ~= TokenType.space then
      print(parsed_tokens[ti].i, parsed_tokens[ti].t)
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

local function navigate(primary_index_func, secondary_index_func, backward, buffer, cursor_pos)
	-- -- determine the sentinel row and row step values based on the direction of movement
	local sentinel_row, row_step, pt
	if backward == true then
		sentinel_row = 1
		row_step = -1
	else
		sentinel_row = #buffer
		row_step = 1
	end
	-- -- unwrap the row and col from the cursor position
	local row, col = cursor_pos[1], cursor_pos[2]
	if row == sentinel_row then
		pt = parse_tokens(jieba.lcut(buffer[row]))
		pt = stack_merge(pt, insert_implicit_space_rule)
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
	pt = parse_tokens(jieba.lcut(buffer[row]))
	pt = stack_merge(pt, insert_implicit_space_rule)
	col = primary_index_func(pt, col)
	if col ~= nil then
		return { row, col }
	end
	row = row + row_step
	while row ~= sentinel_row do
		pt = parse_tokens(jieba.lcut(buffer[row]))
		pt = stack_merge(pt, insert_implicit_space_rule)
		col = secondary_index_func(pt)
		if col ~= nil then
			return { row, col }
		end
		row = row + row_step
	end
	pt = parse_tokens(jieba.lcut(buffer[row]))
	pt = stack_merge(pt, insert_implicit_space_rule)
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

vim.api.nvim_create_autocmd({ "InsertLeave" }, { callback = update_lines })

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
  -- test = jieba.lcut(vim.api.nvim_get_current_line())
  -- print(vim.inspect(parse_tokens(test)))
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

-- M.delete_w = function()
--   M.dw_callback()
--   vim.go.operatorfunc = "v:lua.require'jieba_nvim'.dw_callback"
--   return vim.cmd("normal! g@l")
-- end

M.change_w = function()
  M.delete_w()
  vim.cmd("startinsert")
end

M.delete_w = function ()
  M.select_w()
  vim.cmd("normal d")
  update_lines()
end

M.select_w = function ()
  local line = parse_tokens(jieba.lcut(vim.api.nvim_get_current_line(), false, true))
  line = stack_merge(line, insert_implicit_space_rule)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local _, start, row = index_tokens(line, cursor_pos[2])
  vim.api.nvim_cmd({ cmd = "normal", bang = true, args = { 'v' } }, {})
  vim.api.nvim_win_set_cursor(0, { cursor_pos[1], start})
  vim.cmd "normal! o"
  vim.api.nvim_win_set_cursor(0, { cursor_pos[1], row})
end

return M
