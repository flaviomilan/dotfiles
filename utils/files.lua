local FileUtils = {}

-- Function to aggregate content from multiple input files
-- @param file_paths: A table containing paths to input files
-- @return: Aggregated content from input files
function FileUtils.aggregate_files(file_paths)
    local aggregated_content = ""
    for _, file_path in ipairs(file_paths) do
        local file_content = FileUtils.read_file(file_path)
        if file_content then
            aggregated_content = aggregated_content .. file_content
        else
            print("Error: Unable to read file " .. file_path)
        end
    end
    return aggregated_content
end

-- Function to read content from a file
-- @param file_path: Path to the file to be read
-- @return: Content of the file if successful, or nil if reading fails
function FileUtils.read_file(file_path)
    local file = io.open(file_path, "r")
    if file then
        local content = file:read("*all")
        file:close()
        return content
    else
        return nil -- Return nil if file opening fails
    end
end

-- Function to write content to a file
-- @param file_path: Path to the file to be written
-- @param content: Content to be written to the file
-- @return: True if successful, false and an error message if writing fails
function FileUtils.write_file(file_path, content)
    local dir_path = file_path:match("^(.*[/\\])")
    
    if dir_path then
        local mkdirCommand = "mkdir -p " .. dir_path:gsub("\\", "/")
        local success, _, exitcode = os.execute(mkdirCommand)
        if not success or exitcode ~= 0 then
            return false, "Unable to create directory: " .. dir_path
        end
    end
    
    local file = io.open(file_path, "w")
    if file then
        file:write(content)
        file:close()
        return true
    else
        return false, "Unable to write to file " .. file_path
    end
end


return FileUtils