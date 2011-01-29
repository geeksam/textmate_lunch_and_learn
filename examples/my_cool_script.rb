class PaulaBean
  # Adapted to Ruby from: http://thedailywtf.com/Articles/The_Brillant_Paula_Bean.aspx
  Paula = 'Brillant'

  def get_paula
    return Paula
  end
end

puts "Paula Bean is " + PaulaBean.new.get_paula
