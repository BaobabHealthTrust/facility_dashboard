class CreateAttendanceFigures < ActiveRecord::Migration
  def self.up
    create_table :attendance_figures, :primary_key => :attendance_figure_id do |t|
      t.integer :attendance_figure_id
      t.integer :attendance_figure
      t.datetime :attendance_figure_day
      t.string :location_created
      t.timestamps
    end
  end

  def self.down
    drop_table :attendance_figures
  end
end