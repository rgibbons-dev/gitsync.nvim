local M = {}
local Job = require("plenary.job")

function M.check_remote(loc)
	local function echo(joined)
		if string.find(joined, "up to date") then
			vim.schedule(function()
				vim.api.nvim_echo({ { "config is in sync", "None" } }, false, {})
			end)
		elseif string.find(joined, "behind") or string.find(joined, "ahead") then
			vim.schedule(function()
				vim.api.nvim_echo({ { "config is out of sync", "None" } }, false, {})
			end)
		else
			vim.schedule(function()
				vim.api.nvim_echo({
					{
						"something went wrong with gitsync.nvim. double check your configuration",
						"None",
					},
				}, false, {})
			end)
		end
	end
	local function run_git_status(cwd)
		local stdout_lines = {}
		Job:new({
			command = "git",
			args = { "status" },
			cwd = cwd,
			on_stdout = function(_, data)
				table.insert(stdout_lines, data)
			end,
			on_exit = function()
				local joined = table.concat(stdout_lines, "\n")
				echo(joined)
			end,
		}):start()
	end
	Job:new({
		command = "git",
		args = { "fetch", "origin" },
		cwd = loc,
		on_exit = function()
			run_git_status(loc)
		end,
	}):start()
end

return M
