class CreateDogs < ActiveRecord::Migration
  def change
    create_table :dogs do |t|
      t.string :name
      t.date :birthday
      t.integer :status

      t.timestamps
    end
  end
end
