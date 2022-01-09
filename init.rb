require 'autoproj/gitorious'

Autobuild.parallel_build_level = 10
Autobuild::CMake.show_make_messages = true

os_names, os_releases = Autoproj.workspace.operating_system

ros_distro = ''
so_distro=''

distro_map = {
    'xenial' => 'kinetic',
    'bionic' => 'melodic',
    'focal'  => 'noetic'
}

ros_distro = distro_map[os_releases.find { |release| distro_map[release]}]

distro_map.each do |so_name,ros_name|
  if (ros_distro == ros_name)
    ros_distro= ros_name
    so_distro=so_name
  end
end

if ros_distro == 'noetic'
  python_path = 'python3'
else
  python_path = 'python2.7'
end

Autoproj.message "  ros #{ros_distro}", :blue
Autoproj.message "  distro #{so_distro}", :red
Autoproj.message "  #{python_path} environment", :green

Autoproj.env_add_path 'PYTHONPATH', File.join("python_path", 'dist-packages')
Autoproj.config.set('USE_PYTHON', 'YES') unless Autoproj.config.get('USE_PYTHON', nil)

Autobuild::CMake.prefix_path << Autoproj.prefix
