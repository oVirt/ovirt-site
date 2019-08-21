Jekyll::Hooks.register :site, :after_init do |site|
  if Jekyll.env == "production"
    puts "\nUpdating git submodules..."
    # init and sync are already done by the builder
    puts `git submodule foreach "git pull -qf origin master"`
    puts "\n"
  end
end
