class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :rating, null: false
      t.string :comment

      t.timestamps
    end
  end
end
