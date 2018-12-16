module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :user

    def connect
      # binding.pry
      self.user = 'test1'
    end
  end
end
