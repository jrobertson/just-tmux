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

    shell = dynarex.summary[:shell] || 'bash'
    default_dir = File.expand_path dynarex.summary[:default_dir] || '~'
    session_name = dynarex.summary[:session] || '0'

    h = dynarex.to_h.map do |x| 
      x[:name] = shell if x[:name].empty?
      x[:dir] = default_dir if x[:dir].empty?
      x
    end
    
    @to_s = new_session(session_name, h[0][:name], shell, 
      "cd #{h[0][:dir]} && " + h[0][:command]) +  h[1..-1].map \
      {|x| new_window(x[:name],  shell, "cd #{x[:dir]} && " + \
          x[:command]) }.join

  end

  private

  def new_session(session_name, window_name, shell, command)
    "tmux new-session -d -s %s -n %s '%s'\n%s" % 
      [session_name, window_name, shell, send_keys(command)]
  end
  
  def new_window(window_name, shell, command)
    "tmux new-window -n %s %s\n%s" % [window_name, shell, send_keys(command)]
  end  

  def send_keys(command)  "tmux send-keys '%s' Enter\n" % command  end

end