class Hash
  def deep_stringify_keys
    inject({}) do |options, (key, value)|
      options[key.to_s] = (value.is_a?(Hash) ? value.deep_stringify_keys : value)
      options
    end
  end
end

namespace :translator do

  def write_translations(filename, hash={})
    File.open(filename, "w") do |f|
      f.write(yaml(hash))
    end
  end

  def valid_yaml_string?(yaml)
    !!YAML.load_file(yaml)
  rescue Exception => e
    puts "Yaml load failed: #{e.message}"
  end

  def yaml(hash)
    method = hash.respond_to?(:ya2yaml) ? :ya2yaml : :to_yaml
    hash.deep_stringify_keys.send(method)
  end

  desc "Create locale YML files"
  task :export => :environment do
    puts "Starting Export of YML files."
    puts "Available locales: #{Translator.available_locales.inspect} for #{Rails.env}"

    Rails.application.eager_load!

    Translator.available_locales.each do |l|

      # Export only the redis texts added from the management system.
      #locale_hash = Translator.simple_backend.send(:translations)[l.to_sym]
      locale_hash = {}

      Translator.current_store.keys.each do |k|
        store_array = k.split(".")
        if store_array.first.to_sym == l.to_sym
          value = ActiveSupport::JSON.decode Translator.current_store[k]
          locale_hash.deep_merge!(store_array.drop(1).reverse.inject(value.to_s) { |a, n| { n.to_sym => a } })
        end
      end

      file_hash = {}
      file_hash["#{l}"] = locale_hash

      puts "Writing: #{l}.yml"
      write_translations("#{Rails.root}/shared/translations/#{l}.yml", file_hash)

      puts "Checking #{l}.yml"
      valid_yaml_string?("#{Rails.root}/shared/translations/#{l}.yml")

    end
  end
end