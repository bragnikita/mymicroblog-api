# == Schema Information
#
# Table name: users
#
#  id       :bigint(8)        not null, primary key
#  username :string(255)      not null
#  password :string(255)      not null
#  email    :string(255)
#  admin    :boolean          default(FALSE)
#

class User < ApplicationRecord
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true
  validates :email, presence: true, if: :is_admin?

  # has_many :characters, class_name: "Character", :dependent => :nullify, :foreign_key => "creator_id", :inverse_of => 'creator'
  # has_many :character_lists, class_name: "CharacterList", dependent: :destroy, :inverse_of => 'owner'
  # has_many :scripts, class_name: "Script", dependent: :restrict_with_error, :inverse_of => 'owner'
end
