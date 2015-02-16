Sequel.migration do

  up do
    
    create_table(:users) do
      primary_key  :user_id
      String       :auth_subject_id,     :size=>50,  :null=>true
      boolean      :is_admin
      boolean      :is_contestant
      DateTime     :last_login,                      :null=>true 
      String       :social_email,        :size=>250, :null=>true
      String       :social_name,         :size=>250, :null=>true
      String       :social_picture,      :size=>250, :null=>true
      String       :signup_token,        :size=>25,  :null=>true

      # primary_key  :user_id
      index        :auth_subject_id
    end

    create_table(:contests) do
      primary_key  :contest_id
      String       :name,                :size=>50,  :null=>false
    end

    create_table(:results) do
      foreign_key  :user_id, :users, null: false, key: [:user_id], deferrable: true
      foreign_key  :contest_id, :contests, null: false, key: [:contest_id], deferrable: true
      decimal      :score
      integer      :rank

      primary_key  [:user_id, :contest_id]
    end

  end
end
