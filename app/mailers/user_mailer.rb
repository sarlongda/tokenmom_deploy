class UserMailer < ApplicationMailer  
  default to: "vilayhongbounthanh@gmail.com"
  def contact_mail(name,email,contents)
    

    mail from: email, to: "vilayhongbounthanh@gmail.com",subject: "Contact to Tokenmom Exchange"
  end
end
