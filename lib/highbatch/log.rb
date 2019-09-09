class Log
  require 'logger'
  include Singleton
  attr_reader :verbose, :logger

  def defaults(verbose = false)
    @logger = Logger.new(STDOUT)
    @verbose = verbose
  end

  def error(message)
    logger.error c :red, message if verbose
  end

  def warn(message)
    logger.warn c :magenta, message if verbose
  end

  def info(message)
    puts c(:green, message) if verbose
  end

  private

  COLOR_ESCAPES = {
    none: 0,
    bright: 1,
    black: 30,
    red: 31,
    green: 32,
    yellow: 33,
    blue: 34,
    magenta: 35,
    cyan: 36,
    white: 37,
    default: 39
  }.freeze
  def c(clr, text = nil)
    "\x1B[" + (COLOR_ESCAPES[clr] || 0).to_s + 'm' + (text ? text + "\x1B[0m" : '')
  end

  def bc(clr, text = nil)
    "\x1B[" + ((COLOR_ESCAPES[clr] || 0) + 10).to_s + 'm' + (text ? text + "\x1B[0m" : '')
  end
end
