class SSHKit::Formatter::Cubecomp < SSHKit::Formatter::Pretty
  private

  def write_command(command)
    log_command_start(command) unless command.started?
    log_command_stdout(command) unless command.stdout.empty?
    log_command_stderr(command) unless command.stderr.empty?
    log_command_finished(command) if command.finished?
  end

  def log_command_start(command)
    print(command, c.green('run'), c.yellow(c.bold(String(command))))
  end

  def log_command_stdout(command)
    command.stdout.lines.each do |line|
      print(command, c.green('out'), line)
    end
    command.stdout = ''
  end

  def log_command_stderr(command)
    command.stderr.lines.each do |line|
      print(command, c.yellow('err'), line)
    end
    command.stderr = ''
  end

  def log_command_finished(command)
    state = command.failure? ? c.red('failed') : c.green('done')
    print(command, state, "#{c.yellow(c.bold(String(command)))} in #{sprintf('%5.3f seconds', command.runtime)}")
  end

  def print(command, state, message)
    line = "[#{c.blue(command.host.to_s)}][#{state}] #{message}"
    line << ?\n unless line.end_with?(?\n)
    original_output << line
  end
end
