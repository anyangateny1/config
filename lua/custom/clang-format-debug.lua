-- Debug utility for clang-format in WSL
local M = {}

function M.debug_clang_format()
  local current_file = vim.fn.expand('%:p')
  local current_dir = vim.fn.fnamemodify(current_file, ':h')
  
  print("=== Clang-format Debug Info ===")
  print("Current file: " .. current_file)
  print("Current directory: " .. current_dir)
  
  -- Check if we're on a Windows mount
  if string.match(current_file, "^/mnt/[a-z]/") then
    print("⚠️  File is on Windows filesystem (/mnt/)")
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
  local handle = io.popen('which clang-format && clang-format --version')
  local result = handle:read("*a")
  handle:close()
  
  print("Clang-format info:")
  print(result)
  
  -- Test different clang-format approaches
  print("\n--- Testing clang-format commands ---")
  
  -- Test 1: From current directory without style file
  local test_cmd1 = string.format('cd "%s" && clang-format --dry-run "%s" 2>&1', current_dir, current_file)
  local test_handle1 = io.popen(test_cmd1)
  local test_result1 = test_handle1:read("*a")
  test_handle1:close()
  
  print("1. From current dir (no style specified):")
  if test_result1 == "" then
    print("   ✓ Success")
  else
    print("   ❌ Error: " .. (test_result1:gsub("\n", " ")))
  end
  
  -- Test 2: With explicit style file if found
  if style_file then
    local test_cmd2 = string.format('cd "%s" && clang-format -style=file:"%s" --dry-run "%s" 2>&1', current_dir, style_file, current_file)
    local test_handle2 = io.popen(test_cmd2)
    local test_result2 = test_handle2:read("*a")
    test_handle2:close()
    
    print("2. With explicit style file:")
    if test_result2 == "" then
      print("   ✓ Success")
    else
      print("   ❌ Error: " .. (test_result2:gsub("\n", " ")))
    end
  end
  
  -- Test 3: From the directory containing .clang-format
  if style_file then
    local style_dir = vim.fn.fnamemodify(style_file, ':h')
    local test_cmd3 = string.format('cd "%s" && clang-format --dry-run "%s" 2>&1', style_dir, current_file)
    local test_handle3 = io.popen(test_cmd3)
    local test_result3 = test_handle3:read("*a")
    test_handle3:close()
    
    print("3. From .clang-format directory:")
    if test_result3 == "" then
      print("   ✓ Success")
    else
      print("   ❌ Error: " .. (test_result3:gsub("\n", " ")))
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

return M 