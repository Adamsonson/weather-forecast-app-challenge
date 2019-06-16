class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :timezone
      t.string :photo
      t.jsonb :payload

      t.timestamps
    end
  end
end
