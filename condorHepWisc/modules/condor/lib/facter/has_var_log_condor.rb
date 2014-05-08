Facter.add("has_var_log_condor") do
	setcode do
		File.exist?("/var/log/condor")
	end
end
