# encoding: utf-8

require 'open3'

# http://dota2.ru/guides/880-invokirkhakha-sanstrajk-ni-azhydal-da/
#
class MiniTest::Unit::TestCase
  # Quas Wex Exort.
  #
  def invoke_cache
    @invoke_cache ||= {}
  end

  # So begins a new age of knowledge.
  #
  def invoke(*argv)
    return invoke_cache[argv] if invoke_cache.has_key? argv

    args = argv.dup
    options = (args.last.is_a? Hash) ? args.pop : {}

    executable = File.expand_path('../../../bin/greeb', __FILE__)
    arguments = args.map! { |s| (s.include? ' ') ? '"%s"' % s : s }.join ' '

    Open3.popen2e(executable, *arguments) do |i, o, _|
      i.puts options[:stdin] if options[:stdin]
      i.close
      invoke_cache[argv] = o.readlines.map(&:chomp!)
    end
  end
end
