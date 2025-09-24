class CreateItems < ActiveRecord::Migration[8.0]

  def change
    create_table :items do |t|
      t.string :provider
      t.string :external_key

      t.timestamps
    end
  end

end
