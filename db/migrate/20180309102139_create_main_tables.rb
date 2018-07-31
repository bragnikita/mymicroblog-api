class CreateMainTables < ActiveRecord::Migration[5.1]

  def clear
    drop_table :post_contents if table_exists? :post_contents
    drop_table :images_of_posts if table_exists? :images_of_posts
    drop_table :post_links if table_exists? :post_links
    drop_table :posts if table_exists? :posts
    drop_table :images if table_exists? :images
    drop_table :users if table_exists? :users
  end

  def up
    clear

    create_table :users do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.string :email
      t.boolean :admin, default: false
    end

    create_table :images do |t|
      t.string :link
      t.string :name
      t.string :title
      t.string :type
      t.timestamps
    end

    create_table :posts do |t|
      t.string :title
      t.text :excerpt
      t.string :slug
      t.integer :status, default: 0
      t.datetime :published_at
      t.integer :source_type
      t.integer :visability_mode, default: 0
      t.timestamps
    end

    add_reference :posts, :original_post,
                  references: :posts, null: true,
                  foreign_key: { to_table: :posts, on_delete: :cascade},
                  index: true

    create_table :post_links do |t|
      t.string :slug
      t.references :post, foreign_key: { to_table: :posts, on_delete: :restrict}
    end

    create_table :images_of_posts do |t|
      t.references :image, foreign_key: { to_table: :images, on_delete: :cascade}
      t.references :post, foreign_key: { to_table: :posts, on_delete: :cascade}
      t.string :link_name
      t.integer :index
    end

    add_reference :posts, :cover,
                  references: :images, null: true,
                  foreign_key: {to_table: :images, on_delete: :nullify}

    create_table :post_contents do |t|
      t.text :content
      t.references :post, foreign_key: {to_table: :posts, on_delete: :cascade}
      t.string :type
      t.timestamps
    end
  end

  def down
    clear
  end
end
