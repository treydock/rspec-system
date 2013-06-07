require 'thor'

class Thor::Option
  # More clearly show in the usage output
  # how to negate the boolean options with 'no-' prefix.
  def switch_name
    return "--[no]-#{name}" if type.to_s == 'boolean'
    super
  end
end

module RSpecSystem
  class Cli < Thor
    include Thor::Actions

    def self.source_root
      File.join(File.dirname(__FILE__), 'cli')
    end

    class_option :verbose, :type => :boolean, :default => true, :desc => 'Print verbose output'

    desc 'init', 'Initialize project for use with rspec-system'
    method_option :gitignore, :type => :boolean, :alias => :string, :default => true, :desc => 'Updates project .gitignore'
    method_option :nodeset, :type => :boolean, :alias => :string, :default => true, :desc => 'Create default .nodeset.yml'
    def init
      create_spec_directories
      create_spec_helper_system
      create_system_tmp_directories

      modify_gitignore if options.gitignore?
      create_default_nodeset if options.nodeset?
    end

    source_paths << File.expand_path(File.join(source_root, '..', '..', '..'))

    protected

    def create_spec_directories
      empty_directory('spec')
      empty_directory('spec/system')
    end

    def create_spec_helper_system
      template('templates/spec_helper_system.rb.erb', 'spec/spec_helper_system.rb')
    end

    def create_system_tmp_directories
      empty_directory('.rspec_system')
      empty_directory('.rspec_system/vagrant_projects')
    end

    def modify_gitignore
      lines = [ '.rspec_system' ]
      create_file('.gitignore') unless File.exists?('.gitignore')
      lines.each do |line|
        if IO.readlines('.gitignore').grep(%r{^#{line}}).empty?
          append_to_file('.gitignore', "#{line}\n")
        end
      end
    end

    def create_default_nodeset
      template('.nodeset.yml', '.nodeset.yml')
    end
  end
end