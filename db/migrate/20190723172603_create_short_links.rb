class CreateShortLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :short_links do |t|
      t.string :hash
      t.string :original_link
    end

    add_index :short_links, :hash
  end
end
