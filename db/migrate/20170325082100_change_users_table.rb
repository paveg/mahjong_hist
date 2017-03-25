class ChangeUsersTable < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :email, :string, limit: 255
    change_column :users, :encrypted_password, :string, limit: 255
    change_column :users, :current_sign_in_ip, :string, limit: 255
    change_column :users, :last_sign_in_ip, :string, limit: 255

    add_column :users, :display_name, :string, limit: 255
    add_column :users, :first_name, :string, limit: 255
    add_column :users, :last_name, :string, limit: 255
  end
end
