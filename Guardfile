guard :rspec, :cmd => "bundle exec rspec --color -f d" do
  watch(%r{^spec/ruby/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/ruby/#{m[1]}_spec.rb" }
  watch("spec/ruby/spec_helper.rb") { "spec" }
end
