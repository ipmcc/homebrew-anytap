# brew-any-untap.rb
# Copy-pasta makes me sad. So let's require 'cmd/tap'.
require 'cmd/untap'
include Homebrew

usage = <<EOF
SYNOPSIS
    brew alt-untap <tap>

USAGE
    TODO: FIXME
EOF

def raw_untap(args)
  args.each do |arg|
    tap = arg.downcase
    tapd = HOMEBREW_LIBRARY/"Taps/#{tap}"

    unless tapd.directory?
      opoo "No such tap as #{tap}."
      next
    end

    files = []
    tapd.find_formula{ |file| files << Pathname.new("#{tap}").join(file) }
    unlink_tap_formula(files)
    rm_rf tapd
    puts "Untapped #{files.count} formula"
  end
end

if ARGV.size < 1
  tapd = HOMEBREW_LIBRARY/"Taps"
  tapd.children.each do |tap|
    puts tap.basename.to_s if (tap/'.git').directory?
  end if tapd.directory?
elsif ['-h', '-?', '--help'].include?(ARGV.first)
  puts usage
else
  raw_untap(ARGV)
end

