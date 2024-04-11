local DEBUGGERS = {
    [567416835] = true
}

return function (registry)
	registry:RegisterHook("BeforeRun", function(context)
		if context.Group == "DefaultDebug" and not DEBUGGERS[context.Executor.UserId] then
			return "You don't have permission to run this command"
		end
	end)
end