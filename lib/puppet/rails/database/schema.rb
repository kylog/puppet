class Puppet::Rails::Schema
    def self.init
        oldout = nil
        Puppet::Util.benchmark(Puppet, :notice, "Initialized database") do
            # We want to rewrite stdout, so we don't get migration messages.
            oldout = $stdout
            $stdout = File.open("/dev/null", "w")
            ActiveRecord::Schema.define do
                create_table :resources do |t|
                    t.column :title, :string, :null => false
                    t.column :restype,  :string, :null => false
                    t.column :host_id, :integer
                    t.column :source_file_id, :integer
                    t.column :exported, :boolean
                    t.column :line, :integer
                    t.column :updated_at, :datetime
                end

                create_table :source_files do |t| 
                    t.column :filename, :string
                    t.column :path, :string
                    t.column :updated_at, :datetime
                end

                create_table :puppet_classes do |t| 
                    t.column :name, :string
                    t.column :host_id, :integer
                    t.column :source_file_id, :integer
                    t.column :updated_at, :datetime
                end

                create_table :hosts do |t|
                    t.column :name, :string, :null => false
                    t.column :ip, :string
                    t.column :last_compile, :datetime
                    t.column :last_freshcheck, :datetime
                    t.column :last_report, :datetime
                    #Use updated_at to automatically add timestamp on save.
                    t.column :updated_at, :datetime
                    t.column :source_file_id, :integer
                end

                create_table :facts do |t| 
                    t.column :name, :string, :null => false
                    t.column :value, :text, :null => false
                    t.column :host_id, :integer, :null => false
                    t.column :updated_at, :datetime
                end

                create_table :params do |t|
                    t.column :name, :string, :null => false
                    t.column :value,  :text, :null => false
                    t.column :line, :integer
                    t.column :updated_at, :datetime
                    t.column :resource_id, :integer
                end
         
                create_table :tags do |t| 
                    t.column :name, :string
                    t.column :updated_at, :datetime
                end 

                create_table :taggings do |t| 
                    t.column :tag_id, :integer
                    t.column :taggable_id, :integer
                    t.column :taggable_type, :string
                    t.column :updated_at, :datetime
                end
            end
            $stdout.close
            $stdout = oldout
            oldout = nil
        end
    ensure
        $stdout = oldout if oldout
    end
end

# $Id$
