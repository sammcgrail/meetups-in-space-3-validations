class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|

      t.string :title
      t.string :body, null: false
      t.belongs_to :user
      t.belongs_to :meetup


      t.timestamps
    end

  end
end
