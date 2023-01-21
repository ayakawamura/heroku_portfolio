class CreatePostImages < ActiveRecord::Migration[7.0]
  def change
    create_table :post_images do |t|
      t.references :post, null: false, foreign_key: true
      t.string :image_id, null: false

      t.timestamps
    end
  end
end
