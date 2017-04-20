FactoryGirl.define do
  factory :admin do
    email 'test@mail.net'
    password '123456'
    password_confirmation '123456'
  end
end
