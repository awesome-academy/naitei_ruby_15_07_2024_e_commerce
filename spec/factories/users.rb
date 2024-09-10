FactoryBot.define do
  factory :user do
    user_name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone_in_e164 }
    role { 0 }
    password { "password" }
    encrypted_password {Devise::Encryptor.digest(User, password)}
    confirmed_at { Time.zone.now }
    confirmation_sent_at { Time.zone.now }
    confirmation_token { SecureRandom.urlsafe_base64 }
  end
end
