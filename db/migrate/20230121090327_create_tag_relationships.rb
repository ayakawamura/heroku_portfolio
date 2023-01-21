class CreateTagRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_relationships do |t|
      t.references :post, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :tag_relationships, %i[post_id tag_id], unique: true
  end
end
