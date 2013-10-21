#!/usr/bin/env ruby

# file: just-tmux.rb

require 'dynarex'

class JustTmux

  attr_reader :to_s


  # example raw dynarex file:
  #
  # config=<<EOF
  # <?dynarex schema="tmux[session, shell, default_dir]/window(command, name, dir)"?>
  # session: fun
  # shell: bash
  # default_dir: ~
  # 
  # lis
  # pwd  home  /home/james/ruby
  #EOF
  #
  def initialize(dynarex_file)

    dynarex = Dynarex.new dynarex_file

    shell = dynarex.summary[:shell]
    default_dir = File.expand_path dynarex.summary[:default_dir]
    session_name = dynarex.summary[:session]

    h = dynarex.to_h.map do |x| 
      x[:name] = shell if x[:name].empty?
      x[:dir] = default_dir if x[:dir].empty?
      x
    end

    @to_s = new_session(session_name, h[0][:name], shell, h[0][:dir], 
      h[0][:command]) +  h[1..-1].map {|x| new_window(x[:name], 
      shell, x[:command]) }.join

  end

  private

  def new_window(window_name, shell, command)
    "tmux new-window -n %s %s\ntmux send-keys '%s' Enter\n" % 
        [window_name, shell, command]
  end

  def new_session(session_name, window_name, shell, dir, command)
    r = "tmux new-session -d -s %s -n %s '%s'\n" % 
      [session_name, shell, window_name]
    r + "tmux send-keys 'cd %s && %s' Enter\n" % [dir, command]
  end

end
