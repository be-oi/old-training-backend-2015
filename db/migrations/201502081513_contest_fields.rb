Sequel.migration do
  up do
    alter_table(:contests) do
      add_column :start_time, DateTime, null: false 
      add_column :end_time, DateTime, null: false 
      add_column :url, "varchar(255)", null: false, default: '' 
      add_column :max_score, Integer, null: true
      add_column :nb_contestants, Integer, null: true
    end
  end

end
