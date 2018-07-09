class CreateMainTables < ActiveRecord::Migration[5.1]

  def clear
    drop_table :post_contents if table_exists? :post_contents
    drop_table :images_posts if table_exists? :images_posts
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
      t.datetime :datetime_of_placement
      t.integer :source_type
      t.integer :visability_mode, default: 0
      t.timestamps
    end

    create_join_table :images, :posts do |t|
      t.index :image_id
      t.index :post_id
      t.string :link_name
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
