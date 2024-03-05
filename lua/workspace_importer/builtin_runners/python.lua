local M = {}


M.test ={ {
			name = "Run Pytest",
			command = "pytest",
			args = {"--verbose", "--color=yes"},
			-- working_directory = "/home/anders/Documents/work/ops2_demo/powercore/as/as_gen/",
			environment = {PYTHONDONTWRITEBYTECODE = "1"},
			trigger ="onSave",
		} }

return M
