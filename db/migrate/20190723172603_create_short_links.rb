class CreateShortLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :short_links do |t|
      t.string :short_url
      t.string :original_url
      t.integer :total_visits, default: 0

      t.timestamps
    end

    add_index :short_links, :short_url, unique: true
  end
end
