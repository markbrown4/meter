class CreateTrips < ActiveRecord::Migration

  def change
    create_table :trips do |t|
      t.string  :activity
      t.integer :milliseconds
      t.float   :kilometers
      t.integer :start_location_id
      t.integer :end_location_id
      t.text    :data
      
      t.timestamps
    end

    create_table :locations do |t|
      t.float :lat
      t.float :lng
      t.string :street_name
      t.string :city
      t.string :zip
    end
  end

end
