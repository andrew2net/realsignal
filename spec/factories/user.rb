FactoryGirl.define do
  factory :user do
    first_name 'Test'
    last_name 'User'
    email 'test_user@mail.net'
    password '123456'
    password_confirmation '123456'
    confirmed_at DateTime.now
  end
end
