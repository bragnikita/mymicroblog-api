# Rails Model Testing

## RSpec

Каждый пример отрабатывает в своей транзакции. `before(:all)` выполняется вне транзакции и не откатывается. Юзать `before(:each)`.

```ruby
require 'rails_helper'

RSpec.describe Auction, :type => :model do
  subject { described_class.new }

  it "is valid with valid attributes" do
    subject.title = "Anything"
    expect(subject).to be_valid
  end

  it "is not valid without a title" do
    expect(subject).to_not be_valid
  end

  it "is not valid without a description"
  it "is not valid without a start_date"
  it "is not valid without a end_date"
end
```

## Matchers
Много матчеров можно найти в составе Shoulda (https://github.com/thoughtbot/shoulda-matchers). Достаточно подключить гем `shoulda` (https://github.com/thoughtbot/shoulda)

## Factory Bot (Factory Girl)
http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md

```ruby
# This will guess the User class
#defining
FactoryBot.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    admin false
    date_of_birth   { 21.years.ago } #dynamic attribute
    email { "#{first_name}.#{last_name}@example.com".downcase } #based on other attrs
    sequence :unique_code do |n| # генератор уникальных значений
    	"A000#{n}"
    end

    transient do
        preferred_phones #аттрибуты, не входящие в модель
    end

    #association to Phone objects, overrides :vendor attribute,
    #creates automatically with User
    association :mobile_phone, factory: :phone, vendor: 'Samsung' 

    factory :privileged_user do #наследует все атрибуты user
    	bonuses: 100
    end

    trait :has_comments do #блок атрибутов, который можно реюзать
    	comments: []
  	end
  	factory :commenter do
  		has_comments
  	end
  	# или factory :commenter, traits: [:has_comments]
  	# более поздние атрибуты перезапишут ранние
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    first_name "Admin"
    last_name  "User"
    admin      true
  end
end

#using
user = build(:user)
user = create(:user) #saved copy
attrs = attributes_for(:user) #attribute hash
user = build(:user, first_name: "Joe", preferred_phones: 'Samsung') #overrides attribute

```

### has_many association
```ruby
FactoryBot.define do

  # post factory with a `belongs_to` association for the user
  factory :post do
    title "Through the Looking Glass"
    user
  end

  # user factory without associated posts
  factory :user do
    name "John Doe"

    # user_with_posts will create post data after the user has been created
    factory :user_with_posts do
      # posts_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        posts_count 5
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, user: user)
      end
    end
  end
end

# using
create(:user).posts.length # 0
create(:user_with_posts).posts.length # 5
create(:user_with_posts, posts_count: 15).posts.length # 15
```


Расположение фабрик
```ruby
test/factories.rb
spec/factories.rb
test/factories/*.rb
spec/factories/*.rb
```


