10.times do |i|
  User.create(name: "user_#{i}")
end

Category.create(name: 'category_1')
Category.create(name: 'category_2')

category_1 = Category.first
category_2 = Category.last

User.all.each do |user|
  10.times do |i|
    category = (i % 2 == 0) ? category_1 : category_2
    Item.create(name: "item_#{i}_for_#{user.name}", user: user, category: category)
  end
end
