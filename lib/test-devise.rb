require 'devise'

def validate_email_default(email)
 puts "valid"
end

def validate_email_config(email)
  if email =~ /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i #this is the default devise config initializer regexp 
     puts "valid"
  else
     puts "invalid"
  end
end

if $0 == __FILE__
  validate_email_default("gerardoayalad@outlook.com")
  validate_email_config("gerardoayalad@outlook.com")
  validate_email_default("gerardoayalad@outlook.com")
  validate_email_config("gerardoayalad@outlook.com")
end