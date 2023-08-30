--=====================================================================
--
-- loader.lua - 
--
-- Created by skywind on 2023/08/30
-- Last Modified: 2023/08/30 19:32:59
--
--=====================================================================


-----------------------------------------------------------------------
-- module initialize
-----------------------------------------------------------------------
local modname = ...
if modname ~= nil then
	local MM = {}
	setmetatable(MM, {__index = _G})
	package.loaded[modname] = MM
	if _ENV ~= nil then _ENV = MM else setfenv(1, MM) end
end


-----------------------------------------------------------------------
-- scheduler
-----------------------------------------------------------------------
scheduler = {}
scheduler.__index = scheduler

function scheduler:new()
	local obj = {}
	setmetatable(obj, scheduler)
	obj.tasks = {}
	return obj
end

function scheduler:push(level, task)
	table.insert(self.tasks, {level, task})
end

function scheduler:clear()
	self.tasks = {}
end

function scheduler:run()
	local tasks = {}
	local names = {}
	for _, item in ipairs(self.tasks) do
		local level = item[1]
		local task = item[2]
		if tasks[level] == nil then
			tasks[level] = {}
		end
		table.insert(tasks[level], task)
	end
	for level, _ in pairs(tasks) do
		table.insert(names, level)
	end
	table.sort(names)
	for _, level in ipairs(names) do 
		local current = tasks[level]
		if current then
			for _, task in ipairs(tasks[level]) do
				task()
			end
		end
	end
end


-----------------------------------------------------------------------
-- if __name__ == '__main__':
-----------------------------------------------------------------------
if not pcall(debug.getlocal, 4, 1) then
	local function getfoo(index) 
		function foo()
			print('foo(' .. index .. ')')
		end
		return foo
	end
	local s = scheduler:new()
	s:push(0, getfoo(1000))
	s:push(0, getfoo(1001))
	s:push(0, getfoo(1002))
	s:push(5, getfoo(5000))
	s:push(5, getfoo(5001))
	s:push(5, getfoo(5002))
	s:push(3, getfoo(3000))
	s:push(3, getfoo(3001))
	s:push(3, getfoo(3002))
	s:run()
end



