class CreateCustomers < ActiveRecord::Migration[8.0]

  def change
    create_table :customers do |t|
      t.string :email
      t.string :stripe_external_key
      t.string :paypal_external_key

      t.timestamps
    end
  end

end
