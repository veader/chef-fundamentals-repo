Ohai.plugin(:Apache) do
  provides "apache/modules"

  collect_data(:default) do
    apache Mash.new
    apache[:modules] = {:static => [], :shared => []}
    modules = shell_out("apachectl -t -D DUMP_MODULES")
    modules.stdout.each_line do |line|
      fullkey, dso_type = line.split.map(&:strip)
      apache_mod = fullkey.gsub(/_module/,"")
      if dso_type.match(/shared/)
        apache[:modules][:shared] << apache_mod
      elsif dso_type.match(/static/)
        apache[:modules][:static] << apache_mod
      end
      # fullkey, value = line.split(/\(/, 2).map {|i| i.strip}
      # apache_mod = fullkey.gsub(/_module/,"")
      # dso_type = value.to_s.chomp("\)")
      # if dso_type.match(/shared/)
      #   apache[:modules][:shared] << apache_mod
      # elsif dso_type.match(/static/)
      #   apache[:modules][:static] << apache_mod
      # end
    end
  end
end

# Ohai.plugin(:Apache) do
#   require "mixlib/shellout"
#   provides "apache/modules"
#
#   collect_data(:default) do
#     modules = Mixlib::ShellOut.new("apachectl -t -D DUMP_MODULES")
#     modules.run_command
#     apache Mash.new
#     apache[:modules] = modules.stdout
#   end
# end
