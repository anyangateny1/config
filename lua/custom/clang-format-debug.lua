-- Debug utility for clang-format in WSL
local M = {}

function M.debug_clang_format()
  local current_file = vim.fn.expand('%:p')
  local current_dir = vim.fn.fnamemodify(current_file, ':h')
  
  print("=== Clang-format Debug Info ===")
  print("Current file: " .. current_file)
  print("Current directory: " .. current_dir)
  
  -- Detailed path analysis
  print("\n--- Path Analysis ---")
  print("vim.fn.expand('%:p'): " .. vim.fn.expand('%:p'))
  print("vim.fn.expand('%'): " .. vim.fn.expand('%'))
  print("vim.api.nvim_buf_get_name(0): " .. vim.api.nvim_buf_get_name(0))
  
  -- Check if we're on a Windows mount
  if string.match(current_file, "^/mnt/[a-z]/") then
    print("⚠️  File is on Windows filesystem (/mnt/)")
    
    -- Test different path representations
    local relative_from_root = current_file:gsub("^/mnt/[a-z]/", "")
    print("Path without /mnt/c/: " .. relative_from_root)
    
    -- Test if the file actually exists and is readable
    print("File exists (vim.fn.filereadable): " .. vim.fn.filereadable(current_file))
    print("File exists (vim.loop.fs_stat): " .. (vim.loop.fs_stat(current_file) and "true" or "false"))
  else
    print("✓ File is on Linux filesystem")
  end
  
  -- Look for .clang-format file with detailed search
  print("\n--- Searching for .clang-format ---")
  local search_dirs = {}
  local temp_dir = current_dir
  
  -- Collect all directories we'll search
  while temp_dir ~= "/" do
    table.insert(search_dirs, temp_dir)
    temp_dir = vim.fn.fnamemodify(temp_dir, ':h')
    if temp_dir == vim.fn.fnamemodify(temp_dir, ':h') then break end -- reached root
  end
  
  for i, dir in ipairs(search_dirs) do
    local clang_format_path = dir .. "/.clang-format"
    local exists = vim.fn.filereadable(clang_format_path) == 1
    print(string.format("%d. Checking: %s [%s]", i, clang_format_path, exists and "EXISTS" or "not found"))
    if exists then
      print("   ✓ Found .clang-format at: " .. clang_format_path)
      break
    end
  end
  
  -- Use vim.fs.find to see what it finds
  local style_file = vim.fs.find('.clang-format', {
    path = current_file,
    upward = true,
  })[1]
  
  if style_file then
    print("✓ vim.fs.find found: " .. style_file)
  else
    print("❌ vim.fs.find found nothing")
  end
  
  -- Check clang-format version and location
  print("\n--- Clang-format Binary Info ---")
  
  -- Check if clang-format is installed
  local handle = io.popen('which clang-format 2>/dev/null')
  local which_result = handle:read("*a")
  handle:close()
  
  if which_result and which_result:match("%S") then
    print("✓ clang-format found at: " .. which_result:gsub("\n", ""))
    
    -- Get version
    local version_handle = io.popen('clang-format --version 2>/dev/null')
    local version_result = version_handle:read("*a")
    version_handle:close()
    print("✓ Version: " .. (version_result:gsub("\n", "")))
  else
    print("❌ clang-format NOT FOUND")
    print("💡 Install with: sudo apt update && sudo apt install clang-format")
    return -- Exit early if clang-format not found
  end
  
  -- Test different clang-format approaches
  print("\n--- Testing clang-format commands ---")
  
  -- Test 1: With the exact path vim gives us
  local test_cmd1 = string.format('cd "%s" && clang-format --dry-run "%s" 2>&1', current_dir, current_file)
  local test_handle1 = io.popen(test_cmd1)
  local test_result1 = test_handle1:read("*a")
  test_handle1:close()
  
  print("1. Using vim's exact path (" .. current_file .. "):")
  if test_result1 == "" then
    print("   ✓ Success")
  else
    print("   ❌ Error: " .. (test_result1:gsub("\n", " ")))
  end
  
  -- Test 2: With resolved/canonical path
  local resolved_file = vim.fn.resolve(current_file)
  if resolved_file ~= current_file then
    print("2. Using resolved path (" .. resolved_file .. "):")
    local test_cmd2 = string.format('cd "%s" && clang-format --dry-run "%s" 2>&1', current_dir, resolved_file)
    local test_handle2 = io.popen(test_cmd2)
    local test_result2 = test_handle2:read("*a")
    test_handle2:close()
    
    if test_result2 == "" then
      print("   ✓ Success")
    else
      print("   ❌ Error: " .. (test_result2:gsub("\n", " ")))
    end
  end
  
  -- Test 3: With explicit style file if found
  if style_file then
    local test_cmd3 = string.format('cd "%s" && clang-format -style=file:"%s" --dry-run "%s" 2>&1', current_dir, style_file, current_file)
    local test_handle3 = io.popen(test_cmd3)
    local test_result3 = test_handle3:read("*a")
    test_handle3:close()
    
    print("3. With explicit style file:")
    if test_result3 == "" then
      print("   ✓ Success")
    else
      print("   ❌ Error: " .. (test_result3:gsub("\n", " ")))
    end
  end
  
  -- Test 4: From the directory containing .clang-format
  if style_file then
    local style_dir = vim.fn.fnamemodify(style_file, ':h')
    local test_cmd4 = string.format('cd "%s" && clang-format --dry-run "%s" 2>&1', style_dir, current_file)
    local test_handle4 = io.popen(test_cmd4)
    local test_result4 = test_handle4:read("*a")
    test_handle4:close()
    
    print("4. From .clang-format directory:")
    if test_result4 == "" then
      print("   ✓ Success")
    else
      print("   ❌ Error: " .. (test_result4:gsub("\n", " ")))
    end
  end
end

-- Add command to call the debug function
vim.api.nvim_create_user_command('ClangFormatDebug', M.debug_clang_format, {})

-- Test function to show how the discovery works for any project structure
function M.test_discovery(test_file_path)
  print("=== Testing .clang-format Discovery ===")
  print("Test file path: " .. test_file_path)
  
  local style_file = vim.fs.find('.clang-format', {
    path = test_file_path,
    upward = true,
  })[1]
  
  if style_file then
    print("✓ Would find .clang-format at: " .. style_file)
    print("✓ Would run clang-format from: " .. vim.fn.fnamemodify(style_file, ':h'))
  else
    print("❌ No .clang-format found - would use default behavior")
    print("✓ Would run clang-format from: " .. vim.fn.fnamemodify(test_file_path, ':h'))
  end
  
  return style_file
end

vim.api.nvim_create_user_command('ClangFormatTest', function(opts)
  if opts.args == "" then
    print("Usage: :ClangFormatTest /path/to/test/file.cpp")
    return
  end
  M.test_discovery(opts.args)
end, { nargs = 1 })

-- Shortcut to test current file
vim.api.nvim_create_user_command('ClangFormatTestCurrent', function()
  local current_file = vim.fn.expand('%:p')
  if current_file == "" then
    print("No file currently open")
    return
  end
  M.test_discovery(current_file)
end, {})

return M 