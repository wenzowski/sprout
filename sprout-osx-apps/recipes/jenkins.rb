include_recipe "sprout-osx-base::homebrew"
jenkins_properties = node['sprout']['jenkins']

brew "jenkins"

directory jenkins_properties['plugins_dir'] do
  action :create
  owner node['current_user']
  recursive true
end

jenkins_properties['plugins'].each do |plugin|
  execute "install #{plugin} plugin" do
    user node['current_user']
    command "curl -L http://updates.jenkins-ci.org/latest/#{plugin}.hpi -o #{jenkins_properties['plugins_dir']}/#{plugin}.hpi"
  end
end

link "/Users/#{node['current_user']}/Library/LaunchAgents/homebrew.mxcl.jenkins.plist" do
    to "/usr/local/opt/jenkins/homebrew.mxcl.jenkins.plist"
end

execute "run jenkins" do
  user node['current_user']
  command "launchctl load ~/Library/LaunchAgents/homebrew.mxcl.jenkins.plist"
end

