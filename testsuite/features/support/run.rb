require 'net/ssh'
require 'stringio'

def run(command, host: ENV['SERVER'], user: 'root', ignore_err: false)
  # Execute a command on the remote server
  # Not passing :password uses systems keys for auth
  out = StringIO.new
  err = StringIO.new
  Net::SSH.start(host, user, verify_host_key: Net::SSH::Verifiers::Null.new) do |ssh|
    ssh.exec!(command) do |_chan, str, data|
      out << data if str == :stdout
      err << data if str == :stderr
    end
  end

  if !ignore_err
    raise "Execute command failed #{command}: #{err.string}"
  end

  { stdout: out.string, stderr: err.string }
end
