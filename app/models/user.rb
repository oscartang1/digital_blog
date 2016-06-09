class User < ActiveRecord::Base
    has_many :posts
    has_many :reviews
    has_many :requests
    has_many :follows
	
    acts_as_liker   
    acts_as_followable
    acts_as_follower  
    
    has_attached_file :picture,
                      :styles => { :medium => "90x90#", :thumb => "40x40#" }, 
                      :default_url => "/assets/users/:id/:style/:basename.:extension"
                      
    attr_accessible :f_name, :s_name, :email, :password, :password_confirmation, :picture, :id, :is_public
    
    before_save :encrypt_password
    attr_accessor :password
    
    validates_attachment_size :picture, :less_than => 5.megabytes
    validates_attachment_content_type :picture, :content_type => ['image/jpeg', 'image/png']
    validates_presence_of :f_name, :message => "First name can't be blank"
    validates_presence_of :s_name, :message => "Surname can't be blank"
    validates_confirmation_of :password, :message => "Password doesn't match"
    validates_presence_of :password, :on => :create, :message => "Password can't be blank"
    validates_length_of :password, :on => :create, :minimum => 5, :message => "Password can't be less than 5 characters/numbers"
    validates_presence_of :email, :message => "Email can't be blank"
    validates_uniqueness_of :email, :message => "Email has already been taken"
    validates_format_of :email, :with => /@/
    
    
    
    # return all products that have the value of 'search_string' somewhere in their 'title' or 'author_name'
    def self.fuzzy_search(search_string)
       search_string = "%" + search_string + "%"
       #  find all where a search string is like a title or an author's name
       self.find(:all, :conditions => ["f_name LIKE ? OR s_name  LIKE ? OR email LIKE ?", 
       # order by title
       search_string, search_string, search_string ], order: 'f_name')
    end
    
    def self.authenticate(email, password)
        user = find_by_email(email)
        if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
            user
        else
            nil
        end
    end

    def send_password_reset
        generate_token(:password_reset_token)
        self.password_reset_sent_at = Time.zone.now
        save!
        UserMailer.password_reset(self).deliver
    end

    def generate_token(column)
        begin
            self[column] = SecureRandom.urlsafe_base64
        end while User.exists?(column => self[column])
    end

    def encrypt_password
        if password.present?
            self.password_salt = BCrypt::Engine.generate_salt
            self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
        end
    end

end
