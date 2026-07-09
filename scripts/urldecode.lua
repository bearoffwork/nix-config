local function urldecode(str)
  str = str:gsub("+", " ")
  str = str:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end)
  return str
end

if #arg > 0 then
  for _, v in ipairs(arg) do
    print(urldecode(v))
  end
else
  for line in io.lines() do
    print(urldecode(line))
  end
end
