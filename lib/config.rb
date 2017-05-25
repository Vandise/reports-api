require 'active_support/all'
require 'i18n/core_ext/hash'
require 'tarot'

GC::Profiler.enable

configs = ["app"].map do |file|
  File.expand_path "../../config/yml/#{file}.yml", __FILE__
end
Settings = ::Tarot::Config.new(configs, Rails.env)

local_settings = File.expand_path "../../config/yml/local.yml", __FILE__
if File.exists? local_settings
  locals = YAML::load(open(local_settings).read).stringify_keys!
  Settings.merge(locals.fetch(Rails.env.to_s, {}))
end

def config_option *args
  Settings.get *args
end