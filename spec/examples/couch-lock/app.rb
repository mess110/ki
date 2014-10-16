require 'ki'

def run cmd
  res = `DISPLAY=:0.0 #{cmd}`
  puts res
  res
end

module Ki
  module Helpers
    def wiki_defaults
      base = Wiki.count base: "1"
      if base == 0
        Wiki.create({ title: "wiki", body: "", base: "1" })
      end
    end

    def display_status
      res = run "xrandr | head -n 1 | awk '{ print $8 }'"
      res.strip.to_i == 1920 ? 'cloned' : 'extended'
    end

    def vlc_running?
      res = run "ps -ef | grep vlc | grep -v grep | head -n 1"
      res.strip != ""
    end

    def couch_lock_running?
      res = run "ps -ef | grep lockserver.UDPServer | grep -v grep | head -n 1"
      res.strip != ""
    end

    def sound_output
      res = run "pactl info | grep 'Default Sink' | grep hdmi"
      res.strip == "" ? 'analog' : 'hdmi'
    end
  end
end

class Wiki < Ki::Model
  requires :title, :body
end

class Items < Ki::Model
  requires :name, :qty
end

class Radio < Ki::Model
  forbid :create, :update, :delete

  def after_find
    return if params["q"].nil?
    return unless ['rockfm'].include? params["q"]

    run "vlc http://80.86.106.35:800/"
  end
end

class Volume < Ki::Model
  forbid :create, :update, :delete

  def after_find
    return if params["q"].nil?
    return unless ['up', 'down', 'manager'].include? params["q"]

    case params["q"]
    when 'up'
      run "amixer -D pulse sset Master 5%+"
    when 'down'
      run "amixer -D pulse sset Master 5%-"
    when 'manager'
      run "gnome-control-center sound &"
    end
  end
end

class Monitors < Ki::Model
  forbid :create, :update, :delete

  def after_find
    return if params["q"].nil?
    return unless ['c', 'e'].include? params["q"]

    run "disper -#{params["q"]}"
  end
end

class Ring < Ki::Model
  forbid :create, :update, :delete

  def after_find
    run "aplay public/doorbell-1.wav &"
  end
end

class Fireplace < Ki::Model
  forbid :create, :update, :delete

  def after_find
    return if params["q"].nil?
    return unless ['kill', 'start'].include? params["q"]

    if params["q"] == "kill"
      run "killall -9 vlc"
    else
      run "vlc https://www.youtube.com/watch?v=rH79BmeeM0o --fullscreen &"
    end
  end
end

class Sound < Ki::Model
  forbid :create, :update, :delete

  def after_find
    return if params["q"].nil?
    return unless ['speakers', 'hdmi'].include? params["q"]

    if params["q"] == "speakers"
      run "pactl set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo"
    else
      run "pactl set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1"
    end
  end
end

class Jrobot < Ki::Model
  forbid :create, :update, :delete

  def after_find
    return if params["q"].nil?
    return unless ['listen', 'kill'].include? params["q"]

    if params["q"] == "listen"
      run `cd ../../../../CouchLockServer/; ./start.sh`
    else
      run `kill \`ps ax | grep lockserver.UDPServer | grep -v grep | awk '{ print $1 }'\``
    end
  end
end
