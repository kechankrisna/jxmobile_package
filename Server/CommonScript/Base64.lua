local index_table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function to_binary(integer)
	local remaining = tonumber(integer)
	local bin_bits = ''

	for i = 7, 0, -1 do
		local current_power = math.pow(2, i)

		if remaining >= current_power then
			bin_bits = bin_bits .. '1'
			remaining = remaining - current_power
		else
			bin_bits = bin_bits .. '0'
		end
	end

	return bin_bits
end

local function from_binary(bin_bits)
	return tonumber(bin_bits, 2)
end


local function to_base64(to_encode)
	local bit_pattern = ''
	local encoded = ''
	local trailing = ''

	for i = 1, string.len(to_encode) do
		bit_pattern = bit_pattern .. to_binary(string.byte(string.sub(to_encode, i, i)))
	end

	-- Check the number of bytes. If it's not evenly divisible by three,
	-- zero-pad the ending & append on the correct number of ``=``s.
	if math.mod(string.len(bit_pattern), 3) == 2 then
		trailing = '=='
		bit_pattern = bit_pattern .. '0000000000000000'
	elseif math.mod(string.len(bit_pattern), 3) == 1 then
		trailing = '='
		bit_pattern = bit_pattern .. '00000000'
	end

	for i = 1, string.len(bit_pattern), 6 do
		local byte = string.sub(bit_pattern, i, i+5)
		local offset = tonumber(from_binary(byte))
		encoded = encoded .. string.sub(index_table, offset+1, offset+1)
	end

	return string.sub(encoded, 1, -1 - string.len(trailing)) .. trailing
end


local function from_base64(to_decode)
	local padded = to_decode:gsub("%s", "")
	local unpadded = padded:gsub("=", "")
	local bit_pattern = ''
	local decoded = ''

	for i = 1, string.len(unpadded) do
		local char = string.sub(to_decode, i, i)
		local offset, _ = string.find(index_table, char)
		if offset == nil then
			 error("Invalid character '" .. char .. "' found.")
		end

		bit_pattern = bit_pattern .. string.sub(to_binary(offset-1), 3)
	end

	for i = 1, string.len(bit_pattern), 8 do
		local byte = string.sub(bit_pattern, i, i+7)
		decoded = decoded .. string.char(from_binary(byte))
	end

	local padding_length = padded:len()-unpadded:len()

	if (padding_length == 1 or padding_length == 2) then
		decoded = decoded:sub(1,-2)
	end
	return decoded
end

-- print(to_base64('Man')) -- 'TWFu'
-- print(to_base64('leasure.')) -- 'bGVhc3VyZS4='
-- print(to_base64('pleasure.')) -- 'cGxlYXN1cmUu'
-- print(to_base64('easure.')) -- 'ZWFzdXJlLg=='
-- print(to_base64('sure.')) -- 'c3VyZS4='

-- print(from_base64('TWFu')) -- 'Man'
-- print(from_base64('bGVhc3VyZS4=')) -- 'leasure.'
-- print(from_base64('cGxlYXN1cmUu')) -- 'pleasure.'
-- print(from_base64('ZWFzdXJlLg==')) -- 'easure.'
-- print(from_base64('c3VyZS4=')) -- 'sure.'

function Lib:Base64Encode(szStr)
	return to_base64(szStr);
end

function Lib:Base64Decode(szStr)
	return from_base64(szStr);
end
