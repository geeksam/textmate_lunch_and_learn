input = <<-EOF
  10.56
  5.890
  100.99
  9
EOF

def align_decimals(lines)
  pre_width = lines.map { |line| line =~ /^([^\.]*)/; $1.length } .max
  lines.each do |line|
    line =~ /^([^\.]*)(\.?)(.*)/
    puts "%#{pre_width}s%s%s" % [$1, $2 || '', $3 || '']
  end
end

align_decimals(input.split(/\n/))
