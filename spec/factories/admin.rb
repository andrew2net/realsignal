FactoryGirl.define do
  factory :admin, class: Admin::Admin do
    email 'test@mail.net'
    password '123456'
    password_confirmation '123456'
  end
end
