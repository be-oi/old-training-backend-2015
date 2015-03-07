Sequel.migration do

  up do
    
    create_table(:uva_problem_sets) do
      primary_key  :uva_problem_set_id
      DateTime     :deadline,                        :null=>true 
      integer      :minimum
    end

    create_table(:uva_problems) do
      primary_key  :uva_problem_id
      foreign_key  :uva_problem_set_id, :uva_problem_sets, null: false, key: [:uva_problem_set_id], deferrable: true
      integer      :uva_pid
    end

  end
end
