SpreeScaffold
=============

An advanced admin scaffold generator for Spree.

Creates a ready to use CRUD interface for your models inside Spree admin.
Attachments, sorting and translations are supported.

Installation
============

Add this line to your application's Gemfile:
```ruby
group :development do
  gem 'spree_scaffold', github: 'freego/spree_scaffold', branch: 'X-X-stable'
end
```

And then execute:

    $ bundle

Usage
=====

Generate a scaffold for the new `Brand` model:

    $ rails generate spree_scaffold:scaffold Brand name:string description:text position:integer ... [--i18n name description]

Full example without i18n but using haml views (by default)

    $ rails generate spree_scaffold:scaffold Brand name:string description:text position:integer

Another example with no haml views

    $ rails generate spree_scaffold:scaffold Brand name:string description:text position:integer --haml false

And adjust the [glyphicons](http://glyphicons.com/) icon name on the `app/overrides/spree/admin/add_spree_...` file.

It's better if the first attribute is the "main" text one (name, title etc.)

Some more magic:
* The admin index list will be sortable with drag&drop if you create a `position:integer` field
* `paperclip` image and file attachments are supported: e.g. `picture:image attachment:file`
* Will use `friendly_id` for slugs if a `slug:string` field is present

Example output:

    create  app/models/spree/brand.rb
    create  app/controllers/spree/admin/brands_controller.rb
    create  app/views/spree/admin/brands/index.html.erb
    create  app/views/spree/admin/brands/new.html.erb
    create  app/views/spree/admin/brands/edit.html.erb
    create  app/views/spree/admin/brands/_form.html.erb
    create  db/migrate/20140412175904_create_spree_brands.rb
    create  config/locales/en_brands.yml
    create  config/locales/it_brands.yml
    create  app/overrides/spree/admin/add_spree_brands_to_admin_menu.rb
    append  config/routes.rb

Then run the migration:

    $ rake db:migrate

To rollback:

    $ rake db:rollback
    $ rails destroy spree_scaffold:scaffold Brand name:string description:text position:integer ...

Copyright (c) 2015 sebastyuiop, alepore, released under the New BSD License
