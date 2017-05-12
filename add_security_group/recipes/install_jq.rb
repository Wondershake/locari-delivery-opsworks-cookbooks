Chef::Log.info(OpsWorks::ShellOut.shellout("wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O /tmp/jq"))
Chef::Log.info(OpsWorks::ShellOut.shellout("chmod 755 /tmp/jq"))
