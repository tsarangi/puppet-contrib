Facter.add("has_var_condor") do
	setcode do
		File.exist?("/var/condor")
	end
end
