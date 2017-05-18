desc "Open an irb session with capybara and helpers preloaded"
task :repl do
  sh "irb -I spec:spec/helpers:. -r rubygems -r capybara -r capybara/dsl -r ./local_env -r rspec -r spec_helper -r lib/repl"
end

task :test do
  sh "rspec"
end
