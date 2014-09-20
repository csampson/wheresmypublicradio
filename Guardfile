guard :rspec, :cmd => "rspec --color -f d" do
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/ruby/#{m[1]}_spec.rb" }
  watch(%r{^spec/ruby/(.+)\.rb$})
end
