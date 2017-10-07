require 'rails/generators/named_base'

module SpreeScaffold
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration

      source_root File.expand_path('../../templates', __FILE__)

      argument :attributes, type: :array, default: [], banner: 'field:type field:type'
      class_option :i18n, type: :array, default: [], required: false, desc: 'Translated fields'
      class_option :yaml, type: :array, default: [:true], required: false, desc: 'Yaml views or erb if false'

      # convert views to yaml by default or keep it as erb if requested
      # after_filter :erb2yaml, only: [:create_views, :create_locale], if: -> { yaml? }

      def self.next_migration_number(path)
        if @prev_migration_nr
          @prev_migration_nr = @prev_migration_nr += 1
        else
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        end
      end

      def create_model
        template 'model.rb', "app/models/spree/#{singular_name}.rb"
      end

      def create_controller
        template 'controller.rb', "app/controllers/spree/admin/#{plural_name}_controller.rb"
      end

      def create_migrations
        migration_template 'migrations/model.rb', "db/migrate/create_spree_#{plural_name}.rb"

        if has_attachments?
          migration_template 'migrations/attachments.rb', "db/migrate/create_spree_#{plural_name}_attachments.rb"
        end

        if i18n?
          migration_template 'migrations/translations.rb', "db/migrate/create_spree_#{plural_name}_translations.rb"
        end
      end

      def create_deface_override
        template 'overrides/add_to_admin_menu.html.erb.deface', "app/overrides/spree/layouts/admin/add_spree_#{plural_name}.html.erb.deface"
      end

      def create_routes
        append_file 'config/routes.rb', routes_text
      end

      def create_locale
        %w[en it].each do |locale|
          template "locales/#{locale}.yml", "config/locales/#{plural_name}.#{locale}.yml"
        end
      end

      def create_views
        %w[index new edit _form].each do |view|
          if yaml? && self.behavior == :revoke
            template "views/#{view}.html.erb", "app/views/spree/admin/#{plural_name}/#{view}.html.haml"
          else
            template "views/#{view}.html.erb", "app/views/spree/admin/#{plural_name}/#{view}.html.erb"
          end
        end
        erb2yaml if yaml? && !i18n? && self.behavior != :revoke
      end

      def create_translation_template
        return unless i18n?
        if yaml? && self.behavior == :revoke
          template 'views/translation_form.html.erb', "app/views/spree/admin/translations/#{singular_name}.html.haml"
        else
          template 'views/translation_form.html.erb', "app/views/spree/admin/translations/#{singular_name}.html.erb"
          erb2yaml if yaml?
        end
      end

      protected

      def sortable?
        self.attributes.find { |a| a.name == 'position' && a.type == :integer }
      end

      def has_attachments?
        self.attributes.find { |a| a.type == :image || a.type == :file }
      end

      def slugged?
        self.attributes.find { |a| a.name == 'slug' && a.type == :string }
      end

      def i18n?
        options[:i18n].any?
      end

      def yaml?
        options[:yaml].first.to_s == 'true'
      end

      private

      def erb2yaml
        # try to convert all project erb to haml sintax
        system('rake haml:erb2haml')
      end

      def routes_text
        if sortable?
<<-EOS

Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :#{plural_name} do
      collection do
        post :update_positions
      end
    end
  end
end
EOS
        else
<<-EOS

Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :#{plural_name}
  end
end
EOS
        end
      end
    end
  end
end
