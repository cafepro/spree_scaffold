module Spree
  module Admin
    class <%= class_name.pluralize %>Controller < ResourceController
      def index
        @<%= plural_name %> = Spree::<%= class_name %>.all
        # filters
        @<%= plural_name %> = @<%= plural_name %>.where("lower(name) like '%#{params[:quick_search].downcase}%'") unless params[:quick_search].blank?
        params[:q].each_pair do |field, value|
          @<%= plural_name %> = @<%= plural_name %>.where("lower(#{field}) like '%#{value}%'") unless value.blank?
        end unless params[:q].blank?
        @<%= plural_name %> = @<%= plural_name %>.page(params[:page] || 1).per(50)
      end
    end
  end
end
