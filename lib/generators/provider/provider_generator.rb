# frozen_string_literal: true

class ProviderGenerator < Rails::Generators::NamedBase

  source_root File.expand_path("templates", __dir__)

  argument :attributes, type: :array, default: [], banner: "capabilities"

  class_option :type, type: :string, desc: "Assign a type to this provider"
  class_option :types, type: :array, desc: "Assign multiple types to this provider"

  def add_provider_initializer
    if types.any?
      insert_into_file "config/initializers/providers.rb", %Q(\nProviderKit.register :#{ provider_name }, class_name: "#{ class_name }::Provider", types: [ #{ types.map(&:inspect).join(", ") } ]\n)
    else
      insert_into_file "config/initializers/providers.rb", %Q(\nProviderKit.register :#{ provider_name }, class_name: "#{ class_name }::Provider"\n)
    end
  end

  def create_provider_files
    template "context.rb", File.join("app/providers/#{ singular_name }.rb")
    template "provider.rb", File.join("app/providers/#{ singular_name }/provider.rb")

    capabilities.each do |capability|
      @capability = capability
      template "capability.rb", File.join("app/providers/#{ singular_name }/capabilities/#{ capability.underscore }.rb")
    end
  end

  def create_spec_file
    template "spec.rb", File.join("spec/providers/#{ singular_name }_spec.rb")
  end

  private

    attr_reader :capability

    def capabilities
      @capabilities ||= attributes_names.map do |c|
        c.to_s.classify.pluralize
      end.sort
    end

    def provider_name
      singular_name.to_s.gsub("_", "")
    end

    def types
      @types ||= begin
        types = options[:type].presence || options[:types].presence || []
        types = Array(types).flatten.compact.map(&:to_sym)
      end
    end

end
