require 'ki'

class Monitors < Ki::Model
  forbid :create, :update, :delete

  def after_find
    return if params["q"].nil?
    return unless ['c', 'e'].include? params["q"]

    `disper -#{params["q"]}`
  end
end

class Fireplace < Ki::Model
  forbid :create, :update, :delete

  def after_find
    return if params["q"].nil?
    return unless ['kill', 'start'].include? params["q"]

    if params["q"] == "kill"
      `killall -9 vlc`
    else
      `vlc https://www.youtube.com/watch?v=rH79BmeeM0o --fullscreen`
    end
  end
end

class Sound < Ki::Model
  forbid :create, :update, :delete

  def after_find
    return if params["q"].nil?
    return unless ['speakers', 'hdmi'].include? params["q"]

    if params["q"] == "speakers"
      `pacmd set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo`
    else
      `pacmd set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1`
    end
  end
end
