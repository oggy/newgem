require '<%= gem_name %>/version'
require 'newgem/support/tasks'

AUTHOR             = '<%= author %>'  # can also be an array of Authors
EMAIL              = '<%= email %>'
DESCRIPTION        = 'description of gem'
GEM_NAME           = '<%= gem_name %>' # what ppl will type to install your gem
RUBYFORGE_PROJECT  = '<%= project_name %>' # The unix name for your project
HOMEPATH           = 'http://#{RUBYFORGE_PROJECT}.rubyforge.org'
DOWNLOAD_PATH      = 'http://rubyforge.org/projects/#{RUBYFORGE_PROJECT}'
EXTRA_DEPENDENCIES = [
#  ['activesupport', '>= 1.3.1']
]    # An array of rubygem dependencies [name, version]
EXTRA_DEV_DEPENDENCIES = [
#  ['rspec', '>= 1.1.5']
]    # An array of rubygem dependencies [name, version]

@config_file = "~/.rubyforge/user-config.yml"
@config = nil
RUBYFORGE_USERNAME = "unknown"
def rubyforge_username
  unless @config
    begin
      @config = YAML.load(File.read(File.expand_path(@config_file)))
    rescue
      puts <<-EOS
ERROR: No rubyforge config file found: #{@config_file}
Run 'rubyforge setup' to prepare your env for access to Rubyforge
 - See http://newgem.rubyforge.org/rubyforge.html for more details
      EOS
      exit
    end
  end
  RUBYFORGE_USERNAME.replace @config["username"]
end

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new(GEM_NAME, VERS = <%= module_name %>::VERSION::STRING) do |p|
  p.developer(AUTHOR, EMAIL)
  p.description    = DESCRIPTION
  p.summary        = DESCRIPTION
  p.url            = HOMEPATH
  p.rubyforge_name = RUBYFORGE_PROJECT if RUBYFORGE_PROJECT
  p.test_globs     = ["test/**/test_*.rb"]
  p.clean_globs |= ['**/.*.sw?', '*.gem', '.config', '**/.DS_Store']  #An array of file patterns to delete on clean.
  p.post_install_message = 'PostInstall.txt'

  # == Optional
  p.changes        = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.extra_deps     = EXTRA_DEPENDENCIES
  p.extra_dev_deps = EXTRA_DEV_DEPENDENCIES

  <% if is_jruby -%>
  # JRuby gem created, e.g. <%= gem_name %>-X.Y.Z-jruby.gem
  p.spec_extras = { :platform => 'jruby' }    # A hash of extra values to set in the gemspec.
  <% else -%>
  p.spec_extras = {}    # A hash of extra values to set in the gemspec.
  <% end -%>
end
hoe.spec.rdoc_options = ['--main', Dir['README*'].first]

CHANGES = $hoe.paragraphs_of('History.txt', 0..1).join("\\n\\n")
PATH    = (RUBYFORGE_PROJECT == GEM_NAME) ? RUBYFORGE_PROJECT : "#{RUBYFORGE_PROJECT}/#{GEM_NAME}"
$hoe.remote_rdoc_dir = File.join(PATH.gsub(/^#{RUBYFORGE_PROJECT}\/?/,''), 'rdoc')
$hoe.rsync_args = '-av --delete --ignore-errors'
