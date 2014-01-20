namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "111111",
                 password_confirmation: "111111",
                 admin: true)
    2.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
      users = User.all(limit: 6)
    2.times do

      name = Faker::Lorem.sentence(4)
      summary = Faker::Lorem.sentence(10)
      local = Faker::Lorem.sentence(2)
      financial_value = 150
      financial_value_sum_accumulated = 170
      img_card = "http://envolverde.com.br/portal/wp-content/uploads/2011/10/1156.jpg"
      video = "http://www.youtube.com/watch?v=KtprX8i2k-Q"
      img_pg_1 = "http://envolverde.com.br/portal/wp-content/uploads/2011/10/1156.jpg"
      img_pg_2 = "http://envolverde.com.br/portal/wp-content/uploads/2011/10/1156.jpg"
      img_pg_3 = "http://envolverde.com.br/portal/wp-content/uploads/2011/10/1156.jpg"
      img_pg_4 = "http://envolverde.com.br/portal/wp-content/uploads/2011/10/1156.jpg"
      idea_content = Faker::Lorem.sentence(15)
      risks_challenges = Faker::Lorem.sentence(10)

      users.each { |user| user.ideas.create!(name: name, summary: summary, local: local, financial_value: financial_value, financial_value_sum_accumulated: financial_value_sum_accumulated, img_card: img_card, video: video, img_pg_1: img_pg_1, img_pg_2: img_pg_2, img_pg_3: img_pg_3, img_pg_4: img_pg_4, idea_content: idea_content, risks_challenges: risks_challenges) }

    2.times do

      title = Faker::Lorem.sentence(2)
      summary = Faker::Lorem.sentence(10)
      financial_value = 50
      quantity = 3

      users.each { |user| user.ideas.each { |idea| idea.recompenses.create!(title: title, summary: summary, financial_value: financial_value , quantity: quantity) } }

    2.times do

      financial_value = 50

      users.each { |user| user.ideas.each { |idea| idea.donations.create!(financial_value: financial_value) } }

    end
    end
    end
    end
  end
end