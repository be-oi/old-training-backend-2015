Sequel.migration do
  up do
    alter_table(:users) do
      add_column :name, "varchar(25)", null: false, default: ''

      add_index :signup_token, :unique => true
    end
  end

end