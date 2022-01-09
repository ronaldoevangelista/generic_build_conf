require 'autoproj/gitorious'

os_names, os_releases = Autoproj.workspace.operating_system

Autoproj.message("os_names values: #{os_names}", :red)

Autoproj.message(Autoproj.operating_system, :red)




Autobuild.parallel_build_level = 10
Autobuild::CMake.show_make_messages = true
Autobuild::CMake.prefix_path << Autoproj.prefix

Autoproj.gitorious_server_configuration('GITHUB', 'github.com', :http_url => 'https://github.com')
