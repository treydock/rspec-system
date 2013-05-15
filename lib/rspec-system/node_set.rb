module RSpecSystem
  # Factory class for NodeSet.
  class NodeSet
    # Returns a NodeSet object.
    #
    # @return [RSpecSystem::NodeSet::Base] returns an object based on the Base
    #   abstract class.
    def self.create(setname, config, virtual_env, custom_prefabs_path)
      case(virtual_env)
      when 'vagrant'
        RSpecSystem::NodeSet::Vagrant.new(setname, config, custom_prefabs_path)
      when 'vsphere'
        RSpecSystem::NodeSet::Vsphere.new(setname, config, custom_prefabs_path)
      else
        raise "Unsupported virtual environment #{virtual_env}"
      end
    end
  end
end

require 'rspec-system/node_set/base'
require 'rspec-system/node_set/vagrant'
require 'rspec-system/node_set/vsphere'
