 class SessionsController < Devise::SessionsController

   def create
     self.resource = warden.authenticate(auth_options)
     if self.resource
       sign_in(resource_name, resource, store: false)
       render json: {:user => current_user, :user_id => current_user.id}, status: :ok
     else
       render json: {:error => "Authentication Failure!"}, status: :unauthenticated
     end
   end

 end
