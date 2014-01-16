Fabricator(:user) do 

  username do
    sequence(:email) do |i|
      "darin#{i}"
    end
  end

  password      "abc123"

end
