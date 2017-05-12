execute "delete jq" do
  cwd "/tmp"
  user "root"
  command "rm -f /tmp/jq"
  only_if { File.exists?("/tmp/jq") }
end
