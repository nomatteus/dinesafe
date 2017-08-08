# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  # Use Ubuntu 14.04 Trusty Tahr 64-bit as our operating system
  config.vm.box = "ubuntu/trusty64"


  # Forward the Rails server default port to the host
  config.vm.network :forwarded_port, guest: 3000, host: 3000

  # Install things (may dupe some things in chef recipes...)
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get upgrade --show-upgraded
    sudo aptitude -y install wget vim less
    sudo sed -i -e 's/^#PS1=/PS1=/' /root/.bashrc # enable the colorful root bash prompt
    sudo sed -i -e "s/^#alias ll='ls -l'/alias ll='ls -al'/" /root/.bashrc # enable ll list long alias <3
    sudo aptitude -y install build-essential libpcre3-dev libssl-dev libcurl4-openssl-dev libreadline5-dev libxml2-dev libxslt1-dev libmysqlclient-dev openssh-server git-core
    sudo aptitude -y install git-core libmysqlclient15-dev curl build-essential libcurl4-openssl-dev zlib1g-dev libssl-dev libreadline6 libreadline6-dev libperl-dev gcc libjpeg62-dev libbz2-dev libtiff4-dev libwmf-dev libx11-dev libxt-dev libxext-dev libxml2-dev libfreetype6-dev liblcms1-dev libexif-dev perl libjasper-dev libltdl3-dev graphviz gs-gpl pkg-config unzip
  SHELL

  # Use Chef Solo to provision our virtual machine
  config.vm.provision :chef_solo do |chef|
    chef.channel = 'stable'
    chef.version = '12.10.24'
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]

    chef.add_recipe "apt"
    chef.add_recipe "gpg"
    chef.add_recipe "nodejs"
    chef.add_recipe "ruby_build"
    chef.add_recipe "rvm::system"
    chef.add_recipe "rvm::vagrant"
    chef.add_recipe "vim"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "postgresql::contrib"

    # Install Ruby 2.2.1 and Bundler
    chef.json = {
      rvm: {
        install_rubies: true,
        rubies: ["ruby-2.2.1"],
        default_ruby: "ruby-2.2.1",
        gpg: { # fixes a crash...
          keyserver: "hkp://pool.sks-keyservers.net"
        }
        # gpg_key: ""
        # vagrant: {
        #   system_chef_solo: "/usr/bin/chef-solo"
        # }
      },
      postgresql: {
        # pg_hba: [
        #   {
        #     comment: "",
        #     type: "local",
        #     db: "all",
        #     user: "postgres",
        #     addr: nil,
        #     method: "md5"
        #   }
        # ],
        config: {
          listen_addresses: "*"
        },
        password: {
          postgres: "password"
        },
        # NOTE: Not yet tested provisioning with extensions...
        contrib: {
          extensions: ["cube", "earthdistance"]
        }
      }
    }
  end

  config.vm.provision "shell", inline: <<-SHELL
    ### BELOW NOT WORKING YET -- RUN MANUALLY

    # Run below as user
    # su vagrant

    # sudo -u postgres psql -d template1 -c "ALTER USER postgres WITH PASSWORD 'password';"

    # Auto-trust rvmrc
    # echo "export rvm_trust_rvmrcs_flag=1" >> ~/.rvmrc

    # cd /vagrant
    # bundle
    # Create db and load from structure.sql
    # bundle exec rake db:setup
  SHELL

  # Parallels-specific info: http://parallels.github.io/vagrant-parallels/

  # Configurate the virtual machine to use 2GB of RAM
  config.vm.provider 'virtualbox' do |v|
    v.memory = 2048
    v.cpus = 2
  end

  # Forward SSH
  config.ssh.forward_agent = true
end
