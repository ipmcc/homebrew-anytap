# brew-any-untap.rb
# Copy-pasta makes me sad. So let's require 'cmd/tap'.
require 'cmd/untap'
include Homebrew

usage = <<EOF
SYNOPSIS
    brew any-untap [tap1 tap2 ...]

USAGE
    brew any-untap
      Called without arguments, alt-untap will show you all your currently
      tapped repos.
    brew any-untap tap-name [tap-name2 tap-name3 ...]
      If you give any-untap the name of a tapped repo, it will attempt to
      untap that repository. You should copy the name exactly as it appears
      in the output of `brew any-untap` (i.e. <username>/<tapname>)

      any-untap can also handle multiple arguments. It will simply try to
      remove each tapped repo, one after the other. If any name in the list
      is not found, you will see a warning, but any-untap will continue with
      the next name.
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
  tapd.children.each do |user|
    user.children.each do |tap|
      puts user.basename.to_s + "/" + tap.basename.to_s if (tap/'.git').directory?
    end if tapd.directory?
  end
elsif ['-h', '-?', '--help'].include?(ARGV.first)
  puts usage
else
  raw_untap(ARGV)
end

