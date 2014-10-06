task 'community_modules' do
  if defined? Pkg::Util::Execution
    Pkg::Util::Execution.ex("gem install r10k")
    Pkg::Util::Execution.ex("r10k puppetfile install")
  else
    warn "It looks like the packaging tasks have not been loaded. You'll need to `rake package:bootstrap` before using this task"
  end
end
