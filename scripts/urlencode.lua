local function urlencode(str)
  str = str:gsub("[^%w%-_%.~]", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  return str
end

if #arg > 0 then
  for _, v in ipairs(arg) do
    print(urlencode(v))
  end
else
  for line in io.lines() do
    print(urlencode(line))
  end
end
