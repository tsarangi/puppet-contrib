Facter.add("should_shutdown_condorQ") do
	setcode do
		system('/usr/local/bin/should_shutdown_condorQ.sh')
		if $?.exitstatus == 0
			true
		else
			false
		end
	end
end
