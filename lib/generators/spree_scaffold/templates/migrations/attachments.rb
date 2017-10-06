class CreateSpree<%= class_name.pluralize %>Attachments < ActiveRecord::Migration[5.1]
  def change
    <% attributes.each do |attribute| -%>
      <% if attribute.type == :image || attribute.type == :file -%>
        add_attachment :spree_<%= table_name %>, :<%= attribute.name %>
      <% end -%>
    <% end -%>
  end
end
