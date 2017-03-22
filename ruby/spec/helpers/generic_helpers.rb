module GenericHelpers
  def randomName
    ('a'..'z').to_a.shuffle[0,8].join
  end
end
