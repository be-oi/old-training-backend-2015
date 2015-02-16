Sequel.migration do
  up do
    alter_table(:users) do
      add_column :uva_user_id, Integer, null: true
    end
  end

end