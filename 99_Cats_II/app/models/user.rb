# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
    validates :user_name,:session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: { minimum: 6, allow_nil: true }
    attr_reader :password

    after_initialize :ensure_session_token  

    has_many :cats,
        foreign_key: :user_id,
        class_name: :Cat

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)
        return nil if user.nil?
        user.is_password?(password) ? user : nil
    end

    def self.generation_session_token
        SecureRandom.base64
    end

    def reset_session_token!
        self.session_token = self.class.generation_session_token
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end
    
    private 

    def ensure_session_token
        self.session_token ||= self.class.generation_session_token
    end


end
