Sequel.migration do
  up do
    alter_table(:results) do
      add_column :creation_time, DateTime, null: false 
    end
  end

end
