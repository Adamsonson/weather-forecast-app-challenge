class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :timezone
      t.string :photo
      t.jsonb :payload
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
