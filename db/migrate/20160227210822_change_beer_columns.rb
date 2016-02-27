class ChangeBeerColumns < ActiveRecord::Migration
  def change
    add_column :beers, :style_id, :integer
    rename_column :beers, :style, :old_style
  end
end
