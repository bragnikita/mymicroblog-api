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

FactoryBot.define do
   factory :user do
     sequence :username do |n|
       "bragnikita_#{n}"
     end
     password "JIjo321fds"
     email {
       "#{username}@mail.com"
     }
     admin true

     factory :admin do
       username 'admin'
       email 'admin@mail.com'
       admin true
     end
   end

  # factory :user do
  #   sequence :username do |n| # генератор уникальных значений
  #     "bragnikita_#{n}"
  #   end
  #   password "JIjo321fds"
  #   is_admin false
  #   is_active true
  #
  #   factory :user_with_mail do
  #     email "aaa@example.com"
  #   end
  #
  #   factory :admin do
  #     email "aaa@example.com"
  #     is_admin true
  #   end
  #
  #   trait :with_characters do
  #     after(:create) do |user, evaluator|
  #       create_list(:character, 3, creator: user)
  #     end
  #   end
  #
  # end

end
