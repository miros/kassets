require 'rubygems'
require 'yaml'
require 'ap'

class Konsole

  def initialize(title)
    @session_id = `qdbus org.kde.konsole /Konsole newSession`.strip!
    self.title = title
  end

  def title=(title)
    system %{qdbus org.kde.konsole /Sessions/#{@session_id} setTitle 1 "#{title}"}
  end

  def commands(cmds)
    cmds.each {|cmd| command(cmd)}
  end

  def command(cmd)
    send_text(cmd, "\n")
  end

  def send_text(*parts)
    parts.each {|text| system %{qdbus org.kde.konsole /Sessions/#{@session_id} sendText '#{text}'} }
  end

  def self.prev_tab
    system "qdbus org.kde.konsole /Konsole prevSession"
  end

end

class Kassets

  CONFIG_FILE = '.kassets'

  def run
    tabs.each {|hash| Konsole.new(hash.keys.first).commands(hash.values.first) }
    open_first_tab
  end

  def tabs
    config['tabs']
  end

  def open_first_tab
    (tabs.count - 1).times { Konsole.prev_tab }
  end

  private

    def config
      @config ||= YAML.load_file(locate_config)
    end

    def locate_config
      File.join(File.dirname(__FILE__), CONFIG_FILE)
    end

end

Kassets.new.run







