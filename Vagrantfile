$script = <<-SCRIPT

echo "cd /vagrant" >> /home/vagrant/.profile
echo "The Virtual Machine is up"

cd /vagrant/scripts
chmod 755 fabric-setup.sh
chmod 755 caserver-setup.sh

sudo ./fabric-setup.sh
sudo ./caserver-setup.sh
SCRIPT

Vagrant.configure("2") do |config|


    config.vm.box = "bento/ubuntu-16.04"
    config.vm.boot_timeout = 600

    config.ssh.username = 'vagrant'
    config.ssh.password = 'vagrant'
    config.ssh.insert_key = 'true'

    # Ports foward
   
    # For REST Server
    config.vm.network "forwarded_port", guest: 3000, host: 3000
    
    # For Docker Deamon
    config.vm.network "forwarded_port", guest: 2375, host: 2375
    
    # For Orderer
    config.vm.network "forwarded_port", guest: 7050, host: 7050
    
    # For Peer Containers of hospital-org
    config.vm.network "forwarded_port", guest: 7051, host: 7051
    config.vm.network "forwarded_port", guest: 7052, host: 7052
    config.vm.network "forwarded_port", guest: 7053, host: 7053
    
    # For Peer Containers of lab-org
    config.vm.network "forwarded_port", guest: 8051, host: 8051
    config.vm.network "forwarded_port", guest: 8052, host: 8052
    config.vm.network "forwarded_port", guest: 8053, host: 8053

    # For CA Container
    config.vm.network "forwarded_port", guest: 7054, host: 7054
    
    config.vm.provision "docker"
    #config.vm.provision "shell", inline:  "echo 'All good'"
    config.vm.provision "shell", inline:  $script
  
    # To use a diffrent Hypervisor create a section config.vm.provider
    # And comment out the following section
    # Configuration for Virtual Box
    config.vm.provider :virtualbox do |vb|
      vb.name = "blockchain-assignment"
      # Change the memory here if needed - 2 Gb memory on Virtual Box VM
      vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "1"]
      # Change this only if you need destop for Ubuntu - you will need more memory
      vb.gui = false
      # In case you have DNS issues
      # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    # Configuration for Windows Hyperv
    config.vm.provider :hyperv do |hv|
      hv.name = "blockchain-assignment"  
      # Change the memory here if needed - 2 Gb memory on Virtual Box VM
      hv.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "1"]
      # Change this only if you need destop for Ubuntu - you will need more memory
      hv.gui = false
      # In case you have DNS issues
      # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end


  end