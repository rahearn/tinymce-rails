module TinyMCE
  def self.base
    Railtie.config.tinymce.base ||
      [Rails.application.config.action_controller.asset_host,
       ActionController::Base.config.relative_url_root,
       Rails.application.config.assets.prefix, "/tinymce"].compact.join
  end
  
  class Railtie < Rails::Railtie
    config.tinymce = ActiveSupport::OrderedOptions.new
    
    def asset_root
      File.join(File.dirname(__FILE__), "../../assets")
    end
    
    rake_tasks do
      # Replacement for assets:precompile task in Rails 3.1.0
      load "tinymce/rails-3.1.0.rake" if Rails.version <= "3.1.0"
      
      # Copy TinyMCE assets when assets:precompile task is called
      load "tinymce/assets.rake"
    end
    
    initializer "configure assets", :group => :all do |app|
      app.config.assets.paths.unshift File.join(asset_root, 'integration')
      app.config.assets.paths.unshift File.join(asset_root, 'vendor')
      app.config.assets.precompile << "tinymce/*"
    end
    
    initializer "static assets", :group => :all do |app|
      if app.config.serve_static_assets
        app.config.assets.paths.unshift File.join(asset_root, 'precompiled')
      end
    end
  end
end
