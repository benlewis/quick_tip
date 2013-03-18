FactoryGirl.define do
  factory :stripe_card_tip, :class => StripeCard do
    name 'Ben Lewis'
    credit_card_number '4242424242424242'
    exp_month '05'
    exp_year '2015'
    charge_amount '100'
  end
end