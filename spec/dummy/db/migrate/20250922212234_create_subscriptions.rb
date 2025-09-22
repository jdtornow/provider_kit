class CreateSubscriptions < ActiveRecord::Migration[8.0]

  def change
    create_table :subscriptions do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :provider
      t.string :external_key

      t.timestamps
    end
  end

end
